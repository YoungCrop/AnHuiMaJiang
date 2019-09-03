
--SceneMJAnQing
local gt = cc.exports.gt

local gComm = cc.exports.gComm
local gRoomData = cc.exports.gData.ModleRoom

local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineSound = require("app.Common.Config.DefineSound")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local DefineRoom = require("app.Common.Config.DefineRoom")
local DefineRule = require("app.Common.Config.DefineRule")
local UIDissolution = require("app.Game.UI.UIIRoom.UIDissolution")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngMJAnQin = require("app.Common.NetMng.NetMngMJAnQin")
local CtlMJNetListener = require("app.Common.Controller.CtlMJNetListener")
local SoundMng = require("app.Common.Controller.SoundMng")
local UISettlementFinal = require("app.Game.UI.UIGame.MJAnQing.UISettlementFinal")
local UISettlementOneRound = require("app.Game.UI.UIGame.MJAnQing.UISettlementOneRound")
local UIHeadLayout = require("app.Game.UI.UIIRoom.UIHead.UIHeadLayout")
local UIRoomInfoUpper = require("app.Game.UI.UIIRoom.RoomComm.UIRoomInfoUpper")
local UIRoomInfoBottom = require("app.Game.UI.UIIRoom.RoomComm.UIRoomInfoBottom")
local UIMJLayout = require("app.Game.UI.UIIRoom.RoomComm.UIMJLayout")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local SpriteTileStand = require("app.Common.Tiles.SpriteTileStand")
local LayerTileOut = require("app.Common.Tiles.LayerTileOut")
local SpriteTileOpen = require("app.Common.Tiles.SpriteTileOpen")
local DefineTile = require("app.Common.Tiles.DefineTile")
local UICertificate = require("app.Game.UI.UILobby.BigWinMatch.UICertificate")
local NetCoinGameMng = require("app.Common.NetMng.NetCoinGameMng")

local n = {}

local m = class("SceneMJAnQingEx",gComm.SceneBase)

--[[
Ming bar 明杠
touch tickets 摸牌
明杠与暗杠：杠牌分为明杠与暗杠两种。
Bright bars and dark bars: bar card classified as bars and dark bar two
self-drawn 自摸
--]]
m.DecisionType = {
	-- 接炮胡
	TAKE_CANNON_WIN				= 1,
	-- 自摸胡
	SELF_DRAWN_WIN				= 2,
	-- 明杠
	BRIGHT_BAR					= 3,
	-- 暗杠
	DARK_BAR					= 4,
	-- 碰
	PUNG						= 5,
	-- 吃
	EAT					        = 6,
	-- 听
	TING					    = 8,
}

m.OprateAnimCsb = {
	[m.DecisionType.SELF_DRAWN_WIN ] = "Csd/Animation/MJ/AnimMJZiMo.csb",
	[m.DecisionType.BRIGHT_BAR	   ] = "Csd/Animation/MJ/AnimMJGang.csb",
	[m.DecisionType.DARK_BAR	   ] = "Csd/Animation/MJ/AnimMJGang.csb",
	[m.DecisionType.PUNG		   ] = "Csd/Animation/MJ/AnimMJPeng.csb",
	[m.DecisionType.EAT			   ] = "Csd/Animation/MJ/AnimMJChi.csb",
}

m.SoundDecisionType = {
	[m.DecisionType.TAKE_CANNON_WIN] = DefineSound.OpeType.HU ,
	[m.DecisionType.SELF_DRAWN_WIN ] = DefineSound.OpeType.ZIMO ,
	[m.DecisionType.BRIGHT_BAR	   ] = DefineSound.OpeType.GANG ,
	[m.DecisionType.DARK_BAR	   ] = DefineSound.OpeType.GANG ,
	[m.DecisionType.PUNG		   ] = DefineSound.OpeType.PENG ,
	[m.DecisionType.EAT			   ] = DefineSound.OpeType.CHI ,
	[m.DecisionType.TING		   ] = DefineSound.OpeType.TING ,
}

m.FLIMTYPE = {
	FLIMLAYER_BAR				= 1,
	FLIMLAYER_BU				= 2,
	FLIMLAYER_TING				= 3,
	FLIMLAYER_HU				= 4,
}

m.TAG = {
	FLIMLAYER_BAR				= 50,
	FLIMLAYER_BU				= 51,
	FLIMLAYER_TING				= 52,
	FLIMLAYER_HU                = 53,
}

-- local resCsb = "Csd/Scene/SceneMJAnQing.csb"
local resCsb = "Csd/Scene/SceneMJAnQingNew.csb"

n.outTileItemScale = 0.6875
n.outTileScale = 0.4625
n.tileBGTypeIndex = 1
n.tileTypeIndex = 1

function m:ctor(enterRoomMsgTbl)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	dump(enterRoomMsgTbl,"===SceneAnQin=ctor====")

	gt.socketClient:setDelegate(self)

	gRoomData:clean()
	gRoomData:updateRoomInfo(enterRoomMsgTbl)

	self.arrowTing= {}--听牌小箭头

	self.showReport = false -- 显示一轮的结果
	self.removePlayers = {}--用于记录删除人物的数组

--{{},{}}
-- mjTileSpr = mjTileSpr,
-- mjColor = mjColor,
-- mjNumber = mjNumber,
-- seatIndex = seatIdx,
	self.outMJAnimList = {}

--是否显示听牌提示,只有弃(胡/自摸),且听时，才显示 听箭头
	self.isShowTingTip = false
	self.isHu = false
	self.sendoutTingCard = {mjColor=0,mjNumber=0}

	self.hasSameIpTip = true

	self.isHuCardsShow = false

	self.CtlMJNetListener = CtlMJNetListener:create(self)
	self.mModleMJAnQin = self.CtlMJNetListener.modle

	-- 加载界面资源
	local csbNode = cc.CSLoader:createNodeWithVisibleSize(resCsb)
	local action = cc.CSLoader:createTimeline(resCsb)
	csbNode:runAction(action)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)

	local param = {
		csbNode   = csbNode,
		gameID    = enterRoomMsgTbl.m_gameID,
		roundMaxCount = enterRoomMsgTbl.m_maxCircle,
		roomID    = enterRoomMsgTbl.m_deskId,
		sPos      = enterRoomMsgTbl.m_pos,

		uid = cc.exports.gData.ModleGlobal.userID,
		ruleType = enterRoomMsgTbl.m_playtype,
		roomPeopleNum = enterRoomMsgTbl.m_playerNum,
		roomType = enterRoomMsgTbl.m_RoomType,
	}

	self.UIRoomInfoBottom = UIRoomInfoBottom:create(param)
	-- self.UIRoomInfoBottom:addTo(csbNode)
	self.UIRoomInfoBottom:addTo(self)

	self:addChild(csbNode)
	self.rootNode = csbNode

	self.UIHeadLayout   = UIHeadLayout:create(param)
	self.UIHeadLayout:addTo(csbNode)

	self.UIRoomInfoUpper = UIRoomInfoUpper:create(param)
	self.UIRoomInfoUpper:addTo(csbNode)

	self:loadCSB()

	self.playmes = {}
	self.playmes.m_playtype = enterRoomMsgTbl.m_playtype
	self.playmes.roomId = enterRoomMsgTbl.m_deskId

	self.gParam = {
		roomType = enterRoomMsgTbl.m_RoomType,
		sPosSelf = enterRoomMsgTbl.m_pos,
		isTuoGuan = false,
		tingMJList = {},--{color,number}
		gamePlayerNum = enterRoomMsgTbl.m_playerNum,
		movingTileSpr = nil,--在下面创建--SpriteTileStand:create(1, 1),
		standTilePosY = nil,--自己手牌纵坐标
		isRoomCreater = false,--是否是房主
		roomPeopleNum = enterRoomMsgTbl.m_playerNum,
	}

	local args = {
		csbNode   = csbNode,
		needPeopleNum = enterRoomMsgTbl.m_playerNum,
	}
	self.UIMJLayout = UIMJLayout:create(args)
	self.UIMJLayout:addTo(csbNode)
	local mjTilesReferPos = self.UIMJLayout:getPlayerMjTilesReferPos(4)
	self.gParam.standTilePosY = mjTilesReferPos.holdStart.y

	self.IsAnGangShow = false
	for i,v in ipairs(enterRoomMsgTbl.m_playtype) do
		if v == DefineRule.GREnum.AQDP_AN_GANG_SHOW then
			self.IsAnGangShow = true
		end
	end

	-- 麻将层
	self.playMjLayer = cc.Layer:create()
	self.rootNode:addChild(self.playMjLayer, ConfigGameScene.ZOrder.MJTILES)
	self:addMovingTileSpr()

	-- 出的牌标识动画
	local outMjtileSignNode, outMjtileSignAnime = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimOutMjtileSign.csb")
	outMjtileSignAnime:play("run", true)
	outMjtileSignNode:setVisible(false)
	self.rootNode:addChild(outMjtileSignNode, ConfigGameScene.ZOrder.OUTMJTILE_SIGN)
	self.outMjtileSignNode = outMjtileSignNode

	-- 头像下载管理器
	local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
	self.rootNode:addChild(playerHeadMgr)
	self.playerHeadMgr = playerHeadMgr
	-- 玩家进入房间
	self:playerEnterRoom(enterRoomMsgTbl)

	-- 最大局数
	self.roundMaxCount = enterRoomMsgTbl.m_maxCircle

	self.gParam.isRoomCreater = false
	if enterRoomMsgTbl.m_pos == 0 then-- 0位置是房主
		self.gParam.isRoomCreater = true
	end

	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		self.gParam.isRoomCreater = false
	end



	-- 解散房间
	self.applyDimissRoom = UIDissolution:create(self.roomPlayers, self.playerSeatIdx)

	self:addChild(self.applyDimissRoom, ConfigGameScene.ZOrder.ROUND_REPORT-1)

	--方向图片切换
	-- if self.gParam.roomPeopleNum == 3 or self.gParam.roomPeopleNum == 2 then
	-- 	local turnPosBG = self.UIRoomInfoBottom:getBtnMap().kTurnPosBG
 --        gComm.SpriteUtils.setSpriteFrameEx(turnPosBG,"Image/IRoom/RoomCenter/CenterDirectNoBG.png","Texture/IRoom/RoomCenter.plist")
	-- end

	local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
	self.rootNode:reorderChild(decisionBtnNode, ConfigGameScene.ZOrder.DECISION_BTN)
	decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
	self.rootNode:reorderChild(decisionBtnNode, ConfigGameScene.ZOrder.DECISION_BTN)

	gComm.EventBus.regEventListener(EventCmdID.EventType.DIRECT_LOGIN,self,self.directLogin )
	gComm.EventBus.regEventListener(EventCmdID.EventType.NEXTONEGAME_EVENT,self,self.nextOneGame)
	gComm.EventBus.regEventListener(EventCmdID.EventType.BACK_MAIN_SCENE, self, self.backMainSceneEvt)
	gComm.EventBus.regEventListener(EventCmdID.EventType.SHOW_FINALREPORT,self, self.showFinalReport )

	self.CtlMJNetListener:regEvent()
	self.scheduleLocation = 0 -- 初始化上传地址的时间
end

function m:showFinalReport(noDelayTime)
	if noDelayTime then
		if self.finalReport then
			self:addChild(self.finalReport, ConfigGameScene.ZOrder.REPORT)
			self.finalReport:release()
		end
	else
		local delayTime = cc.DelayTime:create(2.5)
		local callFunc = cc.CallFunc:create(function(sender)
			if self.finalReport then
				self:addChild(self.finalReport, ConfigGameScene.ZOrder.REPORT)
				self.finalReport:release()
			end
		end)
		local seqAction = cc.Sequence:create(delayTime, callFunc)
		self:runAction(seqAction)
	end
end

function  m:updatePlayerInfo()
	for i = 1, 4 do
		for j = 1 , 4  do
			if self.roomPlayers and self.roomPlayers[j] and self.roomPlayers[j].displaySeatIdx == i then
				local roomPlayer = self.roomPlayers[j]
				if roomPlayer.score ~= nil then
					log("m:updatePlayerInfo ",roomPlayer.score)
					self.UIHeadLayout:setTxt(i,{score = roomPlayer.score})
				end
			end
		end
	end
end

function m:unregisterAllMsgListener()
	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent( self )
end


function m:startAudio()
	gComm.CallNativeMng.NativeYaya:startVoice()
end

function m:showMaskLayer()
    local function onTouchBegan()
    	return true
    end
	self.maskLayer = cc.LayerColor:create(cc.c4b(85,85,85,85))
	self.playMjLayer:addChild(self.maskLayer,80000)
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:setSwallowTouches(true)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.maskLayer)
end

function m:hideMaskLayer()
    if self.maskLayer then
    	self.maskLayer:removeFromParent()
		self.maskLayer = nil
    end
end


function m:onTouchBegan(touch, event)
	log("===anQing==onTouchBegan==",self.gParam.isTuoGuan,self.isPlayerShow,
		self.isPlayerDecision,self.gParam.movingTileSpr:isVisible())
	if self.gParam.isTuoGuan then
		return false
	end
	if not self.isPlayerShow or self.isPlayerDecision then
		return false
	end
	local touchMjTile, mjTileIdx = self:touchPlayerMjTiles(touch)
	if not touchMjTile  then
		return false
	end
	self._lastMovedTile = touchMjTile
 	self._moveDis = 0
	log("www========onTouchBegan======")
	-- gComm.Debug:logUD(touch,"=======touch00000000---888---")
	return true
end

function m:onTouchMoved(touch, event)
	log("anqing====onTouchMoved====",self.gParam.movingTileSpr:isVisible())

	local dis = cc.pDistanceSQ(touch:getStartLocation(), touch:getLocation())
	self._moveDis = self._moveDis > dis and self._moveDis or dis

	local touchPoint = self.playMjLayer:convertTouchToNodeSpace(touch)
	if self.gParam.movingTileSpr:isVisible() then
		self.gParam.movingTileSpr:setPosition(touchPoint)
	else
		local touchMjTile, mjTileIdx = self:touchPlayerMjTiles(touch)
		if touchMjTile then
			if touchMjTile ~= self._lastMovedTile then
				if touchMjTile.isSelected then
					touchMjTile.isSelected = false
					touchMjTile.mjTileSpr:setPositionY(self.gParam.standTilePosY)
					self:showHuTip()
				else
					touchMjTile.isSelected = true
					touchMjTile.mjTileSpr:setPositionY(self.gParam.standTilePosY + 26)
					self:showHuTip(touchMjTile)
					self:unSelectedTile(touchMjTile)
					gComm.EventBus.dispatchEvent(EventCmdID.UI_TOUCH_SAME_MJ_BRIGHT,touchMjTile.mjColor,touchMjTile.mjNumber)
				end
			end
			self._lastMovedTile = touchMjTile
		end
		if touchPoint.y > 105 then
			if touchMjTile then
				self.gParam.movingTileSpr:setVisible(true)
				self.gParam.movingTileSpr:setTile(touchMjTile.mjColor,touchMjTile.mjNumber)
				self:unSelectedTile(touchMjTile)
				self:showHuTip(touchMjTile)
				if not touchMjTile.isSelected then
					touchMjTile.isSelected = true
					touchMjTile.mjTileSpr:setPositionY(self.gParam.standTilePosY + 26)
					gComm.EventBus.dispatchEvent(EventCmdID.UI_TOUCH_SAME_MJ_BRIGHT,touchMjTile.mjColor,touchMjTile.mjNumber)
				end
			end
		end
	end
end

function m:onTouchEnded(touch, event)
	local touchMjTile, mjTileIdx = self:touchPlayerMjTiles(touch)
	if not touchMjTile then
		local touchPoint = self.playMjLayer:convertTouchToNodeSpace(touch)
		if touchPoint.y > 105 and self.gParam.movingTileSpr:isVisible() then
			self:sendNetCard(self.gParam.movingTileSpr.tileColor,self.gParam.movingTileSpr.tileValue)
			self.isPlayerShow = false
			self:unSelectedTile()--全部非选中
		end
	else
		if self._moveDis < 36 then --单击，移动小于6个像素认为是单击
			if touchMjTile.isSelected then
				self:sendNetCard(touchMjTile.mjColor,touchMjTile.mjNumber)
				self.isPlayerShow = false
				self:unSelectedTile()--全部非选中
			else
				touchMjTile.isSelected = true
				touchMjTile.mjTileSpr:setPositionY(self.gParam.standTilePosY + 26)
				self:showHuTip(touchMjTile)
				self:unSelectedTile(touchMjTile)
				gComm.EventBus.dispatchEvent(EventCmdID.UI_TOUCH_SAME_MJ_BRIGHT,touchMjTile.mjColor,touchMjTile.mjNumber)
			end
		end
	end
	self.gParam.movingTileSpr:setVisible(false)
	self.gParam.movingTileSpr:setPosition(cc.p(-200,-200))
end

function m:onTouchCancelled()
	log("----onTouchCancelle---")
	-- self:sortPlayerMjTiles()
	self.gParam.movingTileSpr:setVisible(false)
	self.gParam.movingTileSpr:setPosition(cc.p(-200,-200))
end

function m:update(delta)
	-- 更新倒计时
	self:playTimeCDUpdate(delta)
	-- 定时上传地址
	self.scheduleLocation = self.scheduleLocation + delta
	if self.scheduleLocation > 100 then
		self:getLocation()
		self.scheduleLocation = 0
	end
end

function m:getLocation()
	if not cc.exports.gGameConfig.isiOSAppInReview then
		NetMngRoom.upLoadLocation()
	end
end

-- start --
--------------------------------
-- @class function
-- @description 接收房间添加玩家消息
-- @param msgTbl 消息体
-- end --
function m:onRcvAddPlayer(msgTbl)
	dump(msgTbl,"====m:onRcvAddPlayer====")
	-- 封装消息数据放入到房间玩家表中
	local roomPlayer = {}
	roomPlayer.uid = msgTbl.m_userId
	roomPlayer.nickname = msgTbl.m_nike

	roomPlayer.headURL = msgTbl.m_face

	roomPlayer.sex = msgTbl.m_sex
	roomPlayer.ip = msgTbl.m_ip
	-- 服务器位置从0开始
	-- 客户端位置从1开始
	roomPlayer.seatIdx = msgTbl.m_pos + 1
	-- 显示座位编号
	roomPlayer.displaySeatIdx = (msgTbl.m_pos + self.seatOffset) % 4 + 1
	roomPlayer.readyState = msgTbl.m_ready
	roomPlayer.score = msgTbl.m_score

	if self.gParam.roomPeopleNum == 3 then
		if self.seatOffset == 1 and roomPlayer.seatIdx == 1 then
			roomPlayer.displaySeatIdx = 1
		elseif self.seatOffset == 2 and roomPlayer.seatIdx == 1 then
			roomPlayer.displaySeatIdx = 3
		elseif self.seatOffset == 3 and roomPlayer.seatIdx == 3 then
			roomPlayer.displaySeatIdx = 3
		else
		end
	end
	if self.gParam.roomPeopleNum == 2 then
		if self.seatOffset == 3 and roomPlayer.seatIdx == 2 then
			roomPlayer.displaySeatIdx = 2
		elseif self.seatOffset == 2 and roomPlayer.seatIdx == 1 then
			roomPlayer.displaySeatIdx = 2
		end
	end

    local player = {
    	UID        = msgTbl.m_userId,
    	nickname   = msgTbl.m_nike,
        headURL    = msgTbl.m_face,
        sex        = msgTbl.m_sex,
	    IP         = msgTbl.m_ip,
	    sPos       = msgTbl.m_pos,--服务器端从0开始
	    readyState = msgTbl.m_ready,
		score      = msgTbl.m_score,
		uiPos      = roomPlayer.displaySeatIdx,
	}
	gRoomData:addPlayer(player)


	-- 房间添加玩家
	self:roomAddPlayer(roomPlayer)
end

-- start --
--------------------------------
-- @class function
-- @description 从房间移除一个玩家
-- @param msgTbl 消息体
-- end --

function m:onRcvRemovePlayer(msgTbl)
	log("m:onRcvRemovePlayer 删除玩家")
	table.insert(self.removePlayers,msgTbl)
	if not self.showReport then
		self:removePlayerForRoom()
	end
end

