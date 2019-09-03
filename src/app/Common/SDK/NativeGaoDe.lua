
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 


m.disCfg = {
    ocClassName = "AppController",
    ocMethodName = "getDisByTwoPoint",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getDisByTwoPoint",
    javaMethodSig = "(FFFF)F",
}
function m:getDisByTwoPoint(loc1LA,loc1LT,loc2LA,loc2LT)
    local ocParam = {
        location1LA = tonumber(loc1LA),
        location1LT = tonumber(loc1LT),
        location2LA = tonumber(loc2LA),
        location2LT = tonumber(loc2LT),
    }
    local javaParam = {tonumber(loc1LA),tonumber(loc1LT),tonumber(loc2LA),tonumber(loc2LT)}
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.disCfg.ocClassName,self.disCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.disCfg.javaClassName,self.disCfg.javaMethodName,javaParam,self.disCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.locPosCfg = {
    ocClassName = "AppController",
    ocMethodName = "getLocAddres",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getLocAddres",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:getLocAddres()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.locPosCfg.ocClassName,self.locPosCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.locPosCfg.javaClassName,self.locPosCfg.javaMethodName,nil,self.locPosCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.locCfg = {
    ocClassName = "AppController",
    ocMethodName = "getLocation",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getLocation",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:getLocation()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.locCfg.ocClassName,self.locCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.locCfg.javaClassName,self.locCfg.javaMethodName,nil,self.locCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.setLocCfg = {
    ocClassName = "AppController",
    ocMethodName = "setLocation",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "setLocation",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:setLocation(loc)
    local ocParam = loc
    local javaParam = {loc}
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.setLocCfg.ocClassName,self.setLocCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.setLocCfg.javaClassName,self.setLocCfg.javaMethodName,javaParam,self.setLocCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end




return m