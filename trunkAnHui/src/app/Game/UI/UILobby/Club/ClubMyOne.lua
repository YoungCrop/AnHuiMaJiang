
local gComm = cc.exports.gComm

local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local ClubRecord = require("app.Game.UI.UILobby.Club.ClubRecord")
local ClubCreateRoom = require("app.Game.UI.UILobby.Club.ClubCreateRoom")
local ItemClubMyMember = require("app.Game.UI.UILobby.Item.ItemClubMyMember")
local ItemClubMyRoom = require("app.Game.UI.UILobby.Item.ItemClubMyRoom")
-- local ClubMyAll = require("app.Game.UI.UILobby.Club.ClubMyAll")

local csbFile = "Csd/ILobby/Club/ClubMyOne.csb"

local n = {}
local m = class("ClubMyOne",gComm.UIMaskLayer)

function m:ctor(data)
    m.super.ctor(self)
    self.data = data
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit       = "btnExit",
    btnRefresh    = "btnRefresh",
    btnCreateRoom = "btnCreateRoom",
    btnRecord     = "btnRecord",
    btnQuitClub   = "btnQuitClub",
    btnClubMore   = "btnClubMore",
    btnQuickCreate = "btnQuickCreate",
}
n.nodeMap = {
    lvMember    = "lvMember",
    lvRoom      = "lvRoom",
    txtClubID   = "txtClubID",
    txtClubName = "txtClubName",
    txtClubCard = "txtClubCard",
    txtEmptyTip = "txtEmptyTip",
    txtOnePersonCard  = "txtOnePersonCard",
    txtSumNum     = "txtSumNum",
    txtOnlineNum  = "txtOnlineNum",
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
    self:showData(self.data)

    local selfPlayerInfo = cc.exports.gData.ModleGlobal:getSelfInfo()
    if selfPlayerInfo.userID == self.data.adminId then
        self.btnMap["btnQuitClub"]:setVisible(false)
    end
end

function m:showData(data)
    self.btnMap["txtClubName"]:setString(data.clubName)
    self.btnMap["txtClubID"]:setString(data.clubID)
    self.btnMap["txtClubCard"]:setString(data.clubCard)
    self.btnMap["txtOnePersonCard"]:setString(data.OnePersonCard)

    self.btnMap["lvMember"]:removeAllItems()
    self.btnMap["lvRoom"]:removeAllItems()

    self.btnMap["txtSumNum"]:setString("(" .. #data.memberList ..")")

    local num = 0
    for i,v in ipairs(data.memberList) do
        -- for j=1,200 do
            local args = {
                nikeName = v.m_nikeName,
                userID   = v.m_userId,
                isOnline = v.m_isOnLine,--1:在线，非1:离线
                isAdmin  = v.m_isAdmin,--1:亲友圈的创建者，非1:非创建者
                headURL  = v.m_headImageUrl,
            }
            if v.m_isOnLine == 1 then
                num = num + 1
            end
            local item = ItemClubMyMember:create(args)
            local cellSize = item:getContentSize()
            local cellItem = ccui.Widget:create()
            cellItem:setContentSize(cellSize)
            cellItem:addChild(item)
            self.btnMap["lvMember"]:pushBackCustomItem(cellItem)
        -- end
    end
    self.btnMap["txtOnlineNum"]:setString("(" .. num ..")")

    for i,v in ipairs(data.deskList) do
        local args = {
            userIDList   = v.m_RoomUserId,
            nikeNameList = v.m_nikeNames,
            headURLList  = v.m_headImageUrl,
            gameID    = v.m_gameID,
            clubID    = v.m_clubId,
            deskID    = v.m_deskId,
            maxCircle = v.m_MaxCircle,
            ruleList  = v.m_playtype,
            dateTime  = v.m_CreatTime,
            playerNum = v.m_playerNum,
            isMinisterOpen = v.m_quickRoom,--是否是快捷亲友圈开房，后台新增功能,默认是否
        }
        local item = ItemClubMyRoom:create(args)
        local cellSize = item:getContentSize()
        local cellItem = ccui.Widget:create()
        cellItem:setContentSize(cellSize)
        cellItem:addChild(item)
        self.btnMap["lvRoom"]:pushBackCustomItem(cellItem)
    end
    if #data.deskList == 0 then
        self.btnMap["txtEmptyTip"]:setVisible(true)
    else
        self.btnMap["txtEmptyTip"]:setVisible(false)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnExit then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnRefresh then
        NetLobbyMng.getClubDetailInfo(self.data.clubID)
        gComm.UIUtils.floatText("刷新成功")
        gComm.BtnUtils.setButtonLockTime(_sender,2)
    elseif s_name == n.btnMap.btnCreateRoom then
        local args = {
            clubID = self.data.clubID,
        }
        self:addChild(ClubCreateRoom:create(args))
    elseif s_name == n.btnMap.btnRecord then
        NetLobbyMng.getClubGameRecord(self.data.clubID,os.time())--time:// 0是全部，非零是某天
    elseif s_name == n.btnMap.btnQuitClub then
        --// 1入会，2离会,3 代理后台邀请时,前端同意 4 代理后台邀请时,前端不同意
        NetLobbyMng.joinAndQuitClub(2,self.data.clubID)
    elseif s_name == n.btnMap.btnClubMore then
        local layer = require("app.Game.UI.UILobby.Club.ClubMyAll"):create()
        self:getParent():addChild(layer)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnQuickCreate then
        gComm.UIUtils.showLoadingTips()
        NetLobbyMng.SendCreateQuickRoom(self.data.clubID)
    end
end

function m:revJoinQuitClub(msgTbl)
    dump(msgTbl,"m:revJoinQuitClub======")

    if msgTbl.m_errorCode == 0 then
        if msgTbl.m_type == 2 then--// 1入会，2离会
            self:removeFromParent()
        end
    else
        local errorList = {
            [100] = "亲友圈不存在; ",
            [101] = "超过可加入亲友圈上限 ",
            [102] = "我已在亲友圈不要重复申请 ",
            [106] = "短时间重复离会;",
            [107] = ":要加入的亲友圈和之前玩家加入的亲友圈,不是同一个代理的",
        }
        gComm.UIUtils.floatText(errorList[msgTbl.m_errorCode] or ("errorCode = " .. msgTbl.m_errorCode))
    end
end


function m:revClubGameRecord(msgTbl)
    dump(msgTbl,"m:revClubGameRecord======",6)
    if tolua.isnull(self.mClubRecord) then
        msgTbl.clubID = self.data.clubID
        self.mClubRecord = ClubRecord:create(msgTbl)
        self:addChild(self.mClubRecord)
    else
        msgTbl.clubID = self.data.clubID
        self.mClubRecord:showData(msgTbl)
    end
end

function m:revClubDetailInfo(msgTbl)
    dump(msgTbl,"m:revClubDetailInfo======")
    
    if msgTbl.m_errorCode == 0 then
        local args = {
            adminId = msgTbl.m_adminId,
            clubID = msgTbl.m_clubId,
            clubName = msgTbl.m_clubName,
            clubCard = msgTbl.m_clubCardNum,
            OnePersonCard = msgTbl.m_myCurrentDayCardNum .. "/" .. msgTbl.m_currentDayCardLimit,
            memberList = msgTbl.m_playerList,
            deskList = msgTbl.m_deskList,
        }
        self:showData(args)
    else
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_APPLICATION, self, self.revJoinQuitClub)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_VIP_LOG, self, self.revClubGameRecord)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_DETAIL_INFO, self, self.revClubDetailInfo)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m