-- 从房间移除要给玩家
function m:removePlayerForRoom()
	if #self.removePlayers == 0 then
		return
	end
	for _, msgTbl in pairs(self.removePlayers) do
		local seatIdx = msgTbl.m_pos + 1
		-- local roomPlayer = self.roomPlayers[seatIdx]
		local roomPlayer,k = self:getRemovePlayerInfo(seatIdx)
		if roomPlayer then
			-- 隐藏玩家准备手势
			self.UIHeadLayout:setFlagVisible(roomPlayer.displaySeatIdx,{isReady = false})
			-- 取消头像下载监听
			-- self.UIHeadLayout:removePlayer(roomPlayer.seatIdx - 1)
			self.UIHeadLayout:removePlayerByUIPos(roomPlayer.displaySeatIdx)
			-- 去除数据
			self.roomPlayers[roomPlayer.seatIdx] = nil
			-- table.remove(self.roomPlayers,k)
		end
	end
	self.removePlayers = {}
	cc.UserDefault:getInstance():setIntegerForKey("gameCurrentPlayer", #self.roomPlayers or 1)
	dump(self.roomPlayers,"===removePlayerForRoomremovePlayerForRoom==")
end

function m:getRemovePlayerInfo(seatIdx)
	for k,v in pairs(self.roomPlayers) do
		if v.seatIdx == seatIdx then
			return v,k
		end
	end
end

-- start --
--------------------------------
-- @class function
-- @description 断线重连
-- end --
function m:onRcvSyncRoomState(msgTbl,isReconnect)
	dump(msgTbl,"m:onRcvSyncRoomState")
	if msgTbl.m_state == 1 then -- 1-等待状态 4-开始游戏
		if (self.m_curCircle and self.m_curCircle == 0 and self.m_isCircle == -1) or
			(self.m_curCircle and self.m_curCircle == 0 and self.m_isCircle == 0)
		 then
			if self.gParam.isRoomCreater then
			 	self.UIRoomInfoUpper:setBtnBackLobby(false)
		 	else
			 	self.UIRoomInfoUpper:setBtnBackLobby(true)
		 	end
		end
	 	return
	end
	--是否是断线重连
	self.pung = true

	-- 游戏开始后隐藏准备标识
	self:hidePlayersReadySign()
	local args = {
		btnInviteFriend = false,
		btnReady = false,
		kTurnPosBG = true,
	}
	self.UIRoomInfoBottom:setBtnVisible(args)

	-- 显示游戏中按钮
    if cc.exports.gGameConfig.isiOSAppInReview then
		self.UIRoomInfoBottom:setBtnVisible({btnMessage = false})
    end

	--如果有方位,--b_isLanGuo:false未出牌，true已经出过牌
	if msgTbl.m_pos then
		-- 显示当前出牌方位标示
		local seatIdx = msgTbl.m_pos + 1
		self:setTurnSeatSign(seatIdx)
		if seatIdx ~= self.playerSeatIdx then
			self:playTimeCDStart(10)
		end

		if seatIdx == self.playerSeatIdx and msgTbl.b_isLanGuo == false then
			log("m:onRcvSyncRoomState 方位 msgTbl.m_pos = ",msgTbl.m_pos)
			-- 如果是玩家自己玩家选择出牌 标识设置true
			self.isPlayerShow = true
		end
	end

	-- 牌局状态,剩余牌
	self.UIRoomInfoBottom:setBtnVisible({kNodeRound = true})

	self.UIRoomInfoBottom:setTxt({remainTile = msgTbl.m_dCount})


	-- 庄家座位号
	local bankerSeatIdx = msgTbl.m_zhuang + 1

	--拷贝玩家数组
	self.curRoomPlayers = {}
	self.curRoomPlayers = self:copyTab(self.roomPlayers)

	
	dump(self.roomPlayers,"m:onRcvSyncRoomState==self.roomPlayers==" .. self.playerSeatIdx)
	-- 遍历家牌
	for k, roomPlayer in pairs(self.roomPlayers) do
		-- 庄家标识
		local seatIdx = roomPlayer.seatIdx
		local uiPos = roomPlayer.displaySeatIdx
		roomPlayer.isBanker = false
		self.UIHeadLayout:setFlagVisible(uiPos,{zhuang = false})

		if bankerSeatIdx == seatIdx then
			roomPlayer.isBanker = true
			self.UIHeadLayout:setFlagVisible(uiPos,{zhuang = true})
		end

		-- 玩家持有牌
		roomPlayer.holdMjTiles = {}
		-- 玩家已出牌
		roomPlayer.outMjTiles = {}
		-- 玩家已出牌花--中/发/白/东风
		roomPlayer.outMjTilesHua = {}
		-- 碰
		roomPlayer.mjTilePungs = {}
		-- 明杠
		roomPlayer.mjTileBrightBars = {}
		-- 暗杠
		roomPlayer.mjTileDarkBars = {}
		--吃
		roomPlayer.mjTileEat = {}

		-- 麻将放置参考点
		roomPlayer.mjTilesReferPos = self.UIMJLayout:getPlayerMjTilesReferPos(roomPlayer.displaySeatIdx)
		-- 剩余持有牌数量
		roomPlayer.mjTilesRemainCount = msgTbl.m_CardCount[seatIdx] --当前玩家持有牌数量

		if self.gParam.roomType == DefineRule.RoomType.BigMatch and msgTbl.m_IsTuoguan then
			local isTuoGuan = msgTbl.m_IsTuoguan[seatIdx]
			if self.gParam.sPosSelf == seatIdx-1 then
				self.gParam.isTuoGuan = isTuoGuan
				self.UIRoomInfoUpper:setTuoGuanBtnShow(not isTuoGuan)
			else
				self.UIHeadLayout:setTuoGuanFlag(seatIdx-1,isTuoGuan)
			end
		end

		--如果是玩家自己
		if roomPlayer.seatIdx == self.playerSeatIdx then
			-- 玩家持有牌
			if msgTbl.m_myCard then
				--self.m_mCard = msgTbl.m_mCard
				for _, v in ipairs(msgTbl.m_myCard) do
					self:addMjTileToPlayer(v[1], v[2])
				end
				-- 根据花色大小排序并重新放置位置

				self:sortPlayerMjTiles()
			end
		else
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			local mjTilePos = mjTilesReferPos.holdStart
			local maxCount = roomPlayer.mjTilesRemainCount + 1
			for i = 1, maxCount do
				local mjTileName = DefineTile.getTileStandBG(roomPlayer.displaySeatIdx)
				local mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
				mjTileSpr:setPosition(mjTilePos)
				self.playMjLayer:addChild(mjTileSpr, (display.size.height - mjTilePos.y))
				mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)

				local mjTile = {}
				mjTile.mjTileSpr = mjTileSpr
				table.insert(roomPlayer.holdMjTiles, mjTile)

				-- 隐藏多产生的牌
				if i > roomPlayer.mjTilesRemainCount then
					mjTileSpr:setVisible(false)
				end
			end
		end

		-- 服务器座次编号
		local turnPos = seatIdx - 1
		-- 已出牌
		local outMjTilesAry = msgTbl["m_oCard" .. turnPos]
		if outMjTilesAry then
			for _, v in ipairs(outMjTilesAry) do
				self:addAlreadyOutMjTiles(seatIdx, v[1], v[2])
			end
		end

		--已出的花牌
		outMjTilesAry = msgTbl["m_huaCard" .. turnPos]
		if outMjTilesAry then
			for _, v in ipairs(outMjTilesAry) do
				self:addAlreadyOutMjTilesHua(seatIdx, v[1], v[2])
			end
		end

		-- 如果是重连进来的话，需要记住最后出牌人出的牌
		if msgTbl.m_pos then
			if turnPos == msgTbl.m_pos then
				self.preShowSeatIdx = seatIdx
			end
		end

		-- 暗杠
		local darkBarArray = msgTbl["m_aCard" .. turnPos]
		if darkBarArray then
			for _, v in ipairs(darkBarArray) do
				if v[1] ~= 0 and v[2] ~= 0 then
					self:addMjTileBar(seatIdx, v[1], v[2], false)
				end
			end
		end

		-- 明杠
		local brightBarArray = msgTbl["m_mCard" .. turnPos]
		local mSrcPos = msgTbl["m_mSrcPos" .. turnPos] or {}
		if brightBarArray then
			for i, v in ipairs(brightBarArray) do
				if v[1] ~= 0 and v[2] ~= 0 then
					self:addMjTileBarEx(seatIdx, v[1], v[2], true,mSrcPos[i] or 5)
				end
			end
		end

		-- 碰
		local pungArray = msgTbl["m_pCard" .. turnPos]
		local pSrcPos = msgTbl["m_pSrcPos" .. turnPos] or {}
		if pungArray then
			for i, v in ipairs(pungArray) do
				self:addMjTilePungEx(seatIdx, v[1], v[2],pSrcPos[i] or 5)
			end
		end

		--吃
		local eatArray = msgTbl["m_eCard" .. turnPos]

		if eatArray then
			local eatTable = {}
			local group1 = {}
			local group2 = {}
			local group3 = {}
			local group4 = {}
			for i, v in ipairs(eatArray) do
				if v[1] ~= 0 and v[2] ~= 0 then
					local endTag = nil
					if i <= 3 then
						table.insert(group1,{v[2],1,v[1]}) --牌号，手中牌标识，颜色
						if i == 3 then
							table.insert(eatTable,group1)
							table.insert(roomPlayer.mjTileEat,group1)
						end
					elseif i > 3 and i <= 6 then
						table.insert(group2,{v[2],1,v[1]})
						if i == 6 then
							table.insert(eatTable,group2)
							table.insert(roomPlayer.mjTileEat,group2)
						end
					elseif i > 6 and i <= 9  then
						table.insert(group3,{v[2],1,v[1]})
						if i == 9 then
							table.insert(eatTable,group3)
							table.insert(roomPlayer.mjTileEat,group3)
						end
					elseif i > 9 and i <= 12  then
						table.insert(group4,{v[2],1,v[1]})
						if i == 12 then
							table.insert(eatTable,group4)
							table.insert(roomPlayer.mjTileEat,group4)
						end
					end
				end
			end

			for j, eatTile in pairs(eatTable) do
				self:pungBarReorderMjTiles(seatIdx, eatTile[1][3], eatTile)
			end
		end
	end
	--听
	if msgTbl.m_tingState == 1 then
		self:setTinBtnVisible(true)
	end
	self.mModleMJAnQin.gameState.flagReqedTingInfo = false

	self.pung = false
 	self.UIRoomInfoUpper:setBtnBackLobby(false)
end

-- start --
--------------------------------
-- @class function
-- @description 玩家准备手势
-- @param msgTbl 消息体
-- end --
function m:onRcvReady(msgTbl)
	log("m:onRcvReady")

	if self.gParam.sPosSelf == msgTbl.m_pos then
		if self.mUIOneRoundSettlement and (not tolua.isnull(self.mUIOneRoundSettlement)) then
			self.mUIOneRoundSettlement:removeFromParent()
			self.mUIOneRoundSettlement = nil
		end
	end

	local seatIdx = msgTbl.m_pos + 1
	self:playerGetReady(seatIdx)
end

