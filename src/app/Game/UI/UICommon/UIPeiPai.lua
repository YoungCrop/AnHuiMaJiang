local gt = cc.exports.gt
local gComm = cc.exports.gComm

local csbFile = "Csd/ICommon/UIPeiPai.csb"

local DefineTile = require("app.Common.Tiles.DefineTile")

local m = class("UIPeiPai", function()
	return cc.LayerColor:create(cc.c4b(85, 85, 85, 85), display.size.width, display.size.height)
end)

m.TYPE = {
	MJ = 1,
	Poker = 2
}
local n = {}

n.tileScale = 0.6875

function m:ctor(tag)
	self.tagIndex = tag
	
	-- 注册节点事件
	self:registerScriptHandler(handler(self, self.onNodeEvent))

	local csbNode = cc.CSLoader:createNode(csbFile)

	self.csbNode = csbNode

	-- do return end
	
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
	self:addChild(csbNode)

	local Node_peipai = gComm.UIUtils.seekNodeByName(csbNode, "Node_peipai")

	self.oriColor = cc.c4b(116,50,21,255)
	self.selectColor = cc.c4b(206,46,20,255)

	--配牌
	
	local node1 = cc.Node:create()
	node1:setName("nodeCards1")
	Node_peipai:addChild(node1)

	local node2 = cc.Node:create()
	node2:setName("nodeCards2")
	Node_peipai:addChild(node2)

	if self.tagIndex == m.TYPE.MJ then
		node1:setVisible(true)
		node2:setVisible(false)
	else
		node1:setVisible(false)
		node2:setVisible(true)
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames("Texture/CardsMJNew.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Texture/CardsPoker.plist")

	local tiltBG = DefineTile.getBottomOpenTile(0,0)
	for i=1,5 do
		local num = 9
		if i == 4 then
			num = 4
		elseif i == 5 then
			num = 3
		end

		for j=1,num do
			local button = ccui.Button:create()
			button:loadTextures(tiltBG,tiltBG,"",ccui.TextureResType.plistType)
	    	button:setPosition(cc.p(100+540*(i%2)+j*60,680-math.floor((i-0.5)/2)*85))
	    	button:setTag(i*10+j)
	   		node1:addChild(button)

			button:setScale(n.tileScale)
			local mjSprName = DefineTile.getBottomOpenTile(i,j)
   			local spr = cc.Sprite:createWithSpriteFrameName(mjSprName)
   			button:addChild(spr)
   			local size = button:getContentSize()
   			spr:setPosition(size.width*0.5,size.height*0.5)

	   		local function touchEvent(ref, type)
				ref:setPressedActionEnabled(true)
				ref:setZoomScale(-0.1)
				local num = ref:getTag()
				local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..self.PeiPaiPlayer)
				if node_t:getString() == "" then
					node_t:setString(""..num)
				else
					node_t:setString(node_t:getString()..","..num)
				end
  	  		end
   	 		button:addClickEventListener(touchEvent)
		end
	end
	
	for i=1,5 do
		local num = 13
		if i == 5 then
			num = 2
		end

		for j=1,num do
			local mjSprName = string.format("Image/CardsPoker/p%d_%d.png",i, j)
			local button = ccui.Button:create()
			button:loadTextures(mjSprName,mjSprName,"",ccui.TextureResType.plistType)
			if i== 5 then
				button:setPosition(cc.p(100+15*60,720-(j+1)*70))
			else
				button:setPosition(cc.p(100+j*60,720-i*70))
			end
	    	
	    	button:setTag(i*100+j)
	    	button:setScale(0.3)
	   		node2:addChild(button)
	   		local function touchEvent(ref, type)
				ref:setPressedActionEnabled(true)
				ref:setZoomScale(-0.1)
				local num = ref:getTag()
				local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..self.PeiPaiPlayer)
				if node_t:getString() == "" then
					node_t:setString(""..num)
				else
					node_t:setString(node_t:getString()..","..num)
				end
  	  		end
   	 		button:addClickEventListener(touchEvent)
		end
	end

	for i=1,6 do
		local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..i)
		if gt.textCard[i] then
			node_t:setString(gt.textCard[i]) 
		end
	end


	for i = 1,5 do
		local bnt = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_"..i)
		bnt:setTag(i)
		bnt:addClickEventListener(handler(self, self.choosePeiPaiPlayerEvt))
		if i == 1 then 
			self:choosePeiPaiPlayerEvt(bnt)
		end
	end
	for i = 1,4 do
		local bnt = gComm.UIUtils.seekNodeByName(Node_peipai, "renshubnt_"..i)
		bnt:setTag(i)
		bnt:addClickEventListener(handler(self, self.choosePeiPaiRenshuEvt))
		if i == 1 then 
			--self:choosePeiPaiRenshuEvt(bnt)
		end
	end
	
	--重置
	local bnt9 = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_9")
	gComm.BtnUtils.setButtonClick(bnt9, function()
		local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..self.PeiPaiPlayer)
		node_t:setString("") 
	end)

	--删除
	local bnt6 = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_"..6)
	gComm.BtnUtils.setButtonClick(bnt6, function()
		local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..self.PeiPaiPlayer)
		local txt = node_t:getString()
		local str = ""
		if string.len(txt) ~= 0 then
			local subStrs = string.split(txt, ",")
			for i=1,#subStrs-1 do
				if str == "" then
					str = str..subStrs[i]
				else
					str = str..","..subStrs[i]
				end
			end	
		end
		node_t:setString(str) 
	end)

	--保存
	local bnt7 = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_7")
	gComm.BtnUtils.setButtonClick(bnt7, function()
		if self.tagIndex ~= 1 then
			gComm.UIUtils.floatText("长得太丑，不给保存~")
			return 
		end
		local peipaiNum = cc.UserDefault:getInstance():getIntegerForKey("peipaiNum",0)
		local  cardsStr = ""
		for i=1,4 do
			local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..i)
			local str = node_t:getString()
			if i == 4 then
				cardsStr = cardsStr..str
			else
				cardsStr = cardsStr..str.."|"
			end
		end
		cc.UserDefault:getInstance():setStringForKey("peipaicards"..peipaiNum, cardsStr)
		cc.UserDefault:getInstance():setIntegerForKey("peipaiNum",(peipaiNum+1)%10)
		cc.UserDefault:getInstance():flush()
		gComm.UIUtils.floatText("保存成功")
	end)

	--查看
	local bnt8 = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_8")
	gComm.BtnUtils.setButtonClick(bnt8, function()

		if self.tagIndex ~= 1 then
			gComm.UIUtils.floatText("长得太黑，不给你看~")
			return 
		end
		local sv = gComm.UIUtils.seekNodeByName(Node_peipai, "ScrollView_1")
		csbNode:reorderChild(sv,1000)
		sv:removeAllChildren()
		sv:setVisible(true)
		local closeBtn = ccui.Button:create()
		closeBtn:setTitleText("关闭")
		closeBtn:setTitleFontSize(32); 
    	closeBtn:setPosition(cc.p(1200,700))
   		Node_peipai:addChild(closeBtn,1001)
   		gComm.BtnUtils.setButtonClick(closeBtn, function()
			sv:setVisible(false)
			closeBtn:removeFromParent()
		end)
   		for i=0,9 do
   			local cards = cc.UserDefault:getInstance():getStringForKey("peipaicards"..i, "")
   			if string.len(cards) ~= 0 then
				local subStrs = string.split(cards, "|")
				for j=1,#subStrs do
					if string.len(subStrs[j]) ~= 0 then
						local subStrs2 = string.split(subStrs[j], ",")
						for k=1,#subStrs2 do
							local subStrs2 = string.split(subStrs[j], ",")
							local corlor = math.floor(tonumber(subStrs2[k])/10)
							local number = tonumber(subStrs2[k])%10
							local button = ccui.Button:create()
							button:loadTextures(tiltBG,tiltBG,"",ccui.TextureResType.plistType)
					    	button:setPosition(cc.p(50+k*56,4070-j*85-400*i))
					   		sv:addChild(button)
					   		button:setScale(n.tileScale)

							local mjSprName = DefineTile.getBottomOpenTile(i,j)
				   			local spr = cc.Sprite:createWithSpriteFrameName(mjSprName)
				   			button:addChild(spr)
				   			local size = button:getContentSize()
				   			spr:setPosition(size.width*0.5,size.height*0.5)
						end
					end
					local txt = gComm.LabelUtils.createTTFLabel("玩家"..j, 18)
					txt:setPosition(cc.p(50,4070-j*85-400*i))
					sv:addChild(txt)
				end	
				local doBtn = ccui.Button:create()
				doBtn:setTag(i)
				doBtn:setTitleText("使用")
				doBtn:setTitleFontSize(48); 
		    	doBtn:setPosition(cc.p(640,4070-400*i-360))
				sv:addChild(doBtn)
		   		local function touchEvent(ref, type)
					ref:setPressedActionEnabled(true)
					ref:setZoomScale(-0.1)
					local num = ref:getTag()
					local cards = cc.UserDefault:getInstance():getStringForKey("peipaicards"..num, "")
					local subStrs = string.split(cards, "|")
					for j=1,#subStrs do
						local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..j)
						node_t:setString(subStrs[j]) 
					end	
					gComm.UIUtils.floatText("配牌成功")
	  	  		end
	   	 		doBtn:addClickEventListener(touchEvent)
			end
   		end
	end)

	local backBtn = gComm.UIUtils.seekNodeByName(self.csbNode, "Btn_back")
	gComm.BtnUtils.setButtonClick(backBtn, function()
		self:setVisible(false)
		self.listener:setSwallowTouches(false)
	end)
	backBtn = gComm.UIUtils.seekNodeByName(self.csbNode, "Btn_back_2")
	gComm.BtnUtils.setButtonClick(backBtn, function()
		self:setVisible(false)
		self.listener:setSwallowTouches(false)
	end)
