local skynet        = require "skynet"
local websocket     = require "http.websocket"

local util      = require "swt.util"
local global    = require "global"
local http_helper = require "swt.http_helper"

local agent_mgr = global.agent_mgr

local commands = {}
function commands.register(id, pack)
    agent_mgr:register(id, pack.type, pack.name)
end

function commands.debug_print(id, pack)
    agent_mgr:debug_print(id, pack.session, pack.text, pack.index)
end

function commands.debug_ret(id, pack)
    agent_mgr:debug_ret(id, pack.session, pack.ret, pack.output)
end

local handle_agent = {}
function handle_agent.connect(id)
    util.log_info("swt new agent: %d" , id)

    local addr = websocket.addrinfo(id)
    agent_mgr:new_agent(id, addr)
end

function handle_agent.message(id, msg)
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

function handle_agent.close(id, code, reason)
    util.log_info("swt agent close from: %d %s %s" , id, code, reason)
    agent_mgr:close(id)
end

function handle_agent.error(id, err)
    util.log_info("swt agent error from: %d %s", id, err)
    agent_mgr:close(id)
end

return function(router)
    router:get("/agent", util.bind(http_helper.upgrade, handle_agent))
end