-- start --
--------------------------------
-- @class function
-- @description 玩家在线标识
-- @param msgTbl 消息体
-- end --
function m:onRcvOffLineState(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	local roomPlayer = self.roomPlayers[seatIdx]
	if not roomPlayer then
		return
	end
	local uiPos = roomPlayer.displaySeatIdx
	if msgTbl.m_flag == 0 then-- 掉线了
		self.UIHeadLayout:setFlagVisible(uiPos,{offline = true})
	elseif msgTbl.m_flag == 1 then-- 回来了
		self.UIHeadLayout:setFlagVisible(uiPos,{offline = false})
	end
end

-- start --
--------------------------------
-- @class function
-- @description 当前局数/最大局数量
-- @param msgTbl 消息体
-- end --
function m:onRcvRoundState(msgTbl)
	log("m:onRcvRoundState")
	-- 牌局状态,剩余牌
	if msgTbl.m_curCircle == 0 then
		self.UIRoomInfoBottom:setBtnVisible({kNodeRound = false})
	else
		local args = {
			kNodeRound = true,
			kTurnPosBG = true,
		}
		self.UIRoomInfoBottom:setBtnVisible(args)
		-- for i=1,4 do
		-- 	local turnPosSpr = gComm.UIUtils.seekNodeByName(turnPosBgSpr, "Spr_turnPos_" .. i)
		-- 	turnPosSpr:stopAllActions()
		-- end
	end
	self.UIRoomInfoBottom:setTxt({remainTile = 0})

	local str = "第" .. (msgTbl.m_curCircle + 1).. "/" ..msgTbl.m_curMaxCircle .. "局"
	-- self.UIRoomInfoUpper:setRoundIndex(str)
	self.UIRoomInfoBottom:setTxt({roundNum = (msgTbl.m_curCircle + 1).. "/" ..msgTbl.m_curMaxCircle})

	self.playmes.jushu = str

	if self.gParam.isRoomCreater or ( msgTbl.m_curCircle and msgTbl.m_curCircle > 0) or msgTbl.m_isCircle > 0  then
 		self.UIRoomInfoUpper:setBtnBackLobby(false)
 	else
	 	self.UIRoomInfoUpper:setBtnBackLobby(true)
 	end
 	self.m_curCircle = msgTbl.m_curCircle
 	self.m_isCircle = msgTbl.m_isCircle
end

-- start --
--------------------------------
-- @class function
-- @description 游戏开始
-- @param msgTbl 消息体
-- end --
function m:onRcvStartGame(msgTbl)
	log("m:onRcvStartGame")
	if self.mUIOneRoundSettlement and (not tolua.isnull(self.mUIOneRoundSettlement)) then
		self.mUIOneRoundSettlement:removeFromParent()
		self.mUIOneRoundSettlement = nil
	end

	self:onRcvSyncRoomState(msgTbl,false)
	self:IsSameIp()

	--显示剩余牌
	self.UIRoomInfoBottom:setBtnVisible({kNodeRound = true})
end

-- start --
--------------------------------
-- @class function
-- @description 通知玩家出牌
-- @param msgTbl 消息体
-- end --
function m:onRcvTurnShowMjTile(msgTbl)
	dump(msgTbl,"m:onRcvTurnShowMjTile--self.playerSeatIdx= " .. self.playerSeatIdx)

	self:cleanArrowSpr()

	local msgTbl = self:dealMsgTblOfRcvTurnShowMjTile(msgTbl)
	-- 牌局状态,剩余牌
	self.UIRoomInfoBottom:setTxt({remainTile = msgTbl.m_dCount})

	local seatIdx = msgTbl.m_pos + 1
	-- 当前出牌座位
	self:setTurnSeatSign(seatIdx)

	-- 出牌倒计时
	self:playTimeCDStart(msgTbl.m_time)
	local roomPlayer = self.roomPlayers[seatIdx]
	-- 该玩家是否杠过（0-没杠过，1-杠过了）
	--roomPlayer.m_gang = msgTbl.m_gang
	if seatIdx == self.playerSeatIdx then
		-- local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
		-- decisionBtnNode:setVisible(false)

		self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)
		self:setTinBtnVisible(false)

		-- 轮到玩家出牌
		self.isPlayerShow = true

		local haidiWinType = false
		local decisionTypes = {}
		if msgTbl.m_think then
			for _,value in ipairs(msgTbl.m_think) do
				local think_m_type = value[1]
				local think_m_cardList = {}
				think_m_cardList = value[2]

				if think_m_type == 2 then
					-- 胡
					haidiWinType = true
					-- b_isHu = true
					local decisionData = {}
					decisionData.flag = 2
					decisionData.mjColor = think_m_cardList[1][1]
					decisionData.mjNumber = think_m_cardList[1][2]
					table.insert(decisionTypes,decisionData)
					log("胡")
				end

				if think_m_type == 3 then
					-- 暗杠
					local decisionData = {}
					decisionData.flag = 3
					decisionData.cardList = {}
					for _,v in ipairs(value) do
						if _>1 and #v > 0 then
							local card = {}
							card.mjColor = v[1][1]
							card.mjNumber = v[1][2]
							table.insert(decisionData.cardList,card)
						end
					end
					table.insert(decisionTypes,decisionData)
					log("暗杠")
				end
				if think_m_type == 4 then
					-- 明杠
					local decisionData = {}
					decisionData.flag = 4
					decisionData.cardList = {}
					for _,v in ipairs(think_m_cardList) do
						local card = {}
						card.mjColor = v[1]
						card.mjNumber = v[2]
						table.insert(decisionData.cardList,card)
					end
					table.insert(decisionTypes,decisionData)
					log("明杠")
				end
				if think_m_type == 7 then
					-- 暗补
					local decisionData = {}
					decisionData.flag = 7
					decisionData.cardList = {}
					for _,v in ipairs(think_m_cardList) do
						local card = {}
						card.mjColor = v[1]
						card.mjNumber = v[2]
						table.insert(decisionData.cardList,card)
					end
					table.insert(decisionTypes,decisionData)
					log("暗补")
				end
				if think_m_type == 8 then
					-- 明补
					local decisionData = {}
					decisionData.flag = 8
					decisionData.cardList = {}
					for _,v in ipairs(think_m_cardList) do
						local card = {}
						card.mjColor = v[1]
						card.mjNumber = v[2]
						table.insert(decisionData.cardList,card)
					end
					table.insert(decisionTypes,decisionData)
					log("明补")
				end

				if think_m_type == 9 then
					-- 听牌
					log("听牌")
					local decisionData = {}
					decisionData.flag = 9
					decisionData.cardList = {}
					for _,v in ipairs(value) do
						if _>1 and _%2 == 0 then
							local card = {}
							card.mjColor = v[1][1]
							card.mjNumber = v[1][2]
							table.insert(decisionData.cardList,card)
						end
					end
					self.tingHuCards = self:copyTab(value)
					table.insert(decisionTypes,decisionData)
				end
			end
			self.isShowTingTip = false
			self.isHu = false
			local tingKey = nil
			--只有听
			for k,v in pairs(decisionTypes) do
				if v.flag == 9 then
					self.isShowTingTip = true
					tingKey = k
				elseif v.flag == 2 then
					self.isHu = true
				end
			end
			if self.isShowTingTip == true then
				table.remove(decisionTypes,tingKey)
			end
		end

		-- 按钮排列
		if #decisionTypes > 0 then
			-- 自摸类型决策
			self.isPlayerDecision = true

			local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
			selfDrawnDcsNode:setVisible(true)

			for _, decisionBtn in ipairs(selfDrawnDcsNode:getChildren()) do

				local nodeName = decisionBtn:getName()

				decisionBtn:setVisible(true)

				if nodeName == "Btn_decisionPass" then
					-- 设置不存在的索引值
					decisionBtn:setTag(0)
					gComm.BtnUtils.setButtonClick(decisionBtn, function()

						local function passDecision()
							self.isPlayerDecision = false


							local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
							selfDrawnDcsNode:setVisible(false)

							local m_think = {{msgTbl.m_color,msgTbl.m_number}}

							if not (self.isShowTingTip and self.isHu) then
								NetMngMJAnQin.sendOutCard(0,m_think)
							end


							-- 删除弹出框（杠）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
							-- 删除弹出框（补）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)

							self.isHu = false
							if self.isShowTingTip and self.isHu == false then
								self:showTingArrow()
							end
						end
						--passDecision()
						local addTipPanel = false
						for idx, decisionData in ipairs(decisionTypes) do
							if decisionData.flag == 2 then
								addTipPanel = true
							end
						end
						if addTipPanel then
							for _, decisionBtn in ipairs(selfDrawnDcsNode:getChildren()) do
								decisionBtn:setEnabled(false)
							end
							UINoticeTips:create("您确定不胡吗 ?", function ( )
									-- 确定不胡
								for _, decisionBtn in ipairs(selfDrawnDcsNode:getChildren()) do
									decisionBtn:setEnabled(true)
								end
								passDecision()
							end, function ( )
								for _, decisionBtn in ipairs(selfDrawnDcsNode:getChildren()) do
									decisionBtn:setEnabled(true)
								end
							end)
						else
							passDecision()
						end
					end)

				else
					decisionBtn:setVisible(false)
				end
			end

			local decisionBtn_pass = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, "Btn_decisionPass")
			local beginPos = cc.p(decisionBtn_pass:getPosition())
			local btnSpace = decisionBtn_pass:getContentSize().width * 2

			-- 获取可以杠的数据和可补的数据
			local cardList_bar = {}
			local cardList_specialBar = {}
			local cardList_bu = {}
			local cardList_ting = {}
			for idx, decisionData in ipairs(decisionTypes) do
				if decisionData.flag == 3 or decisionData.flag == 4 then
					-- 明暗杠
					for _,v in ipairs(decisionData.cardList) do
						local card_bar = {}
						card_bar.flag = decisionData.flag
						card_bar.mjColor = v.mjColor
						card_bar.mjNumber = v.mjNumber
						table.insert(cardList_bar,card_bar)
					end
				elseif decisionData.flag == 9 then
					-- 听
					for _,v in ipairs(decisionData.cardList) do
						local card_ting = {}
						card_ting.flag = decisionData.flag
						card_ting.ting = v
						table.insert(cardList_ting,card_ting)
					end
				end
			end
			log("杠的次数",#cardList_bar)
			log("补的次数",#cardList_bu)
			dump(decisionTypes,"===decisionTypesdecisionTypes==")


			local btn_presentList = {}
			for idx, decisionData in ipairs(decisionTypes) do
				local decisionBtn = nil

				if decisionData.flag == 2 then
					-- 胡
					decisionBtn = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, "Btn_decisionWin")

					-- 杠的显示优先级为1
					table.insert(btn_presentList,{1,decisionBtn})
				elseif decisionData.flag == 3 or decisionData.flag == 4 then
					-- print("===============111111111111111")
					-- 明暗杠
					local btn_bar_name = "Btn_decisionBar"

					decisionBtn = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, btn_bar_name)
					local isExistBarBtn = false
					for _,v in ipairs(btn_presentList) do
						-- 杠的显示优先级为2
						if v[1] == 2 then
							isExistBarBtn = true
							break
						end
					end
					if not isExistBarBtn then
						table.insert(btn_presentList,{2,decisionBtn})
					end
					-- 显示杠胡牌
					local mjTileSpr = gComm.UIUtils.seekNodeByName(decisionBtn, "Spr_mjTile")
					if mjTileSpr then
						if #cardList_bar == 1 then
							local img = DefineTile.getBottomOpenTile(cardList_bar[1].mjColor, cardList_bar[1].mjNumber)
							-- mjTileSpr:setSpriteFrame(img)
							gComm.SpriteUtils.setSpriteFrameEx(mjTileSpr,img,"Texture/CardsMJNew.plist")
							mjTileSpr:getParent():setVisible(true)
						else
							mjTileSpr:getParent():setVisible(false)
						end
					end

				elseif decisionData.flag == 7 or decisionData.flag == 8 then
					-- 明暗补
					decisionBtn = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, "Btn_decisionBu")
					local isExistBarBu = false

					for _,v in ipairs(btn_presentList) do
						-- 补的显示优先级为3
						if v[1] == 3 then
							isExistBarBu = true
							break
						end
					end
					if not isExistBarBu then
						table.insert(btn_presentList,{3,decisionBtn})
					end
					-- 显示补
					local mjTileSpr = gComm.UIUtils.seekNodeByName(decisionBtn, "Spr_mjTile")
					if mjTileSpr then
						if #cardList_bu == 1 then

							local img = DefineTile.getBottomOpenTile(cardList_bu[1].mjColor, cardList_bu[1].mjNumber)
							-- mjTileSpr:setSpriteFrame(img)
							gComm.SpriteUtils.setSpriteFrameEx(mjTileSpr,img,"Texture/CardsMJNew.plist")
							mjTileSpr:setVisible(true)
						else
							mjTileSpr:setVisible(false)
						end
					end
				elseif decisionData.flag == 9 then
					-- 明暗补
					decisionBtn = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, "Btn_decisionTing")
					local isExistBarBu = false

					for _,v in ipairs(btn_presentList) do
						-- 听的显示优先级为4
						if v[1] == 4 then
							isExistBarBu = true
							break
						end
					end
					if not isExistBarBu then
						table.insert(btn_presentList,{4,decisionBtn})
					end
				else
					--
				end

				decisionBtn:setVisible(true)
				decisionBtn:setTag(idx)

				-- 可杠
				if decisionData.flag == 3 or decisionData.flag == 4 then
					if #cardList_bar == 1 then
						gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
							self.isPlayerDecision = false

							local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
							selfDrawnDcsNode:setVisible(false)

							-- 删除弹出框（杠）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
							-- 删除弹出框（补）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
							-- 发送消息
							local btnTag = sender:getTag()
							local decisionData = decisionTypes[sender:getTag()]


							local m_type = decisionData.flag
							local m_think = {}
							if decisionData.flag>4 then
								for m,n in ipairs(decisionData.cardList[1]) do
									local card = {n.mjColor,n.mjNumber}
									table.insert(m_think,card)
								end
							else
								local think_temp = {decisionData.cardList[1].mjColor,decisionData.cardList[1].mjNumber}
								table.insert(m_think,think_temp)
							end
							NetMngMJAnQin.sendOutCard(m_type,m_think)

							self.isPlayerShow = false
						end)
					else
						gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
							-- 删除弹出框（杠）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
							-- 删除弹出框（补）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
							-- add new
							local flimLayer = self:createFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR,cardList_bar,cardList_specialBar)
							self:addChild(flimLayer,ConfigGameScene.ZOrder.FLIMLAYER,m.TAG.FLIMLAYER_BAR)
							flimLayer:ignoreAnchorPointForPosition(false)
							flimLayer:setAnchorPoint(0.5,0)
							local pos_x = 0
							if decisionBtn:getPositionX()+flimLayer:getContentSize().width/2 > display.size.width then
								flimLayer:setPositionX(display.size.width-flimLayer:getContentSize().width/2)
							elseif decisionBtn:getPositionX()-flimLayer:getContentSize().width/2 < 0 then
								flimLayer:setPositionX(flimLayer:getContentSize().width/2)
							else
								flimLayer:setPositionX(decisionBtn:getPositionX())
							end
							flimLayer:setPosition(640,decisionBtn:getPositionY()+flimLayer:getContentSize().height/2)
						end)
					end
				elseif decisionData.flag == 7 or decisionData.flag == 8 then   -- 补张
					if #cardList_bu == 1 then
						gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
						self.isPlayerDecision = false

						local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
						selfDrawnDcsNode:setVisible(false)

						-- 删除弹出框（杠）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
						-- 删除弹出框（补）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)

						-- 发送消息
						local btnTag = sender:getTag()
						local decisionData = decisionTypes[sender:getTag()]

						local m_type = decisionData.flag
						local m_think = {}

						local think_temp = {decisionData.cardList[1].mjColor,decisionData.cardList[1].mjNumber}
						table.insert(m_think,think_temp)

						NetMngMJAnQin.sendOutCard(m_type,m_think)

						end)
					else
						gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
							-- 删除弹出框（杠）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
							-- 删除弹出框（补）
							self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
							-- add new
							local flimLayer = self:createFlimLayer(m.FLIMTYPE.FLIMLAYER_BU,cardList_bu)
							self:addChild(flimLayer,ConfigGameScene.ZOrder.FLIMLAYER,m.TAG.FLIMLAYER_BU)
							flimLayer:ignoreAnchorPointForPosition(false)
							flimLayer:setAnchorPoint(0.5,0)
							local pos_x = 0
							if decisionBtn:getPositionX()+flimLayer:getContentSize().width/2 > display.size.width then
								flimLayer:setPositionX(display.size.width-flimLayer:getContentSize().width/2)
							elseif decisionBtn:getPositionX()-flimLayer:getContentSize().width/2 < 0 then
								flimLayer:setPositionX(flimLayer:getContentSize().width/2)
							else
								flimLayer:setPositionX(decisionBtn:getPositionX())
							end
							flimLayer:setPositionY(decisionBtn:getPositionY()+flimLayer:getContentSize().height/2)
							log(flimLayer:getPositionX())
						end)
					end
				elseif decisionData.flag == 9  then   -- 听

					gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
						-- 删除弹出框（杠）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
						-- 删除弹出框（补）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
						self.isPlayerDecision = false

						local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
						local children = selfDrawnDcsNode:getChildren()
						for i, parentNode in ipairs(children) do
							if parentNode:getName() == "Btn_decisionPass" then
								parentNode:setVisible(true)
							else
								parentNode:setVisible(false)
							end
						end

						local btnTag = sender:getTag()
						local decisionData = decisionTypes[sender:getTag()]

						local roomPlayer = self.roomPlayers[self.playerSeatIdx]

						if #decisionData.cardList > 0 then
							for _,v1 in ipairs(roomPlayer.holdMjTiles) do
								local flag  = false
								for _,v2 in ipairs(decisionData.cardList) do
									if v1.mjColor == v2.mjColor and v1.mjNumber == v2.mjNumber then
										flag = true
										break
									end
								end
								if not flag then
									v1.mjTileSpr:setColor(cc.c3b(200,200,200))
									v1.mjIsTouch = true
								end
							end
						end
					end)
				elseif decisionData.flag == 2  then   -- 胡
					gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)
						self.isPlayerDecision = false

						local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
						selfDrawnDcsNode:setVisible(false)

						-- 删除弹出框（杠）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
						-- 删除弹出框（补）
						self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)

						-- 发送消息
						local btnTag = sender:getTag()
						local decisionData = decisionTypes[sender:getTag()]


						local m_type = decisionData.flag
						local m_think = {}

						local think_temp = {decisionData.mjColor,decisionData.mjNumber}
						table.insert(m_think,think_temp)

						if decisionData.mjColor == 0 or decisionData.mjNumber == 0 then
							m_think = {}
						end

						NetMngMJAnQin.sendOutCard(m_type,m_think)
					end)
				else
					log("=====noHandler=====decisionDatadecisionData==" .. decisionData.flag)
				end
			end

			-- 根据显示优先级进行排序
			table.sort(btn_presentList, function(a, b)
				return a[1] < b[1]
			end)
			-- 根据排序好的优先级进行显示按钮
			for _,v in ipairs(btn_presentList) do
				beginPos = cc.p(beginPos.x - btnSpace , beginPos.y)
				v[2]:setPosition(beginPos)
			end
		else
			if self.isShowTingTip and self.isHu == false then
				self:showTingArrow()
			end
		end

		-- 摸牌
		if msgTbl.m_flag == 0 and msgTbl.m_color ~= 0 and msgTbl.m_number ~= 0 then
			-- 添加牌放在末尾
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			local mjTilePos = mjTilesReferPos.holdStart
			mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, #roomPlayer.holdMjTiles))
			mjTilePos = cc.pAdd(mjTilePos, cc.p(36, 0))

			local mjTile = self:addMjTileToPlayer(msgTbl.m_color, msgTbl.m_number)
			if mjTile and mjTile.mjTileSpr and (not tolua.isnull(mjTile.mjTileSpr)) then
				mjTile.mjTileSpr:setPosition(mjTilePos)
				self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))
			end
			if self.isShowTingTip and self.isHu == false then
				self:showTingArrow()
			end
		end
		self:setMJGray(roomPlayer.holdMjTiles,msgTbl.m_cardUnusable)
	else
		-- 摸牌
		-- 添加牌
		if msgTbl.m_flag == 0 then
			if not roomPlayer then
				if cc.exports.gGameConfig.debugMode then
					UINoticeTips:create("2240座位号："..seatIdx .. "人数:" .. #self.roomPlayers)
				end
				return
			end
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			local mjTilePos = mjTilesReferPos.holdStart
			mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, roomPlayer.mjTilesRemainCount))

			dump(roomPlayer,"==roomPlayer=seatIdx,self.playerSeatIdx=" .. seatIdx .. " ".. self.playerSeatIdx)
			roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount + 1

			local mjTileSpr = roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr
			if mjTileSpr and (not tolua.isnull(mjTileSpr)) then
				mjTileSpr:setVisible(true)
				local dn = self.playerSeatIdx-seatIdx
				if dn == 2 or dn == -2 then
					mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(-15,0)) )
				elseif dn == -1 or dn == 3 then
					mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(0,30)) )
				elseif dn == 1 or dn == -3 then
					mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(0,-40)) )
				end
				if self.gParam.roomPeopleNum == 2 then
					if self.seatOffset == 3 and seatIdx == 2 then
						mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(-15,0)) )
					elseif self.seatOffset == 2 and seatIdx == 1 then
						mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(-15,0)) )
					end
				elseif self.gParam.roomPeopleNum == 3 then

					log("---------------self.seatOffset",self.seatOffset,seatIdx,self.playerSeatIdx)
					if self.seatOffset == 3 and seatIdx == 2  then
						mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(0,30)))
					elseif self.seatOffset == 3 and seatIdx == 3 then
						mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(0,-40)))
					elseif self.seatOffset == 1 and seatIdx == 1 then
						mjTileSpr:setPosition( cc.pAdd(mjTilePos,cc.p(0,30)))
					end
				end
			end
		end
	end
end

-- start --
--------------------------------
-- @class function
-- @description 广播玩家出牌
-- end --
function m:onRcvSyncShowMjTile(msgTbl)
	-- dump(msgTbl,"===m:onRcvSyncShowMjTile(msgTbl)===" .. self.playerSeatIdx)
	if msgTbl.m_errorCode ~= 0 and msgTbl.m_errorCode ~= 1 then  --m_errorCode 1-补杠失败
		dump(msgTbl,"===m:onRcvSyncShowMjTile(msgTbl)==onError==" .. self.playerSeatIdx)
		self:onError(gt.socketClient)
		return
	end
	-- if msgTbl.m_errorCode == 2 then--不能出牌
	-- 	--msgTbl.m_pos
	-- 	--msgTbl.m_card--已经出的牌要返回到自己的手牌中
	-- end

	self:setMJNormal()
	-- 座位号（1，2，3，4）
	local seatIdx = msgTbl.m_pos + 1

	if seatIdx == self.playerSeatIdx then
		self.isPlayerDecision = false

	end

	local roomPlayer = self.roomPlayers[seatIdx]
	if msgTbl.m_type == 2 then
		-- 自摸胡, 为什么会有这种类型。
		self:showDecisionAnimation(seatIdx, m.DecisionType.SELF_DRAWN_WIN, msgTbl.m_hu)

		--m_type == 1普通出牌，8补花,9听牌
	elseif msgTbl.m_type == 1 or msgTbl.m_type == 8 or msgTbl.m_type == 9 then
		if next(self.outMJAnimList) then
			log("==onRcvSyncShowMjTile=self.outMJAnimList=num=",#self.outMJAnimList)
			for k,v in pairs(self.outMJAnimList) do
				v.mjTileSpr:stopAllActions()
				v.mjTileSpr:removeFromParent()
				self:addAlreadyOutMjTiles(v.seatIndex, v.mjColor, v.mjNumber)
			end
			self.outMJAnimList = {}
		end

		-- 出牌动作
		local mjTilesReferPos = roomPlayer.mjTilesReferPos
		local mjTilePos = mjTilesReferPos.holdStart
		local realpos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, roomPlayer.mjTilesRemainCount))
		if seatIdx == self.playerSeatIdx then
			realpos = roomPlayer.mjTilesReferPos.showMjTilePos
		end

		if ( next(msgTbl.m_think) ~= nil ) then
			local  mj_color = msgTbl.m_think[1][1]
			local  mj_number = msgTbl.m_think[1][2]
			SoundMng.playCardEffect(mj_color, mj_number,roomPlayer.sex)
			self:showMjTileAnimation(seatIdx, realpos, mj_color, mj_number,function()
				-- 显示出的牌
				self:addAlreadyOutMjTiles(seatIdx, mj_color, mj_number)
				-- 显示出的牌箭头标识
				local isHua = self.mModleMJAnQin:IsHuaCard(mj_color, mj_number)
				self:showOutMjtileSign(seatIdx,isHua)
				SoundMng.PlayCardOut()
			end)
			if seatIdx == self.playerSeatIdx then
				for i = #roomPlayer.holdMjTiles, 1, -1 do
					local mjTile = roomPlayer.holdMjTiles[i]
					if mjTile.mjColor == mj_color
						and mjTile.mjNumber == mj_number
						and mjTile.mjTileSpr then

						mjTile.mjTileSpr:removeFromParent()
						table.remove(roomPlayer.holdMjTiles, i)
						break
					end
				end
				self:sortPlayerMjTiles()
			end
		end
		if seatIdx ~= self.playerSeatIdx then
			if not tolua.isnull(roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr) then
				roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr:setVisible(false)
				roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount - 1
			end
		else
			local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
			selfDrawnDcsNode:setVisible(false)
			self:cleanArrowSpr() --清除小箭头

			self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)
			-- 停止倒计时音效
			if self.playCDAudioID then
				gComm.SoundEngine:stopEffect(self.playCDAudioID)
				self.playCDAudioID = nil
			end
		end
		if msgTbl.m_type == 8 then
			-- self:showAnimBuHua(roomPlayer.mjTilesReferPos.showMjTilePos)
			self:showAnimBuHua(roomPlayer.mjTilesReferPos.showMjHuaAnimPos)
		elseif msgTbl.m_type == 9 then
			if seatIdx == self.playerSeatIdx then
				self:setTinBtnVisible(true)
			end
		end

		-- 记录出牌的上家
		self.preShowSeatIdx = seatIdx
	elseif msgTbl.m_type == 3 then
		-- 暗杠
		log("     暗杠    ")
		if (next(msgTbl.m_think) ~= nil) then
			local msgTable = {}
			msgTable.m_color = msgTbl.m_think[1][1]
			msgTable.m_number = msgTbl.m_think[1][2]
			-- if self.IsAnGangShow then
			-- 	self:showDecisionAnimation(seatIdx, m.DecisionType.BRIGHT_BAR)
			-- else
				self:showDecisionAnimation(seatIdx, m.DecisionType.DARK_BAR)
			-- end
			self:addMjTileBar(seatIdx, msgTable.m_color, msgTable.m_number, false)
			-- self:addMjTileBarEx(seatIdx, msgTable.m_color, msgTable.m_number, false,msgTbl.m_srcPos)
			self:hideOtherPlayerMjTiles(seatIdx, true, false)

			self:sortPlayerMjTiles()
		end
	elseif msgTbl.m_type == 7 then
		-- 暗补
		log("     暗补     ")
		if (next(msgTbl.m_think) ~= nil) then
			local  mj_color = msgTbl.m_think[1][1]
			local  mj_number = msgTbl.m_think[1][2]
			self:addMjTileBar(seatIdx, mj_color, mj_number, false)
			-- self:addMjTileBarEx(seatIdx, mj_color, mj_number, false,msgTbl.m_srcPos)
			self:hideOtherPlayerMjTiles(seatIdx, true, false)
			self:showDecisionAnimation(seatIdx, m.DecisionType.DARK_BU)
		end
	elseif msgTbl.m_type == 4 then
		-- 碰转明杠
		log("     碰转明杠 ")
		if msgTbl.m_GangType == 2 then--2表示只飘字杠
			self:showOprateSprite(seatIdx)
		elseif msgTbl.m_GangType == 3 then--3表示杠的摆四张牌
			if (next(msgTbl.m_think) ~= nil) then
				local  mj_color = msgTbl.m_think[1][1]
				local  mj_number = msgTbl.m_think[1][2]
				self:changePungToBrightBar(seatIdx, mj_color, mj_number)
				self:sortPlayerMjTiles()
			end
		else
			if (next(msgTbl.m_think) ~= nil) then
				local  mj_color = msgTbl.m_think[1][1]
				local  mj_number = msgTbl.m_think[1][2]
				self:changePungToBrightBar(seatIdx, mj_color, mj_number)
				self:showDecisionAnimation(seatIdx, m.DecisionType.BRIGHT_BAR)
				self:sortPlayerMjTiles()
			end
		end
	-- elseif msgTbl.m_type == 8 then
	-- 	-- 明补(就是补花)
	elseif msgTbl.m_type == DefineRoom.THINK_OPERATE.TO_TING then --听 提示,目前没用
		local roomPlayer = self.roomPlayers[seatIdx]
		local holdcount = #roomPlayer.holdMjTiles - 1

		if self.playerSeatIdx == seatIdx then
			self.m_tingState = 1
			self:setTingState(holdcount)
		end
		self:showDecisionAnimation(seatIdx, m.DecisionType.TING)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 通知玩家决策