end

function m:choosePeiPaiPlayerEvt(senderLabel)
	local sendTag = senderLabel:getTag()
	local Node_peipai = gComm.UIUtils.seekNodeByName(self.csbNode, "Node_peipai")
	for i=1,5 do
		local bnt = gComm.UIUtils.seekNodeByName(Node_peipai, "bnt_"..i)
		if sendTag == i then 
			bnt:setTitleColor(self.selectColor)
			self.PeiPaiPlayer = sendTag
		else
			bnt:setTitleColor(self.oriColor)
		end
	end
end

function m:showView(tag)
	self:setVisible(true)
	self.listener:setSwallowTouches(true)
	self.tagIndex = tag

	local node1 = gComm.UIUtils.seekNodeByName(self.csbNode, "nodeCards1")
	local node2 = gComm.UIUtils.seekNodeByName(self.csbNode, "nodeCards2")
	if self.tagIndex == 1 then
		node1:setVisible(true)
		node2:setVisible(false)
	else
		node1:setVisible(false)
		node2:setVisible(true)
	end
end

function m:choosePeiPaiRenshuEvt(senderLabel)
	local sendTag = senderLabel:getTag()
	local Node_peipai = gComm.UIUtils.seekNodeByName(self.csbNode, "Node_peipai")
	for i=1,4 do
		local bnt = gComm.UIUtils.seekNodeByName(Node_peipai, "renshubnt_"..i)
		if sendTag == i then 
			bnt:setTitleColor(self.selectColor)
			local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t6")
			node_t:setString(""..sendTag)
		else
			bnt:setTitleColor(self.oriColor)
		end
	end
