
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {}

m.initYa = {
    ocClassName = "AppController",
    ocMethodName = "createYayaSDK",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "playVoice",
    javaMethodSig = "(Ljava/lang/String;)V",
}

function m:createYayaSDK()
    local ocParam = {
            appid = "1001018",
            audioPath = cc.FileUtils:getInstance():getWritablePath(), 
            isDebug = "false", 
            oversea = "false",
        }
    local javaParam = {url}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.initYa.ocClassName,self.initYa.ocMethodName,ocParam)
    elseif "android" == device.platform then
        -- local ok,res = luaNative.callStaticMethod(self.initYa.javaClassName,self.initYa.javaMethodName,javaParam,self.initYa.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.logYaya = {
    ocClassName = "AppController",
    ocMethodName = "loginYayaSDK",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "loginYayaSDK",
    javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V",
}

function m:loginYayaSDK(username,userid)
    local ocParam = {
            username = username, 
            userid = userid,
        }
    local javaParam = {username,userid}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.logYaya.ocClassName,self.logYaya.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.logYaya.javaClassName,self.logYaya.javaMethodName,javaParam,self.logYaya.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.sVoice = {
    ocClassName = "AppController",
    ocMethodName = "startVoice",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "startVoice",
    javaMethodSig = "()Z",
}
function m:startVoice()
    local path = cc.FileUtils:getInstance():getWritablePath()
    local ocParam = {
            recodePath = path .. "laoyouAnHuiMJ.amr"
        }
    local javaParam = nil

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.sVoice.ocClassName,self.sVoice.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.sVoice.javaClassName,self.sVoice.javaMethodName,javaParam,self.sVoice.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.playV = {
    ocClassName = "AppController",
    ocMethodName = "playVoice",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "playVoice",
    javaMethodSig = "(Ljava/lang/String;)V",
}
function m:playVoice(curUrl)
    local ocParam = {
            voiceUrl = curUrl
        }
    local javaParam = {curUrl}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.playV.ocClassName,self.playV.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.playV.javaClassName,self.playV.javaMethodName,javaParam,self.playV.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.spVoice = {
    ocClassName = "AppController",
    ocMethodName = "stopVoice",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "stopVoice",
    javaMethodSig = "()Z",
}
function m:stopVoice()
    local ocParam = nil
    local javaParam = nil

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.spVoice.ocClassName,self.spVoice.ocMethodName)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.spVoice.javaClassName,self.spVoice.javaMethodName,javaParam,self.spVoice.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.gtUrl = {
    ocClassName = "AppController",
    ocMethodName = "getVoiceUrl",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getVoiceUrl",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:getVoiceUrl()
    local ocParam = nil
    local javaParam = nil
    local ok,res = "",""
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.gtUrl.ocClassName,self.gtUrl.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.gtUrl.javaClassName,self.gtUrl.javaMethodName,javaParam,self.gtUrl.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.cnl = {
    ocClassName = "AppController",
    ocMethodName = "cancelVoice",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "cancelVoice",
    javaMethodSig = "()Z",
}
function m:cancelVoice()
    local ocParam = nil
    local javaParam = nil

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cnl.ocClassName,self.cnl.ocMethodName)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.cnl.javaClassName,self.cnl.javaMethodName,javaParam,self.cnl.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

return m