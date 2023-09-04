local skynet        = require "skynet"
local websocket     = require "http.websocket"
local json          = require "cjson"
local util          = require "swt.util"
local http_helper   = require "swt.http_helper"

local node_type, node_name
local function agent_send(id, cmd, pack)
    websocket.write(id, util.pack(cmd, pack), "binary")
end

local session2id = {}
local code_template = [[
    local skynet = require 'skynet'
    local json   = require "cjson"
    local debug_address = %d
    local session = %s
    local function debug_print(...)
        local args = {...}
        local out = {}
        for k, v in ipairs(args) do
            if type(v) == "table" then
                out[k] = json.encode(v)
            else
                out[k] = tostring(v)
            end
        end
        skynet.send(debug_address, 'lua', 'print', session, table.concat(out, '\t'))
    end
    local env = setmetatable({print = debug_print}, {__index = _G})
    local f, err = load(%q, '@inject', 'bt', env)
    if not f then
        print(err)
        return
    end
    local r, err = xpcall(f, debug.traceback)
    if not r then
        print(err)
        return
    end
    print('ok')
]]

local function send_print(session, text)
    if not session2id[session] then
        return
    end
    local frame_size = 32 * 1024
    local max = #text // frame_size
    for i = 0, max do
        local s = i * frame_size + 1
        local e = (i + 1) * frame_size
        if e > #text then
            e = #text
        end

        agent_send(
            session2id[session],
            "debug_print",
            {session = session, text = string.sub(text, s, e), index = max - i, max = max}
        )
    end
end

local commands = {}
function commands.run(id, msg)
    util.log_debug("[handle_debug] id:%s, run:%s", tostring(id), tostring(msg.script))
    local session = msg.session
    session2id[session] = id

    local ok, ret, output
    if msg.target and msg.target ~= skynet.self() then
        ok, ret, output = pcall(skynet.call,
            msg.target,
            "debug",
            "SWT_RUN",
            string.format(code_template, skynet.self(), session, msg.script),
            "debug_run")
        if not ok then
            output = ret
        end
    else
        local function debug_print(...)
            local args = {...}
            local out = {}
            for k, v in ipairs(args) do
                if type(v) == "table" then
                    out[k] = json.encode(v)
                else
                    out[k] = tostring(v)
                end
            end

            send_print(msg.session, table.concat(out, '\t'))
        end
        local env = setmetatable({print = debug_print}, {__index = _G})

        ret, output = load(msg.script, "@debug", "bt", env)
        if ret then
            ret, output = xpcall(ret, debug.traceback)
            if ret then
                output = "ok"
            end
        end
    end

    agent_send(id, "debug_ret", {session = msg.session, ret = output == "ok", output = output})
    session2id[msg.session] = nil
end

local function dispatch(id, msg)
    local cmd, pack = util.unpack(msg)
    if not cmd or not commands[cmd] then
        util.log_error("swt agent message id:%d error:%s", id, msg)
        return
    end

    local ok, err = xpcall(commands[cmd], debug.traceback, id, pack)
    if not ok then
        util.log_error("swt agent message id:%d error:%s", id, err)
    end
end

local handle = {}
function handle.connect(id)
    skynet.timeout(100, function() -- TODO ?
        agent_send(id, 'register', {type = node_type, name = node_name})
    end)
end

function handle.message(id, msg)
    skynet.fork(dispatch, id, msg)
end

return function(type, name, router, command)
    node_type = type
    node_name = name
    router:get("/debug", util.bind(http_helper.upgrade, handle))

    command.print = function(session, out)
        send_print(session, out)
    end
end