end

function m:onNodeEvent(eventName)
	if "enter" == eventName then
		self.listener = cc.EventListenerTouchOneByOne:create()
		self.listener:setSwallowTouches(true)
		self.listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)


	elseif "cleanup" == eventName then
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:removeEventListenersForTarget(self)
	end
end

function m:onTouchBegan(touch, event)
	return true
end

function m:getPeipaiData() 
	local Node_peipai = gComm.UIUtils.seekNodeByName(self.csbNode, "Node_peipai")
	
	local msgToSend = {}
	local senTab = {}
	local cardNum = ""
	local cardsTab = {}
	if self.tagIndex == 1 then
		for i=1,4 do
			local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..i)
			local txt = node_t:getStringValue()
			gt.textCard[i] = txt
			if string.len(txt) ~= 0 then
				local subStrs = string.split(txt, ",")
				for k,v in ipairs(subStrs) do
					local carTab = {}
					if string.len(v) ~= 0 then
						carTab[1] = math.floor(tonumber(v)/10)
						carTab[2] = tonumber(v)%10
						cardsTab[#cardsTab+1] = carTab
					end
				end
				msgToSend["m_cardValue"..i] = cardsTab
				--senTab[#senTab+1] = cardsTab
				cardsTab = {}
			else
				msgToSend["m_cardValue"..i] = {}
			end
		end
		-- 宝牌
		local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t5")
		local txt = node_t:getStringValue()
		gt.textCard[5] = txt
		if string.len(txt) ~= 0 then
			local carTab = {}
			carTab[1] = math.floor(tonumber(txt)/10)
			carTab[2] = tonumber(txt)%10
			table.insert(msgToSend["m_cardValue1"],carTab)
		else
			table.insert(msgToSend["m_cardValue1"],{0,0})
		end
	else
		for i=1,5 do
			local node_t = gComm.UIUtils.seekNodeByName(Node_peipai, "t"..i)
			local txt = node_t:getStringValue()
			gt.textCard[i] = txt
			if string.len(txt) ~= 0 then
				local subStrs = string.split(txt, ",")
				for k,v in ipairs(subStrs) do
					local carTab = {}
					if string.len(v) ~= 0 then
						carTab[1] = math.floor(tonumber(v)/100)
						carTab[2] = tonumber(v)%100
						cardsTab[#cardsTab+1] = carTab
					end
				end
				msgToSend["m_cardValue"..i] = cardsTab
				cardsTab = {}
			else
				msgToSend["m_cardValue"..i] = {}
			end
		end

	end

	local node_robotnum = gComm.UIUtils.seekNodeByName(Node_peipai, "t6")
	local m_robotNum = node_robotnum:getStringValue()
	msgToSend.m_robotNum = tonumber(m_robotNum)
	return msgToSend
end

return m