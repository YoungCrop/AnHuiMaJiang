
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 

m.insCfg = {
    ocClassName = "AppController",
    ocMethodName = "isWeiboAppInstalled",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isWbAppInstalled",
    javaMethodSig = "()Z",
}
function m:checkIsInstalled()
    local ok,res = false,false
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.insCfg.ocClassName,self.insCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.insCfg.javaClassName,self.insCfg.javaMethodName,nil,self.insCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.txtCfg = {
    ocClassName = "AppController",
    ocMethodName = "shareToWeiBo",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareTextToWeiBo",
    javaMethodSig = "(Ljava/lang/String;I)V",
}
function m:shareText(_txt,cbHandle)
    local ocParam = {
        shareType = "text",
        title = _txt,
        description = "",
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
    ocMethodName = "shareToWeiBo",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareImageToWeiBo",
    javaMethodSig = "(Ljava/lang/String;I)V",
}
function m:shareImage(_imgPath,_title,_desc,cbHandle)
    local ocParam = {
        shareType = "image",
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
    ocMethodName = "shareToWeiBo",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareURLToWeiBo",
    javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
}

function m:shareURL(_url,_title,_desc,cbHandle)
    local ocParam = {
        shareType = "link",
        url = _url,
        title = _title or "",
        description = _desc or "",
        scriptHandler = cbHandle,
        imgFilePath = "",
    }
    local javaParam = {_url,_title or "",_desc or "",cbHandle}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.ocClassName,self.urlCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.javaClassName,self.urlCfg.javaMethodName,javaParam,self.urlCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


return m