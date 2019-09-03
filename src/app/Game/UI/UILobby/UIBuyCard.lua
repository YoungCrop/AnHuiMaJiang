
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local csbFile = "Csd/ILobby/UIBuyCard.csb"

local n = {}
local m = class("UIBuyCard",gComm.UIMaskLayer)

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
    btnCopyCard = "btnCopyCard",
    btnCopyQues = "btnCopyQues",
    btnCopyComplaints = "btnCopyComplaints",
    btnExit = "btnExit",
}
n.nodeMap = {
    txtCopyCard = "txtCopyCard",
    txtCopyQues = "txtCopyQues",
    txtCopyComplaints = "txtCopyComplaints",
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
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
    	self:removeFromParent()
    elseif s_name == n.btnMap.btnCopyCard then
    	local str = self.btnMap["txtCopyCard"]:getString()
    	self:copyString(str)

    elseif s_name == n.btnMap.btnCopyQues then
    	local str = self.btnMap["txtCopyQues"]:getString()
    	self:copyString(str)

    elseif s_name == n.btnMap.btnCopyComplaints then
    	local str = self.btnMap["txtCopyComplaints"]:getString()
    	self:copyString(str)

    end
end

function m:copyString(copyText)
    gCallNativeMng.AppNative:copyText(copyText)
	gComm.UIUtils.floatText("复制成功")
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