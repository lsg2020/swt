local skynet        = require "skynet"

local util      = require "swt.util"
local ws_client = require "swt.ws_client"

local AGENT_EXPIRE_TIME = 60 * 100

local AGENT_STATUS = {
    INIT = "init",
    CONNECTED = "connected",
    DISCONNECTED = "disconnected",
}

local agent_mt = {}
agent_mt.__index = agent_mt

function agent_mt:build_info()
    return {addr = self.addr, name = self.name, type = self.type, status = self.status}
end

local mt = {}
mt.__index = mt

function mt:get(addr)
    local agent = self.agents[addr]
    if agent then
        agent.expire_time = skynet.now() + AGENT_EXPIRE_TIME
        return agent
    end

    agent = setmetatable({
        status = AGENT_STATUS.INIT,
        addr = addr,
        name = addr,
        type = addr,
        expire_time = skynet.now() + AGENT_EXPIRE_TIME,
        usages = 1,
    }, agent_mt)

    local agent_mgr = self
    agent.ws = ws_client.new('ws://' .. addr .. '/debug', {
        on_connected_cb = function()
        end,
        on_disconnected_cb = function()
            agent.status = AGENT_STATUS.DISCONNECTED
        end,
        handler = function(cmd, msg)
            if cmd == 'register' then
                agent.status = AGENT_STATUS.CONNECTED
                agent.name = msg.name
                agent.type = msg.type
            elseif cmd == 'debug_print' then
                local session, text, index = msg.session, msg.text, msg.index
                local cb = agent_mgr.sessions[session]
                if not cb then
                    util.log_info("debug_print not exists session:%d", session)
                    return
                end
                cb("print", text, index)
            elseif cmd == 'debug_ret' then
                local session, ret, output = msg.session, msg.ret, msg.output
                local cb = agent_mgr.sessions[session]
                if not cb then
                    util.log_info("debug_ret not exists session:%d", session)
                    return
                end
                cb("ret", ret, output)
            end
        end
    })

    self.agents[addr] = agent
    return agent
end

function mt:agent_inc(agent, count)
    agent.usages = agent.usages + (count or 1)
end

function mt:agent_dec(agent, count)
    agent.usages = agent.usages - (count or 1)
    if agent.usages <= 0 then
        agent.ws:close()
        self.agents[agent.addr] = nil
    end
end

function mt:on_timer()
    local now = skynet.now()
    self:foreach(function(agent)
        if now > agent.expire_time then
            self:agent_dec(agent)
        end
    end)
end

function mt:foreach(cb)
    for _, agent in pairs(self.agents) do
        cb(agent)
    end
end

function mt:debug_run(addr, script, target, print_cb)
    local agent = self:get(addr)
    if agent.status ~= AGENT_STATUS.CONNECTED then
        return false, "agent not connected"
    end

    self:agent_inc(agent)

    local session = self.next_session
    self.next_session = self.next_session + 1
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
    self.sessions[session] = callback

    agent.ws:send("run", {session = session, script = script, target = target})
    skynet.wait(co)
    self:agent_dec(agent)

    return ret, table.concat(output, "\n")
end

return {
    new = function()
        return setmetatable({agents = {}, sessions = {}, next_session = 1}, mt)
    end
}