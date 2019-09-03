
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local ItemCoinMain = require("app.Game.UI.UILobby.Item.ItemCoinMain")

local csbFile = "Csd/ILobby/Coin/UICoinExchangeTip.csb"

local n = {}
local m = class("UICoinExchangeTip",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        cardNum = args.cardNum,
        coinNum = args.coinNum,
        okHandler = args.okHandler,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose  = "btnClose",
    btnCancle = "btnCancle",
    btnOK     = "btnOK",
}

n.nodeMap = {
    imgBG     = "imgBG",
    panel     = "panel",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    
    self:initRichText(self.param.cardNum,self.param.coinNum)
end

function m:initRichText(cardNum,coinNum)
    local colorY = cc.c3b(139,105,20)
    local colorR = cc.c3b(255,0,0)
    local fontFile = "fonts/DroidDefault.ttf"--"Helvetica"
    local fontSize = 30
    local size = self.btnMap["panel"]:getContentSize()

    self._richText = ccui.RichText:create()
    self._richText:ignoreContentAdaptWithSize(false)
    self._richText:setContentSize(size)
    self._richText:setVerticalSpace(15)

    -- 是否用       60房卡         兑换             10000金币             ？
    -- 充值成功后将为您自动购买
    -- 剩余的房卡房卡返回您的账户

    local re1 = ccui.RichElementText:create(1, colorY, 255, "是否用", fontFile, fontSize)
    local re2 = ccui.RichElementText:create(2, colorR, 255, cardNum, fontFile, fontSize)
    local re3 = ccui.RichElementText:create(3, colorY, 255, "兑换", fontFile, fontSize)
    local re4 = ccui.RichElementText:create(4, colorR, 255, coinNum, fontFile, fontSize)
    local re5 = ccui.RichElementText:create(5, colorY, 255, "?", fontFile, fontSize)

    local reNewLine1 = ccui.RichElementNewLine:create(19, colorY, 255)
    local re6 = ccui.RichElementText:create(6, colorY, 255, "充值成功后将为您自动购买", fontFile, fontSize)
    local re7 = ccui.RichElementText:create(7, colorR, 255, coinNum, fontFile, fontSize)

    local reNewLine2 = ccui.RichElementNewLine:create(19, colorY, 255)
    local re8 = ccui.RichElementText:create(8, colorY, 255, "剩余的房卡房卡返回您的账户", fontFile, fontSize)


    self._richText:pushBackElement(re1)
    self._richText:pushBackElement(re2)
    self._richText:pushBackElement(re3)
    self._richText:pushBackElement(re4)
    self._richText:pushBackElement(re5)

    self._richText:pushBackElement(reNewLine1)
    self._richText:pushBackElement(re6)
    self._richText:pushBackElement(re7)

    self._richText:pushBackElement(reNewLine2)
    self._richText:pushBackElement(re8)

    self._richText:setPosition(cc.p(size.width / 2, size.height / 2))
    self._richText:setLocalZOrder(10)

    self.btnMap["panel"]:addChild(self._richText)

    gComm.Debug:logUD(self._richText,"=======_richText----")
end


function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnOK then
        if self.param.okHandler then
            self.param.okHandler()
        end
        self:removeFromParent()
    elseif s_name == n.btnMap.btnCancle then
        self:removeFromParent()
    end
end
 

function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m