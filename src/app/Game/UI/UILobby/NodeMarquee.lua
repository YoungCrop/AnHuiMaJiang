
local gComm = cc.exports.gComm

local csbFile = "Csd/ILobby/NodeMarquee.csb"

local n = {}
local m = class("NodeMarquee", function()
    return display.newNode()
end)

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

	self.msgTextCache = {}
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end
n.nodeMap = {
    sv = "sv",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)
 
    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
end

function m:showMsg(msgText)
	log("marquee====txt==",msgText)
	-- self.btnMap["txtMsg"]:getContentSize().width，长度大于4096，会不出来，报如下错
	-- cocos2d: Texture2D: Error uploading compressed texture
	-- self.msgTextCache[msgText or ""] = true
	-- local str = ""
	-- for k,v in pairs(self.msgTextCache) do
	-- 	str = str .. k .. "     "
	-- end
	self.showMsgStr = msgText
	self:moveAction()
end

function m:moveAction()
	if self._moveAction then
		transition.removeAction(self._moveAction)
	end
	local barSize = self.btnMap["sv"]:getContentSize()
	self.btnMap["sv"]:removeAllChildren()
	self.btnMap["txtMsg"] = gComm.LabelUtils.createTTFLabel(self.showMsgStr, 35)
	self.btnMap["txtMsg"]:addTo(self.btnMap["sv"])
	self.btnMap["txtMsg"]:setAnchorPoint(0, 0.5)
	self.btnMap["txtMsg"]:setPosition(cc.p(barSize.width,barSize.height * 0.5))
	
	local MOVE_TIME = 10
	self.sumWidth = self.btnMap["txtMsg"]:getContentSize().width + barSize.width
	self.moveTime = self.sumWidth / barSize.width * MOVE_TIME
	local seqTable = {}
	seqTable[#seqTable + 1 ] = cc.CallFunc:create(function()
		self.btnMap["txtMsg"]:setPositionX(barSize.width)
	end)
	seqTable[#seqTable + 1 ] = cc.MoveBy:create(self.moveTime, cc.p(-self.sumWidth, 0))

	local seq = transition.sequence(seqTable)
	self._moveAction = cc.RepeatForever:create(seq)
	self.btnMap["txtMsg"]:runAction(self._moveAction)
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