-- end --
function m:onRcvMakeDecision(msgTbl)
	dump(msgTbl,"m:onRcvMakeDecision")

	self.isShowEat = false
	if msgTbl.m_flag == 1 then
		-- 玩家决策
		self.isPlayerDecision = true

		-- 决策倒计时
		self:playTimeCDStart(msgTbl.m_time)

		-- 玩家决策
		local decisionTypes = msgTbl.m_think --玩家决策类型
		-- 最后加入决策"过"选项
		--table.insert(decisionTypes, 0)  --插入过类型
		local pass = {50,{}}
		table.insert(decisionTypes, pass)
		-- 显示对应的决策按键
		local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn") --显示所有的按键决策
		decisionBtnNode:setVisible(true)

		for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
			decisionBtn:setVisible(false)
		end
		local Btn_decision_0 = gComm.UIUtils.seekNodeByName(decisionBtnNode, "Btn_decision_0")
		local startPosX = Btn_decision_0:getPositionX()
		local posY = Btn_decision_0:getPositionY()

		local noSame = {}
		for i, v in ipairs(decisionTypes) do
			local isExist = false
			-- 这儿为什么会重复？？
			table.foreach(noSame, function(k, m)
				if m[1] == v[1] then
					isExist = true
					return false
				end
			end)
			if not isExist then
				table.insert(noSame, v)
			end
		end

		local posTag = #noSame
		self.result1 = nil
		self.result2 = nil
		table.sort(noSame,function(a,b)
			return a[1] < b[1]
		end)
		for i, v in ipairs(noSame) do
			-- 1-出牌 2-胡，3-暗杠 4-明杠，5-碰，6-吃，7-暗补、8-明补
			local m_type = nil
			if v[1] == 50 then
				m_type = 0
			elseif v[1] == 2 then
				m_type = 1
			elseif v[1] == 3 or v[1] == 4 then
				m_type = 2
			elseif v[1] == 5 then
				m_type = 3
			elseif v[1] == 6 then
				m_type = 4
			elseif v[1] == 7 or v[1] == 8 then
				m_type = 5
			end

			posTag = posTag - 1

			local decisionBtn = gComm.UIUtils.seekNodeByName(decisionBtnNode, "Btn_decision_" .. m_type)
			if decisionBtn:getChildByTag(5) then
				decisionBtn:getChildByTag(5):removeFromParent()
			end
			decisionBtn:setTag(v[1])
			decisionBtn:setVisible(true)


			decisionBtn:setPosition(cc.p(startPosX - posTag * Btn_decision_0:getContentSize().width * 2, posY))

			-- 显示要碰，杠，胡的牌
			local mjTileSpr = gComm.UIUtils.seekNodeByName(decisionBtn, "Spr_mjTile")

			if mjTileSpr then
				local img = DefineTile.getBottomOpenTile( msgTbl.m_color, msgTbl.m_number)
				-- mjTileSpr:setSpriteFrame(img)
				gComm.SpriteUtils.setSpriteFrameEx(mjTileSpr,img,"Texture/CardsMJNew.plist")
				mjTileSpr:setVisible(true)
			end

			-- 响应决策按键事件
			gComm.BtnUtils.setButtonClick(decisionBtn, function(sender)

				local function makeDecision(decisionType, m_type)

					self.isPlayerDecision = false
					self.isShowEat = false

					self.result1 = nil
					self.result2 = nil

					-- 隐藏决策按键
					local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
					decisionBtnNode:setVisible(false)
					-- 发送决策消息

					local m_type = decisionType
					local m_think = {{msgTbl.m_color,msgTbl.m_number}}
					if decisionType == 18 then --明大蛋 发3张
						for i= 1,2 do
							local card = {msgTbl.m_color,msgTbl.m_number}
							table.insert(m_think,card)
						end
					end
					NetMngMJAnQin.sendPlayerDecision(m_type,m_think)
				end

				local decisionType = sender:getTag()
				log("onRcvMakeDecision decisionType = ",decisionType, " self.isShowEat = ",self.isShowEat)

				if decisionType == 6 then  --吃牌

					local function sendEatMssage(result1, result2)
						self.isPlayerDecision = false --决策标识为false
						self.isShowEat = false

						self.result1 = nil
						self.result2 = nil

						-- 隐藏决策按键
						local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
						decisionBtnNode:setVisible(false)

						-- 发送决策消息
						local m_type = 6
						local m_think = {{msgTbl.m_color,result1},{msgTbl.m_color,result2}} -- wxg msgTbl.m_color又是哪里来的?

						NetMngMJAnQin.sendPlayerDecision(m_type,m_think)
					end


					if self.isShowEat then

						if self.result1 ~= nil  and self.result2 ~= nil then
							sendEatMssage(self.result1, self.result2)
						end

						self.result1 = nil
						self.result2 = nil

						return
					end


					self.isShowEat = true
					local showMjEatTable = {} --要显示的吃的牌
					for _, m in pairs(decisionTypes) do
						if m[1] == 6 then
							table.insert(showMjEatTable, {m[2][1][2], msgTbl.m_number, m[2][2][2]})
						end
					end

					if #showMjEatTable == 1 then

						local result = {}

						for n = 1, 3 do
							if msgTbl.m_number ~= showMjEatTable[1][n] then
								table.insert(result,showMjEatTable[1][n])
							end
						end

						self.result1 = result[1]
						self.result2 = result[2]

						self.isShowEat = true

						sendEatMssage(self.result1, self.result2)
						return
					end

					local eatBg = cc.Scale9Sprite:create("")
					if mjTileSpr then
						eatBg:setContentSize(cc.size(#showMjEatTable * 3 * mjTileSpr:getContentSize().width + #showMjEatTable * 25, decisionBtn:getContentSize().height))
					end
					local menu = cc.Menu:create()
					local pos = 0
					local mjWidth = 0
					for i, mjNumber in pairs(showMjEatTable) do
						pos = pos + 1

						for j = 1, 3 do
							local mjTileSpr = SpriteTileOpen:create(msgTbl.m_color, mjNumber[j],0.75)
							if tonumber(mjNumber[j]) == tonumber(msgTbl.m_number) then
								mjTileSpr:setColorYellow()
							end
							local menuItem = cc.MenuItemSprite:create(mjTileSpr,mjTileSpr) --创建菜单项
							menuItem:setTag(i)

							local function menuCallBack(i, sender)
								local result = {}
								for m, eat in pairs(showMjEatTable) do
									if m == i then
										for n = 1, 3 do
											if msgTbl.m_number ~= showMjEatTable[m][n] then
												table.insert(result,showMjEatTable[m][n])
											end
										end
									end
								end
								sendEatMssage(result[1], result[2])
							end
							menuItem:registerScriptTapHandler(menuCallBack)

							menuItem:setPosition(cc.p(mjWidth  + (pos - 1) * 10, eatBg:getContentSize().height / 1))
							menu:addChild(menuItem)
							mjWidth = mjWidth + mjTileSpr:getContentSize().width * 0.75

						end
					end

					eatBg:addChild(menu)

					if pos == 1 then
						menu:setPosition(eatBg:getContentSize().width * 0.5 - mjWidth * 0.5 + mjTileSpr:getContentSize().width * 0.5 ,0)
					elseif pos == 2 then
						menu:setPosition(eatBg:getContentSize().width * 0.5 - mjWidth * 0.5 + mjTileSpr:getContentSize().width * 0.4 ,0)
					else
						menu:setPosition(eatBg:getContentSize().width * 0.5 - mjWidth * 0.5 + mjTileSpr:getContentSize().width * 0.3 ,0)
					end

					sender:addChild(eatBg , -10, 5) -- wxg 这里作为sender的子类,当menuCallBack回调的时候,并没有销毁这个eatBg,导致下次再吃牌时
												 -- 这玩意还会被显示出来,表象即上次吃的牌类型,显示在了上面..
												 -- 记得在发送吃消息的时候,把eatBg删除掉
					eatBg:setPosition(0,eatBg:getContentSize().height * 1.3)
				elseif decisionType == 2 then --胡牌
					for _, m in pairs(decisionTypes) do
						if m[1] == 2 then
							self.isPlayerDecision = false
							-- 隐藏决策按键
							local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
							decisionBtnNode:setVisible(false)
							-- 发送决策消息
							local m_type = decisionType
							local m_think = m[2]

							NetMngMJAnQin.sendPlayerDecision(m_type,m_think)
						end
					end
				else
					if decisionType == 0 then

						-- 胡的时候点击过，添加提示
						local addTipPanel = false
						for i, v in ipairs(noSame) do
							-- 1-出牌 2-胡，3-暗杠 4-明杠，5-碰，6-吃，7-暗补、8-明补
							if v[1] == 2 then
								addTipPanel = true
							end
						end

						if addTipPanel then
							for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
								decisionBtn:setEnabled(false)
							end
							UINoticeTips:create("您确定不胡吗 ?", function ( )
								-- 确定不胡
								for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
									decisionBtn:setEnabled(true)
								end
								makeDecision(decisionType, 0)
							end, function ( )
								for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
									decisionBtn:setEnabled(true)
								end
							end)
						else
							makeDecision(decisionType, 0)
						end

					else
						makeDecision(decisionType, 0)
					end
				end

			end)
		end
	end

end

-- start --
--------------------------------
-- @class function
-- @description 广播决策结果
-- end --
function m:onRcvSyncMakeDecision(msgTbl)

	dump(msgTbl,"m:onRcvSyncMakeDecision",5)

	if msgTbl.m_errorCode ~= 0  and msgTbl.m_errorCode ~= 1 then --m_errorCode 1 补杠碰
		return
	end

	dump(msgTbl,"m:onRcvSyncMakeDecision22")

	-- 隐藏决策按键
	local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
	if decisionBtnNode:isVisible() == true then

		local isCanHuFlag = false
		for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
			if  decisionBtn:getName() == "Btn_decision_1" then
				if decisionBtn:isVisible() == true then
					isCanHuFlag = true
					break
				end
			end
		end

		if isCanHuFlag == true then -- 有胡
			for _, decisionBtn in ipairs(decisionBtnNode:getChildren()) do
				 if decisionBtn:getName() == "Btn_decision_0" or decisionBtn:getName() == "Btn_decision_1" then
					decisionBtn:setVisible(true)
				else
					decisionBtn:setVisible(false)
				end
			end
		end

		if isCanHuFlag == false then
			self.isPlayerDecision = false
			decisionBtnNode:setVisible( false )
		end
	end

	if self.gParam.sPosSelf == msgTbl.m_pos then
	 	self.isPlayerDecision = false
	end
	--            0,      --过
	-- TO_HU    = 2,	  --胡
	-- TO_AGANG = 3,	  --暗杠
	-- TO_MGANG = 4,	  --明杠
	-- TO_PENG  = 5,	  --碰
	-- TO_CHI   = 6,	  --吃
	-- TO_ABU   = 7,	  --暗补
	-- TO_MBU   = 8,	  --明补
	-- TO_TING  = 11,	  --听

	if msgTbl.m_think ~= 0 and msgTbl.m_think[1] ~= DefineRoom.THINK_OPERATE.TO_MBU
			and msgTbl.m_think[1] ~= 0  then
		if next(self.outMJAnimList) then
			for k,v in pairs(self.outMJAnimList) do
				v.mjTileSpr:stopAllActions()
				v.mjTileSpr:removeFromParent()
				self:addAlreadyOutMjTiles(v.seatIndex, v.mjColor, v.mjNumber,true)
			end
			self.outMJAnimList = {}
		end
	end

	local seatIdx = msgTbl.m_pos + 1

	if msgTbl.m_think[1] == 2 then
		-- 接炮胡
		self:showDecisionAnimation(seatIdx, m.DecisionType.TAKE_CANNON_WIN, msgTbl.m_hu)
	elseif msgTbl.m_think[1] == 3 or  msgTbl.m_think[1] == 4 then

		-- self:addMjTileBar(seatIdx, msgTbl.m_color, msgTbl.m_number, true)
		self:addMjTileBarEx(seatIdx, msgTbl.m_color, msgTbl.m_number, true,msgTbl.m_srcPos)
		-- 杠牌动画
		self:showDecisionAnimation(seatIdx, m.DecisionType.BRIGHT_BAR)

		-- 隐藏持有牌中打出的牌
		self:hideOtherPlayerMjTiles(seatIdx, true, true)
		-- 移除上家打出的牌
		self:removePreRoomPlayerOutMjTile()

	elseif msgTbl.m_think[1] == 5 then --DefineRoom.THINK_OPERATE.TO_PENG
		-- 碰牌
		-- self:addMjTilePung(seatIdx, msgTbl.m_color, msgTbl.m_number)
		self:addMjTilePungEx(seatIdx, msgTbl.m_color, msgTbl.m_number,msgTbl.m_srcPos)
		-- 碰牌动画
		self:showDecisionAnimation(seatIdx, m.DecisionType.PUNG)

		-- 隐藏持有牌中打出的牌
		self:hideOtherPlayerMjTiles(seatIdx, false)
		if msgTbl.m_errorCode == 0 then --m_errorCode 1 补杠碰
			-- 移除上家打出的牌
			self:removePreRoomPlayerOutMjTile()
		end
	elseif msgTbl.m_think[1] == 6 then
		local eatGroup = {}
		table.insert(eatGroup,{msgTbl.m_think[2][1][2], 0, msgTbl.m_color})
		table.insert(eatGroup,{msgTbl.m_number, 1, msgTbl.m_color})
		table.insert(eatGroup,{msgTbl.m_think[2][2][2], 0, msgTbl.m_color})

		-- 吃牌
		local roomPlayer = self.roomPlayers[seatIdx]
		table.insert(roomPlayer.mjTileEat, eatGroup)

		self:pungBarReorderMjTiles(seatIdx, msgTbl.m_color, eatGroup)
		-- 碰牌动画
		self:showDecisionAnimation(seatIdx, m.DecisionType.EAT)

		-- 隐藏持有牌中打出的牌
		self:hideOtherPlayerMjTiles(seatIdx, false)
		-- 移除上家打出的牌
		self:removePreRoomPlayerOutMjTile()

	elseif msgTbl.m_think[1] == DefineRoom.THINK_OPERATE.TO_MBU then --补花[8]

		-- 座位号（1，2，3，4）
		local seatIdx = msgTbl.m_pos + 1
		local roomPlayer = self.roomPlayers[seatIdx]

		log("--8888-roomPlayer.mjTilesRemainCount---", seatIdx," ",self.playerSeatIdx)


		if seatIdx ~= self.playerSeatIdx then
			log("===self.outMJAnimList=num=",#self.outMJAnimList)
			if next(self.outMJAnimList) then
				for k,v in pairs(self.outMJAnimList) do
					v.mjTileSpr:stopAllActions()
					v.mjTileSpr:removeFromParent()
					self:addAlreadyOutMjTiles(v.seatIndex, v.mjColor, v.mjNumber)
				end
				self.outMJAnimList = {}
			end

			-- 出牌动作
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			local mjTilePos = mjTilesReferPos.holdStart
			local realpos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, roomPlayer.mjTilesRemainCount))
			if ( next(msgTbl.m_think) ~= nil ) then
				local  mj_color = msgTbl.m_color
				local  mj_number = msgTbl.m_number
				SoundMng.playCardEffect(mj_color, mj_number,roomPlayer.sex)
				self:showMjTileAnimation(seatIdx, realpos, mj_color, mj_number,function()
					-- 显示出的牌
					self:addAlreadyOutMjTiles(seatIdx, mj_color, mj_number)

					-- 显示出的牌箭头标识
					-- self:showOutMjtileSign(seatIdx)
					self:showOutMjtileSignHua(seatIdx)
					SoundMng.PlayCardOut()
				end)
			end

			-- dump(roomPlayer,"===roomPlayer==onRcvSyncMakeDecision===" .. seatIdx .. " ".. self.playerSeatIdx )

			if roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr then
				roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr:setVisible(false)
				roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount - 1

				log("---roomPlayer.mjTilesRemainCount--5--" .. roomPlayer.mjTilesRemainCount)
			end

			log("---roomPlayer.mjTilesRemainCount--6--" .. roomPlayer.mjTilesRemainCount)
		end
		-- self:showAnimBuHua(roomPlayer.mjTilesReferPos.showMjTilePos)
		self:showAnimBuHua(roomPlayer.mjTilesReferPos.showMjHuaAnimPos)
		-- 记录出牌的上家
		self.preShowSeatIdx = seatIdx
	end
end

function m:onRcvChatMsg(msgTbl)
	dump(msgTbl,"===onRcvChatMsg===")
	self.UIHeadLayout:onRcvChatMsg(msgTbl)
end

function m:showReportHandle( dTime,msgTbl )
	local delayTime = cc.DelayTime:create(dTime)
	local callFunc = cc.CallFunc:create(function(sender)
		self:showRcvSettlement(msgTbl)
	end)
	local seqAction = cc.Sequence:create(delayTime, callFunc)
	self:runAction(seqAction)
end

function m:onRcvRoundReport(msgTbl)
	dump(msgTbl,"m:onRcvRoundReport" .. self.gParam.roomType.. "==" ..DefineRule.RoomType.BigMatch)

	self.showReport = true
    self:showMaskLayer()

	self:removeHuTipLayer()
	self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)

	self:showAllPlayerMjTile(msgTbl)

	if self.gParam.roomType == DefineRule.RoomType.BigMatch then
		-- m_result;//0-自摸，1-点炮，2-慌庄
		-- m_win[5];//4家胡牌情况，0-没胡，1-自摸，2-收炮，3-点炮
		if msgTbl.m_result == 2 then--流局
        	self:showRoundRes(false)
		else
		    local winIndex = msgTbl.m_win[self.gParam.sPosSelf+1]
	        if winIndex == 1 or winIndex == 2 then
	        	--胜利
	        	self:showRoundRes(true)
	        else
	        	--失败,无操作
	        end
		end
		self:showReportHandle(2.0,msgTbl)
	else
		if msgTbl.m_result == 2 then--流局
			self:showAnimCsb(display.center,"Csd/Animation/MJ/AnimMJLiuJu.csb",handlerEx(self,self.showReportHandle,0.3,msgTbl))
		else
			self:showReportHandle(2.0,msgTbl)
		end
	end
end

function m:showAllPlayerMjTile( msgTbl )
	dump(self.roomPlayers,"m:showAllPlayerMjTile( msgTbl )")--结算不显示了
end

function m:removeallscene()
	log("m:removeallscene")

	if next(self.outMJAnimList) then
		for k,v in pairs(self.outMJAnimList) do
			v.mjTileSpr:stopAllActions()
			v.mjTileSpr:removeFromParent()
		end
		self.outMJAnimList = {}
	end

	-- 停止倒计时音效
	self.playTimeCD = nil

	-- 移除所有麻将
	self.playMjLayer:removeAllChildren()
	self:addMovingTileSpr()

	-- 隐藏座次标识
	local args = {
		kNodeRound = false,
		kTurnPosBG = false,
	}
	-- 隐藏牌局状态
	self.UIRoomInfoBottom:setBtnVisible(args)

	-- 隐藏倒计时
	self.UIRoomInfoBottom:setTxt({countDown = ""})

	-- 隐藏出牌标识
	self.outMjtileSignNode:setVisible(false)

	-- 隐藏决策
	local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
	decisionBtnNode:setVisible(false)

	local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
	selfDrawnDcsNode:setVisible(false)

	local decisionBtn_pass = gComm.UIUtils.seekNodeByName(selfDrawnDcsNode, "Btn_decisionPass")
	decisionBtn_pass:setVisible(true)

	self.showReport = false
	self:removePlayerForRoom()
	self:setTinBtnVisible(false)
	self:removeHuTipLayer()
end

