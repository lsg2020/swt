local skynet    = require "skynet"
local websocket = require "http.websocket"
local util      = require "swt.util"

local mt = {}
mt.__index = mt

function mt:connect()
    while not (self.conn or self.closed) do
        local ok, conn = pcall(websocket.connect, self.addr, nil, 100)
        if ok then
            self.conn = conn
            util.log_info("connect to %s succeed", self.addr)

            if self.options and self.options.on_connected_cb then
                self.options.on_connected_cb(self)
            end
            break
        end

        util.log_error("connect %s failed: %s", self.addr, conn)
        skynet.sleep(100)
    end

    return self.conn
end

function mt:send(cmd, pack)
    if self.conn then
        return websocket.write(self.conn, util.pack(cmd, pack), "binary")
    end
end

function mt:close()
    self:_close()
    self.closed = true
end

function mt:_dispatch(data)
    local cmd, msg = util.unpack(data)
    if self.options and self.options.handler then
        self.options.handler(cmd, msg)
    end
end

function mt:_close()
    if not self.conn then
        return
    end

    self.conn = nil

    websocket.close(self.conn)
    if self.options and self.options.on_disconnected_cb then
        self.options.on_disconnected_cb(self)
    end
end

function mt:_run()
    while true do
        if not self:connect() then
            break
        end

        while self.conn do
            local ok, resp, close_reason = pcall(websocket.read, self.conn)
            if not ok or not resp then
                util.log_error("connection %s read error: %s", self.addr, resp or close_reason)
                break
            end

            skynet.fork(self._dispatch, self, resp)
        end
        self:_close()
    end
end

local M = {}

function M.new(addr, options)
    local obj = {
        addr = addr,
        conn = nil,
        close = false,
        options = options,
    }
    setmetatable(obj, mt)

    skynet.fork(obj._run, obj)
    return obj
end

return M