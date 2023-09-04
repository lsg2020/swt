local skynet    = require "skynet"
local swt       = require "swt"

SFG_NODE_TYPE = "game-app"
SFG_NODE_NAME = "node-1"
SFG_AGENT_PORT = 9528

local function get_node_infos()
    local node_type = skynet.getenv("SFG_NODE_TYPE")
    assert(node_type)

    local node_name = skynet.getenv("SFG_NODE_NAME")
    assert(node_name)
    
    local port = skynet.getenv("SFG_AGENT_PORT")
    assert(port)
    port = tonumber(port)
    assert(port and type(port) == "number")
    local addr = "0.0.0.0:"..port

    return tostring(node_type), tostring(node_name), addr
end

skynet.start(function()
    -- skynet.newservice("debug_console", 8000)

    local node_type, node_name , listen_addr = get_node_infos()
    swt.start_agent(node_type, node_name, listen_addr)

    skynet.newservice("bar")
    skynet.newservice("foo")
end)
