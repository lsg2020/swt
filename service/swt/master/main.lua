local skynet        = require "skynet"
local socket        = require "skynet.socket"
local httpd         = require "http.httpd"
local sockethelper  = require "http.sockethelper"

local router    = require "router"
local util      = require "swt.util"
local global    = require "global"
local http_helper  = require "swt.http_helper"

local http_router
local command = {}

function command.start(listen_addr)
    global.agent_mgr = require("agent_mgr").new()

    local http_socket = socket.listen(listen_addr:match("([^:]+):(%d+)"))
    socket.start(http_socket, function(id, addr)
        socket.start(id)
        skynet.fork(http_helper.dispatch, http_router, id, addr)
    end)

    http_router = router.new()
    http_router:options("/*", function(request) http_helper.response(request.id, 200, "") end)
    http_router:get("/admin/*", util.bind(
        http_helper.static, 
        "/admin", 
        {default = "index.html", cache = {}}
    ))
    require("handle_agent")(http_router)
    require("handle_api")(http_router)
end

skynet.start(function ()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = assert(command[cmd], cmd)
        f(...)
    end)
end)