local skynet    = require "skynet"
local json      = require "cjson"

local util      = require "swt.util"
local ws_client = require "swt.ws_client"

local master_conn
local debug_cmd = {}

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
    local env = setmetatable({print=debug_print, require=skynet.debug_require}, {__index=_G})
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
    local frame_size = 32 * 1024
    local max = #text // frame_size
    for i = 0, max do
        local s = i * frame_size + 1
        local e = (i + 1) * frame_size
        if e > #text then 
            e = #text
        end

        master_conn:send("debug_print", {session = session, text = string.sub(text, s, e), index = max - i})
    end
end

function debug_cmd.run(msg)
    local ok, ret, output
    if msg.target and msg.target ~= skynet.self() then
        ok, ret, output = pcall(skynet.call,
                msg.target,
                "debug",
                "SWT_RUN",
                string.format(code_template, skynet.self(), msg.session, msg.script),
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
        local env = setmetatable({print=debug_print, require=skynet.debug_require}, {__index=_G})

        ret, output = load(msg.script, "@debug", "bt", env)
        if ret then
            ret, output = xpcall(ret, debug.traceback)
            if ret then
                output = "ok"
            end
        end
    end

    master_conn:send("debug_ret", {session = msg.session, ret = output == "ok", output = output})
end

local command = {}

function command.start(node_type, node_name, master_addr)
    master_addr = string.format("ws://%s/agent", master_addr)
    master_conn = ws_client.new(master_addr, {
        on_connected_cb = function()
            master_conn:send("register", {type = node_type, name = node_name})
            util.log_info("swt connect to master: %s", master_addr)
        end,
        on_disconnected_cb = function()
            util.log_info("swt master disconnected : %s", master_addr)
        end,
        handler = function(cmd, msg)
            if not debug_cmd[cmd] then
                util.log_error("swt unknown message %s", cmd)
                return
            end
            debug_cmd[cmd](msg)
        end,
    })
end

function command.print(session, out)
    send_print(session, out)
end

skynet.start(function ()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = assert(command[cmd], cmd)
        f(...)
    end)
end)