function m:showRcvSettlement(msgTbl)
	dump(msgTbl,"m:showRcvSettlementshowRcvSettlementshowRcvSettlement" .. self.playerSeatIdx)
	-- 弹出局结算界面
	self.curRoomPlayers = {}
	self.curRoomPlayers = self:copyTab(self.roomPlayers)
	if msgTbl.m_end == 0 then -- 不是最后一局
		local args = {
			msgTbl        = msgTbl,
			roomPlayers   = self.roomPlayers,
			playerSeatIdx = self.playerSeatIdx,
			isLastRound   = msgTbl.m_end == 1,
			playmes       = self.playmes,
			roomType	  = self.gParam.roomType,
		}
		self.mUIOneRoundSettlement = UISettlementOneRound:create(args)
		self:addChild(self.mUIOneRoundSettlement, ConfigGameScene.ZOrder.ROUND_REPORT)
	else
		if self.gParam.roomType == DefineRule.RoomType.BigMatch then
			--最后一局不显示单局结算
		else
			local args = {
				msgTbl        = msgTbl,
				roomPlayers   = self.curRoomPlayers,
				playerSeatIdx = self.playerSeatIdx,
				isLastRound   = msgTbl.m_end == 1,
				playmes       = self.playmes,
				roomType	  = self.gParam.roomType,
			}
			self.mUIOneRoundSettlement = UISettlementOneRound:create(args)
			self:addChild(self.mUIOneRoundSettlement, ConfigGameScene.ZOrder.ROUND_REPORT)
		end
	end

	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		local args = {btnOutRoom = true}
		self.UIRoomInfoUpper:setBtnVisible(args)

	    for i = 1, #self.roomPlayers do
	        local roomPlayer = self.roomPlayers[i]
			self.UIHeadLayout:setTxt(roomPlayer.displaySeatIdx,{score = msgTbl.m_score[i]})
	    end
	end

	-- 停止播放倒计时警告音效
	if self.playCDAudioID then
		gComm.SoundEngine:stopEffect(self.playCDAudioID)
		self.playCDAudioID = nil
	end
	if self.playTimeCD then
		self.playTimeCD = nil
	end
end

function m:onRcvFinalReport(msgTbl)
	dump(msgTbl,"m:onRcvFinalReportonRcvFinalReportonRcvFinalReport")

	if self.gParam.roomType == DefineRule.RoomType.BigMatch then

	else
		if msgTbl.m_isPlaying == 1 then
			local args = {
				curRoomPlayers = self.curRoomPlayers,
				msgTbl         = msgTbl,
				playerSeatIdx  = self.playerSeatIdx,
				playmes        = self.playmes,
				roomType       = self.gParam.roomType,
			}
			self.finalReport = UISettlementFinal:create(args)
			self.finalReport:retain()
		elseif msgTbl.m_isPlaying == 0 then
			local delayTime = cc.DelayTime:create(2.5)
			local callFunc = cc.CallFunc:create(function(sender)
				local args = {
					curRoomPlayers = self.curRoomPlayers,
					msgTbl         = msgTbl,
					playerSeatIdx  = self.playerSeatIdx,
					playmes        = self.playmes,
					roomType       = self.gParam.roomType,
				}
				local finalReport = UISettlementFinal:create(args)
				self:addChild(finalReport, ConfigGameScene.ZOrder.REPORT)
			end)
			local seqAction = cc.Sequence:create(delayTime, callFunc)
			self:runAction(seqAction)
		end
	end
end

-- start --
--------------------------------
-- @class function
-- @description 房间添加玩家
-- @param roomPlayer 玩家信息
-- end --
function m:roomAddPlayer(roomPlayer)
	self.UIHeadLayout:roomAddPlayer(roomPlayer.seatIdx - 1)
	-- 添加入缓冲
	self.roomPlayers[roomPlayer.seatIdx] = roomPlayer
	-- table.insert(self.roomPlayers,roomPlayer)
	cc.UserDefault:getInstance():setIntegerForKey("gameCurrentPlayer", #self.roomPlayers or 1)

	dump(roomPlayer,"m:roomAddPlayer(roomPlayer)===anqing"..self.gParam.roomPeopleNum .. #self.roomPlayers)
	
	dump(self.roomPlayers,"=========roomAddPlayerroomPlayers====")
	if #self.roomPlayers == self.gParam.roomPeopleNum then
		local args = {
			btnInviteFriend = false,
			kNodeRound = false,
		}
		self.UIRoomInfoBottom:setBtnVisible(args)
		self.UIHeadLayout:setFlagVisible(roomPlayer.displaySeatIdx,{isReady = true})
	end
end

-- start --
--------------------------------
-- @class function
-- @description 玩家自己进入房间
-- @param msgTbl 消息体
-- end --
function m:playerEnterRoom(msgTbl)

	if self.applyDimissRoom then
		self.applyDimissRoom:setVisible(false)
	end

	self:getLocation()

	-- 房间中的玩家
	self.roomPlayers = {}
	local selfPlayerInfo = cc.exports.gData.ModleGlobal:getSelfInfo()
		-- userID   = 0,
		-- nikeName = "",--昵称
		-- nikeNameShort = "",--简化昵称
		-- sex      = 1,--1男，2女
		-- headURL  = "",--头像地址
		-- IP       = "",--ip地址
		-- GM       = 1,--gm号. -- 是否是gm 0不是  1是
		-- isGM     = false,

	-- 玩家自己放入到房间玩家中
	local roomPlayer = {}
	roomPlayer.uid = selfPlayerInfo.userID
	roomPlayer.nickname = selfPlayerInfo.nikeName
	roomPlayer.headURL = selfPlayerInfo.headURL
	roomPlayer.sex = selfPlayerInfo.sex
	roomPlayer.ip = selfPlayerInfo.IP
	roomPlayer.seatIdx = msgTbl.m_pos + 1
	roomPlayer.m_pos = msgTbl.m_pos
	-- 玩家座位显示位置
	roomPlayer.displaySeatIdx = 4
	roomPlayer.readyState = msgTbl.m_ready
	roomPlayer.score = msgTbl.m_score
	
	dump(roomPlayer,"==playerEnterRoom==")
	gRoomData:enterRoom(roomPlayer)

	log("roomPlayer.score = " .. roomPlayer.score)
	-- 添加玩家自己
	self:roomAddPlayer(roomPlayer)

	-- 房间编号
	self.roomID = msgTbl.m_deskId
	-- 玩家方位编号
	self.playerSeatIdx = roomPlayer.seatIdx
	-- 玩家显示固定座位号
	self.playerFixDispSeat = 4
	-- 逻辑座位和显示座位偏移量(从0编号开始)
	local seatOffset = (self.playerFixDispSeat - 1) - msgTbl.m_pos
	self.seatOffset = seatOffset
	-- 旋转座次标识
	self.UIRoomInfoBottom:getBtnMap().kTurnPosBG:setRotation(-seatOffset * 90)
	-- for _, turnPosSpr in ipairs(turnPosBgSpr:getChildren()) do
	-- 	turnPosSpr:setVisible(false)
	-- end
	-- 玩家出牌类型
	self.isPlayerShow = false
	self.isPlayerDecision = false

	if roomPlayer.readyState == 0 then
		-- 未准备显示准备按钮
		local args = {
			btnReady = true,
		}
		self.UIRoomInfoBottom:setBtnVisible(args)
	end
end

function m:IsSameIp()
	-- if true then
	-- 	return
	-- end
	if self.hasSameIpTip then
		self.hasSameIpTip = false

		local ips = {}

		for i=1,#self.roomPlayers do

			local playeri = self.roomPlayers[i]
			local ipSubi = string.sub(playeri.ip,1,-4)

			local sameip = {}

			table.insert(sameip,playeri.nickname)

			for j=i+1,#self.roomPlayers do
				local playerj = self.roomPlayers[j]
				local ipSubj = string.sub(playerj.ip,1,-4)

				if string.len(ipSubi) > 0 and string.len(ipSubj) > 0 and ipSubi == ipSubj then
					 table.insert(sameip,playerj.nickname)
				end
			end
			if #sameip >= 2 then
				table.insert(ips,sameip)
				if #sameip >= 3 then
					break
				end
			end
		end


		local nickGroup = ""
		for _, v in pairs(ips) do
			for i,v2 in ipairs(v) do
				if string.len(nickGroup) == 0 then
					nickGroup =  v2
				else
					nickGroup = nickGroup .. ","..v2
				end
			end
			nickGroup  = nickGroup .. " 的 IP 相同"
		end

		if string.len(nickGroup) > 0 then
			local delayTime = cc.DelayTime:create(0.1)
			local callFunc = cc.CallFunc:create(function(sender)
				UINoticeTips:create(nickGroup)
			end)
			local seqAction = cc.Sequence:create(delayTime, callFunc)
			self:runAction(seqAction)

		end
	end
end

-- start --
--------------------------------
-- @class function
-- @description 玩家进入准备状态
-- @param seatIdx 座次
-- end --
function m:playerGetReady(seatIdx)
	local roomPlayer = self.roomPlayers[seatIdx]
	log("m:playerGetReady seatIdx = ",seatIdx, " roomPlayer.score = ",roomPlayer.score)
	if roomPlayer.score ~= nil then
		self.UIHeadLayout:setTxt(roomPlayer.displaySeatIdx,{score = roomPlayer.score})
	end
	local args = {
		btnInviteFriend = false,
	}
	self.UIRoomInfoBottom:setBtnVisible(args)

	-- 显示玩家准备手势
	self.UIHeadLayout:setFlagVisible(roomPlayer.displaySeatIdx,{isReady = true})

	-- 玩家本身
	if seatIdx == self.playerSeatIdx then
		self:clearGameData()
		-- 隐藏准备按钮
		local args = {
			btnReady = false,
		}
		self.UIRoomInfoBottom:setBtnVisible(args)

		-- 隐藏牌局状态
		self.UIRoomInfoBottom:setBtnVisible({kNodeRound = false})
		-- 刷新分数
		self:updatePlayerInfo()
	end
end

-- start --
--------------------------------
-- @class function
-- @description 隐藏所有玩家准备手势标识
-- end --
function m:hidePlayersReadySign()
	for i = 1, 4 do
		self.UIHeadLayout:setFlagVisible(i,{isReady = false})
	end
end

-- start --
--------------------------------
-- @class function
-- @description 设置座位编号标识
-- @param seatIdx 座位编号
-- end --
function m:setTurnSeatSign(seatIdx)
	-- 显示轮到的玩家座位标识（标识亮起）
	-- 显示当先座位标识
	if self.gParam.roomPeopleNum ==3 then
		if self.seatOffset == 1 and seatIdx == 1 then
			seatIdx = 4
		elseif self.seatOffset == 2 and seatIdx == 1 then
			seatIdx = 1
		elseif self.seatOffset == 3 and seatIdx == 3 then
			seatIdx = 4
		else
		end
	end
	if self.gParam.roomPeopleNum == 2 then
		if self.seatOffset == 3 and seatIdx == 2 then
			seatIdx = 3
		elseif self.seatOffset == 2 and seatIdx == 1 then
			seatIdx = 4
		end
	end

	local turnPosBG = self.UIRoomInfoBottom:getBtnMap().kTurnPosBG
	local turnPosSpr = gComm.UIUtils.seekNodeByName(turnPosBG, "spriteTurnPos" .. seatIdx)

	turnPosSpr:setVisible(true)
	turnPosSpr:stopAllActions()
	turnPosSpr:runAction( cc.RepeatForever:create( cc.Blink:create(1.5,1) ))

	if self.preTurnSeatIdx and self.preTurnSeatIdx ~= seatIdx then
		-- 隐藏上次座位标识
		local turnPosSpr = gComm.UIUtils.seekNodeByName(turnPosBG, "spriteTurnPos" .. self.preTurnSeatIdx)
		turnPosSpr:stopAllActions()
		turnPosSpr:setVisible(false)
	end

	self.preTurnSeatIdx = seatIdx
end

-- start --
--------------------------------
-- @class function
-- @description 出牌倒计时
-- @param
-- @param
-- @param
-- @return
-- end --
function m:playTimeCDStart(timeDuration)
	self.playTimeCD = timeDuration

	self.isVibrateAlarm = false
	self.UIRoomInfoBottom:setTxt({countDown = timeDuration})
end

-- start --
--------------------------------
-- @class function
-- @description 更新出牌倒计时
-- @param delta 定时器周期
-- end --
function m:playTimeCDUpdate(delta)
	if not self.playTimeCD then
		return
	end

	self.playTimeCD = self.playTimeCD - delta
	if self.playTimeCD < 0 then
		self.playTimeCD = 0
	end
	log("===playTimeCD==",self.playTimeCD,self.isVibrateAlarm,self.isPlayerShow,self.isPlayerDecision)
	if (self.isPlayerShow or self.isPlayerDecision) and self.playTimeCD <= 3 and not self.isVibrateAlarm then
		-- 剩余3s开始播放警报声音+震动一下手机
		self.isVibrateAlarm = true

		local defaultVibrate = cc.UserDefault:getInstance():getIntegerForKey("settingVibrate", 1)
		if defaultVibrate == 1 then

			-- 播放声音
			self.playCDAudioID = gComm.SoundEngine:playEffect("common/timeup_alarm")

			-- 震动提醒
			cc.Device:vibrate(1)
		end
	end
	local timeCD = math.ceil(self.playTimeCD)
	self.UIRoomInfoBottom:setTxt({countDown = timeCD})
end


-- start --
--------------------------------
-- @class function
-- @description 给玩家发牌-- @param mjColor
-- @param mjNumber
-- end --
function m:addMjTileToPlayer(mjColor, mjNumber)
	local mjTileSpr = SpriteTileStand:create(mjColor, mjNumber)
	self.playMjLayer:addChild(mjTileSpr)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTile = {}
	mjTile.mjTileSpr = mjTileSpr
	mjTile.mjColor = mjColor
	mjTile.mjNumber = mjNumber
	table.insert(roomPlayer.holdMjTiles, mjTile)

	return mjTile
end

function m:clearGameData()

	self:removeallscene()

	self.preClickMjTile = nil
	self.chooseMjTile = nil

	self.isPlayerShow = false
	self.isPlayerDecision = false
	self.showReport = false

	self.tingHuCards = nil

	self.isShowTingTip = false
	self.isHu = false
end

-- 断线重连,走一次登录流程
function m:reLogin()
	self:clearGameData()

	local accessToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Access_Token" )
	local refreshToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Refresh_Token" )
	local openid 		= cc.UserDefault:getInstance():getStringForKey( "WX_OpenId" )

	local unionid 		= cc.UserDefault:getInstance():getStringForKey( "WX_Uuid" )
	local sex 			= cc.UserDefault:getInstance():getStringForKey( "WX_Sex" )
	local nickname 		= gt.nickname
	local headimgurl 	= cc.UserDefault:getInstance():getStringForKey( "WX_ImageUrl" )

	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN
	msgToSend.m_plate = "wechat"

	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview or
		 		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		msgToSend.m_plate = "local"
	end

	msgToSend.m_accessToken = accessToken
	msgToSend.m_refreshToken = refreshToken
	msgToSend.m_openId = openid
	msgToSend.m_severID = 13001
	msgToSend.m_uuid = unionid
	msgToSend.m_sex = tonumber(sex)
	msgToSend.m_nikename = nickname
	msgToSend.m_imageUrl = headimgurl

	local catStr = string.format("%s%s%s%s", openid, accessToken, refreshToken, unionid)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))

	self.loginMsg = msgToSend
	--gt.socketClient:sendMessage(msgToSend)
end

function m:onRcvLogin(msgTbl)
	dump(msgTbl,"=====AnQing_onRcvLogin=====")
	if msgTbl.m_errorCode == 5 then
		-- 去掉转圈
		gComm.UIUtils.removeLoadingTips()
		-- UINoticeTips:create(您尚未在"..msgTbl.m_errorMsg.."退出游戏，请先退出后再登陆此游戏！")
		return
	end

	-- 发送登录gate消息
	gt.socketClient:close()

	gt.socketClient:connect(msgTbl.m_gateIp, msgTbl.m_gatePort)
	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN_SERVER
	msgToSend.m_seed = msgTbl.m_seed
	msgToSend.m_id = msgTbl.m_id
	local catStr = tostring(msgTbl.m_seed)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))
	--gt.socketClient:sendMessage(msgToSend)

	self.gateMsg = msgToSend
end

function m:onRcvLoginSerVer(msgTbl)
	-- 去掉转圈
	gComm.UIUtils.removeLoadingTips()

	if msgTbl.m_state == 0 then
		-- 事件回调
		gt.socketClient:unRegisterMsgListenerByTarget(self)
		gComm.EventBus.unRegAllEvent(self)
		-- 消息回调
		--self:unregisterAllMsgListener()

		-- 进入大厅主场景
		-- 判断是否是新玩家
		local isNewPlayer = msgTbl.m_new == 0 and true or false
		local args = {isNewPlayer = isNewPlayer}
		require("app.Game.Scene.SceneManager").goSceneLobby(args)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 玩家麻将牌根据花色，编号重新排序
-- end --
function m:sortPlayerMjTiles( isbegan, isSortByMj )
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	-- 按照花色分类
	table.sort(roomPlayer.holdMjTiles, function(a, b)
		if a.mjColor ~= b.mjColor then
			return a.mjColor < b.mjColor
		else
			return a.mjNumber < b.mjNumber
		end
	end)

	-- 重新放置位置
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.holdStart
	for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
		if mjTile.mjTileSpr then
			mjTile.mjTileSpr:stopAllActions()
			mjTile.mjTileSpr:setPosition(mjTilePos)
			self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))
			mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
		end
	end

	if isbegan and roomPlayer.holdMjTiles and #roomPlayer.holdMjTiles > 0 then
		local mjSpr = roomPlayer.holdMjTiles[#roomPlayer.holdMjTiles].mjTileSpr
		if mjSpr then
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			local mjTilePos = mjTilesReferPos.holdStart
			mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, #roomPlayer.holdMjTiles - 1))
			mjTilePos = cc.pAdd(mjTilePos, cc.p(36, 0))
			mjSpr:setPosition(mjTilePos)
		end
	end
end

-- start --
--------------------------------
-- @class function
-- @description 选中玩家麻将牌
-- @return 选中的麻将牌
-- end --
function m:touchPlayerMjTiles(touch)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	if not roomPlayer then
		return nil
	end
	for idx, mjTile in ipairs(roomPlayer.holdMjTiles) do
		if tolua.isnull(mjTile.mjTileSpr) then
			return nil
		end
		local touchPoint = mjTile.mjTileSpr:convertTouchToNodeSpace(touch)
		local mjTileSize = mjTile.mjTileSpr:getContentSize()
		local mjTileRect = cc.rect(0, 0, mjTileSize.width, mjTileSize.height)
		if cc.rectContainsPoint(mjTileRect, touchPoint) and mjTile.mjIsTouch ~= true then
			if self._lastMJTileSelected ~= mjTile then
				self._lastMJTileSelected = mjTile
				gComm.SoundEngine:playEffect("common/audio_card_click")
			end
			return mjTile, idx
		end
	end
	return nil
end

-- start --
--------------------------------
-- @class function
-- @description 显示已出牌
-- @param seatIdx 座位号
-- @param mjColor 麻将花色
-- @param mjNumber 麻将编号
-- end --
function m:addAlreadyOutMjTiles(seatIdx, mjColor, mjNumber, isHide)
	-- 添加到已出牌列表
	local roomPlayer = self.roomPlayers[seatIdx]
	if not roomPlayer then
		log("==m:addAlreadyOutMjTiles=no roomPlayer==" .. seatIdx)
		return
	end
	local mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber)

	local mjTile = {}
	mjTile.mjTileSpr = mjTileSpr
	mjTile.mjColor = mjColor
	mjTile.mjNumber = mjNumber
	if self.mModleMJAnQin:IsHuaCard(mjColor, mjNumber) then
		table.insert(roomPlayer.outMjTilesHua, mjTile)
	else
		table.insert(roomPlayer.outMjTiles, mjTile)
	end

	-- 玩家已出牌缩小
	if self.playerSeatIdx == seatIdx then
		mjTileSpr:setScale(n.outTileScale)
	end

	if isHide then
		mjTileSpr:setVisible( false )
	end

	-- 显示已出牌
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.outStart
	local lineTotlaCount = 10
	if self.gParam.roomPeopleNum == 2 then
		lineTotlaCount = 16
	end

	local lineCount = math.ceil(#roomPlayer.outMjTiles / lineTotlaCount) - 1
	local lineIdx = #roomPlayer.outMjTiles - lineCount * lineTotlaCount - 1

	if self.mModleMJAnQin:IsHuaCard(mjColor, mjNumber) then
		lineCount = 1
		lineIdx = #roomPlayer.outMjTilesHua
		mjTilePos = mjTilesReferPos.outStartHua
	end

	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, lineCount))
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))
	mjTileSpr:setPosition(mjTilePos)
	self.playMjLayer:addChild(mjTileSpr, (display.size.height - mjTilePos.y))
end

