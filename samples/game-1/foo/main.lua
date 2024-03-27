local skynet    = require "skynet"

local function foo_sub()
    local sum = 0
    for k = 1, 100 do
        for h = 1, 100 do
            sum = sum + 1
        end
    end
end

local function foo_main()
    while true do
        local tb = {}
        for k = 1, 10000 do
            tb[#tb+1] = k
        end
        foo_sub()
        skynet.sleep(100)
    end
end

skynet.start(function ()
    print("foo service started")
    skynet.fork(foo_main)
end)
