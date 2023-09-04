local skynet    = require "skynet"
local socket    = require "skynet.socket"

local router    = require "router"
local http_helper  = require "swt.http_helper"
local util = require "swt.util"

local http_router = router.new()
local command = {}

function command.start(node_type, node_name, listen_addr)
    util.log_info("swt/agent start listening at %s...", listen_addr)

    local http_socket = socket.listen(listen_addr:match("([^:]+):(%d+)"))
    socket.start(http_socket, function(id, addr)
        util.log_debug("new connection, id:%s, addr:%s", tostring(id), tostring(addr))
        socket.start(id)
        skynet.fork(http_helper.dispatch, http_router, id, addr)
    end)

    require("handle_debug")(node_type, node_name, http_router, command)
end

skynet.start(function ()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = assert(command[cmd], cmd)
        f(...)
    end)
end)
