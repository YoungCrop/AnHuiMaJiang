
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local ClubCreateTip = require("app.Game.UI.UILobby.Club.ClubCreateTip")
local ClubCreate = require("app.Game.UI.UILobby.Club.ClubCreate")
local ClubJoin = require("app.Game.UI.UILobby.Club.ClubJoin")
local ClubMyOne = require("app.Game.UI.UILobby.Club.ClubMyOne")
-- local ItemClubMyAll = require("app.Game.UI.UILobby.Item.ItemClubMyAll")


local csbFile = "Csd/ILobby/Club/ClubMyAll.csb"

local n = {}
local m = class("ClubMyAll",gComm.UIMaskLayer)

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
    btnExit       = "btnExit",
    btnCreateClub = "btnCreateClub",
    btnJoinClub   = "btnJoinClub",
}
n.nodeMap = {
    lvClub = "lvClub",
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
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnExit then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnCreateClub then
        if cc.exports.gData.ModleGlobal.isGM then
            self:addChild(ClubCreate:create())
        else
            self:addChild(ClubCreateTip:create())
        end
    elseif s_name == n.btnMap.btnJoinClub then
        self.mClubJoin = ClubJoin:create()
        self:addChild(self.mClubJoin)
        -- local ClubRecord = require("app.Game.UI.UILobby.Club.ClubRecord")
        -- self:addChild(ClubRecord:create())
    end
end

function m:revJoinQuitClub(msgTbl)
    dump(msgTbl,"m:revJoinQuitClub======")
    gComm.UIUtils.removeLoadingTips()

    -- // 离会错误码:  0：成功，1：失败，2：不能删除创建亲友圈者;
    -- 3:我已不在亲友圈不需要重复离开.;
    -- 4:要离开的亲友圈不存在 
    -- 105 : 短时间重复入会
    -- // 入会错误码:  0：成功，1：失败, 
    -- 100 : 亲友圈不存在; 
    -- 101 : 超过可加入亲友圈上限 
    -- 102 : 我已在亲友圈不要重复申请 
    -- 106 : 短时间重复离会;
    -- 107:要加入的亲友圈和之前玩家加入的亲友圈,不是同一个代理的
    
    if msgTbl.m_errorCode == 0 then
        if msgTbl.m_type == 1 then--// 1入会，2离会
            NetLobbyMng.getClubDetailInfo(msgTbl.m_clubId)
            if not tolua.isnull(self.mClubJoin) then
                self.mClubJoin:removeFromParent()
            end
        else
        end
    else
        local errorList = {
            [100] = "亲友圈不存在",
            [101] = "超过可加入亲友圈上限",
            [102] = "我已在亲友圈不要重复申请",
            [110] = "重复入会",
            [106] = "短时间重复离会",
            [107] = "要加入的亲友圈和之前玩家加入的亲友圈,不是同一个代理的",
            [108] = "有自己创建的亲友圈不允许加入别人的",
            [109] = "您被拒绝加入该亲友圈",
        }
        local str = errorList[msgTbl.m_errorCode] or ("errorCode = " .. msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:revCreateClub(msgTbl)
    dump(msgTbl,"m:revCreateClub======")
    gComm.UIUtils.removeLoadingTips()
    
    if msgTbl.m_errorCode == 0 then
        self:revClubDetailInfo(msgTbl)
        gComm.UIUtils.floatText("亲友圈创建成功")
    else
        local errorList = {
            [-1]  = "玩家非代理",
            [1]   = "代理房卡不足",
            [4]   = "代理亲友圈已上限",
            [6]   = "消息推送失败",
            [7]   = "其他",
            [8]   = "已加入别的代理的亲友圈",
            [9]   = "亲友圈名称包含敏感词",
            [11]  = "为亲友圈名字过长",
            [12]  = "代表后台生成亲友圈id为0",
            [101] = "玩家在别人的亲友圈,无法创建",
        }
        local str = errorList[msgTbl.m_errorCode] or ("errorCode = " .. msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:revMyClubList(msgTbl)
    dump(msgTbl,"m:revMyClubList======",5)
    if #msgTbl.m_myAllClubBasicInfos > 0 then
        for i,v in ipairs(msgTbl.m_myAllClubBasicInfos) do
            local args = {
                clubID         = v.m_clubId,
                clubName       = v.m_clubName,
                curMemberNum   = v.m_currentMemberNum,
                memberNumLimit = v.m_memberNumLimit,
                headUrl        = v.m_adminHeadUrl,
            }
            local item = require("app.Game.UI.UILobby.Item.ItemClubMyAll"):create(args)
            local cellSize = item:getContentSize()
            local cellItem = ccui.Widget:create()
            cellItem:setContentSize(cellSize)
            cellItem:addChild(item)
            self.btnMap["lvClub"]:pushBackCustomItem(cellItem)
        end   
    else
    end
end

function m:revClubDetailInfo(msgTbl)
    dump(msgTbl,"m:revClubDetailInfo======",5)
    if msgTbl.m_errorCode == 0 then
        local args = {
            adminId = msgTbl.m_adminId,
            clubID  = msgTbl.m_clubId,
            clubName = msgTbl.m_clubName,
            clubCard = msgTbl.m_clubCardNum,
            OnePersonCard = msgTbl.m_myCurrentDayCardNum .. "/" .. msgTbl.m_currentDayCardLimit,
            memberList = msgTbl.m_playerList,
            deskList = msgTbl.m_deskList,
        }
        local layer = ClubMyOne:create(args)
        self:getParent():addChild(layer)
        self:removeFromParent()
    else
    end
end

function m:revClubError(msgTbl)
    dump(msgTbl,"m:revClubError======")
    gComm.UIUtils.removeLoadingTips()
    --     //m_type == 3,同意加入亲友圈的返回, 0:是代理 10000: 成功  -10000 :初始值(失败) 2: 亲友圈异常 -1:已经加入该亲友圈 -2 已加入10个亲友圈 -3 亲友圈已满
    -- //m_type == 4,申请加入亲友圈的返回,10000: 成功  -10000 :代表亲友圈不存在,失败 

    local errorList = {
        [3]        = "同意加入亲友圈的返回",
        [0]        = "是代理",
        [-10000]   = "初始值(失败)",
        [2]        = "亲友圈异常",
        [-1]       = "已经加入该亲友圈",
        [-2]       = "已加入10个亲友圈",
        [-3]       = "亲友圈已满",
        [4]        = "申请加入亲友圈的返回",
        [-10001]   = "代表亲友圈不存在,失败",
        [10000]    = "成功",
    }
    if msgTbl.m_type == 4 then
        errorList[10000] = "申请已发出，请等待审核"
    end
    local str = errorList[msgTbl.m_errorCode] or ("errorCode = " .. msgTbl.m_errorCode)
    gComm.UIUtils.floatText(str)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_APPLICATION, self, self.revJoinQuitClub)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_CREATE, self, self.revCreateClub)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_ALL_BASIC_INFO, self, self.revMyClubList)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_DETAIL_INFO, self, self.revClubDetailInfo)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_ERROR, self, self.revClubError)
    NetLobbyMng.getMyClublist()
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m