
local m = {}

function m:printTT_(content, ...)
    local tab = 0
    local out_list = {}

    local function printk(value, key, tab)
        if key == nil then
            return
        end
        if type(key) ~= "number" then
            key = tostring(key)
        else
            key = string.format("[%d]", key)
        end
        if type(value) == "table" then
            if key ~= nil then
                table.insert(out_list, tab .. key .. " =")
            end
            table.insert(out_list, tab .. "{")
            for k, v in pairs(value) do
                printk(v, k, tab .. "|  ")
            end
            table.insert(out_list, tab .. "},")
        else
            local content
            if type(value) == "nil" or value == "^&nil" then
                value = "nil"
            elseif type(value) == "string" then
                value = string.format("\"%s\"", tostring(value))
            else
                value = tostring(value)
            end
            content = string.format("%s%s = %s,", tab, key, value)
            table.insert(out_list, tostring(content))
        end
    end
    local value = type(content) == "string" and string.format(content, ...) or content
    local key = os.date("[\"%X\"]", os.time())
    printk(value, key, "")

    local out_str = table.concat(out_list, "\n")
    print(out_str .. "\n")
    return out_str

    -- local logFileName = os.date("print_tab_%Y_%m_%d.log", os.time())
    -- local logFileName = "a.log"
    -- local file = assert(io.open(logFileName, "a+"))
    -- file:write(out_str .. "\n")
    -- file:close()
end

--打印用户数据
function m:logUD(ud,desc)
    local function tmp(metaT,dSet)  
        if metaT then
            for _val, _val_type in pairs(metaT) do
                if type(_val_type) ~= "userdata" then   
                    if not string.find(_val,"_") then                  
                        table.insert(dSet,_val)  
                    end        
                end  
            end
            table.sort(dSet)
            dSet[tostring(metaT)] = {}
            tmp(getmetatable(metaT),dSet[tostring(metaT)])      
        end  
    end

    if desc then
        print("=========" .. desc .. "=========")
    end
    if type(ud) == "table" then
        return m:printTT_(ud)
    elseif type(ud) == "userdata" then
        local resTb = {}
        tmp(getmetatable(ud),resTb)
        return m:printTT_(resTb)
    end
end

function m:logd(...)
    m:printTT_(...)
end

function m:log(content)
    self:logdw(content)
end

function m:logdw(content)
    m:printTT_(debug.traceback(content))
end


return m
