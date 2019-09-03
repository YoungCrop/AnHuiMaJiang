
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetCoinGameMng = require("app.Common.NetMng.NetCoinGameMng")
local ItemCoinMain = require("app.Game.UI.UILobby.Item.ItemCoinMain")
local NodeCoinBtnListUI = require("app.Game.UI.UILobby.Coin.NodeCoinBtnListUI")
local NodeCoinRuleUI = require("app.Game.UI.UILobby.Coin.NodeCoinRuleUI")
local UICoinExchange = require("app.Game.UI.UILobby.Coin.UICoinExchange")
local UIShop = require("app.Game.UI.UILobby.UIShop")
local UIBuyCard = require("app.Game.UI.UILobby.UIBuyCard")
local EventCmdID = require("app.Common.Config.EventCmdID")
local ConfigCoinLimit = require("app.Common.Config.Coin.ConfigCoinLimit")
local ConfigCoinRuleType = require("app.Common.Config.Coin.ConfigCoinRuleType")
local DefineRule = require("app.Common.Config.DefineRule")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")

local csbFile = "Csd/ILobby/Coin/UICoinMain.csb"

local n = {}
local m = class("UICoinMain",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self._data = {
        curGameID = 0,
    }
    self._itemList = {}
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit      = "btnExit",
    btnWF        = "btnWF",
    btnCoinPlus  = "btnCoinPlus",
    btnCardPlus  = "btnCardPlus",
    btnHelp      = "btnHelp",
    btnStart     = "btnStart",
}

n.nodeMap = {
    imgBG       = "imgBG",
    imgGameName = "imgGameName",
    txtCoin     = "txtCoin",
    txtCard     = "txtCard",
    lvMain      = "lvMain",
    svMain      = "svMain",
}

