
local gComm = cc.exports.gComm

local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local csbFile = "Csd/ILobby/UIAgreement.csb"

local n = {}
local m = class("UIAgreement",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit = "btnExit",
}
n.nodeMap = {
    svAgreement = "svAgreement",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)
    self._csbNode = csbNode

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self:reqAgreementHandle()
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
        self:removeFromParent()
    end
end

function m:reqAgreementHandle(str)
    local scrollVwSize = self.btnMap["svAgreement"]:getContentSize()
    -- local txt = gComm.LabelUtils.createTTFLabel(str, 30)
    -- txt:setAnchorPoint(0.5, 1)
    -- txt:setTextColor(cc.BLACK)
    -- txt:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    -- txt:setWidth(scrollVwSize.width)
    -- local labelSize = txt:getContentSize()
    -- txt:setPosition(scrollVwSize.width * 0.5, labelSize.height)
    -- self.btnMap["svAgreement"]:addChild(txt)
    -- self.btnMap["svAgreement"]:setInnerContainerSize(labelSize)

    local _webView = ccexp.WebView:create()
    _webView:setAnchorPoint(0,0)
    -- _webView:setPosition(scrollVwSize.width / 2, scrollVwSize.height / 2)
    _webView:setPosition(self.btnMap["svAgreement"]:getPosition())

    _webView:setContentSize(scrollVwSize)
    local url = "https://anhui-update.yongwuzhijing88.com/YwZj_2017/AnHui/agreement.txt"
    _webView:loadURL(url)
    _webView:setScalesPageToFit(true)

    _webView:setOnShouldStartLoading(function(sender, url)
        print("onWebViewShouldStartLoading, url is ", url)
        return true
    end)
    _webView:setOnDidFinishLoading(function(sender, url)
        -- gComm.UIUtils.removeLoadingTips()
        print("onWebViewDidFinishLoading, url is ", url)
    end)
    _webView:setOnDidFailLoading(function(sender, url)
        -- gComm.UIUtils.removeLoadingTips()
        print("setOnDidFailLoading, url is ", url)
    end)

    self._csbNode:addChild(_webView)

    -- gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))
    -- gComm.Debug:logUD(_webView,"--_webView_webView--")
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    
    local url = "https://anhui-update.yongwuzhijing88.com/YwZj_2017/AnHui/agreement.txt"
    -- self.xhr = gComm.XMLHttpMng.reqString(url,handler(self,self.reqAgreementHandle))
end

function m:onExit()
    log(self.__TAG,"onExit")
    
    if self.xhr then
        self.xhr:unregisterScriptHandler()
        self.xhr = nil
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m