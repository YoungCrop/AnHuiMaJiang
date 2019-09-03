
local gComm = cc.exports.gComm

local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local NetCmd = require("app.Common.NetMng.NetCmd")
local netMng = require("app.Common.NetMng.NetLobbyMng")
local EventCmdID = require("app.Common.Config.EventCmdID")
-- local UIMaskLayer = require("app.Common.UIBase.UIMaskLayer")

local csbFile = "Csd/ILobby/UIJoinRoom.csb"

local n = {}
local m = class("UIJoinRoom",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    self.inputNum = 0
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit = "btnExit",
    btnReset = "btnReset",
    btnDelete = "btnDelete",
    btnNum_0 = "btnNum_0",
    btnNum_1 = "btnNum_1",
    btnNum_2 = "btnNum_2",
    btnNum_3 = "btnNum_3",
    btnNum_4 = "btnNum_4",
    btnNum_5 = "btnNum_5",
    btnNum_6 = "btnNum_6",
    btnNum_7 = "btnNum_7",
    btnNum_8 = "btnNum_8",
    btnNum_9 = "btnNum_9",
}
n.nodeMap = {
    Label_num_1 = "Label_num_1",
    Label_num_2 = "Label_num_2",
    Label_num_3 = "Label_num_3",
    Label_num_4 = "Label_num_4",
    Label_num_5 = "Label_num_5",
    Label_num_6 = "Label_num_6",
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
        btn:setString("")
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnReset then
    	for i=1,6 do
    		self.btnMap["Label_num_" .. i]:setString("")
    	end
        self.inputNum = 0
    elseif s_name == n.btnMap.btnDelete then
        if self.inputNum > 0 then
           self.btnMap["Label_num_" .. self.inputNum]:setString("")
           self.inputNum = self.inputNum - 1
        end
    else
    	local tag = string.sub(s_name,8,8)
        if self.inputNum < 6 then
            self.inputNum = self.inputNum + 1
            print("tag----------------",tag)
           self.btnMap["Label_num_" .. self.inputNum]:setString(tag)
            if self.inputNum == 6 then
                self:HandlerEnterRoom()
            end
        end
    end
end
function m:HandlerEnterRoom()
	if self.inputNum == 6 then
		local roomID = 0
		local tmpAry = {100000, 10000, 1000, 100, 10, 1}
		for i = 1, self.inputNum do
			local inputNum = tonumber(self.btnMap["Label_num_" .. i]:getString())
			roomID = roomID + inputNum * tmpAry[i]
		end
		netMng.SendJoinRoom(roomID)
		gComm.UIUtils.showLoadingTips(mTxtTipConfig.GetConfigTxt("LTKey_0006"))
        self.inputNum = 0
        for i=1,6 do
            self.btnMap["Label_num_" .. i]:setString("")
        end
	end
end

function m:onRcvJoinRoom(msgTbl)
	-- body
end

function m:onEnter()
    log(self.__TAG,"onEnter")
	gComm.EventBus.regEventListener(EventCmdID.EventType.GETIN_EVENT_JONIN,self,self.onRcvJoinRoom)

    -- 更新
    -- self:scheduleUpdate(handler(self,self.onUpdateTT))
end

function m:onExit()
    log(self.__TAG,"onExit")
    gComm.EventBus.unRegEventByName(self,EventCmdID.EventType.GETIN_EVENT_JONIN)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end

function m:onUpdateTT()
    log(self.__TAG,"onUpdateTT")
    
end

return m