
local NativeWeiXin = require("app.Common.SDK.NativeWeiXin")
local NativeQQ = require("app.Common.SDK.NativeQQ")
local NativeFanKui = require("app.Common.SDK.NativeFanKui")
local NativeGaoDe = require("app.Common.SDK.NativeGaoDe")
local NativeMeChuang = require("app.Common.SDK.NativeMeChuang")
local NativeWeiBo = require("app.Common.SDK.NativeWeiBo")
local NativeZhiFuBao = require("app.Common.SDK.NativeZhiFuBao")
local AppNative = require("app.Common.SDK.AppNative")
local NativeYaya = require("app.Common.SDK.NativeYaya")

local m = {}

m.NativeYaya = NativeYaya
m.AppNative = AppNative
m.NativeGaoDe = NativeGaoDe
m.NativeMeChuang = NativeMeChuang
m.NativeFanKui = NativeFanKui
m.NativeWeiXin = NativeWeiXin

m.shareType = {
    QQ = "QQ", --QQ好友
    QQZone = "QQZone", --QQ空间
    WeiBo = "WeiBo",--新浪微博
    Zfb   = "Zfb", --支付宝
    WeiXin = "WeiXin",--微信好友
    WeiXinPYQ = "WeiXinPYQ",--微信朋友圈
}

function m:checkIsInstalled(_type)
    local isInstalled = false
    if _type == m.shareType.WeiBo then
        isInstalled = NativeWeiBo:checkIsInstalled()
    elseif _type == m.shareType.WeiXin or _type == m.shareType.WeiXinPYQ then
        isInstalled = NativeWeiXin:isWXAppInstalled()
    elseif _type == m.shareType.QQ or _type == m.shareType.QQZone then
        isInstalled = NativeQQ:isQQInstalled()
    elseif _type == m.shareType.Zfb then
        isInstalled = NativeZhiFuBao:isAPAppInstalled()
    end
    return isInstalled
end

function m:isSupportApi(_type)
    local isInstalled = false
    if _type == m.shareType.WeiBo then
    elseif _type == m.shareType.WeiXin then
        isInstalled = NativeWeiXin:isWXAppInstalled()
    elseif _type == m.shareType.QQ then
        isInstalled = NativeQQ:isQQSupportApi()
    elseif _type == m.shareType.Zfb then
        isInstalled = NativeZhiFuBao:isAPAppSupportOpenApi()
    end
    return isInstalled
end

function m:shareText(_type,_txt,cbHandle)
    if _type == m.shareType.QQ then
        NativeQQ:shareText(1,_txt,cbHandle)
    elseif _type == m.shareType.QQZone then
        --弹出的QQ界面中没有QQ空间,不支持QQ空间分享文本
        NativeQQ:shareText(2,_txt,cbHandle)
    elseif _type == m.shareType.WeiXin then
        NativeWeiXin:shareText(0,_txt,cbHandle)
    elseif _type == m.shareType.WeiXinPYQ then
        NativeWeiXin:shareText(1,_txt,cbHandle)
    elseif _type == m.shareType.Zfb then
        NativeZhiFuBao:shareText(_txt,cbHandle)
    elseif _type == m.shareType.WeiBo then
        NativeWeiBo:shareText(_txt,cbHandle)
    end
end

function m:shareImage(_type,_imgPath,_title,_desc,cbHandle)
    if _type == m.shareType.QQ then
        NativeQQ:shareImage(1,_imgPath,_title,_desc,cbHandle)
    elseif _type == m.shareType.QQZone then
        --弹出的QQ界面中没有QQ空间,不支持QQ空间分享图片
        NativeQQ:shareImage(2,_imgPath,_title,_desc,cbHandle)

    elseif _type == m.shareType.WeiXin then
        NativeWeiXin:shareImage(0,_imgPath,_title,_desc,cbHandle)
    elseif _type == m.shareType.WeiXinPYQ then
        NativeWeiXin:shareImage(1,_imgPath,_title,_desc,cbHandle)
        
    elseif _type == m.shareType.Zfb then
        NativeZhiFuBao:shareImage(_imgPath,_title,_desc,cbHandle)
    elseif _type == m.shareType.WeiXin then
        NativeWeiXin:shareImage(_imgPath,_title,_desc,cbHandle)
    elseif _type == m.shareType.WeiBo then
        NativeWeiBo:shareImage(_imgPath,_title,_desc,cbHandle)
    end
end

function m:shareURL(_type,_url,_title,_desc,cbHandle)
    if _type == m.shareType.QQ then
        NativeQQ:shareURL(1,_url,_title,_desc,cbHandle)
    elseif _type == m.shareType.QQZone then
        NativeQQ:shareURL(2,_url,_title,_desc,cbHandle)

    elseif _type == m.shareType.WeiXin then
        NativeWeiXin:shareURL(0,_url,_title,_desc,cbHandle)
    elseif _type == m.shareType.WeiXinPYQ then
        NativeWeiXin:shareURL(1,_url,_title,_desc,cbHandle)

    elseif _type == m.shareType.Zfb then
        NativeZhiFuBao:shareURL(_url,_title,_desc,cbHandle)

    
    -- 0--好友 1--朋友圈
    elseif _type == m.shareType.WeiXin then
        NativeWeiXin:shareURL(0,_url,_title,_desc,cbHandle)
    elseif _type == m.shareType.WeiXinPYQ then
        NativeWeiXin:shareURL(1,_url,_title,_desc,cbHandle)

    elseif _type == m.shareType.WeiBo then
        NativeWeiBo:shareURL(_url,_title,_desc,cbHandle)
    end
end

return m