function m:addAlreadyOutMjTilesHua(seatIdx, mjColor, mjNumber)
	-- 添加到已出牌列表
	local roomPlayer = self.roomPlayers[seatIdx]
	if not roomPlayer then
		log("==m:addAlreadyOutMjTilesHua=no roomPlayer==" .. seatIdx)
		return
	end
	local mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber)
	local mjTile = {}
	mjTile.mjTileSpr = mjTileSpr
	mjTile.mjColor = mjColor
	mjTile.mjNumber = mjNumber
	table.insert(roomPlayer.outMjTilesHua, mjTile)

	-- 玩家已出牌缩小
	if self.playerSeatIdx == seatIdx then
		mjTileSpr:setScale(n.outTileScale)
	end

	-- 显示已出牌
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.outStartHua

	local lineIdx = #roomPlayer.outMjTilesHua
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, 1))
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))

	mjTileSpr:setPosition(mjTilePos)
	self.playMjLayer:addChild(mjTileSpr, (display.size.height - mjTilePos.y))
end

-- start --
--------------------------------
-- @class function
-- @description 移除上家被下家，杠打出的牌
-- end --
function m:removePreRoomPlayerOutMjTile()
	-- 移除上家打出的牌
	log("removePreRoomPlayerOutMjTile===" .. (self.preShowSeatIdx or "nil"))
	if self.preShowSeatIdx then
		local roomPlayer = self.roomPlayers[self.preShowSeatIdx]
		local endIdx = #roomPlayer.outMjTiles
		local outMjTile = roomPlayer.outMjTiles[endIdx]

		if outMjTile and outMjTile.mjTileSpr then
			outMjTile.mjTileSpr:removeFromParent()
			table.remove(roomPlayer.outMjTiles, endIdx)
		end

		-- 隐藏出牌标识箭头
		self.outMjtileSignNode:setVisible(false)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 显示指示出牌标识箭头动画
-- @param seatIdx 座次
-- end --
function m:showOutMjtileSign(seatIdx,isHua)
	local roomPlayer = self.roomPlayers[seatIdx]
	local endIdx = #roomPlayer.outMjTiles
	local outMjTile = roomPlayer.outMjTiles[endIdx]
	self.outMjtileSignNode:setVisible(true)
	if isHua == true then
		endIdx = #roomPlayer.outMjTilesHua
		outMjTile = roomPlayer.outMjTilesHua[endIdx]
	end
	if outMjTile.mjTileSpr then
		self.outMjtileSignNode:setPosition(outMjTile.mjTileSpr:convertToWorldSpace(outMjTile.mjTileSpr:getAnchorPointInPoints()))
	end
end

function m:showOutMjtileSignHua(seatIdx)
	local roomPlayer = self.roomPlayers[seatIdx]
	local endIdx = #roomPlayer.outMjTilesHua
	local outMjTile = roomPlayer.outMjTilesHua[endIdx]
	self.outMjtileSignNode:setVisible(true)
	if outMjTile.mjTileSpr then
		self.outMjtileSignNode:setPosition(outMjTile.mjTileSpr:convertToWorldSpace(outMjTile.mjTileSpr:getAnchorPointInPoints()))
	end
end

-- start --
--------------------------------
-- @class function
-- @description 隐藏碰，杠牌
-- @param seatIdx 座次
-- @param isBar 杠
-- @param isBrightBar 明杠
-- @param mjCount 张数
-- end --
function m:hideOtherPlayerMjTiles(seatIdx, isBar, isBrightBar,mjCount)
	if seatIdx == self.playerSeatIdx then
		return
	end

	-- 持有牌隐藏已经碰杠牌
	-- 碰2张
	local mjTilesCount = 2
	if isBar then
		-- 明杠3张
		mjTilesCount = 3
		-- 暗杠4张
		if not isBrightBar then
			mjTilesCount = 4
		end
	end
	-- 有张数  传入数值决定
	if mjCount then
		mjTilesCount = mjCount
	end

	local roomPlayer = self.roomPlayers[seatIdx]
	local idx = roomPlayer.mjTilesRemainCount - mjTilesCount + 1
	for i = 1, mjTilesCount do
		local mjTile = roomPlayer.holdMjTiles[idx]
		if mjTile.mjTileSpr then
			mjTile.mjTileSpr:setVisible(false)
		end
		idx = idx + 1
	end
	roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount - mjTilesCount
	self:sortPlayerMjTiles()
end

function m:addMjTilePung(seatIdx, mjColor, mjNumber)
	local roomPlayer = self.roomPlayers[seatIdx]
	local pungData = {}
	pungData.mjColor = mjColor
	pungData.mjNumber = mjNumber
	table.insert(roomPlayer.mjTilePungs, pungData)

	pungData.groupNode = self:pungBarReorderMjTiles(seatIdx, mjColor, mjNumber)
end

function m:addMjTilePungEx(seatIdx, mjColor, mjNumber,pengServerPos)
	local roomPlayer = self.roomPlayers[seatIdx]
	local pungData = {}
	pungData.mjColor = mjColor
	pungData.mjNumber = mjNumber
	table.insert(roomPlayer.mjTilePungs, pungData)

	local op = gRoomData:getOprateCodeName(seatIdx-1,pengServerPos)
	pungData.groupNode = self:pungBarReorderMjTilesEx(seatIdx, mjColor, mjNumber,nil,nil,op)
end

-- start --
--------------------------------
-- @class function
-- @description 杠牌
-- @param seatIdx 座位编号
-- @param mjColor 麻将牌花色
-- @param mjNumber 麻将牌编号
-- @param isBrightBar 明杠或者暗杠
-- end --
function m:addMjTileBar(seatIdx, mjColor, mjNumber, isBrightBar)
	local roomPlayer = self.roomPlayers[seatIdx]

	-- 加入到列表中
	local barData = {}
	barData.mjColor = mjColor
	barData.mjNumber = mjNumber
	local barType = 1
	if isBrightBar then
		-- 明杠
		table.insert(roomPlayer.mjTileBrightBars, barData)
		barType = 1
	else
		-- 暗杠
		table.insert(roomPlayer.mjTileDarkBars, barData)
		barType = 2
	end
	barData.groupNode = self:pungBarReorderMjTiles(seatIdx, mjColor, mjNumber, true, barType)
end

function m:addMjTileBarEx(seatIdx, mjColor, mjNumber, isBrightBar,sPos)
	local roomPlayer = self.roomPlayers[seatIdx]

	-- 加入到列表中
	local barData = {}
	barData.mjColor = mjColor
	barData.mjNumber = mjNumber
	local barType = 1
	local op = gRoomData.opCodeEnum.SelfOp
	if isBrightBar then
		op = gRoomData:getOprateCodeName(seatIdx-1,sPos)
		-- 明杠
		table.insert(roomPlayer.mjTileBrightBars, barData)
		barType = 1
	else
		-- 暗杠
		table.insert(roomPlayer.mjTileDarkBars, barData)
		barType = 2
	end
	log("--addMjTileBarEx--",op)
	barData.groupNode = self:pungBarReorderMjTilesEx(seatIdx, mjColor, mjNumber, true, barType,op)
end

-- start --
--------------------------------
-- @class function
-- @description 碰杠重新排序麻将牌,显示碰杠
-- @param seatIdx
-- @param mjColor
-- @param mjNumber
-- @param isBar
-- @param isBrightBar -- 1-明杠,2-暗杠，3-特殊杠
-- @return
-- end --
function m:pungBarReorderMjTiles(seatIdx, mjColor, mjNumber, isBar, isBrightBar)
	local roomPlayer = self.roomPlayers[seatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	-- 显示碰杠牌
	local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos  --杠的位置点

	local groupNode = cc.Node:create()
	groupNode:setPosition(mjTilesReferPos.groupStartPos)
	self.playMjLayer:addChild(groupNode)
	local mjTilesCount = 3
	if isBar then
		mjTilesCount = 4
	end

	for i = 1, mjTilesCount do
		local mjTileName = nil
		local mjTileSpr = nil
		if isBar and isBrightBar == 2 and i <= 3 then
			-- 暗杠前三张牌扣着
			mjTileName = DefineTile.getTileBGGang(roomPlayer.displaySeatIdx)
			mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
		else
			--如果不是吃
			if type(mjNumber) == "number"  then
				if isBar and isBrightBar == 2 and self.IsAnGangShow == false then
					mjTileName = DefineTile.getTileBGGang(roomPlayer.displaySeatIdx)
					mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
				else
					mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber)
				end
			else
				mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber[i][1])
			end
		end

		if mjTileSpr then
			if roomPlayer.displaySeatIdx == 4 then
				mjTileSpr:setScale(n.outTileItemScale)
			end
			mjTileSpr:setPosition(groupMjTilesPos[i])
			groupNode:addChild(mjTileSpr,0,i)
		end

	end
	local pos = cc.p(mjTilesReferPos.groupSpace.x,mjTilesReferPos.groupSpace.y)
	mjTilesReferPos.groupStartPos = cc.pAdd(mjTilesReferPos.groupStartPos, pos)
	mjTilesReferPos.holdStart = cc.pAdd(mjTilesReferPos.holdStart, pos)

	mjTilesReferPos.showHandStart = mjTilesReferPos.groupStartPos

	-- 更新持有牌显示位置
	if seatIdx == self.playerSeatIdx then
		-- 玩家自己
		-- 碰2张
		local mjTilesCount = 2
		if isBar then
			-- 明杠3张
			mjTilesCount = 3
			-- 暗杠4张
			if isBrightBar ==2 then
				mjTilesCount = 4
			end
		end
		if type(mjNumber) == "number" then
			if not self.pung then
				local filterMjTilesCount = 0
				local transMjTiles = {}
				for i, mjTile in ipairs(roomPlayer.holdMjTiles) do
					if filterMjTilesCount < mjTilesCount
						and mjTile.mjColor == mjColor
						and mjTile.mjNumber == mjNumber
						and mjTile.mjTileSpr then
						mjTile.mjTileSpr:removeFromParent()
						filterMjTilesCount = filterMjTilesCount + 1
					else
						-- 保存其它牌,去除碰杠牌
						table.insert(transMjTiles, mjTile)
					end
				end
				roomPlayer.holdMjTiles = transMjTiles
			end
		else
			local removeTable = {}
			for j = 1, 3 do
				if tonumber(mjNumber[j][2]) ~= tonumber(1) then
					table.insert(removeTable, {mjNumber[j][1], mjNumber[j][3]})
				end
			end
			if #removeTable > 0 then
				for k, v in ipairs(removeTable) do
					for i=#roomPlayer.holdMjTiles, 1,-1 do
						local mjTile = roomPlayer.holdMjTiles[i]
						if mjTile.mjNumber == v[1]
							and  mjTile.mjColor == v[2]
							and mjTile.mjTileSpr then
							mjTile.mjTileSpr:removeFromParent()
							table.remove(roomPlayer.holdMjTiles, i)
							break
						end
					end
				end
			end
		end
		-- 重新排序现持有牌
		self:sortPlayerMjTiles()
	else
		local mjTilesReferPos = roomPlayer.mjTilesReferPos
		local mjTilePos = mjTilesReferPos.holdStart
		for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
			if mjTile.mjTileSpr then
				mjTile.mjTileSpr:setPosition(mjTilePos)
				self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))

				mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
			end

		end
	end

	return groupNode
end

-- gRoomData
-- m.opCodeEnum = {
-- 	LeftOp     = 1,
-- 	RightOp    = 2,
-- 	SelfOp     = 3,
-- 	OppositeOp = 4,
-- }
--opCode,1左操作，2自操作，3右操作，4对门操作
function m:pungBarReorderMjTilesEx(seatIdx, mjColor, mjNumber, isBar, isBrightBar,opCode)
	log("pungBarReorderMjTilesEx",seatIdx, mjColor, mjNumber, isBar, isBrightBar,opCode)
	local roomPlayer = self.roomPlayers[seatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	-- 显示碰杠牌
	local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos  --杠的位置点

	local groupNode = cc.Node:create()
	groupNode:setPosition(mjTilesReferPos.groupStartPos)
	self.playMjLayer:addChild(groupNode)
	local mjTilesCount = 3
	if isBar then
		mjTilesCount = 4
	end

	for i = 1, mjTilesCount do
		local mjTileName = nil
		local mjTileSpr = nil
		if isBar and isBrightBar == 2 and i <= 3 then
			-- 暗杠前三张牌扣着
			mjTileName = DefineTile.getTileBGGang(roomPlayer.displaySeatIdx)
			mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
		else
			--如果不是吃
			if type(mjNumber) == "number"  then
				if isBar and isBrightBar == 2 and self.IsAnGangShow == false then
					mjTileName = DefineTile.getTileBGGang(roomPlayer.displaySeatIdx)
					mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
				else
					mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber)
					if opCode == gRoomData.opCodeEnum.LeftOp and i == 1 then
						mjTileSpr:setColorRed()
					elseif opCode == gRoomData.opCodeEnum.RightOp and i == 3 then
						mjTileSpr:setColorRed()
					elseif opCode == gRoomData.opCodeEnum.OppositeOp then
						if mjTilesCount == 4 and i == 4 then
							mjTileSpr:setColorRed()
						elseif mjTilesCount == 3 and i == 2 then
							mjTileSpr:setColorRed()
						end
					end
				end
			else
				mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber[i][1])
			end
		end

		if mjTileSpr then
			if roomPlayer.displaySeatIdx == 4 then
				mjTileSpr:setScale(n.outTileItemScale)
			end
			mjTileSpr:setPosition(groupMjTilesPos[i])
			groupNode:addChild(mjTileSpr,0,i)
		end

	end
	local pos = cc.p(mjTilesReferPos.groupSpace.x,mjTilesReferPos.groupSpace.y)
	mjTilesReferPos.groupStartPos = cc.pAdd(mjTilesReferPos.groupStartPos, pos)
	mjTilesReferPos.holdStart = cc.pAdd(mjTilesReferPos.holdStart, pos)

	mjTilesReferPos.showHandStart = mjTilesReferPos.groupStartPos

	-- 更新持有牌显示位置
	if seatIdx == self.playerSeatIdx then
		-- 玩家自己
		-- 碰2张
		local mjTilesCount = 2
		if isBar then
			-- 明杠3张
			mjTilesCount = 3
			-- 暗杠4张
			if isBrightBar ==2 then
				mjTilesCount = 4
			end
		end
		if type(mjNumber) == "number" then
			if not self.pung then
				local filterMjTilesCount = 0
				local transMjTiles = {}
				for i, mjTile in ipairs(roomPlayer.holdMjTiles) do
					if filterMjTilesCount < mjTilesCount
						and mjTile.mjColor == mjColor
						and mjTile.mjNumber == mjNumber
						and mjTile.mjTileSpr then
						mjTile.mjTileSpr:removeFromParent()
						filterMjTilesCount = filterMjTilesCount + 1
					else
						-- 保存其它牌,去除碰杠牌
						table.insert(transMjTiles, mjTile)
					end
				end
				roomPlayer.holdMjTiles = transMjTiles
			end
		else
			local removeTable = {}
			for j = 1, 3 do
				if tonumber(mjNumber[j][2]) ~= tonumber(1) then
					table.insert(removeTable, {mjNumber[j][1], mjNumber[j][3]})
				end
			end
			if #removeTable > 0 then
				for k, v in ipairs(removeTable) do
					for i=#roomPlayer.holdMjTiles, 1,-1 do
						local mjTile = roomPlayer.holdMjTiles[i]
						if mjTile.mjNumber == v[1]
							and  mjTile.mjColor == v[2]
							and mjTile.mjTileSpr then
							mjTile.mjTileSpr:removeFromParent()
							table.remove(roomPlayer.holdMjTiles, i)
							break
						end
					end
				end
			end
		end
		-- 重新排序现持有牌
		self:sortPlayerMjTiles()
	else
		local mjTilesReferPos = roomPlayer.mjTilesReferPos
		local mjTilePos = mjTilesReferPos.holdStart
		for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
			if mjTile.mjTileSpr then
				mjTile.mjTileSpr:setPosition(mjTilePos)
				self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))

				mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
			end

		end
	end

	return groupNode
end

-- start --
--------------------------------
-- @class function
-- @description 自摸碰变成明杠
-- @param seatIdx
-- @param mjColor
-- @param mjNumber
-- end --
function m:changePungToBrightBar(seatIdx, mjColor, mjNumber)
	local roomPlayer = self.roomPlayers[seatIdx]
	if seatIdx == self.playerSeatIdx then
		for i, mjTile in ipairs(roomPlayer.holdMjTiles) do
			if mjTile.mjColor == mjColor and mjTile.mjNumber == mjNumber and mjTile.mjTileSpr then
				mjTile.mjTileSpr:removeFromParent()
				table.remove(roomPlayer.holdMjTiles, i)
				break
			end
		end
	elseif roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr then
		roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr:setVisible(false)
		roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount - 1
	end

	-- 查找碰牌
	local brightBarData = nil
	for i, pungData in ipairs(roomPlayer.mjTilePungs) do
		if pungData.mjColor == mjColor and pungData.mjNumber == mjNumber then
			-- 从碰牌列表中删除
			brightBarData = pungData
			table.remove(roomPlayer.mjTilePungs, i)
			break
		end
	end

	self:sortPlayerMjTiles()
	-- 添加到明杠列表
	if brightBarData then
		-- 加入杠牌第4个牌
		local mjTilesReferPos = roomPlayer.mjTilesReferPos
		local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos
		local mjTileSpr = LayerTileOut:create(roomPlayer.displaySeatIdx, mjColor, mjNumber)
		if 4 == roomPlayer.displaySeatIdx then
			mjTileSpr:setScale(n.outTileItemScale)
		end
		mjTileSpr:setPosition(groupMjTilesPos[4])
		local spr =  brightBarData.groupNode:getChildByTag(2)
		if spr.isRedState == true then
			spr:setColorNormal()
			mjTileSpr:setColorRed()
		end
		brightBarData.groupNode:addChild(mjTileSpr)
		table.insert(roomPlayer.mjTileBrightBars, brightBarData)
	end
end

function m:showOprateSprite(seatIdx)
	local img = "Image/IRoom/DecisionBtn/dec_gang.png"
	-- 显示决策标识
	local roomPlayer = self.roomPlayers[seatIdx]
	local opSprite = cc.Sprite:createWithSpriteFrameName(img)
	opSprite:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
	self.rootNode:addChild(opSprite, ConfigGameScene.ZOrder.DECISION_SHOW)
	-- 标识显示动画
	opSprite:setScale(0)
	local scaleToAction = cc.ScaleTo:create(0.5, 1)
	local easeBackAction = cc.EaseBackOut:create(scaleToAction)
	local fadeOutAction = cc.FadeOut:create(1)
	local callFunc = cc.CallFunc:create(function(sender)
		-- 播放完后移除
		sender:removeFromParent()
	end)
	local seqAction = cc.Sequence:create(easeBackAction, fadeOutAction, callFunc)
	opSprite:runAction(seqAction)

	local index = m.SoundDecisionType[m.DecisionType.BRIGHT_BAR]
	SoundMng.playEffect(index,roomPlayer.sex)
end

function m:showDecisionAnimationEX(seatIdx, decisionType, huCard)
	local csb = m.OprateAnimCsb[decisionType]
	-- self:showAnimCsb(nodePostion,csbIndex,cbFun)
	--吃碰杠补花自摸
	if csb then
		local roomPlayer = self.roomPlayers[seatIdx]
		self:showAnimCsb(roomPlayer.mjTilesReferPos.showMjTilePos,csb)
		local index = m.SoundDecisionType[decisionType]
		SoundMng.playEffect(index,roomPlayer.sex)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 显示玩家接炮胡，自摸胡，明杠，暗杠，碰动画显示
