
local m = class("GameStateDB")

m.ERROR_INVALID_FILE_CONTENTS = -1
m.ERROR_HASH_MISS_MATCH       = -2
m.ERROR_STATE_FILE_NOT_FOUND  = -3

function m:ctor()
    self._fileName   = "GameStateDB.txt"
    self._cbHandle   = nil
end

function m:init(_cbHandle, fileName)
    if type(_cbHandle) ~= "function" then
        print("m:init() - invalid self._cbHandle")
        return false
    end
    self._cbHandle = _cbHandle
    if type(fileName) == "string" then
        self._fileName = fileName
    end
    self._cbHandle({
        eventName  = "init",
        filename   = self:getGameStateDBPath(),
    })
    return true
end


--返回保存是否成功结果及保存存档字符串
function m:save(newValues)
    local values = self._cbHandle({
        eventName   = "save",
        values      = newValues
    })
    if type(values) ~= "table" then
        print("m:save() - listener return invalid data")
        return false
    end

    local filename = self:getGameStateDBPath()
    local ret = false
    local saveStr = json.encode(values)
    if type(saveStr) == "string" then
        ret = io.writefile(filename, saveStr)
    end

    printf("m:save() - update file \"%s\"", filename)
    return ret,saveStr
end



function m:load(_strData)
    local contents = nil
    if _strData == nil then
        local filename = self:getGameStateDBPath()
        if not io.exists(filename) then
            printf("m:load() - file \"%s\" not found", filename)
            return self._cbHandle({eventName = "load", errorCode = m.ERROR_STATE_FILE_NOT_FOUND})
        end

        contents = io.readfile(filename)
        printf("m:load() - get values from \"%s\"", filename)
    else
        printf("m:load() with function!!!")
        contents = _strData
    end

    local values = json.decode(contents)
    if type(values) ~= "table" then
        print("m:load() - invalid data")
        return self._cbHandle({eventName = "load", errorCode = m.ERROR_INVALID_FILE_CONTENTS})
    end
    return self._cbHandle({
        eventName   = "load",
        values      = values,
        time        = os.time()
    })
end

function m:getGameStateDBPath()
    return string.gsub(device.writablePath, "[\\\\/]+$", "") .. "/" .. self._fileName
end


return m