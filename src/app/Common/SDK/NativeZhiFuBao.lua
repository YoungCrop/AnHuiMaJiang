
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 


m.txtCfg = {
    ocClassName = "AppController",
    ocMethodName = "shareTextToZFB",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareTextToZFB",
    javaMethodSig = "(Ljava/lang/String;I)V",
}
function m:shareText(_txt,cbHandle)
    local ocParam = {
        text = _txt,
        scriptHandler = cbHandle,
    }
    local javaParam = {_txt,cbHandle}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.txtCfg.ocClassName,self.txtCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.txtCfg.javaClassName,self.txtCfg.javaMethodName,javaParam,self.txtCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.imageCfg = {
	ocClassName = "AppController",
	ocMethodName = "shareImageToZFB",

	javaClassName = "org/cocos2dx/lua/AppActivity",
	javaMethodName = "shareImageToZFB",
	javaMethodSig = "(Ljava/lang/String;I)V",
}
function m:shareImage(_imgPath,cbHandle)
    local ocParam = {
        imgFilePath = _imgPath,
        scriptHandler = cbHandle,
    }
    local javaParam = {_imgPath,cbHandle}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.ocClassName,self.imageCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.javaClassName,self.imageCfg.javaMethodName,javaParam,self.imageCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


m.urlCfg = {
	ocClassName = "AppController",
	ocMethodName = "shareURLToZFB",

	javaClassName = "org/cocos2dx/lua/AppActivity",
	javaMethodName = "shareURLToZFB",
	javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
}

function m:shareURL(_url,_title,_desc,cbHandle)
    local ocParam = {
        url = _url,
        title = _title or "",
        description = _desc or "",
        scriptHandler = cbHandle,
    }
    local javaParam = {_url,_title or "",_desc or "",cbHandle}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.ocClassName,self.urlCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.javaClassName,self.urlCfg.javaMethodName,javaParam,self.urlCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.istCfg = {
    ocClassName = "AppController",
    ocMethodName = "isAPAppInstalled",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isZFBAppInstalled",
    javaMethodSig = "()Z",
}

function m:isAPAppInstalled()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.istCfg.ocClassName,self.istCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.istCfg.javaClassName,self.istCfg.javaMethodName,nil,self.istCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.supCfg = {
    ocClassName = "AppController",
    ocMethodName = "isAPAppSupportOpenApi",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isZFBSupportAPI",
    javaMethodSig = "()Z",
}

function m:isAPAppSupportOpenApi()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.supCfg.ocClassName,self.supCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.supCfg.javaClassName,self.supCfg.javaMethodName,nil,self.supCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end


m.supTimeCfg = {
    ocClassName = "AppController",
    ocMethodName = "isAPAppSupportShareTimeLine",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isAPAppSupportShareTimeLine",
    javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V",
}

function m:isAPAppSupportShareTimeLine()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.supTimeCfg.ocClassName,self.supTimeCfg.ocMethodName)
    elseif "android" == device.platform then
        -- local ok,res = luaNative.callStaticMethod(self.supTimeCfg.javaClassName,self.supTimeCfg.javaMethodName,nil,self.supTimeCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

return m