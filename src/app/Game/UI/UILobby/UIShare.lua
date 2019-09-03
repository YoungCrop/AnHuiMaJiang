
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local ConfigShare = require("app.Common.Config.ConfigShare")

local csbFile = "Csd/ILobby/UIShare.csb"

local n = {}
local m = class("UIShare",gComm.UIMaskLayer)

function m:ctor(isShared)
    local args = {
        opacity = 85,
    }
    m.super.ctor(self,args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    
    self.isShared = isShared
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnPYQ    = "btnPYQ",
    btnQQ     = "btnQQ",
    btnQQZone = "btnQQZone",
    btnWeiBo  = "btnWeiBo",
    btnWeiXin = "btnWeiXin",
    btnZFB    = "btnZFB",
}
n.nodeMap = {
    imgBG = "imgBG",
}

function m:loadCSB()
 	-- local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
 	local csbNode = cc.CSLoader:createNode(csbFile)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        if self.isShared then
            btn:getChildByName("iconJaing"):setVisible(false)
        end
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
end

n.isTest = false

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnWeiXin then
        local _type = gCallNativeMng.shareType.WeiXin
        self:shareHandle(_type)
    elseif s_name == n.btnMap.btnPYQ then
        local res = gComm.StringUtils.compareVersion(cc.exports.gData.ModleGlobal.appVersion,"1.0.12")
        if res == 1 then
            self:shareNativePYQ(1)
        else
            local _type = gCallNativeMng.shareType.WeiXinPYQ
            self:shareHandle(_type)
        end
    elseif s_name == n.btnMap.btnQQ then
        local _type = gCallNativeMng.shareType.QQ
        self:shareHandle(_type)
    elseif s_name == n.btnMap.btnQQZone then
        local _type = gCallNativeMng.shareType.QQZone
        self:shareHandle(_type)
    elseif s_name == n.btnMap.btnWeiBo then
        local _type = gCallNativeMng.shareType.WeiBo
        self:shareHandle(_type)
    elseif s_name == n.btnMap.btnZFB then
        local _type = gCallNativeMng.shareType.Zfb
        self:shareHandle(_type)
    end
end
-- if(platform == 1){//微信朋友圈
-- }else if (platform == 2){//微信好友
-- }else if (platform == 3){//QQ好友
-- }else if (platform == 4){//QQ空间
-- }else if (platform == 5){//微博
-- }else if (platform == 6){//支付宝
function m:shareNativePYQ(platform)
    -- local filePath = cc.FileUtils:getInstance():fullPathForFilename("Image/BigImg/WechatPYQShare.png")
    -- log("path ===1234===",filePath)

    local txt = ""
    local handle = handler(self,self.Tip)
    if "android" == device.platform then

        gCallNativeMng.NativeWeiXin:removeShareUri()
        local imageObj = cc.Image:new()
        imageObj:initWithImageFile("Image/BigImg/WechatPYQShare.png")
        local filePath = cc.FileUtils:getInstance():getWritablePath().."WechatPYQShare.png"
        imageObj:saveToFile(filePath)

        gCallNativeMng.NativeWeiXin:shareNativePYQImage(platform,txt,filePath,handle)
        NetLobbyMng.getCardByShare()
    elseif "ios" == device.platform then
        local url = gCallNativeMng.NativeMeChuang:getMCURL()
        gCallNativeMng.NativeWeiXin:openNativeShareURL(url,txt,handle)
    end
end

function m:shareHandle(_type)
    if not gCallNativeMng:checkIsInstalled(_type) then
        gComm.UIUtils.floatText("未安装此app!")
        return
    end
    local handle = handler(self,self.Tip)
    local title = ConfigTxtTip.GetConfigTxt("LTKey_AppName")
    local desc = ConfigShare.lobbyShareDesRandom[math.random(1,#ConfigShare.lobbyShareDesRandom)]
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    gCallNativeMng:shareURL(_type,url,title,desc,handle)  
    self:removeFromParent()
end

--[[

--支付宝
//  错误码
typedef enum {
    APSuccess           = 0,    //  成功
    APErrCodeCommon     = -1,   //  通用错误
    APErrCodeUserCancel = -2,   //  用户取消
    APErrCodeSentFail   = -3,   //  发送失败
    APErrCodeAuthDeny   = -4,   //  授权失败
    APErrCodeUnsupport  = -5,   //  不支持
}APErrorCode;

--QQ
typedef enum
{
    EQQAPISENDSUCESS = 0,
    EQQAPIQQNOTINSTALLED = 1,
    EQQAPIQQNOTSUPPORTAPI = 2,
    EQQAPIMESSAGETYPEINVALID = 3,
    EQQAPIMESSAGECONTENTNULL = 4,
    EQQAPIMESSAGECONTENTINVALID = 5,
    EQQAPIAPPNOTREGISTED = 6,
    EQQAPIAPPSHAREASYNC = 7,
    EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
    EQQAPISENDFAILD = -1,
    EQQAPISHAREDESTUNKNOWN = -2, //未指定分享到QQ或TIM
    
    EQQAPITIMNOTINSTALLED = 11, //TIM未安装
    EQQAPITIMNOTSUPPORTAPI = 12, // TIM api不支持
    //qzone分享不支持text类型分享
    EQQAPIQZONENOTSUPPORTTEXT = 10000,
    //qzone分享不支持image类型分享
    EQQAPIQZONENOTSUPPORTIMAGE = 10001,
    //当前QQ版本太低，需要更新至新版本才可以支持
    EQQAPIVERSIONNEEDUPDATE = 10002,
    ETIMAPIVERSIONNEEDUPDATE = 10004,
} QQApiSendResultCode;

--微博
typedef NS_ENUM(NSInteger, WeiboSDKResponseStatusCode)
{
    WeiboSDKResponseStatusCodeSuccess               = 0,//成功
    WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
    WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
    WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
    WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
    WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
    WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
    WeiboSDKResponseStatusCodeUnknown               = -100,
};

--微信
enum  WXErrCode {
    WXSuccess           = 0,    /**< 成功    */
    WXErrCodeCommon     = -1,   /**< 普通错误类型    */
    WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    WXErrCodeSentFail   = -3,   /**< 发送失败    */
    WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
    WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
};

]]

function m:Tip(resId,errorDesc)
    local arr = string.split(resId,"&")
    local str = arr[1]
    if arr[2] then
        str = str .. "   " .. arr[2]
    end
    if errorDesc then
        str = str .. "   " .. errorDesc
    end
    log("myTip======" .. str)
    
    if arr[1] == "0" or arr[1] == "com.tencent.xin.sharetimeline" then
        -- UINoticeTips:create("分享成功")
        -- gComm.UIUtils.floatText("分享成功")
        -- gComm.UIUtils.floatText(str)
        NetLobbyMng.getCardByShare()
    else
        str = str .. "======" .. (resId or "nil-nil") .. (arr[1] or "arr[1]")
        -- UINoticeTips:create(str)
        -- gComm.UIUtils.floatText(str)
    end
end

function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)

    dump(Size,"====size====")

    if not cc.rectContainsPoint(Rect, touchPoint) then
        self:removeFromParent()
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    self:setTouchEndedHandle(handler(self,self.onTouchEnded))
end

function m:onExit()
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m
