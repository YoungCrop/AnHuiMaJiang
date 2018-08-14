
local gComm = cc.exports.gComm

local DefineRule = require("app.Common.Config.DefineRule")
local NetCmd = require("app.Common.NetMng.NetCmd")
local UIVideoPlayDetail = require("app.Game.UI.UILobby.UIVideoPlayDetail")
local ItemClubRecord = require("app.Game.UI.UILobby.Item.ItemClubRecord")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Club/ClubRecord.csb"

local n = {}
local m = class("ClubRecord",gComm.UIMaskLayer)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    m.super.ctor(self)
    dump(data,"==ClubRecord==",8)
    self.data = data
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit   = "btnExit",
    btnSelect = "btnSelect",
    txtDate   = "txtDate",
    btnDateChange = "btnDateChange",
}

n.nodeMap = {
    lvDate   = "lvDate",
    lvRecord = "lvRecord",
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
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["txtDate"]:setString(os.date("%Y/%m/%d"))
    -- 一天86400秒
    for i=1,9 do
        local time = os.time() - 86400*(i-1)
        local str = os.date("%Y/%m/%d",time)
        local btn = gComm.UIUtils.seekNodeByName(csbNode, "txtDate" .. i)
        self.btnMap["txtDate" .. i] = btn
        btn:setString(str)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end
    self.btnMap["lvDate"]:setVisible(false)
    self:showData(self.data)
end

function m:showData(param)
    if param.m_errorCode == 0 then
        self.data = param
        local data = param.m_data or {}
        self.btnMap["lvRecord"]:removeAllItems()
        if #data == 0 then
            self.btnMap["txtEmpty"]:setVisible(true)
        else
            self.btnMap["txtEmpty"]:setVisible(false)
            for i,v in ipairs(data) do
                local args = {
                    index        = i,
                    userIDList   = v.m_userid,
                    nikeNameList = v.m_nike,
                    headURLList  = v.m_headurl,
                    scoreList    = v.m_score,
                    recordID  = v.m_id,
                    gameID    = v.m_gameId,
                    clubID    = v.m_clubId,
                    deskID    = v.m_deskId,
                    ruleList  = v.m_playtype,
                    dateTime  = v.m_time,
                    matchList = v.m_match,
                    clickHandle = handler(self,self.clickHandle)
                }
                local item = ItemClubRecord:create(args)
                local cellSize = item:getContentSize()
                local cellItem = ccui.Widget:create()
                cellItem:setContentSize(cellSize)
                cellItem:addChild(item)
                self.btnMap["lvRecord"]:pushBackCustomItem(cellItem)
            end
        end
    else
    end
end


function m:clickHandle( index )
    local cellData = self.data.m_data[index]
    local layer = UIVideoPlayDetail:create(cellData)
    self:addChild(layer)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnSelect then
        local str = self.btnMap["txtDate"]:getString()
        local strList = string.split(str,"/")
        local time = os.time{year=tonumber(strList[1]), month=tonumber(strList[2]), day=tonumber(strList[3]),hour = 0,min = 0,sec=1}
        NetLobbyMng.getClubGameRecord(self.data.clubID,time)--time:// 0是全部，非零是某天
    elseif s_name == n.btnMap.btnDateChange or s_name == n.btnMap.txtDate then
        self.btnMap["lvDate"]:setVisible(not self.btnMap["lvDate"]:isVisible())
    else
        self.btnMap["lvDate"]:setVisible(false)
        local str = _sender:getString()
        print(str)
        self.btnMap["txtDate"]:setString(str)
    end
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
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_REPLAY, self, self.onRcvReplay)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m