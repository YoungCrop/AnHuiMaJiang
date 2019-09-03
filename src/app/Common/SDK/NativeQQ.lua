
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 


m.txtCfg = {
    ocClassName = "AppController",
    ocMethodName = "shareTextToQQ",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareTextToQQ",
    javaMethodSig = "(ILjava/lang/String;I)V",
}
function m:shareText(_type,_txt,cbHandle)
    local ocParam = {
        text = _txt,
        disType = _type,
        scriptHandler = cbHandle,
    }
    local javaParam = {_type,_txt,cbHandle}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.txtCfg.ocClassName,self.txtCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.txtCfg.javaClassName,self.txtCfg.javaMethodName,javaParam,self.txtCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.imageCfg = {
	ocClassName = "AppController",
	ocMethodName = "shareImageToQQ",

	javaClassName = "org/cocos2dx/lua/AppActivity",
	javaMethodName = "shareImageToQQ",
	javaMethodSig = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
}
function m:shareImage(_type,_imgPath,_title,_desc,cbHandle)
    local ocParam = {
        imgFilePath = _imgPath,
        title = _title or "分享图片",
        description = _desc or "我说些啥呢,^^^",
        disType = _type,
        scriptHandler = cbHandle,
    }
    local javaParam = {_type,_imgPath,_title,_desc,cbHandle}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.ocClassName,self.imageCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.javaClassName,self.imageCfg.javaMethodName,javaParam,self.imageCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


m.urlCfg = {
	ocClassName = "AppController",
	ocMethodName = "shareURLToQQ",

	javaClassName = "org/cocos2dx/lua/AppActivity",
	javaMethodName = "shareURLToQQ",
	javaMethodSig = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
}

function m:shareURL(_type,_url,_title,_desc,cbHandle)
    local ocParam = {
        url = _url,
        title = _title or "",
        description = _desc or "",
        disType = _type,
        scriptHandler = cbHandle,
    }
    local javaParam = {_type,_url,_title or "",_desc or "",cbHandle}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.ocClassName,self.urlCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.urlCfg.javaClassName,self.urlCfg.javaMethodName,javaParam,self.urlCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.insCfg = {
    ocClassName = "AppController",
    ocMethodName = "isQQInstalled",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isQQInstalled",
    javaMethodSig = "()Z",
}

function m:isQQInstalled()
    local ok,res = false,false
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.insCfg.ocClassName,self.insCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.insCfg.javaClassName,self.insCfg.javaMethodName,nil,self.insCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.supCfg = {
    ocClassName = "AppController",
    ocMethodName = "isQQSupportApi",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isQQSupportApi",
    javaMethodSig = "()Z",
}

function m:isQQSupportApi()
    local ok,res = false,false
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.supCfg.ocClassName,self.supCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.supCfg.javaClassName,self.supCfg.javaMethodName,nil,self.supCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

return m