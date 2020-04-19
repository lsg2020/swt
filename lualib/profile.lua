local c = require "profile.c"
c.init()
local mark = c.mark

local M = {
}

-- luacheck: ignore coroutine on_coroutine_destory
local old_co_create = coroutine.create
local old_co_wrap = coroutine.wrap

function coroutine.create(f)
    return old_co_create(function (...)
            mark()
            return f(...)
        end)
end


function coroutine.wrap(f)
    return old_co_wrap(function (...)
            mark()
            return f(...)
        end)
end


function M.dump(records)
    local ret = {"------- dump profile -------"}
    for i,v in ipairs(records) do
        local s = string.format("[%d] %s name:%s file:[%s]%s:%d count:%d total:%fs ave:%fs percent:%.4g%%",
            i, v.point, v.name, v.flag, v.source, v.line, v.count, v.all_cost, v.ave_cost, v.percent*100)
        ret[#ret+1] = s
    end
    return table.concat(ret, "\n")
end

function M.dstop(count)
    local records = c.stop(count)
    local s = M.dump(records)
    print(s)
end

local exists = 0
function M.start()
    if exists == 0 then
        c.start()
    end
    exists = exists + 1
end

function M.stop(check_time)
    local record_time, nodes = c.call_paths(check_time)
    exists = exists - 1
    if exists <= 0  then
        exists = 0
        c.stop(0)
    end
    return {time = record_time, nodes = nodes}
end


return M
