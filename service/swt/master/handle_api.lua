local skynet        = require "skynet"
local websocket     = require "http.websocket"

local global    = require "global"
local json      = require "cjson"
local http_helper   = require "swt.http_helper"
local util = require "swt.util"

local agent_mgr = global.agent_mgr

local apis = {}

-- luacheck: ignore request
function apis.agent_list(request)
    local agents = {}
    if request and request.query and request.query.agents then
        for _, addr in ipairs(request.query.agents) do
            local agent = agent_mgr:get(addr)
            table.insert(agents, agent:build_info())
        end
    end

    return agents
end

function apis.agent_services(request)
    local test = [[
        local skynet = require "skynet"
        local service_list = skynet.call(".launcher", "lua", "list")
        --if sfg_raw_print then
        --    for k, v in pairs(service_list) do
        --        sfg_raw_print("[sfg-service-info]:", k, v)
        --    end
        --end
        print(service_list)
    ]]
    local output = {}
    if request.query.agents then
        for _, addr in pairs(request.query.agents) do
            local ok, ret, resp = pcall(agent_mgr.debug_run, agent_mgr, addr, test)
            if ok and ret then
                output[addr] = json.decode(resp)
            end
        end
    end
    return output
end

local function _debug_run(request, targets, script)
    local function response(target, type, msg)
        if request.socket_close then
            return
        end
        websocket.write(request.id,
            json.encode({node_id = target.node.addr, addr = target.addr, type = type, msg = msg}),
            "binary"
        )
    end

    local wait_amount = 0
    local function run(target)
        local ok, ret, err = pcall(agent_mgr.debug_run,
            agent_mgr,
            target.node.addr,
            script,
            target.addr,
            function(text, index, max)
                response(target, "print", {text = text, index = index, max = max})
            end
        )

        if not ok or not ret then
            response(target, "error", ret or err)
        else
            response(target, "finish", "ok")
        end

        wait_amount = wait_amount - 1
        if wait_amount == 0 and not request.socket_close then
            websocket.close(request.id)
        end
    end
    for _, target in pairs(targets) do
        wait_amount = wait_amount + 1
        skynet.fork(run, target)
    end
end

function apis.debug_run(request)
    local handle = {
        message = function(_, msg)
            local data = json.decode(msg)
            if data.cmd == "run" then
                local script = data.script
                local targets = data.targets

                _debug_run(request, targets, script)
            end
        end,
        error = function()
            request.socket_close = true
        end,
        close = function()
            request.socket_close = true
        end
    }
    http_helper.upgrade(handle, request)
end

function apis.profiler(request)
    local handle = {
        message = function(_, msg)
            local data = json.decode(msg)
            if data.cmd == "run" then
                local time = data.time
                local targets = data.targets

                local script = [[
                local skynet = require "skynet"
                local profile = require "profile"
                profile.start()
                skynet.sleep(%d * 100)
                print(profile.stop())
                ]]
                script = string.format(script, time)

                _debug_run(request, targets, script)
            end
        end,
        error = function()
            request.socket_close = true
        end,
        close = function()
            request.socket_close = true
        end
    }
    http_helper.upgrade(handle, request)
end

return function(router)
    router:any("/api/:subcmd", function(request)
        local cmd = request.subcmd
        util.log_debug("[handle_api] handling %s ...", "/api/"..cmd)
        
        if not apis[cmd] then
            http_helper.response(request.id, 404, {code = 20404, message = string.format("cmd:%s not found", cmd)})
            util.log_debug("unknown cmd")            
            return
        end

        if request.body ~= "" then
            local params = json.decode(request.body)
            for k, v in pairs(params) do
                request.query[k] = v
            end
        end

        local ok, resp = xpcall(apis[cmd], debug.traceback, request)
        if not ok then
            http_helper.response(request.id,
                    500,
                    {code = 20500, message = string.format("cmd:%s server error:%s", cmd, resp)}
            )
            return
        end
        if resp then
            http_helper.response(request.id, 200, {code = 20000, message = "success", data = resp})
        end
    end)
end