-- @param seatIdx 座位索引
-- @param decisionType 决策类型
-- end --
function m:showDecisionAnimation(seatIdx, decisionType, huCard)
	local csb = m.OprateAnimCsb[decisionType]
	if csb then
		self:showDecisionAnimationEX(seatIdx, decisionType, huCard)
		return
	end
	local decisionSuffixs = {
		"Image/IRoom/DecisionBtn/dec_hu.png", --接炮胡
		"Image/IRoom/DecisionBtn/dec_zimo.png", --自摸胡
		"Image/IRoom/DecisionBtn/dec_gang.png", --明杠
		"Image/IRoom/DecisionBtn/dec_gang.png", --暗杠
		"Image/IRoom/DecisionBtn/dec_peng.png",
		"Image/IRoom/DecisionBtn/dec_chi.png",
		"Image/IRoom/DecisionBtn/dec_gang.png", --特殊杠
		"Image/IRoom/DecisionBtn/dec_ting.png", --听
		--1, 4, 2, 2, 3, 5
	}
	-- 1  接炮胡
	-- 2  杠
	-- 3  碰
	-- 4  自摸胡
	-- 5  吃
	if huCard ~= nil then
		-- 显示决策标识
		local roomPlayer = self.roomPlayers[seatIdx]

		local groupNode = cc.Node:create()
		groupNode:setCascadeOpacityEnabled( true )
		groupNode:setPosition( roomPlayer.mjTilesReferPos.showMjTilePos )
		self.rootNode:addChild( groupNode, ConfigGameScene.ZOrder.DECISION_SHOW )

		local nextX = 0
		local nextY = 0
		local totoalX = 0
		local totoalY = 0
		local xoffset = 0
		local yoffset = 0
		huCard = {2}

		for i,v in ipairs(huCard) do -- 创建要显示的图片文字
			local decisionSignSpr = cc.Sprite:createWithSpriteFrameName(decisionSuffixs[1])
			decisionSignSpr:setPosition( cc.p(nextX,nextY) )
			groupNode:addChild( decisionSignSpr )
			if roomPlayer.displaySeatIdx == 1 or roomPlayer.displaySeatIdx == 3 then -- 左右两边竖着显示
				decisionSignSpr:setAnchorPoint( 0, 1 )
				nextY = nextY + decisionSignSpr:getContentSize().height
				totoalY = totoalY + decisionSignSpr:getContentSize().height
				xoffset = decisionSignSpr:getContentSize().width / 2
			else
				-- 上线两边左右显示
				decisionSignSpr:setAnchorPoint( 0, 0 )
				nextX = nextX + decisionSignSpr:getContentSize().width
				totoalX = totoalX + decisionSignSpr:getContentSize().width
				yoffset = decisionSignSpr:getContentSize().height/2
			end
		end

		if roomPlayer.displaySeatIdx == 1 or roomPlayer.displaySeatIdx == 3 then -- 左右两边竖着显示
			groupNode:setPosition( cc.pAdd( roomPlayer.mjTilesReferPos.showMjTilePos, cc.p(-xoffset,totoalY/2) ) )
		else
			groupNode:setPosition( cc.pAdd( roomPlayer.mjTilesReferPos.showMjTilePos, cc.p(-totoalX/2,-yoffset) ) )
		end

		-- 标识显示动画
		groupNode:setScale(0)
		local scaleToAction = cc.ScaleTo:create(0.5, 1)
		local easeBackAction = cc.EaseBackOut:create(scaleToAction)
		local fadeOutAction = cc.FadeOut:create(1)
		local callFunc = cc.CallFunc:create(function(sender)
			-- 播放完后移除
			sender:removeFromParent()
		end)
		local seqAction = cc.Sequence:create(easeBackAction, fadeOutAction, callFunc)
		groupNode:runAction(seqAction)

		local index = m.SoundDecisionType[decisionType]
		SoundMng.playEffect(index,roomPlayer.sex)
	else
		-- 显示决策标识
		local roomPlayer = self.roomPlayers[seatIdx]
		local decisionSignSpr = cc.Sprite:createWithSpriteFrameName(decisionSuffixs[decisionType])
		decisionSignSpr:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
		self.rootNode:addChild(decisionSignSpr, ConfigGameScene.ZOrder.DECISION_SHOW)
		-- 标识显示动画
		decisionSignSpr:setScale(0)
		local scaleToAction = cc.ScaleTo:create(0.5, 1)
		local easeBackAction = cc.EaseBackOut:create(scaleToAction)
		local fadeOutAction = cc.FadeOut:create(1)
		local callFunc = cc.CallFunc:create(function(sender)
			-- 播放完后移除
			sender:removeFromParent()
		end)
		local seqAction = cc.Sequence:create(easeBackAction, fadeOutAction, callFunc)
		decisionSignSpr:runAction(seqAction)
		local index = m.SoundDecisionType[decisionType]
		SoundMng.playEffect(index,roomPlayer.sex)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 显示出牌动画
-- @param seatIdx 座次
-- end --
function m:showMjTileAnimation(seatIdx, startPos, mjColor, mjNumber, cbFunc)

	local mjTilePos = startPos

	local roomPlayer = self.roomPlayers[seatIdx]
	local rotateAngle = {-90, 180, 90, 0}
	local mjTileSpr = LayerTileOut:create(self.playerFixDispSeat, mjColor, mjNumber)
	self.rootNode:addChild(mjTileSpr, 98)

	self.startMjTileAnimation = mjTileSpr
	self.startMjTileColor = mjColor
	self.startMjTileNumber	= mjNumber

	local data = {
		mjTileSpr = mjTileSpr,
		mjColor = mjColor,
		mjNumber = mjNumber,
		seatIndex = seatIdx,
	}
	self.outMJAnimList[#self.outMJAnimList + 1] = data

	log(mjColor .. "==m:showMjTileAnimation(seatIdx=" .. mjNumber,"------",#self.outMJAnimList)
	mjTileSpr:setPosition(mjTilePos)

	local totalTime = 0.035
	local moveToAc_1 = cc.MoveTo:create(totalTime, roomPlayer.mjTilesReferPos.showMjTilePos)
	local rotateToAc_1 = cc.ScaleTo:create(totalTime, 1.6)

	local delayTime = cc.DelayTime:create(0.35)

	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.outStart
	local mjTilesCount = #roomPlayer.outMjTiles + 1
	local lineCount = math.ceil(mjTilesCount / 10) - 1
	local lineIdx = mjTilesCount - lineCount * 10 - 1

	if self.mModleMJAnQin:IsHuaCard(mjColor, mjNumber) then
		lineCount = 1
		lineIdx = #roomPlayer.outMjTilesHua + 1
		mjTilePos = mjTilesReferPos.outStartHua
	end

	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, lineCount))
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))

	local moveToAc_2 = cc.MoveTo:create(totalTime, mjTilePos)
	local rotateToAc_2 = cc.ScaleTo:create(totalTime, 1.0)

	local callFunc = cc.CallFunc:create(function(sender)
		sender:removeFromParent()
		log("==m:showMjTileAnimation=self.outMJAnimList=num=",#self.outMJAnimList)
		self.outMJAnimList = {}
		self.startMjTileAnimation = nil
		cbFunc()
	end)

	-- mjTileSpr:runAction(cc.Sequence:create(cc.Spawn:create(moveToAc_1, rotateToAc_1),
	-- 									delayTime,
	-- 									-- setro,
	-- 									cc.Spawn:create(moveToAc_2, rotateToAc_2),
	-- 									callFunc));
	mjTileSpr:runAction(cc.Sequence:create(moveToAc_1,
										delayTime,
										moveToAc_2,
										callFunc));
end

function m:backMainSceneEvt()
	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent(self)
    self:unRegEvent()


    local args = {
        isShowCoinMain = false,
    }
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		args.isShowCoinMain = true
	end
    require("app.Game.Scene.SceneManager").goSceneLobby(args)
end

function m:createFlimLayer(flimLayerType,cardList,cardList2)
	-- 一个麻将
	local mjTileSpr = LayerTileOut:create(self.playerFixDispSeat, 2, 2)

	local width_oneMJ = mjTileSpr:getContentSize().width
	local height_oneMJ = mjTileSpr:getContentSize().height
	local space_gang = 20
	local barNum = #cardList+#cardList2
	local col = math.min(barNum,4)
	if barNum >16 then
		col = 5
	end
	local width = 30+mjTileSpr:getContentSize().width*4*(math.min(barNum,col))+space_gang*(math.min(barNum,col)-1)
	local height = (24+mjTileSpr:getContentSize().height)*(math.ceil(barNum/col))

	local flimLayer = cc.LayerColor:create(cc.c4b(85, 85, 85, 100), width, height)
	flimLayer:setContentSize(cc.size(width,height))
	local function onTouchBegan(touch, event)
		return true
	end

	-- 添加半透明底
	local image_bg = ccui.ImageView:create()
	image_bg:loadTexture("")
	image_bg:setScale9Enabled(true)
	image_bg:setCapInsets(cc.rect(10,10,1,1))
	image_bg:setContentSize(cc.size(width,height))
	image_bg:setAnchorPoint(cc.p(0,0))
	flimLayer:addChild(image_bg)

	local tileBG = DefineTile.getBottomOpenTile(0,0)
	local barCount = 0
	local col1 = math.min(barNum,4)
	if barNum >16 then
		col1 = 5
	end
	-- 创建麻将(普通杠)
	for idx,value in ipairs(cardList) do
		local flag = value.flag
		local mjColor = value.mjColor
		local mjNumber = value.mjNumber
		barCount = barCount+1
		local mjSprName = DefineTile.getBottomOpenTile(mjColor, mjNumber)

		local c = 4
		if flag == 4 then
			c = 1
		end
		for i=1,c do
			local button = ccui.Button:create()
			button:loadTextures(tileBG,tileBG,"",ccui.TextureResType.plistType)
			button:setTouchEnabled(true)
    		button:setAnchorPoint(cc.p(0,0))
    		button:setPosition(cc.p(15+space_gang*(barCount%col1)+width_oneMJ*(i-1)+width_oneMJ*4*(barCount%col1),
    			10+(height_oneMJ+10)*math.floor((barCount-0.5)/col1)))
   			button:setTag(barCount)
   			local spr = cc.Sprite:createWithSpriteFrameName(mjSprName)
   			button:addChild(spr)
   			local size = button:getContentSize()
   			spr:setPosition(size.width*0.5,size.height*0.5)

   			flimLayer:addChild(button)

    		local function touchEvent(ref, type)
       			if type == ccui.TouchEventType.ended then
        		 	self.isPlayerDecision = false

					local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
					selfDrawnDcsNode:setVisible(false)

					-- 发送消息
					local cardData = cardList[ref:getTag()]

					local m_type = cardData.flag
					local m_think = {}

					local think_temp = {cardData.mjColor,cardData.mjNumber}
					table.insert(m_think,think_temp)

					NetMngMJAnQin.sendOutCard(m_type,m_think)

					self.isPlayerShow = false

					-- 删除弹出框（杠）
					self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
					-- 删除弹出框（补）
					self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
       		 	end
  	  		end
   	 		button:addTouchEventListener(touchEvent)
		end
	end

	-- 创建麻将（特殊杠）
	for idx,value in ipairs(cardList2) do
		local flag = value.flag
		barCount = barCount+1
		for i,v in ipairs(value.bar) do
			local mjSprName = DefineTile.getBottomOpenTile(v.mjColor, v.mjNumber)
			local button = ccui.Button:create()
			button:loadTextures(tileBG,tileBG,"",ccui.TextureResType.plistType)
			button:setTouchEnabled(true)
    		button:setAnchorPoint(cc.p(0,0))
    		button:setPosition(cc.p(15+space_gang*(barCount%col1)+width_oneMJ*(i-1)+width_oneMJ*4*(barCount%col1), 10+(height_oneMJ+10)*math.floor((barCount-0.5)/col1)))
   			button:setTag(idx)

   			local spr = cc.Sprite:createWithSpriteFrameName(mjSprName)
   			button:addChild(spr)
   			local size = button:getContentSize()
   			spr:setPosition(size.width*0.5,size.height*0.5)

   			flimLayer:addChild(button)
    		local function touchEvent(ref, type)
       			if type == ccui.TouchEventType.ended then
        		 	self.isPlayerDecision = false

					local selfDrawnDcsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_selfDrawnDecision")
					selfDrawnDcsNode:setVisible(false)

					-- 发送消息
					local cardData = cardList2[ref:getTag()]

					local m_type = cardData.flag
					local m_think = {}
					for m,n in ipairs(cardData.bar) do
						local card = {n.mjColor,n.mjNumber}
						table.insert(m_think,card)
					end
					NetMngMJAnQin.sendOutCard(m_type,m_think)

					self.isPlayerShow = false

					-- 删除弹出框（杠）
					self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BAR)
					-- 删除弹出框（补）
					self:removeFlimLayer(m.FLIMTYPE.FLIMLAYER_BU)
       		 	end
  	  		end
   	 		button:addTouchEventListener(touchEvent)
		end
	end
	return flimLayer
end

function m:removeFlimLayer(flimLayerType)
	local child = self:getChildByTag(m.TAG.FLIMLAYER_BAR)

	if flimLayerType == m.FLIMTYPE.FLIMLAYER_BAR then
		child = self:getChildByTag(m.TAG.FLIMLAYER_BAR)
	elseif flimLayerType == m.FLIMTYPE.FLIMLAYER_BU then
		child = self:getChildByTag(m.TAG.FLIMLAYER_BU)
	else

	end

	if not child then
		return
	end

	child:removeFromParent()

end

function m:updateDecies()
	if self.btn_presentList and #self.btn_presentList>0 then
		for _,v in ipairs(self.btn_presentList) do
			v[2]:setVisible(true)
		end
		self.decisionBtn_pass:setVisible(true)
	end
end

function m:stopAudio()
	--停止录音
	gComm.CallNativeMng.NativeYaya:stopVoice()

	local getUrl = function ()
		local res = gComm.CallNativeMng.NativeYaya:getVoiceUrl()

		if string.len(res) > 0 and self.checkVoiceUrlType then

			self.checkVoiceUrlType = false
			--获得到地址上传给服务器
			NetMngMJAnQin.sendChatMsg(res)

			gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
			self.voiceUrlScheduleHandler = nil
		end
	end
	self.checkVoiceUrlType = true
	if self.voiceUrlScheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
		self.voiceUrlScheduleHandler = nil
	end
	self.voiceUrlScheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(getUrl, 0.2, false)
end

function m:cancelAudio()
	gComm.CallNativeMng.NativeYaya:cancelVoice()
end

function m:onShowBeatOthers(msgTbl)
	self.UIHeadLayout:onShowBeatOthers(msgTbl)
end


function m:onRcvDeleteCard(msgTbl)
	log("m:onRcvDeleteCard")
	-- Lint m_numPos;			 //需要删除的张数
	-- Lint m_deletePos;        //删除的位置
	-- CardValue m_deleteCard;  //需要删除的牌
	local seatIdx = msgTbl.m_deletePos + 1
	local roomPlayer = self.roomPlayers[seatIdx]
	for j=1,msgTbl.m_numPos do
		if seatIdx == self.playerSeatIdx then
			for i=#roomPlayer.holdMjTiles, 1,-1 do
				local mjTile = roomPlayer.holdMjTiles[i]
				if mjTile.mjNumber == msgTbl.m_deleteCard[2]
					and  mjTile.mjColor == msgTbl.m_deleteCard[1]
					and mjTile.mjTileSpr then
					mjTile.mjTileSpr:removeFromParent()
					table.remove(roomPlayer.holdMjTiles, i)
					break
				end
			end
			self:sortPlayerMjTiles()
		elseif roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr then
			roomPlayer.holdMjTiles[roomPlayer.mjTilesRemainCount].mjTileSpr:setVisible(false)
			roomPlayer.mjTilesRemainCount = roomPlayer.mjTilesRemainCount - 1
		end
	end
end

function m:onConnect( socket )
	if socket:whichSocket() then
		if self.loginMsg then
			gt.socketClient:sendMessage(self.loginMsg)
		end
	else
		if self.gateMsg then
			gt.socketClient:sendMessage(self.gateMsg)
		end
	end
end

function m:onError( socket ,errorInfo)
	gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0001"))

	socket:close()
	self:reLogin()

	-- 重连检测结算界面，如果有移除
	if self.mUIOneRoundSettlement and (not tolua.isnull(self.mUIOneRoundSettlement)) then
		self.mUIOneRoundSettlement:removeFromParent()
		self.mUIOneRoundSettlement = nil
	end

	gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip,cc.exports.gGameConfig.LoginServer.port,true)
end
-- start --
--------------------------------
-- @class function
-- @description 检查玩家手中的牌的数量是否正确
-- end --
function m:checkPlayerMJNumsIsSure()
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	if not roomPlayer then
		return true
	end
	local num1 = #roomPlayer.holdMjTiles +3*(#roomPlayer.mjTileBrightBars + #roomPlayer.mjTileDarkBars)+3*(#roomPlayer.mjTileEat)
    local num2 = 13
    return num1 == num2
end

function m:copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
end

-- start --
--------------------------------
-- @class function
-- @description 处理决策数据（同类型决策合并）
-- end --
function m:dealMsgTblOfRcvTurnShowMjTile(msgTbl)
	local m_thinkTbl = {}
	local function checkSameType(type)
		for i,v in ipairs(m_thinkTbl) do
			if #m_thinkTbl > 0 and v[1] == type then
				return i
			end
		end
		return false
	end
	for i,v in ipairs(msgTbl.m_think) do
		local key = checkSameType(v[1])
		if key then
			if #v[2] > 0 then
				table.insert(m_thinkTbl[key],v[2])
			end
			if #v[3] > 0 then
				table.insert(m_thinkTbl[key],v[3])
			end
		else
			table.insert(m_thinkTbl,v)
		end
	end
	msgTbl.m_think = m_thinkTbl
	return msgTbl
end

-- start --
--------------------------------
-- @class function
-- @description 创建听牌胡牌层
-- end --
function m:createTingTipLayer(_mjColor,_mjNumber)
	dump(self.tingHuCards,"===self.tingHuCards===")
	if not self.tingHuCards then
		return false
	end
	local cardsList = nil
	for i,v in ipairs(self.tingHuCards) do
		if i%2 == 0 then
			if v[1][1] == _mjColor and v[1][2] == _mjNumber then
			   	cardsList = self.tingHuCards[i+1]
				break
			end
		end
	end
	if (not cardsList) or #cardsList == 0 then --没有胡牌数据
		return false
	end
	return self:createMJTip(cardsList)
end

