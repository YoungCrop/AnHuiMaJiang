
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")
local netMng = require("app.Common.NetMng.NetLobbyMng")
local ItemBigWinGame = require("app.Game.UI.UILobby.Item.ItemBigWinMatch")
local UIBigWinRecord = require("app.Game.UI.UILobby.BigWinMatch.UIBigWinRecord")

local csbFile = "Csd/ILobby/BigWinMatch/UIBigWinMatch.csb"

local n = {}
local m = class("UIBigWinMatch",gComm.UIMaskLayer)

function m:ctor(uid)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.uid = uid
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit        = "btnExit",
    btnWinningList = "btnWinningList",
}
n.nodeMap = {
    lvContent = "lvContent",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_RED_MATCH_INFO, self, self.onRcvMatchList)
    netMng.getBigWinMatchInfo()
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
        self:removeFromParent()
    elseif s_name == n.btnMap.btnWinningList then
        local layer = UIBigWinRecord:create()
        self:addChild(layer)
    end
end

function m:onRcvMatchList(msgTbl)
    dump(msgTbl,"m:onRcvMatchList---")

    for i, data in ipairs(msgTbl.m_list) do
        local param = {
            gameID     = data.m_matchList + 3,
            matchID    = data.m_matchList,
            ruleList   = data.m_playtype,
            remainTime = data.m_lastTimes,
            needNum    = data.m_NeedCount,
            playerNum  = data.m_PlayerCount,
            curInMatchType = msgTbl.m_matchType,
            parentNode = self,
        }
        local item = ItemBigWinGame:create(param)
        item:setTag(param.matchID)
        local cellSize = item:getContentSize()
        local cellItem = ccui.Widget:create()
        cellItem:setContentSize(cellSize)
        cellItem:addChild(item)
        cellItem:setTag(param.matchID)
        self.btnMap["lvContent"]:pushBackCustomItem(cellItem)
    end
end

n.resDesc = {
    [0]  = "加入成功",
    [1]  = "退出成功",
    [2]  = "退出失败",
    [3]  = "已经参加其他比赛",
    [4]  = "没有这个比赛id",
    [5]  = "房卡不足",
    [6]  = "红包赛,玩家进入该玩法,已达最大次数",
    [7]  = "玩家在别的游戏内",
    [8]  = "服务器无该游戏",
}

function m:onRevJoinMatch(msg)
    dump(msg,"======onRevJoinMatch=======")
    --m_matchType;    //0.退出比赛 1.红包赛斗地主 2.红包赛安庆点炮 3. 红包赛淮北麻将 
    --m_errorCode;    //0 加入成功  1.退出成功 2.退出失败  3.已经参加其他比赛4.没有这个比赛id 5. 房卡不足; 6. 红包赛,玩家进入该玩法,已达最大次数
    gComm.UIUtils.floatText(n.resDesc[msg.m_errorCode])
    if msg.m_errorCode == 0 then
        local item = self.btnMap["lvContent"]:getChildByTag(msg.m_matchType):getChildByTag(msg.m_matchType)
        item:ChangeItemState(false,msg.m_PlayerCount)
    elseif msg.m_errorCode == 1 then
        local item = self.btnMap["lvContent"]:getChildByTag(msg.m_matchType):getChildByTag(msg.m_matchType)
        item:ChangeItemState(true,msg.m_PlayerCount)
    end
end

function m:onRcvReplay( msgTbl )
    dump(msgTbl,"m:onRcvReplay---")
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_JOIN_RED_MATCH, self, self.onRevJoinMatch)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m