n.GameNameImgCfg = {
    [DefineRule.GameID.POKER_DDZ]    = "Image/ILobby/UICoin/Coin_rule_doudizhu.png",
    [DefineRule.GameID.AnQinDianPao] = "Image/ILobby/UICoin/Coin_rule_anqing.png",
    [DefineRule.GameID.MJHuaiBei]    = "Image/ILobby/UICoin/Coin_rule_huaibei.png",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
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

    local playerData = cc.exports.gData.ModleGlobal
    self.btnMap["txtCard"]:setString(playerData.roomCardsCount[2])
    local data = cc.exports.gData.ModleGlobal:getSelfInfo()
    self.btnMap["txtCoin"]:setString(data.coinNum)
end

function m:initMainLS(gameID)
    log("gameID===",gameID)
    local img = n.GameNameImgCfg[gameID]
    if img then
        self.btnMap["imgGameName"]:loadTexture(img,ccui.TextureResType.plistType)
    end
    self.btnMap["lvMain"]:removeAllItems()
    self._itemList = {}

    local data = self:getCoinConfigData(gameID)
    local zhengshu,xiaoshu = math.modf(#data/2)
    if xiaoshu > 0 then
        zhengshu = zhengshu + 1
    end
    for i=1,zhengshu do
        local item = self:doItemLayout(data,i)
        self.btnMap["lvMain"]:pushBackCustomItem(item)
    end
end

function m:doItemLayout(data,groupIndex)

    local lvSize = self.btnMap["lvMain"]:getContentSize()
    local layout = ccui.Layout:create()
    layout:setTouchEnabled(true)
    layout:setContentSize(cc.size(lvSize.width/3,lvSize.height))

    local lSize = layout:getContentSize()
    for i=1,2 do
        local index = groupIndex + (i-1)*3
        local d = data[index]
        if d then
            local args = {
                index       = d.Index,
                clickHandle = handler(self,self.onItemHandle),
                coinNum     = d.MinCoin .. "以上",--MinCoin
                diFen       = d.Score,--Score
                menNum      = 0,--在线人数，服务器发送
                Open        = d.Open,--1开，0关
                itemImgBG   = d.DrawPicture,
            }
            local item = ItemCoinMain:create(args)
            self._itemList[d.Index] = item
            layout:addChild(item)
            item:setPosition(cc.p(lSize.width/2,lSize.height/4*(5-i*2)))
            -- item:setPosition(cc.p(lSize.width/2,lSize.height/4*(i*2-1)))
        end
    end
    return layout
end

function m:onItemHandle(index)
    log("==onItemHandle==",index)
    NetCoinGameMng.JoinCoinGame(index)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    local args = {}
    if s_name == n.btnMap.btnExit then
        NetCoinGameMng.levelCoinGameHall()
		self:removeFromParent()
    elseif s_name == n.btnMap.btnWF then
        args = {
            curGameID = self._data.curGameID,
            pos      = cc.p(_sender:getWorldPosition().x,_sender:getWorldPosition().y-5),
        }
        local layer = NodeCoinBtnListUI:create(args)
        self:addChild(layer)

    elseif s_name == n.btnMap.btnCoinPlus then
        args = {
            coinNum = self.btnMap["txtCoin"]:getString(),
            cardNum = self.btnMap["txtCard"]:getString(),
        }
        local layer = UICoinExchange:create(args)
        self:addChild(layer)

    elseif s_name == n.btnMap.btnCardPlus then
        args = {

        }
        if "ios" == device.platform then
            local layer = UIShop:create(args)
            self:addChild(layer)
        else
            local layer = UIBuyCard:create(args)
            self:addChild(layer)
        end
    elseif s_name == n.btnMap.btnHelp then
        args = {
            pos      = cc.p(_sender:getWorldPosition().x-25,_sender:getWorldPosition().y-25),
        }
        local layer = NodeCoinRuleUI:create(args)
        self:addChild(layer)

    elseif s_name == n.btnMap.btnStart then
        NetCoinGameMng.JoinFastCoinGame()
    end
end

-- m.GameID = {
--     MJChangChun   = 1,--长春麻将
--     GameID_TDK    = 2,--填大坑
--     POKER_DDZ     = 4,--斗地主
--     AnQinDianPao  = 5,--安庆点炮
--     MJHuaiBei     = 6,--淮北麻将
-- }
function m:getCoinConfigData(gameID)
    local data = {}
    for i,v in ipairs(ConfigCoinLimit.data) do
        if v.GameType == gameID then
            table.insert(data,v)
        end
    end
    return data
end

function m:onBtnSelectedHandle(eventName,args)
    args = args or {}
    local gameID = args.gameID
    dump(args,"==onBtnSelectedHandle==args====")
    -- self:initMainLS(gameID)
    self._data.curGameID = gameID

    gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0005"))
    NetCoinGameMng.GameCoinMainInfo(gameID)
end

function m:onCoinNumChange(eventName,args)
    args = args or {}
    self.btnMap["txtCard"]:setString(args.cardNum)
    self.btnMap["txtCoin"]:setString(args.coinNum)
end

function m:revCoinJoinFast(msgTbl)
    dump(msgTbl,"m:revCoinJoinFast======")
    -- //0,快速开始成功,1,已加入快速开始列表  2,低于当前大玩法中的任何一个小玩法的门票钱

    local errorList = {
        [1] = "已加入快速开始列表 ",
        [2] = "您的金币不足，无法进入任何场次",
        [3] = "已加入其他场",
    }

    if msgTbl.m_errorCode == 0 then
    elseif msgTbl.m_errorCode == 2 then
        if not self:isShwoCoinTip(msgTbl.maxTimes,msgTbl.curTimes,msgTbl.lower,msgTbl.lowerLimit) then
            gComm.UIUtils.floatText(errorList[2])
        end
    else
        local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:revCoinMainInfo(msgTbl)
    dump(msgTbl,"m:revCoinMainInfo======")
    gComm.UIUtils.removeLoadingTips()

    --0, 成功 ;1 没有任何金币场开启  ;2已经进入金币场准备状态不能退出; 3,该金币场已关闭,改为其他金币场
    local errorList = {
        [1] = "没有任何金币场开启 ",
        [2] = "已经进入金币场准备状态不能退出 ",
        [3] = "该金币场已关闭,改为其他金币场 ",
    }

    if msgTbl.m_errorCode == 0 then
        self._data.curGameID = msgTbl.big
        local isExist = true
        for k,v in pairs(msgTbl.index) do
            if not self._itemList[v] then
                isExist = false
            end
        end
        if isExist == false then
            self:initMainLS(msgTbl.big)
        end
        for k,v in pairs(msgTbl.index) do
            if self._itemList[v] then
                self._itemList[v]:setCurOnlineManNum(msgTbl.num[k])
            end
        end
    else
        local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:isShwoCoinTip(maxTimes,curTimes,coin,lowerLimit)
    if curTimes < maxTimes and
        cc.exports.gData.ModleGlobal:getSelfInfo().coinNum < lowerLimit then
        local str = "您的金币不足，每日可以领取" .. maxTimes .. "次".. coin .."金币的金币补助，是否领取？"
        local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
        UINoticeTips:create(str,function()
                    NetCoinGameMng.getCoin()
                end,function()
                    -- body
                end)
        return true
    else
        return false
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gComm.EventBus.regEventListener(EventCmdID.UI_COIN_BTN_SELECTED, self, self.onBtnSelectedHandle)
    gComm.EventBus.regEventListener(EventCmdID.UI_USER_COIN_CHANGE, self, self.onCoinNumChange)

    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_FAST_START, self, self.revCoinJoinFast)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_REFRESH_HALL, self,self.revCoinMainInfo)

    gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0005"))
    local data = cc.exports.gData.ModleGlobal:getSelfInfo()
    local index = cc.UserDefault:getInstance():getIntegerForKey("UICoinMainSelectIndex",-1)
    if index == -1 then
        index = data.m_coinBig or 4
    end
    self._data.curGameID = index
    NetCoinGameMng.GameCoinMainInfo(index)


    log("===coinMainTest--m--",m)
    log("===coinMainTest--self=",self)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
    gComm.EventBus.unRegAllEvent(self)

    cc.UserDefault:getInstance():setIntegerForKey("UICoinMainSelectIndex",self._data.curGameID)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end


return m
