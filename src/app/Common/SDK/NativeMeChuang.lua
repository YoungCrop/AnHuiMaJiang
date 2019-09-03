
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 


m.urlRoomIDCfg = {
    ocClassName = "AppController",
    ocMethodName = "getRoomID",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getRoomID",
    javaMethodSig = "()Ljava/lang/String;",
}
-- start --
--------------------------------
-- @class function
-- @description 获取分享链接房间号
-- end --
function m:getUrlRoomID()
    local roomID = nil
    if "ios" == device.platform then
        local ok,ret = luaNative.callStaticMethod(self.urlRoomIDCfg.ocClassName,self.urlRoomIDCfg.ocMethodName)
        roomID = ret
    elseif "android" == device.platform then
        local ok,ret = luaNative.callStaticMethod(self.urlRoomIDCfg.javaClassName,self.urlRoomIDCfg.javaMethodName,nil,self.urlRoomIDCfg.javaMethodSig)
        roomID = ret
    elseif "windows" == device.platform then

    end
    return roomID
end

m.cleanRoomCfg = {
    ocClassName = "AppController",
    ocMethodName = "clearRoomID",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "clearRoomID",
    javaMethodSig = "()V",
}
-- start --
--------------------------------
-- @class function
-- @description 清除分享链接房间号
-- end --
function m:clearUrlRoomID()
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cleanRoomCfg.ocClassName,self.cleanRoomCfg.ocMethodName)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cleanRoomCfg.javaClassName,self.cleanRoomCfg.javaMethodName,nil,self.cleanRoomCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


m.userPCfg = {
    ocClassName = "AppController",
    ocMethodName = "getUserParam",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getUserParam",
    javaMethodSig = "()Ljava/lang/String;",
}
-- start --
--------------------------------
-- @class function
-- @description 获取分享链接自定义参数
-- end --
function m:getUrlUserParam()
    local userParam = nil
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.userPCfg.ocClassName,self.userPCfg.ocMethodName)
        userParam = res
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.userPCfg.javaClassName,self.userPCfg.javaMethodName,nil,self.userPCfg.javaMethodSig)
        userParam = res
    elseif "windows" == device.platform then

    end
    return userParam
end

m.cleanUCfg = {
    ocClassName = "AppController",
    ocMethodName = "clearUserParam",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "clearUserParam",
    javaMethodSig = "()V",
}

-- start --
--------------------------------
-- @class function
-- @description 清除分享链接自定义参数
-- end --
function m:clearUrlUserParam()
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cleanUCfg.ocClassName,self.cleanUCfg.ocMethodName)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cleanUCfg.javaClassName,self.cleanUCfg.javaMethodName,nil,self.cleanUCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

-- “https://arr7b3.mlinks.cc/A07p?roomID="..self.roomID.."&userParam=myParam"
m.mcURL = "https://arr7b3.mlinks.cc/AbZz"
m.iOSAppUrl = "https://itunes.apple.com/cn/app/id1371226787"
function m:getMCURL()
    local url = "https://fir.im/anhuigame"
    return url
end

function m:getMCURLParam(roomID,userParam)
    local url = m.mcURL .. "?roomID="..roomID.."&userParam="..userParam
    return url
end

return m