
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 

m.copyCfg = {
    ocClassName = "AppController",
    ocMethodName = "copyText",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "copyText",
    javaMethodSig = "(Ljava/lang/String;)V",
}
function m:copyText(_txt)
    local ocParam = {
        copyText = _txt
    }
    local javaParam = {_txt}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.copyCfg.ocClassName,self.copyCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.copyCfg.javaClassName,self.copyCfg.javaMethodName,javaParam,self.copyCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end
 
m.sigCfg = {
    ocClassName = "AppController",
    ocMethodName = "getDeviceSignalLevel",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getDeviceSignal",--"getDeviceNoWifiLevel",
    javaMethodSig = "()Ljava/lang/String;",
}

function m:getDeviceSignalLevel()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.sigCfg.ocClassName,self.sigCfg.ocMethodName)

    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.sigCfg.javaClassName,self.sigCfg.javaMethodName,nil,self.sigCfg.javaMethodSig)
    elseif "windows" == device.platform then
        res = 1
    end
    return res
end

m.batCfg = {
    ocClassName = "AppController",
    ocMethodName = "getDeviceBattery",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getDeviceBattery",
    javaMethodSig = "()Ljava/lang/String;",
}

function m:getDeviceBattery()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.batCfg.ocClassName,self.batCfg.ocMethodName)

    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.batCfg.javaClassName,self.batCfg.javaMethodName,nil,self.batCfg.javaMethodSig)
    elseif "windows" == device.platform then
        res = 1
    end
    return res
end

function m:getAppDownLoadUrl()
    local url = ""
    if "ios" == device.platform then
        url =  "https://itunes.apple.com/cn/app/xian-lai-nan-chang-ma-jiang/id1114285005?mt=8"              
    elseif "android" == device.platform then
        url = "http://www.gongyang58.com:8080/apkdownload/"
    end
    return url
end

m.oUrlCfg = {
    ocClassName = "AppController",
    ocMethodName = "openWebURL",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "openWebURL",
    javaMethodSig = "(Ljava/lang/String;)V",
}

function m:openWebURL(url)
    local ocParam = {
        webURL = url
    }
    local javaParam = {url}
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.oUrlCfg.ocClassName,self.oUrlCfg.ocMethodName,ocParam)

    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.oUrlCfg.javaClassName,self.oUrlCfg.javaMethodName,javaParam,self.oUrlCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.pbCCfg = {
    ocClassName = "AppController",
    ocMethodName = "getPastBordContext",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getPastBordContext",
    javaMethodSig = "(I)Ljava/lang/String;",
}
function m:getPastBordContext(cbHandle)
    local ok,res = "",""
    local javaParam = {cbHandle}
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.pbCCfg.ocClassName,self.pbCCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.pbCCfg.javaClassName,self.pbCCfg.javaMethodName,javaParam,self.pbCCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.appV = {
    ocClassName = "AppController",
    ocMethodName = "getVersionName",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getAppVersionName",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:getAppVersionName()
    local ok,res = "",""
    local javaParam = nil
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.appV.ocClassName,self.appV.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.appV.javaClassName,self.appV.javaMethodName,javaParam,self.appV.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

function m:getAppID()
    local res = "WeiXinAppID"
    return res
end

m.openID = {
    ocClassName = "AppController",
    ocMethodName = "getOpenUDID",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "getOpenUDID",
    javaMethodSig = "()Ljava/lang/String;",
}
function m:getOpenUDID()
    local ok,res = "",""
    local javaParam = nil
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.openID.ocClassName,self.openID.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.openID.javaClassName,self.openID.javaMethodName,javaParam,self.openID.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.payIapCg = {
    ocClassName = "AppController",
    ocMethodName = "pay_iap",
}
--支付
function m:payIap(quantity,cbHandle)
    local ocParam = {
        quantity = quantity,
        scriptHandler = cbHandle,
    }
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.payIapCg.ocClassName,self.payIapCg.ocMethodName,ocParam)
    elseif "android" == device.platform then
    elseif "windows" == device.platform then

    end
end

m.reqIapCg = {
    ocClassName = "AppController",
    ocMethodName = "req_iap",
}
function m:reqIap(identifier,cbHandle)
    local ocParam = {
        identifier = identifier,
        scriptHandler = cbHandle,
    }
    local ok,res = false,false
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.reqIapCg.ocClassName,self.reqIapCg.ocMethodName,ocParam)
    elseif "android" == device.platform then
    elseif "windows" == device.platform then

    end
    return ok
end

m.existMethodCg = {
    ocClassName = "AppController",
    ocMethodName = "isExistMethod",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isExistMethod",
    javaMethodSig = "(Ljava/lang/String;)Z",
}
function m:isExistMethod(methodName)
    local ok,res = false,false
    local ocParam = {
        methodName = methodName or "",--函数名后要有冒号(:)
    }
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.existMethodCg.ocClassName,self.existMethodCg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        -- ok,res = luaNative.callStaticMethod(self.existMethodCg.javaClassName,self.existMethodCg.javaMethodName,javaParam,self.existMethodCg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

return m
