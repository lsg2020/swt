local skynet        = require "skynet"
local socket        = require "skynet.socket"
local httpd         = require "http.httpd"
local sockethelper  = require "http.sockethelper"
local websocket     = require "http.websocket"
local urllib        = require "http.url"

local util      = require "swt.util"
local json      = require "cjson"

local function response(id, code, resp)
    if type(resp) == "table" then
        resp = json.encode(resp)
    end

    local header = {
        ["Access-Control-Allow-Origin"] = "*",
        ["Access-Control-Allow-Methods"] = "POST,GET,OPTIONS",
        ["Access-Control-Allow-Headers"] = "Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,X-Data-Type,X-Requested-With", -- luacheck: ignore
    }
    local ok, err = httpd.write_response(sockethelper.writefunc(id), code, resp, header)
    if not ok then
        util.log_error("swt http response error fd = %d, %s", id, err)
    end
    socket.close(id)
end

local function upgrade(handle_agent, request)
    local ok, err = websocket.accept(request.id, handle_agent, "ws", request.addr, 
        {
            upgrade = {
                header = request.headers, 
                method = request.method, 
                url = request.url
            }
        })
    if not ok then
        util.log_debug("[http_helper] upgrade-accept failed:%s", tostring(err))
        if handle_agent.error then
            handle_agent.error(request.id, err)
        end
    end
end

local function dispatch(router, id, addr)
    local code, url, method, headers, body = httpd.read_request(sockethelper.readfunc(id), 8192)
    if not code then
        if url ~= sockethelper.socket_error then
            util.log_error("swt http read error: %s", url)
        end
        socket.close(id)
        return
    end

    if code ~= 200 then
        response(id, code)
        return
    end

    local path, query = urllib.parse(url)
    query = urllib.parse_query(query)

    local ok, error = router:execute(method, path, {
        id = id,
        addr = addr,
        path = path,
        method = method,
        headers = headers,
        query = query,
        body = body,
    })

    if not ok then
        response(id, 404, error)
        return
    end
end

local function static(path, options, request)
    local real_path = request.path
    if options and options.default and string.match(real_path, "^"..path.."[/]*$") then
        real_path = real_path .. "/" .. options.default
    end

    local now = skynet.now()
    local cache
    local expire = 0
    if options and options.cache then
        cache = options.cache[real_path]
        expire = options.expire or 30 * 100
    end

    if not cache or cache.expire < now then
        cache = {expire = now + expire, code = 200, resp = ""}
        local f = io.open(string.sub(real_path, 2), "rb")
        if f then
            cache.resp = f:read("*a")
            f:close()
        else
            cache.code = 404
        end
    end

    if options and options.cache then
        options.cache[real_path] = cache
    end

    response(request.id, cache.code, cache.resp)
end


return {
    response = response,
    upgrade = upgrade,
    dispatch = dispatch,
    static = static,
}