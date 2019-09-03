
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {}


local WX_APP_ID = "wx1cfbd0c36d76b153"
local WX_SECRET = "40e280e6badd58c2c193f9f541d01ffa"
local WX_BASE_URL = "https://api.weixin.qq.com/sns/"
local ACCESS_TOKEN_URL  = WX_BASE_URL .. "oauth2/access_token?grant_type=authorization_code&appid=%s&secret=%s&code=%s"
local REFRESH_TOKEN_URL = WX_BASE_URL .. "oauth2/refresh_token?grant_type=refresh_token&appid=%s&refresh_token=%s"
local USER_INFO_URL     = WX_BASE_URL .. "userinfo?access_token=%s&openid=%s"

function m:getAccessTokenUrl(code)
    local str = string.format(ACCESS_TOKEN_URL,WX_APP_ID,WX_SECRET,code)
    return str
end

function m:getRefreshTokenUrl(refresh_token)
    local str = string.format(REFRESH_TOKEN_URL,WX_APP_ID,refresh_token)
    return str
end

function m:getUerInfoUrl(access_token,openid)
    local str = string.format(USER_INFO_URL,access_token,openid)
    return str
end

        
m.txtCfg = {
    ocClassName = "AppController",
    ocMethodName = "shareTextToWX",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareTextToWX",
    javaMethodSig = "(ILjava/lang/String;I)V",
}
function m:shareText(_type,_txt,cbHandle)
    local ocParam = {
        disType = _type,
        text = _txt,
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
    ocMethodName = "shareImageToWX",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareImageToWX",
    javaMethodSig = "(ILjava/lang/String;I)V",
}
function m:shareImage(_type,_imgPath,_title,_desc,cbHandle)
    local ocParam = {
        disType = _type,
        imgFilePath = _imgPath,
        title = _title or "分享图片",
        description = _desc or "我说些啥呢,^^^",
        scriptHandler = cbHandle,
    }
    local javaParam = {_type,_imgPath,cbHandle}

    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.ocClassName,self.imageCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageCfg.javaClassName,self.imageCfg.javaMethodName,javaParam,self.imageCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


m.urlCfg = {
    ocClassName = "AppController",
    ocMethodName = "shareURLToWX",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareURLToWX",
    javaMethodSig = "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V",
}

function m:shareURL(_type,_url,_title,_desc,cbHandle)
    local ocParam = {
        disType = _type,
        url = _url,
        title = _title or "",
        description = _desc or "",
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

m.istCfg = {
    ocClassName = "AppController",
    ocMethodName = "isWXAppInstalled",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "isWXAppInstalled",
    javaMethodSig = "()Z",
}

function m:isWXAppInstalled()
    local ok,res
    if "ios" == device.platform then
        ok,res = luaNative.callStaticMethod(self.istCfg.ocClassName,self.istCfg.ocMethodName)
    elseif "android" == device.platform then
        ok,res = luaNative.callStaticMethod(self.istCfg.javaClassName,self.istCfg.javaMethodName,nil,self.istCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
    return res
end

m.authCfg = {
    ocClassName = "AppController",
    ocMethodName = "sendAuthRequest",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "sendAuthRequest",
    javaMethodSig = "(I)V",
}
-- 微信授权登录
function m:sendAuthRequest(cbHandle)
    local ocParam = {
        scriptHandler = cbHandle,
    }
    local javaParam = {cbHandle}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.authCfg.ocClassName,self.authCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.authCfg.javaClassName,self.authCfg.javaMethodName,javaParam,self.authCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.imageNativeCfg = {
    ocClassName = "AppController",
    ocMethodName = "openNativeShareImageToWX",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "shareToWXPYQNativeImage",
    javaMethodSig = "(ILjava/lang/String;Ljava/lang/String;)V",
}
-- if(platform == 1){//微信朋友圈 ok
-- }else if (platform == 2){//微信好友 ok
-- }else if (platform == 3){//QQ好友
-- }else if (platform == 4){//QQ空间
-- }else if (platform == 5){//微博 ok
-- }else if (platform == 6){//支付宝
function m:shareNativePYQImage(_platform,_txt,_filePath,cbHandle)
    local ocParam = {
        platform = _platform,
        text     = _txt,
        imgFilePath = _filePath,
        scriptHandler = cbHandle,
        disType = 1,
    }
    local javaParam = {_platform,_txt,_filePath}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageNativeCfg.ocClassName,self.imageNativeCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.imageNativeCfg.javaClassName,self.imageNativeCfg.javaMethodName,javaParam,self.imageNativeCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

m.uriCfg = {
    -- ocClassName = "AppController",
    -- ocMethodName = "sendAuthRequest",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "removeShareUri",
    javaMethodSig = "()V",
}
--删除文件夹中的图片资源
function m:removeShareUri()
    local ocParam = {
    }
    local javaParam = {}
    if "ios" == device.platform then
        -- local ok,res = luaNative.callStaticMethod(self.uriCfg.ocClassName,self.uriCfg.ocMethodName,ocParam)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.uriCfg.javaClassName,self.uriCfg.javaMethodName,javaParam,self.uriCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end


m.nativeShareURL = {
    ocClassName = "AppController",
    ocMethodName = "openNativeShare",

    -- javaClassName = "org/cocos2dx/lua/AppActivity",
    -- javaMethodName = "sendAuthRequest",
    -- javaMethodSig = "(I)V",
}

function m:openNativeShareURL(_url,_description,_cbHandle)
    local ocParam = {
        url           = _url,
        scriptHandler = _cbHandle,
        description   = _description,
    }
    local javaParam = {cbHandle}
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.nativeShareURL.ocClassName,self.nativeShareURL.ocMethodName,ocParam)
    elseif "android" == device.platform then
    elseif "windows" == device.platform then
    end
end




return m