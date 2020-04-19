local skynet        = require "skynet"
local socket        = require "skynet.socket"
local httpd         = require "http.httpd"
local sockethelper  = require "http.sockethelper"
local websocket     = require "http.websocket"

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

local function upgrade(handle_agent)
    return function (request)
        local tmp = {string.format("GET %s HTTP/1.1", request.path)}
        for k, v in pairs(request.headers) do
            table.insert(tmp, string.format("%s:%s", k, v))
        end

        local ok, err = websocket.accept(request.id, handle_agent, "ws", request.addr, {upgrade = tmp})
        if not ok then
            if handle_agent.error then
                handle_agent.error(request.id, err)
            end
        end
    end
end

return {
    response = response,
    upgrade = upgrade,
}