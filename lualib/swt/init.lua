local skynet    = require "skynet"

local M = {}

-----------------------------------------------------------------------------
-- 启动master
--  listen_addr: 管理工具监听端口 例:"0.0.0.0:8000"
function M.start_master(listen_addr)
    local master = skynet.uniqueservice("swt/master")
    skynet.send(master, "lua", "start", listen_addr)
end

-----------------------------------------------------------------------------
-- 启动agent
--  node_type: 节点类型名
--  node_name: 节点名
--  master_addr: 连接master地址 例:"127.0.0.1:8000"
function M.start_agent(node_type, node_name, master_addr)
    local agent = skynet.uniqueservice("swt/agent")
    skynet.send(agent, "lua", "start", node_type, node_name, master_addr)
end


return M