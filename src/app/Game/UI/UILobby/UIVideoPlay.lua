

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")
local netMng = require("app.Common.NetMng.NetLobbyMng")
local ItemVideoPlay = require("app.Game.UI.UILobby.Item.ItemVideoPlay")
local UIVideoPlayDetail = require("app.Game.UI.UILobby.UIVideoPlayDetail")

local csbFile = "Csd/ILobby/UIVideoPlay.csb"

local n = {}
local m = class("UIVideoPlay",gComm.UIMaskLayer)

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
    btnExit = "btnExit",
}
n.nodeMap = {
    lvContent = "lvContent",
    txtEmpty = "txtEmpty",
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
    self.btnMap["txtEmpty"]:setVisible(false)

    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_HISTORY_RECORD, self, self.onRcvHistoryRecord)
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_REPLAY, self, self.onRcvReplay)
    netMng.getHistoryRecord(self.uid)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
        self:removeFromParent()
    end
end

function m:onRcvHistoryRecord(msgTbl)
    dump(msgTbl,"m:onRcvHistoryRecord---" .. #msgTbl.m_data)
    if #msgTbl.m_data == 0 then
        -- 没有战绩
        self.btnMap["txtEmpty"]:setVisible(true)
    else
        -- 显示战绩列表
        self.historyMsgTbl = msgTbl
        for i, cellData in ipairs(msgTbl.m_data) do
            cellData.index = i
            local item = ItemVideoPlay:create(cellData)
            item:setClickHandle(handler(self,self.clickHandle))
            local cellSize = item:getContentSize()
            local cellItem = ccui.Widget:create()
            cellItem:setContentSize(cellSize)
            cellItem:addChild(item)
            self.btnMap["lvContent"]:pushBackCustomItem(cellItem)
        end
    end
end

function m:clickHandle( index )
    local cellData = self.historyMsgTbl.m_data[index]
    local layer = UIVideoPlayDetail:create(cellData)
    self:addChild(layer)
end

function m:onRcvReplay( msgTbl )
    dump(msgTbl,"m:onRcvReplay---")
    if msgTbl.m_gameID == DefineRule.GameID.POKER_DDZ then
        if #msgTbl.m_card0 == 0 then
            gComm.UIUtils.floatText("无回放数据!")
        else
            local isJiaofen = true
            for _,v in pairs(msgTbl.m_playtype) do 
                if v == DefineRule.GREnum.DDZ_JIAO_FEN then
                    isJiaofen = true
                elseif v == DefineRule.GREnum.DDZ_JIAO_DIZHU then
                    isJiaofen = false
                end
            end
            if isJiaofen then
                local layer = require("app.Game.UI.UIGame.PokerDDZ.UIPlaybackJiaoFen"):create(msgTbl)
                self:addChild(layer, 6)
            else
                local layer = require("app.Game.UI.UIGame.PokerDDZ.UIPlaybackClassic"):create(msgTbl)
                self:addChild(layer, 6)
            end
        end
        return 
    elseif msgTbl.m_gameID == DefineRule.GameID.GameID_TDK then 
        gComm.UIUtils.floatText("填大坑回放暂未开放")
    elseif msgTbl.m_gameID == DefineRule.GameID.AnQinDianPao then
        local layer = require("app.Game.UI.UIGame.MJAnQing.UIPlayback"):create(msgTbl)
        self:addChild(layer, 6)
    elseif msgTbl.m_gameID == DefineRule.GameID.MJHuaiBei then
        local layer = require("app.Game.UI.UIGame.MJHuaiBei.UIPlayback"):create(msgTbl)
        self:addChild(layer, 6)
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m