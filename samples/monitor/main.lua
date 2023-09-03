local skynet    = require "skynet"
local swt       = require "swt"

local function get_master_addr()
    local port = skynet.getenv("SWT_MASTER_PORT")
    assert(port, "SWT_MASTER_PORT missing")

    port = tonumber(port)
    assert(port and type(port) == "number", "SWT_MASTER_PORT invalid number")

    return "0.0.0.0:"..port
end

skynet.start(function()
    -- skynet.newservice("debug_console", 8000)

    local listen_addr = get_master_addr()
    swt.start_master(listen_addr)
end)

