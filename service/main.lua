local skynet    = require "skynet"
local swt       = require "swt"

skynet.start(function()
    skynet.newservice("debug_console", 8000)
    swt.start_master("0.0.0.0:9527")
    swt.start_agent("app", "node1", "127.0.0.1:9527")
end)