function m:createMJTip(cardsList)
	dump(cardsList,"===createMJTip===")
	-- 一个麻将
	local scale = 0.6
	local mjTileSpr = SpriteTileOpen:create(2, 2,scale)

	local width_oneMJ = mjTileSpr:getContentSize().width * scale
	local height_oneMJ = mjTileSpr:getContentSize().height * scale
	local space_gang = 40
	local barNum = (#cardsList)/2
	local col = math.min(barNum,7)

	local width = 60+width_oneMJ*(math.min(barNum,col))+space_gang*(math.min(barNum,col)-1)
	local height = (24+height_oneMJ)*(math.ceil(barNum/col))

	-- local flimLayer = cc.LayerColor:create(cc.c4b(85, 85, 85, 100), width, height)
	-- flimLayer:setContentSize(cc.size(width,height))
	-- flimLayer:setTouchEnabled(false)
    local flimLayer = ccui.ImageView:create()
    flimLayer:loadTexture("Image/IRoom/CommomRoom/game_bg_ting_tip.png",ccui.TextureResType.plistType)
    flimLayer:setScale9Enabled(true)
    flimLayer:setContentSize(cc.size(width,height))
    flimLayer:setAnchorPoint(cc.p(0.5,0.5))

	local barCount = 0
	-- 创建胡牌
	self.gParam.tingMJList = {}
	for idx,value in ipairs(cardsList) do
		local row = 1
		if idx > 14 then
			--上面一行，最多2行，从下面一行开始
			row = 2
		end
		if idx%2 == 1 then
			barCount = barCount + 1
			local mjTileSpr = SpriteTileOpen:create(value[1], value[2],scale)
			table.insert(self.gParam.tingMJList,{value[1], value[2]})

			mjTileSpr:setPosition(cc.p(15+space_gang*(barCount%col)+width_oneMJ*(barCount%col) + width_oneMJ*0.5,
    			10 + height_oneMJ * 0.5 + (height_oneMJ+10)*(row -1)))
			flimLayer:addChild(mjTileSpr)

		else
			local cardCountLabel = gComm.LabelUtils.createTTFLabel(value[2] .. "张", 18)
			cardCountLabel:setTextColor(display.COLOR_GREEN)
			cardCountLabel:setAnchorPoint(cc.p(0,0))
			cardCountLabel:setPosition(cc.p(20+width_oneMJ+space_gang*(barCount%col)+width_oneMJ*(barCount%col),
    			10+(height_oneMJ+10)*(row -1)))
			flimLayer:addChild(cardCountLabel)
		end
	end
	return flimLayer
end

function m:ShowTingTipLayer(cardsList)
	dump(cardsList,"-----ShowTingTipLayer--===--")
	if cardsList and #cardsList == 0 then
		log("----ShowTingTipLayer====-#cardsList = 0")
		return
	end

	self.tingCardList = cardsList
	self.gParam.tingMJList = {}
	for idx,value in ipairs(cardsList) do
		if idx%2 == 1 then
			table.insert(self.gParam.tingMJList,{value[1], value[2]})
		end
	end
	self:setTinBtnVisible(true)
end

function m:setTinBtnVisible(isShow)
	if not isShow then
		self.mModleMJAnQin.gameState.flagReqedTingInfo = false
	end
	if isShow and #self.gParam.tingMJList == 0 then
		NetMngMJAnQin.requestTingInfo()
	else
		self.UIRoomInfoUpper:showMJTing(isShow,self.gParam.tingMJList)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 移除听牌胡牌层
-- end --
function m:removeTingTipLayer(flimLayerType)
	local child = self:getChildByTag(m.TAG.FLIMLAYER_TING)
	if not child then
		child = self.playMjLayer:getChildByTag(m.TAG.FLIMLAYER_TING)
		if child then
			child:removeFromParent()
		end
		return
	end
	child:removeFromParent()
end

-- start --
--------------------------------
-- @class function
-- @description 下一局
-- end --
function m:nextOneGame()
	self:removeallscene()
	self:updatePlayerInfo()
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		-- NetCoinGameMng.joinCoinGameNext()
	else
		local m_pos = self.playerSeatIdx - 1
		NetMngMJAnQin.sendReady(m_pos)
	end
end


function m:onRcvTuoGuan(msgTbl)
	dump(msgTbl,"m:onRcvTuoGuan" .. self.gParam.sPosSelf)

	if self.gParam.sPosSelf == msgTbl.m_pos then
-- //1.进入托管  2.取消托管
		local flag = (msgTbl.m_type == 2)
		self.UIRoomInfoUpper:setTuoGuanBtnShow(flag)
		self.gParam.isTuoGuan = (msgTbl.m_type == 1)
	else
		local flag = (msgTbl.m_type == 1)
		self.UIHeadLayout:setTuoGuanFlag(msgTbl.m_pos,flag)
	end
end

function m:onRcvActiveCode(msgTbl)
	dump(msgTbl,"m:onRcvActiveCode")
	if (not msgTbl.m_ActiveCode) or msgTbl.m_ActiveCode == "" then
		local delayTime = cc.DelayTime:create(1.5)
		local callFunc = cc.CallFunc:create(function(sender)
        	gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
		end)
		local seqAction = cc.Sequence:create(delayTime, callFunc)
		self:runAction(seqAction)
	else
		local param = {
	        activityCode = msgTbl.m_ActiveCode,
	        nickName = msgTbl.m_nike,
	        isPoker  = false,
		}
		local layer = UICertificate:create(param)
		self:addChild(layer,ConfigGameScene.ZOrder.REPORT)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 移除胡牌提示层
-- end --
function m:removeHuTipLayer()
	local child = self:getChildByTag(m.TAG.FLIMLAYER_HU)
	if not child then
		return
	end
	child:removeFromParent()
end
-- 直接登录
function m:directLogin( msgTbl )

	self:unregisterAllMsgListener()

	local eventDispatcher = self.playMjLayer:getEventDispatcher()
	eventDispatcher:removeEventListenersForTarget(self.playMjLayer)

	if self.scheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
		self.scheduleHandler = nil
	end

	if self.voiceUrlScheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
		self.voiceUrlScheduleHandler = nil
	end
end

function m:setTingState(holdcount)
	if self.m_tingState == 1 then
		-- 清除原来，重新加载
		if self.tingZheZhaoSpr and #self.tingZheZhaoSpr > 0 then
			for i,v in ipairs(self.tingZheZhaoSpr) do
				if v then
					v:removeFromParent()
					v = nil
				end
			end
		end
		self.tingZheZhaoSpr = {}
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]

		for k,mjTile in pairs(roomPlayer.holdMjTiles) do
			if mjTile.isCurGetCard == 0 then
				local width    = mjTile.mjTileSpr:getContentSize().width
				local height   = mjTile.mjTileSpr:getContentSize().height
				local zhezhaoSpr = cc.Sprite:createWithSpriteFrameName("Image/IRoom/CommomRoom/game_card_bg.png")
				-- zhezhaoSpr:setScale(0.5)
				local pos      = cc.p(mjTile.mjTileSpr:getPosition())
				zhezhaoSpr:setPosition(cc.p(pos.x, pos.y))
				self.playMjLayer:addChild(zhezhaoSpr, 1000)

				table.insert(self.tingZheZhaoSpr, zhezhaoSpr)
			end
		end
	else
		image_bg:setVisible(false)
	end
end

function m:showTingArrow()
	local mjTiles = {}
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	if roomPlayer and roomPlayer.holdMjTiles then
		for k,mjTile in pairs(roomPlayer.holdMjTiles) do
			local mjColor = mjTile.mjColor
			local mjNumber = mjTile.mjNumber
			local mjTileSpr = mjTile.mjTileSpr
			dump(mjTile,type(mjColor) .. "====33333===")
			dump(self.tingHuCards, "====4444444444===")

			for m,v in pairs(self.tingHuCards) do
				if m%2 == 0 and v[1][1] == mjColor and v[1][2] == mjNumber then
					table.insert(mjTiles, mjTile)
				end
			end
		end
	end

	for k,mjTile in pairs(mjTiles) do
		local width    = mjTile.mjTileSpr:getContentSize().width
		local height   = mjTile.mjTileSpr:getContentSize().height
		local arrowSpr = cc.Sprite:createWithSpriteFrameName("Image/IRoom/CommomRoom/game_ting_arrow.png")
		local pos      = cc.p(mjTile.mjTileSpr:getPosition())
		arrowSpr.x     = pos.x
		arrowSpr.y     = pos.y + height*0.6 - 3
		arrowSpr:setPosition(cc.p(arrowSpr.x, arrowSpr.y))
		local zorder = mjTile.mjTileSpr:getZOrder()
		self.playMjLayer:addChild(arrowSpr,zorder-1)--, display.size.height)
		arrowSpr:setName("arrow"..mjTile.mjColor..mjTile.mjNumber..math.floor(pos.x))

		table.insert(self.arrowTing, arrowSpr)
	end
end

function m:isInTingCards(mjColor,mjNumber)
	local flag = false
	if (not mjColor) or (not mjNumber) then
		return flag
	end

	for k,v in pairs(self.tingHuCards) do
		if k%2 == 0 and v[1][1] == mjColor and v[1][2] == mjNumber then
			flag = true
			break
		end
	end
	return flag
end

function m:cleanArrowSpr()
	for k,arrowSpr in pairs(self.arrowTing) do
		if not tolua.isnull(arrowSpr) then
			arrowSpr:removeFromParent()
			arrowSpr = nil
		end
	end

	self.arrowTing = {}
end

function m:loadCSB()
    self:YuYinTouchEvent()
end


function m:YuYinTouchEvent()
	--语音按钮
	self.yuyinBtn = self.UIRoomInfoBottom:getBtnMap().btnVoice

	-- 正式包点击回调
	local isSild = false
	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            self.sendVocie = false
	        gComm.SoundEngine:pauseAllSound()
	        self.sendVocie = true
	        self:startAudio()

	        isSild = false
	        if self.voiceTip then
	        	self.voiceTip:gotoFrameAndPlay(0,true)
	        	self.voiceNode:setVisible(true)
	        end

        elseif eventType == ccui.TouchEventType.moved then
		     isSild = false
        elseif eventType == ccui.TouchEventType.ended then
		    if not isSild then
		    	isSild = true
		    	gComm.SoundEngine:resumeAllSound()
		    	self:stopAudio()
		    	self.yuyinBtn:setEnabled(false)
			    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function (sender)
			    	self.yuyinBtn:setEnabled(true)
			    end)))

		    end
		     if self.voiceTip then
	        	self.voiceTip:pause()
	        	self.voiceNode:setVisible(false)
	         end
        elseif eventType == ccui.TouchEventType.canceled then
           if not isSild then
		    	isSild  = true
		    	gComm.SoundEngine:resumeAllSound()
		    	self:stopAudio()
		    	self.yuyinBtn:setEnabled(false)
			    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function (sender)
			    	self.yuyinBtn:setEnabled(true)
			    end)))
		    end
		    if self.voiceTip then
	        	self.voiceTip:pause()
	        	self.voiceNode:setVisible(false)
	        end
        end
    end

    self.yuyinBtn:addTouchEventListener(touchEvent)
end

function m:unRegEvent()
	self.CtlMJNetListener:unRegEvent()
end

function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")

	-- 触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)

	local eventDispatcher = self.playMjLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.playMjLayer)

	-- 逻辑更新定时器
	self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)

	local tipsNode, tipsAnimation = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimVoiceTip.csb")
	tipsAnimation:gotoFrameAndPlay(0, false)
	tipsAnimation:pause()
	tipsNode:setPosition(display.center)
	tipsNode:setVisible(false)

	self:addChild(tipsNode,2000)
	self.voiceTip = tipsAnimation
	self.voiceNode = tipsNode
	--self.yuyinChatNode:setVisible(true)

	NetMngRoom.enterRoomTipByURL()
end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")

	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent(self)
    self:unRegEvent()
 --    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
	-- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

function m:onCleanup()
    m.super.onCleanup(self)
    log(self.__TAG,"onCleanup")

	local eventDispatcher = self.playMjLayer:getEventDispatcher()
	eventDispatcher:removeEventListenersForTarget(self.playMjLayer)
	if self.scheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
		self.scheduleHandler = nil
	end

	if self.voiceUrlScheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
		self.voiceUrlScheduleHandler = nil
	end
	self:unregisterAllMsgListener()

	self.gParam.roomPeopleNum = nil
end

function m:showAnimZhengFan(zhengSeatIdx,fanSeatIdx)
	local shunCsd = "Csd/Animation/MJ/AnimMJShunBao.csb"
	local fanCsb = "Csd/Animation/MJ/AnimMJFanBao.csb"

	local csbNode1, action1 = gComm.UIUtils.createCSAnimation(shunCsd)
	local csbNode2, action2 = gComm.UIUtils.createCSAnimation(fanCsb)

	local roomPlayer = self.roomPlayers[zhengSeatIdx + 1]
	csbNode1:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
	self.rootNode:addChild(csbNode1, ConfigGameScene.ZOrder.DECISION_SHOW)

	roomPlayer = self.roomPlayers[fanSeatIdx + 1]
	csbNode2:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
	self.rootNode:addChild(csbNode2, ConfigGameScene.ZOrder.DECISION_SHOW)

	-- action1:setTimeSpeed(5)
	action1:gotoFrameAndPlay(0, false)
	action2:gotoFrameAndPlay(0, false)

	if "windows" == device.platform then
		local delayTime = cc.DelayTime:create(1.5)
		local cbFun = cc.CallFunc:create(function(sender)
			sender:removeFromParent()
		end)
		local Seq = cc.Sequence:create(delayTime,cbFun)
		csbNode1:runAction(Seq)
		csbNode2:runAction(Seq)
	else
		action1:setLastFrameCallFunc(function()
			csbNode1:removeFromParent()
			log("===setFrameEventCallFuncsetFrameEventCallFunc==1--" .. action1:getTimeSpeed())
		end)

		action2:setLastFrameCallFunc(function()
			csbNode2:removeFromParent()
			log("===setFrameEventCallFuncsetFrameEventCallFunc==2==" .. action2:getTimeSpeed())
		end)
	end
end

function m:showAnimBuHua(nodePostion)
	-- local pos = cc.pAdd(nodePostion,cc.p(0,150))
	local fileCsd = "Csd/Animation/MJ/AnimMJBuHua.csb"
	local csbNode1, action1 = gComm.UIUtils.createCSAnimation(fileCsd)
	csbNode1:setPosition(nodePostion)
	self.rootNode:addChild(csbNode1, ConfigGameScene.ZOrder.DECISION_SHOW)

	action1:gotoFrameAndPlay(0, false)
	if "windows" == device.platform then
		local delayTime = cc.DelayTime:create(1.5)
		local cbFun = cc.CallFunc:create(function(sender)
			csbNode1:removeFromParent()
		end)
		local Seq = cc.Sequence:create(delayTime,cbFun)
		csbNode1:runAction(Seq)
	else
		action1:setLastFrameCallFunc(function()
			csbNode1:removeFromParent()
			log("===showAnimBuHua==--" .. action1:getTimeSpeed())
		end)
    end
end

function m:showAnimCsb(nodePostion,fileCsd,cbFun)
	-- --吃碰杠补花自摸
	-- local csbList = {
	-- 	[1] = "Csd/Animation/MJ/AnimMJChi.csb",
	-- 	[2] = "Csd/Animation/MJ/AnimMJPeng.csb",
	-- 	[3] = "Csd/Animation/MJ/AnimMJGang.csb",
	-- 	[4] = "Csd/Animation/MJ/AnimMJBuHua.csb",
	-- 	[5] = "Csd/Animation/MJ/AnimMJZiMo.csb",
	-- }
	-- -- local pos = cc.pAdd(nodePostion,cc.p(0,150))
	-- local fileCsd = csbList[csbIndex]--"Csd/Animation/MJ/AnimMJBuHua.csb"
	-- if not fileCsd then
	-- 	return
	-- end
	local csbNode1, action1 = gComm.UIUtils.createCSAnimation(fileCsd)
	csbNode1:setPosition(nodePostion)
	self.rootNode:addChild(csbNode1, ConfigGameScene.ZOrder.DECISION_SHOW)

	action1:gotoFrameAndPlay(0, false)
	if "windows" == device.platform then
		local delayTime = cc.DelayTime:create(1.5)
		local cbHandle = cc.CallFunc:create(function(sender)
			csbNode1:removeFromParent()
			if cbFun then
				cbFun()
			end
		end)
		local Seq = cc.Sequence:create(delayTime,cbHandle)
		csbNode1:runAction(Seq)
	else
		action1:setLastFrameCallFunc(function()
			csbNode1:removeFromParent()
			if cbFun then
				cbFun()
			end
			log("===showAnimBuHua==--" .. action1:getTimeSpeed())
		end)
    end
end

function m:setMJGray(spriteList,dataList)
	-- dump(spriteList,"===setMJGray===")
	local flag = {}
	for k,v in pairs(dataList) do
		flag[v] = true
	end
	self.lastGraySprite = {}
	for k,v in pairs(spriteList or {}) do
		if flag[v.mjColor*10 + v.mjNumber] then
			v.mjIsTouch = true
			v.mjTileSpr:setColorGray()
			self.lastGraySprite[#self.lastGraySprite+1] = v
		end
	end
end

function m:setMJNormal()
	for k,v in pairs(self.lastGraySprite or {}) do
		v.mjIsTouch = false
		v.mjTileSpr:setColorNormal()
	end
	self.lastGraySprite = {}
end

function m:showRoundRes(isShengLi)
	local img = "Image/IRoom/CommomRoom/game_round_liuJu.png"
	if isShengLi then
		img = "Image/IRoom/CommomRoom/game_round_shengLi.png"
	end

	-- 显示决策标识
	local opSprite = cc.Sprite:createWithSpriteFrameName(img)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	opSprite:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
	self.rootNode:addChild(opSprite, ConfigGameScene.ZOrder.DECISION_SHOW+2)
	-- 标识显示动画
	opSprite:setScale(0)
	local scaleToAction = cc.ScaleTo:create(0.2, 1)
	local easeBackAction = cc.EaseBackOut:create(scaleToAction)
	local delayTime = cc.DelayTime:create(1.5)
	local fadeOutAction = cc.FadeOut:create(0.2)
	local callFunc = cc.CallFunc:create(function(sender)
		-- 播放完后移除
		sender:removeFromParent()
	end)
	local seqAction = cc.Sequence:create(easeBackAction, delayTime,fadeOutAction, callFunc)
	opSprite:runAction(seqAction)
end

function m:sendNetCard(tileColor,tileValue)
	local m_type = 1
	local m_think = {}
	local think_temp = {tileColor,tileValue}
	table.insert(m_think,think_temp)
	if self.isShowTingTip and self.isHu == false then
		--检测选择要出的牌是否在 听牌中，若是则 m_type = 9
		self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)
		if self:isInTingCards(tileColor,tileValue) then
			self.sendoutTingCard = {mjColor=tileColor,mjNumber=tileValue}
			m_type = 9
		end
	end
	gComm.EventBus.dispatchEvent(EventCmdID.UI_TOUCH_SAME_MJ_BRIGHT,0,0)
	NetMngMJAnQin.sendOutCard(m_type,m_think)
end

function m:addMovingTileSpr()
	self.gParam.movingTileSpr = SpriteTileStand:create(1, 1)
	self.playMjLayer:addChild(self.gParam.movingTileSpr,10000)
	-- self.gParam.movingTileSpr:setGlobalZOrder(10000)
	-- self.gParam.movingTileSpr:setLocalZOrder(10000)
	self.gParam.movingTileSpr:setVisible(false)
	self.gParam.movingTileSpr:setPosition(cc.p(-200,-200))
end

function m:showHuTip(touchMjTile)
	if self.isShowTingTip and self.isHu == false then
		touchMjTile = touchMjTile or {}
		local mjColor,mjNumber = touchMjTile.mjColor,touchMjTile.mjNumber
		if self:isInTingCards(mjColor,mjNumber) then
			local tingTipLayer = self:createTingTipLayer(mjColor,mjNumber)
			if tingTipLayer then
				self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)
				-- self:addChild(tingTipLayer,ConfigGameScene.ZOrder.FLIMLAYER,m.TAG.FLIMLAYER_TING)
				self.playMjLayer:addChild(tingTipLayer,6000,m.TAG.FLIMLAYER_TING)
				tingTipLayer:ignoreAnchorPointForPosition(false)
				tingTipLayer:setAnchorPoint(0.5,0)

				local mjPosX = touchMjTile.mjTileSpr:getPositionX()
				local mjWidth = touchMjTile.mjTileSpr:getContentSize().width * 0.5
				local width = tingTipLayer:getContentSize().width * 0.5

				if display.width - mjPosX < width then
					mjPosX = mjPosX - width + mjWidth
				elseif mjPosX < width then
					mjPosX = mjPosX + width - mjWidth
				end
				tingTipLayer:setPosition(mjPosX,180)
			end
		else
			self:removeTingTipLayer(m.FLIMTYPE.FLIMLAYER_TING)
		end
	end
end

function m:unSelectedTile(exceptTile)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.holdStart
	exceptTile = exceptTile or {}
	for idx, mjTile in ipairs(roomPlayer.holdMjTiles) do
		if mjTile.isSelected == true and exceptTile.mjTileSpr ~= mjTile.mjTileSpr then
			mjTile.isSelected = false
			if not tolua.isnull(mjTile.mjTileSpr) then
				mjTile.mjTileSpr:setPositionY(mjTilePos.y)
			end
		end
	end
end

function m:I_ShowCoinCard(args)
    -- local args = {
    --     coinNum = msgTbl.m_coin,
    --     cardNum = msgTbl.m_card2,
    -- }
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		if self.roomPlayers and self.roomPlayers[self.gParam.sPosSelf+1] then
			local roomInfo = self.roomPlayers[self.gParam.sPosSelf+1]
			log("m:updatePlayerInfo ",roomInfo.score)
			roomInfo.score = args.coinNum
			self.UIHeadLayout:setTxt(roomInfo.displaySeatIdx,{score = roomInfo.score})
		end
	end
end

function m:I_ShowCoinInRoom(args)
	dump(args,"==I_ShowCoinInRoom==")
    -- local args = {
    --     userId = msgTbl.userId,
    --     changeCoin = msgTbl.num,
    --     finalCoin  = msgTbl.allCo,
    --     reasonType = msgTbl.oper,
    -- }
    m.super.I_ShowCoinInRoom(self,args)
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		if self.roomPlayers then
			local fInfo = nil
			for i=1,4 do
				local info = self.roomPlayers[i]
				if info and info.uid == args.userId then
					fInfo = info
					break
				end
			end
			if fInfo then
				fInfo.score = args.finalCoin
				self.UIHeadLayout:setTxt(fInfo.displaySeatIdx,{score = fInfo.score})
			end
		end
	end
end

return m
