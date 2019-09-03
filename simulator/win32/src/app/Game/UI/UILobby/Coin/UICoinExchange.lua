
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCoinGameMng = require("app.Common.NetMng.NetCoinGameMng")
local ItemCoinExchange = require("app.Game.UI.UILobby.Item.ItemCoinExchange")
local ConfigCoinExchange = require("app.Common.Config.Coin.ConfigCoinExchange")
local UICoinExchangeTip = require("app.Game.UI.UILobby.Coin.UICoinExchangeTip")

local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")

local csbFile = "Csd/ILobby/Coin/UICoinExchange.csb"

local n = {}
local m = class("UICoinExchange",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        coinNum = args.coinNum,
        cardNum = args.cardNum,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose      = "btnClose",
}

n.nodeMap = {
    imgBG       = "imgBG",
    txtCoin     = "txtCoin",
    txtCard     = "txtCard",
    lvMain      = "lvMain",
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
    self.btnMap["txtCoin"]:setString(self.param.coinNum)
    self.btnMap["txtCard"]:setString(self.param.cardNum)

    self:initMainLS()
end

function m:initMainLS()
    self.btnMap["lvMain"]:removeAllItems()
    local num = #ConfigCoinExchange.data
    local zhengshu,xiaoshu = math.modf(num/4)
    if xiaoshu > 0 then
        zhengshu = zhengshu + 1
    end
    for i=1,zhengshu do
        local item = self:doItemLayout(i)
        self.btnMap["lvMain"]:pushBackCustomItem(item)
    end
end

function m:doItemLayout(groupIndex)
    local lvSize = self.btnMap["lvMain"]:getContentSize()
    local layout = ccui.Layout:create()
    layout:setTouchEnabled(true)
    layout:setContentSize(cc.size(lvSize.width,lvSize.height/2))
    local lSize = layout:getContentSize()

    for i=1,4 do
        local index = (groupIndex - 1) * 4
        local data = ConfigCoinExchange.data[index + i]
        if data then
            local args = {
                index = data.Index,
                clickHandle = handler(self,self.onItemHandle),
                coinNum     = data.Coin .. "金币",
                cardNum     = data.CardCost,
                iconCoin    = data.DrawPicture,
            }
            local item = ItemCoinExchange:create(args)
            layout:addChild(item)
            item:setPosition(cc.p(lSize.width/8*(i*2-1),lSize.height/2))
        end
    end
    return layout
end

function m:onItemHandle(index)
    log("==onItemHandle==",index)
    local data = ConfigCoinExchange.data[index]
    local args = {
        coinNum     = data.Coin .. "金币",
        cardNum     = data.CardCost .. "房卡",
        okHandler   = function()
            NetCoinGameMng.ConvertCoin(index,data.CardCost)
        end,
    }
    local layer = UICoinExchangeTip:create(args)
    self:addChild(layer)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    end
end

function m:revCoinConvert(msgTbl)
    dump(msgTbl,"m:revCoinConvert======")
    -- Lint m_errorCode;   //0为兑换成功;1 索引值不对,查询数据不存在 ;2 该索引对应对的扣除房卡卡数不对,查询数据不存在;3 房卡不足
    -- Lint addCoin;       //玩家充值金币数
    -- Lint userCoin;      //玩家充值后现有金币数
    local errorList = {
        [1] = "索引值不对,查询数据不存在 ",
        [2] = "该索引对应对的扣除房卡卡数不对,查询数据不存在",
        [3] = "房卡不足",
        [0] = "兑换成功",
    }
    local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
    gComm.UIUtils.floatText(str)
    if msgTbl.m_errorCode == 0 then
        local args = { coinNum = msgTbl.userCoin }
        cc.exports.gData.ModleGlobal:setSelfInfo(args)
        self.btnMap["txtCoin"]:setString(msgTbl.userCoin)
        -- self.btnMap["txtCard"]:setString(self.param.cardNum)
    end
end

function m:onCoinNumChange(eventName,args)
    args = args or {}
    self.btnMap["txtCard"]:setString(args.cardNum)
    self.btnMap["txtCoin"]:setString(args.coinNum)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gComm.EventBus.regEventListener(EventCmdID.UI_USER_COIN_CHANGE, self, self.onCoinNumChange)
    
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_CONVERT, self, self.revCoinConvert)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gComm.EventBus.unRegAllEvent(self)
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m