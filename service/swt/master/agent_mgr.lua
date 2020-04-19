local skynet        = require "skynet"
local websocket     = require "http.websocket"

local util      = require "swt.util"

local mt = {}
mt.__index = mt

local function conv_agentid(ws)
    return 'agent_' .. ws
end

function mt:new_agent(ws, addr)
    local key = conv_agentid(ws)
    self.agents[key] = {
        id = key,
        ws = ws,
        addr = addr,
        type = nil,
        name = addr,
    }
end

function mt:register(ws, type, name)
    local key = conv_agentid(ws)
    local agent = self:get(key)
    assert(agent)
    agent.type = type
    agent.name = name
end

function mt:get(key)
    return self.agents[key]
end

function mt:foreach(cb)
    for id, agent in pairs(self.agents) do
        if not cb(agent) then
            return
        end
    end
end

function mt:session()
    local session = self.next_session
    self.next_session = self.next_session + 1
    return session
end

function mt:close(ws)
    websocket.close(ws)
    self.agents[conv_agentid(ws)] = nil
end

function mt:send(agent, cmd, pack)
    websocket.write(agent.ws, util.pack(cmd, pack), "binary")
end

function mt:debug_run(agent_id, script, target, print_cb)
    local agent = self:get(agent_id)
    assert(agent, "agent not exists " .. agent_id)

    local session = self:session()
    local co = coroutine.running()

    local output = {}
    local temp_print
    local ret, err
    local callback = function(type, ...)
        if type == "print" then
            local text, index = ...
            if print_cb then
                print_cb(text, index)
            else
                if temp_print then
                    temp_print = temp_print .. text
                else
                    temp_print = text
                end

                if index == 0 then
                    table.insert(output, temp_print)
                    temp_print = nil
                end
            end
        elseif type == "ret" then
            ret, err = ...
            if not ret then
                table.insert(output, err)
            end
            skynet.wakeup(co)
        else
            assert(false, "error type:" .. type)
        end
    end
    self.sessions[session] = {
        agent_id = agent_id,
        callback = callback
    }

    self:send(agent, "run", {session = session, script = script, target = target})
    skynet.wait(co)

    return ret, table.concat(output, "\n")
end

function mt:debug_print(ws, session, text, index)
    local session = self.sessions[session]
    if not session then
        util.log_info("debug_print not exists session:%d", session)
        return
    end
    if session.agent_id ~= conv_agentid(ws) then
        return
    end

    session.callback("print", text, index)
end

function mt:debug_ret(ws, session, ret, output)
    local session = self.sessions[session]
    if not session then
        util.log_info("debug_ret not exists session:%d", session)
        return
    end
    if session.agent_id ~= conv_agentid(ws) then
        return
    end

    self.sessions[session] = nil
    session.callback("ret", ret, output)
end

local M = {}
function M.new()
    return setmetatable({agents = {}, sessions = {}, next_session = 1}, mt)
end

return M