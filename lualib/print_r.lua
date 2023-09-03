--version 1.0.0

local tinsert = table.insert
local tconcat = table.concat
local sformat = string.format

-- log输出格式化
local function logPrint(str)
    str = os.date("\nLog output date: %Y-%m-%d %H:%M:%S \n", os.time()) .. str
    print(str)
end

-- key值格式化
local function formatKey(key, to_writefile)
    local t = type(key)
    if t == "number" then
        return "[" .. key .. "]"
    elseif t == "string" then
        local n = tonumber(key)
        if n then
            return "[" .. key .. "]"
        end
        if to_writefile then
            return "[\"" .. key .. "\"]"
        end
    end
    return key
end

-- 栈
local function newStack()
    local stack = {
        tableList = {}
    }
    function stack:push(t)
        table.insert(self.tableList, t)
    end
    function stack:pop()
        return table.remove(self.tableList)
    end
    function stack:contains(t)
        for _, v in ipairs(self.tableList) do
            if v == t then
                return true
            end
        end
        return false
    end
    return stack
end

-- 生成table表 函数
---@param explict_show bool 是否显示地显示nil 和 0长度字符串
---     如果是，则分别显示为 p<nil> 和 p<''>
local function dump(to_writefile, explict_show, ...)
    local final = {}

    local args = { ... }
    for k, v in pairs(args) do
        local root = v
        if type(root) == "table" then
            local temp = {
                "{\n",
            }
            local stack = newStack()
            local function table2String(t, depth)
                stack:push(t)
                if type(depth) == "number" then
                    depth = depth + 1
                else
                    depth = 1
                end
                local indent = ""
                for i = 1, depth do
                    indent = indent .. "    "
                end
                for k, v in pairs(t) do
                    local key = tostring(k)
                    local typeV = type(v)
                    if typeV == "table" then
                        if key ~= "__valuePrototype" then
                            if stack:contains(v) then
                                table.insert(temp, indent .. formatKey(key, to_writefile) .. " = {\"检测到循环引用!\"},\n")
                            else
                                local mt = getmetatable(v)
                                if mt and mt.__tostring then
                                    local text = mt.__tostring(v)
                                    table.insert(temp, string.format("%s%s = \"%s\",\n", indent, formatKey(key, to_writefile), tostring(text)))
                                else
                                    table.insert(temp, indent .. formatKey(key, to_writefile) .. " = {\n")
                                    table2String(v, depth)
                                    table.insert(temp, indent .. "},\n")
                                end
                            end
                        end
                    elseif typeV == "string" or typeV == "function" then
                        table.insert(temp, string.format("%s%s = \"%s\",\n", indent, formatKey(key, to_writefile), tostring(v)))
                    else
                        table.insert(temp, string.format("%s%s = %s,\n", indent, formatKey(key, to_writefile), tostring(v)))
                    end
                end
                stack:pop()
            end
            table2String(root)
            tinsert(temp, "}")
            tinsert(final, table.concat(temp))
        elseif root == nil and explict_show then
            tinsert(final, "p<nil>")
        elseif root == "" and explict_show then
            tinsert(final, "p<''>")
        else
            tinsert(final, tostring(root))
        end
    end

    return tconcat(final, "\t")
end

local function dump_title(title, tail, ...)
    local out = ""
    if title then
        out = "-- " .. tostring(title) .. "------------\n" .. out
    end

    out = out .. dump(false, false, ...)

    if tail then
        out = out .. "-- " .. tostring(tail) .. "\n"
    end

    return out
end

local function print_r(...)
    local out = dump(false, true, ...)
    print(out)
end

local function log(...)
    local out = dump(false, false, ...)
    logPrint(out)
end

local M = {}
function M.test()
    local tb = {
        a = "aa",
        b = "bb",
        c = 33,
        d = {
            dd = {
                eee = 444,
            }
        },
        [99] = 99,
    }
    local f = {
        tb = tb,
    }
    tb.f = f

    local out = dump(false, true, "test dump ------------------", tb)
    print(out)

    out = dump_title("dump-title", "dump-tail", tb)
    print(out)

    print_r("test print_r", tb)

    log("test log:", tb)
end
-- M.test()

M.dump = dump
M.dump_title = dump_title
M.print_r = print_r
M.log = log

return M