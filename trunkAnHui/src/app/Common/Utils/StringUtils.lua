
--StringUtils
local m = {}

--比较版本号,xx.yy.zz
--1:versionFir 大于 versionSec
---1:versionFir 小于 versionSec
--0:versionFir 等于 versionSec
--版本号是3位
function m.compareVersion( versionFir, versionSec )
    local versionFirArr = string.split(versionFir,".")
    local versionSecArr = string.split(versionSec,".")

    dump(versionFirArr,"===versionFirArr=")
    dump(versionSecArr,"===versionSecArr=")
    if #versionFirArr == 2 then
        versionFirArr[3] = 0
    end
    if #versionSecArr == 2 then
        versionSecArr[3] = 0
    end
    dump(versionFirArr,"===versionFirArr=end")
    dump(versionSecArr,"===versionSecArr=end")

    for i=1,#versionFirArr do
        if tonumber(versionFirArr[i]) > tonumber(versionSecArr[i]) then
            return 1
        elseif tonumber(versionFirArr[i]) < tonumber(versionSecArr[i]) then
            return -1
        end
    end
    return 0
end

function m.GetShortName(str,maxLen)
    -- print(str,"===GetShortNameGetShortName===")
    maxLen = maxLen or 4
    local charNum = m.getStringCharCount(str)
    if charNum > maxLen then
        local byteSize = 0
        local index = 1
        for i = 1 , maxLen do
            local byteCount = 0
            local curByte = string.byte(str, index)
            --print(curByte,"===curBytecurBytecurBytecurByte===" .. maxLen .. "     " ..charNum)
            if curByte > 0 and curByte < 128 then        
                byteCount = 1                        --1字节字符
            elseif curByte >= 192 and curByte < 224 then
                byteCount = 2                        --双字节字符
            elseif curByte >= 224 and curByte < 240 then
                byteCount = 3                        --汉字
            elseif curByte >= 240 and curByte < 248 then
                byteCount = 4                        --4字节字符
            end
            byteSize = byteSize + byteCount
            index = index + byteCount                -- 重置下一字节的索引
        end
        return string.sub(str,1,byteSize)..'..'
    else
        return str
    end
end

--计算字符串字符个数
function m.getStringCharCount(str)
    local lenInByte = #str
    -- print("--getStringCharCount--",lenInByte)
    local charCount = 0
    local i = 1
    while (i <= lenInByte) 
    do
        local curByte = string.byte(str, i)
        -- print("curBytecurByte==",curByte)
        local byteCount = 1
        if curByte > 0 and curByte < 128 then        
            byteCount = 1                        --1字节字符
        elseif curByte >= 192 and curByte < 224 then
            byteCount = 2                        --双字节字符
        elseif curByte >= 224 and curByte < 240 then
            byteCount = 3                        --汉字
        elseif curByte >= 240 and curByte < 248 then
            byteCount = 4                        --4字节字符
        end
        
        local char = string.sub(str, i, i + byteCount - 1)
        i = i + byteCount                                  -- 重置下一字节的索引
        charCount = charCount + 1                          -- 字符的个数（长度）
    end
    return charCount
end



-- start --
--------------------------------
-- @class function
-- @description 获取 [minVar, maxVar] 区间随机值
-- @param minVar 最小值
-- @param maxVar 最大值
-- @return 区间随机值
-- end --
function m.getRangeRandom(minVar, maxVar)
    if minVar == maxVar then
        return minVar
    end

    return math.floor((math.random() * 1000000)) % (maxVar - minVar + 1) + minVar
end

return m
