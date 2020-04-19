local json      = require "cjson"

local M = {}

function M.log_info(...)
    print(string.format(...))
end

function M.log_error(...)
    print(string.format(...))
end

function M.pack(cmd, data)
    return json.encode({cmd = cmd, data = data})
end

function M.unpack(msg)
    local pack = json.decode(msg)
    return pack.cmd, pack.data
end

return M
