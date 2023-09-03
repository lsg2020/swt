local skynet    = require "skynet"

local function bar_sub()
    local sum = 0
    for k = 1, 10000 do
        for h = 1, 10000 do
            sum = sum + 1
        end
    end
end

local function bar_main()
    while true do
        local tb = {}
        for k = 1, 10000 do
            tb[#tb+1] = k
        end
        bar_sub()
        skynet.sleep(500)
    end
end

skynet.start(function ()
    print("bar service started")
    skynet.fork(bar_main)
end)
