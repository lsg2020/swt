local skynet    = require "skynet"

local function bar_short()
    local sum = 0
    for k = 1, 10000 do
        for h = 1, 10000 do
            sum = sum + 1
        end
    end
end

local function bar_long()
    for k = 1, 5 do
        bar_short()
    end
end

local function bar_sub()
    local sum = 0
    for k = 1, 10000 do
        for h = 1, 10000 do
            sum = sum + 1
        end
    end
    bar_short()
    bar_long()
end

local function bar_main()
    while true do
        local tb = {}
        for k = 1, 10000 do
            tb[#tb+1] = k
        end
        bar_sub()
        skynet.sleep(100)
    end
end

skynet.start(function ()
    print("bar service started")
    skynet.fork(bar_main)
end)
