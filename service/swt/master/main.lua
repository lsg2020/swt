local skynet        = require "skynet"
local socket        = require "skynet.socket"
local httpd         = require "http.httpd"
local urllib        = require "http.url"
local sockethelper  = require "http.sockethelper"

local router    = require "router"
local util      = require "swt.util"
local global    = require "global"
local http_helper  = require "http_helper"

local http_router
local command = {}

local function http_dispatch(id, addr)
    local code, url, method, headers, body = httpd.read_request(sockethelper.readfunc(id), 8192)
    if not code then
        if url ~= sockethelper.socket_error then
            util.log_error("swt http read error: %s", url)
        end
        socket.close(id)
        return
    end

    if code ~= 200 then
        http_helper.response(id, code)
        return
    end

    local path, query = urllib.parse(url)
    query = urllib.parse_query(query)

    local ok, error = http_router:execute(method, path, {
        id = id,
        addr = addr,
        path = path,
        method = method,
        headers = headers,
        query = query,
        body = body,
    })

    if not ok then
        http_helper.response(id, 404, error)
        return
    end
end

local static_cache = {}
local function static_file(path, options)
    return function (request)
        local real_path = request.path
        if options and options.default and real_path == path then
            real_path = real_path .. "/" .. options.default
        end

        local now = skynet.now()
        local cache = static_cache[real_path]
        if not cache or cache.expire < now then
            cache = {expire = now + 30 * 100, code = 200, resp = ""}
            local f = io.open(string.sub(real_path, 2), "rb")
            if f then
                cache.resp = f:read("*a")
                f:close()
            else
                cache.code = 404
            end
        end

        http_helper.response(request.id, cache.code, cache.resp)
    end
end

function command.start(listen_addr)
    global.agent_mgr = require("agent_mgr").new()

    local http_socket = socket.listen(listen_addr:match("([^:]+):(%d+)"))
    socket.start(http_socket, function(id, addr)
        socket.start(id)
        skynet.fork(http_dispatch, id, addr)
    end)

    http_router = router.new()
    http_router:options("/*", function(request) http_helper.response(request.id, 200, "") end)
    http_router:get("/admin/*", static_file("/admin", {default = "index.html"}))
    require("handle_agent")(http_router)
    require("handle_api")(http_router)
end

skynet.start(function ()
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = assert(command[cmd], cmd)
        f(...)
    end)
end)