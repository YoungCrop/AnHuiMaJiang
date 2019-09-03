

local gt = cc.exports.gt
local gComm = cc.exports.gComm

local DefineRule = require("app.Common.Config.DefineRule")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local netMng = require("app.Common.NetMng.NetLobbyMng")
local DefineRule = require("app.Common.Config.DefineRule")
local NetCmd = require("app.Common.NetMng.NetCmd")
local ItemAgentRoom = require("app.Game.UI.UILobby.Item.ItemAgentRoom")
local csbFile = "Csd/ILobby/UIAgentRoom.csb"

local n = {}
local m = class("UIAgentRoom",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

	self.lastTime = os.time() - 1  -- 上次点击和本次点击的时间差
	-- 当前按钮状态
	self.currentTab = 1 -- 1 代开  2 已开

    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit    = "btnExit",
    btnRefersh = "btnRefersh",
    btnAgentCreate = "btnAgentCreate",
    btnComplete    = "btnComplete",
}
n.nodeMap = {
--key - {name,defaultVisible,}
    txtEmpty       = {"txtEmpty",     false, },  
    lvRoom         = {"lvRoom",        true, },  
    spriteComplete = {"spriteComplete",false, },          
    spriteAgent    = {"spriteAgent",   true, },       
    nodeTitle      = {"nodeTitle",     false, },     
}
n.emptyTip = {
	"暂时没有任何代开记录",
	"暂时没有已开房间",
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
        btn:setVisible(v[2])
    end

end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
		gComm.EventBus.unRegAllEvent(self)
		self:removeFromParent()
    elseif s_name == n.btnMap.btnRefersh then
		self:btnHandle(self.currentTab)
    elseif s_name == n.btnMap.btnAgentCreate then
		self:btnHandle(1)
    elseif s_name == n.btnMap.btnComplete then
		self:btnHandle(2)
    end
end

function m:btnHandle( _type )		
	if os.time() - self.lastTime < 1 then
		gComm.UIUtils.floatText("您操作过于频繁，请稍后再进行操作")
		return
	else	
		self.lastTime = os.time()
		self.currentTab = _type
		-- 在请求信息的时候设置按钮不可点
		self:setBtnTouchEnabled(false)
		self.btnMap["lvRoom"]:removeAllChildren()
		netMng.getAgentRoom(_type)
	end
end

function m:setBtnTouchEnabled( isEnabled )
	self.btnMap["btnRefersh"]:setVisible(isEnabled)
	self.btnMap["btnAgentCreate"]:setTouchEnabled(isEnabled)
	self.btnMap["btnComplete"]:setTouchEnabled(isEnabled)
end

function m:onRcvAgentRoom( msgTbl )
	dump(msgTbl,self.__TAG .. "onRcvAgentRoom")
	self.btnMap["lvRoom"]:removeAllChildren()
	self.btnMap["spriteAgent"]:setVisible(false)
	self.btnMap["spriteComplete"]:setVisible(false)
	self.btnMap["txtEmpty"]:setVisible(false)

	local operateState = true
	if msgTbl.m_type == 1 then
		operateState = true
		self.btnMap["spriteAgent"]:setVisible(true)
		self:setBtnTouchEnabled(true)
	elseif msgTbl.m_type == 2 then
		operateState = false
		self.btnMap["spriteComplete"]:setVisible(true)
		self:setBtnTouchEnabled(true)
	end

	-- 更新提示和按钮显示
	if msgTbl.m_deskList and #msgTbl.m_deskList == 0 then
		if msgTbl.m_type == 1 then
			self.btnMap["txtEmpty"]:setString(n.emptyTip[1])
			self.btnMap["txtEmpty"]:setVisible(true)
		elseif msgTbl.m_type == 2 then
			self.btnMap["txtEmpty"]:setString(n.emptyTip[2])
			self.btnMap["txtEmpty"]:setVisible(true)
		end
	end
	for i, cellData in ipairs(msgTbl.m_deskList) do
		cellData.index = i
		cellData.showOperate = operateState
		local item = ItemAgentRoom:create(cellData)
		local cellSize = item:getContentSize()
		local cellItem = ccui.Widget:create()
		cellItem:setTag(cellData.m_deskId)
		cellItem:setTouchEnabled(true)
		cellItem:setContentSize(cellSize)
		cellItem:addChild(item)
		self.btnMap["lvRoom"]:pushBackCustomItem(cellItem)
	end

end

function m:onRcvJoinRoom(msgTbl)
	if msgTbl.m_errorCode ~= 0 then
		-- 进入房间失败
		gComm.UIUtils.removeLoadingTips()

		if msgTbl.m_errorCode == 5 then
			-- 房间人已满
			gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0018"))
		elseif msgTbl.m_errorCode == 2 then
			-- 房间不存在
			gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0015"))
		elseif msgTbl.m_errorCode == 4 then
			-- 房间已开始
			gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0083"))
		elseif msgTbl.m_errorCode == 3 then
			-- 您已加入了房间
			gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0082"))
		elseif msgTbl.m_errorCode == 6 then
			-- 加入比赛场
            gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0084"))
		end
	end
end

function m:onRcvDissmisAgentRoom( msgTbl )
	if msgTbl.m_errorCode == 0 then
		for i,item in ipairs(self.btnMap["lvRoom"]:getItems()) do
			if item:getTag() == msgTbl.m_deskId then
				self.btnMap["lvRoom"]:removeChild(item)
			end
		end
	elseif  msgTbl.m_errorCode == 1 then  -- 桌子不存在
		gComm.UIUtils.floatText("桌子不存在")
	elseif msgTbl.m_errorCode == 2 then   --房间不是你的
		gComm.UIUtils.floatText("房间不是您的")
	elseif msgTbl.m_errorCode == 3 then
		gComm.UIUtils.floatText("房间正在使用中")
	end

	-- 刷新界面
	if msgTbl.m_errorCode ~= 0 then
		self:btnHandle(self.currentTab)
	end
end

function m:onEnter()
    log(self.__TAG,"onEnter")

	-- 代开房间消息
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_GET_AGENT_ROOM, self, self.onRcvAgentRoom)
	-- 解散代开房间结果
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_DISMISS_AGENT_ROOM, self, self.onRcvDissmisAgentRoom)
    netMng.getAgentRoom(1)
end

function m:onExit()
    log(self.__TAG,"onExit")
    
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m