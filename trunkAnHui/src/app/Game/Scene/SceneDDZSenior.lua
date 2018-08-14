
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local DefineRoom = require("app.Common.Config.DefineRoom")
local UIPlayerInfoTips = require("app.Game.UI.UIIRoom.UIPlayerInfoTips")
local EventCmdID = require("app.Common.Config.EventCmdID")
local UIDissolution = require("app.Game.UI.UIIRoom.UIDissolution")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local UISettlementFinal = require("app.Game.UI.UIGame.PokerDDZ.UISettlementFinal")
local UISettlementOneRound = require("app.Game.UI.UIGame.PokerDDZ.UISettlementOneRound")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local UIRoomInfoExClass = require("app.Game.UI.UIIRoom.RoomComm.UIRoomInfoExClass")

local UICertificate = require("app.Game.UI.UILobby.BigWinMatch.UICertificate")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")

local m = class("SceneDDZSenior", gComm.SceneBase)


m.ZOrder = {
	MJTABLE						= 1,
	PLAYER_INFO					= 2,
	MJTILES						= 6,
	OUTMJTILE_SIGN				= 7,
	DECISION_BTN				= 8,
	DECISION_SHOW				= 9,
	PLAYER_INFO_TIPS			= 10,
	REPORT						= 16,
	DISMISS_ROOM				= 17,
	SETTING						= 18,
	CHAT						= 20,
	MJBAR_ANIMATION				= 21,
	FLIMLAYER           	    = 16,
	HAIDILAOYUE					= 23,

	ROUND_REPORT				= 66, -- 单局结算界面显示在总结算界面之上
	VOICE_NODE					= 67, -- 语音节点
}

-- 牌型
m.CardType = {
	card_style_error 				= 0,
	card_style_single 				= 1,  	--单张;
	card_style_double 				= 2,  	--一对;
	card_style_three  				= 3,  	--三个;
	card_style_three_single 		= 4, 	--三带单;
	card_style_three_double 		= 5,	--三带对;
	card_style_three_list 			= 6,	--飞机;
	card_style_three_list_single 	= 7,	--飞机带单;
	card_style_three_list_double 	= 8,	--飞机带对;
	card_style_bomb_and_single 		= 9,	--四代2单;
	card_style_bomb_and_double 		= 10,	--四代2对;
	card_style_single_list 			= 11,	--单顺;
	card_style_double_list 			= 12,	--双顺;
	card_style_bomb3 				= 13,	--带癞子的炸弹;
	card_style_bomb2 				= 14,	--纯粹硬炸弹;
	card_style_bomb1 				= 15,	--纯粹软炸弹;
	card_style_rocket 				= 16,	--王炸
	card_style_four2 				= 17,   --四带二;
}

local landlordPos = cc.p(149, 210)

local csbRes = "Csd/Scene/SceneDDZEx.csb"

m._gameType = nil -- 0 经典斗地主，1 叫分斗地主， 2 抢地主玩法

function m:ctor(enterRoomMsgTbl)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

	dump(enterRoomMsgTbl)

	gt.socketClient:setDelegate(self)

	self._gameType = -1
	self.removePlayers = {}

	self.jiaofenStatus = 0  -- 0 没有状态  5 加倍   6 跟

	self.enterRoomMsgTbl = enterRoomMsgTbl

	-- 加载界面资源
	local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbRes)
	local action = cc.CSLoader:createTimeline(csbRes)
	csbNode:runAction(action)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
	self:addChild(csbNode)
	self.rootNode = csbNode

	local bg = gComm.UIUtils.seekNodeByName(csbNode, "mahjong_table")
	bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))


	if gComm.FunUtils.IsiOSPlatform() then
		self.luaBridge = require("cocos/cocos2d/luaoc")
	elseif gComm.FunUtils.IsAndroidPlatform() then
		self.luaBridge = require("cocos/cocos2d/luaj")
	end

	if cc.exports.gGameConfig.isiOSAppInReview then
		local readyPlayNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readyPlay")
		readyPlayNode:setVisible(false)
	end

	self.showShouPaiAmount = true  -- true 显示   false  不显示
	self.addAlarm = 0     -- 0 不报警   1 剩余3张报警  2 剩余5张报警
	self.mMaxFanShu = 3

	self.playmes = enterRoomMsgTbl


	self.gParam = {
		roomType = enterRoomMsgTbl.m_RoomType,
		sPosSelf = enterRoomMsgTbl.m_pos,
		isTuoGuan = false,
		isJiaoFenGame = false,--是否是叫分
	}

	for k,v in ipairs(enterRoomMsgTbl.m_playtype) do
		if v == DefineRule.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT then
			self.showShouPaiAmount = false
		elseif v == DefineRule.GREnum.DDZ_ALARM_HIDE then
			self.addAlarm = 0
		elseif v == DefineRule.GREnum.DDZ_ALARM_REMAIN_3 then
			self.addAlarm = 1
		elseif v == DefineRule.GREnum.DDZ_ALARM_REMAIN_5 then
			self.addAlarm = 2
		elseif v == DefineRule.GREnum.DDZ_JIAO_FEN then
			self._gameType = 1
			self.playmes.gameType = 2
			self.gParam.isJiaoFenGame = true
		elseif v == DefineRule.GREnum.DDZ_JIAO_DIZHU then--不用self._gameType这个变量
			self.playmes.gameType = 1

		elseif v == DefineRule.GREnum.DDZ_BOMB_3 then
			self.mMaxFanShu = 3
		elseif v == DefineRule.GREnum.DDZ_BOMB_4 then
			self.mMaxFanShu = 4
		elseif v == DefineRule.GREnum.DDZ_BOMB_5 then
			self.mMaxFanShu = 5
		end
	end

	self.playmes.m_playCircle = 1
	self.playmes.roomId = enterRoomMsgTbl.m_deskId

	local param = {
		csbNode   = self.rootNode,
		gameID    = enterRoomMsgTbl.m_gameID,
		roundMaxCount = enterRoomMsgTbl.m_maxCircle,
		roomID    = enterRoomMsgTbl.m_deskId,
		sPos      = enterRoomMsgTbl.m_pos,

		uid = cc.exports.gData.ModleGlobal.userID,
		ruleType = enterRoomMsgTbl.m_playtype,
		roomPeopleNum = enterRoomMsgTbl.m_playerNum,
		roomType = enterRoomMsgTbl.m_RoomType,
	}
	self.UIRoomInfoExClass = UIRoomInfoExClass:create(param)

	-- 翻倍数
	self.mTimesText = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_Times")
	self.mBombCount = 0
	self.mBombTimes = 1

	self.mTimesText:setString(self.mBombTimes)

	-- 刚进入房间,隐藏玩家信息节点
	for i = 1, 3 do
		local playerNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. i)
		playerNode:setVisible(false)
	end
	self:hidePlayersReadySign()

	-- 隐藏闹钟
	local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_alarmbg")
   	for i = 1, 3 do
		local point = gComm.UIUtils.seekNodeByName(chatBgNode, "Spr_point_"..i)
		point:setVisible(false)
    end

	-- 隐藏玩家牌参考位置（牌参考位置父节点，pos(0，0）)
	local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
	playNode:setVisible(false)

	--隐藏相同IP提示层
	local SameIpNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_SameIP")
	SameIpNode:setVisible(false)

	-- 倒计时
	self.playTimeCDLabel = gComm.UIUtils.seekNodeByName(chatBgNode, "Label_playTimeCD")
	self.playTimeCDLabel:setString("0")

	-- 隐藏游戏中短信、语音设置按钮
	local playBtnsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playBtns")
	playBtnsNode:setVisible(true)

	-- 隐藏准备按钮
	local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
	readyBtn:setVisible(false)
	gComm.BtnUtils.setButtonClick(readyBtn, handler(self, self.readyBtnClickEvt))

	-- 隐藏所有玩家对话框
	local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_chatBg")
	self.rootNode:reorderChild(chatBgNode, m.ZOrder.CHAT)
	chatBgNode:setVisible(false)

	-- 隐藏玩家操作提示
	self.mOperTipsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_OperTips")
	self.mOperTipsNode:setVisible(false)

	-- 添加表情管理倒计时
	local node_controlBiaoqing = gComm.UIUtils.seekNodeByName(self.rootNode, "node_controlBiaoqing")
	node_controlBiaoqing:setVisible(false)
	self.controlBiaoqingNode = node_controlBiaoqing

	self.biaoqingTimeCD = nil
	self.interactAniTimeCD = nil
	local Txt_cutdouwn = gComm.UIUtils.seekNodeByName(node_controlBiaoqing, "Txt_cutdouwn")
	self.biaoqingCutDown = Txt_cutdouwn

	--增加扑克牌层
	local playMjLayer = cc.Layer:create()
	self.rootNode:addChild(playMjLayer, m.ZOrder.MJTILES)
	self.playMjLayer = playMjLayer

	-- 头像下载管理器
	local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
	self.rootNode:addChild(playerHeadMgr)
	self.playerHeadMgr = playerHeadMgr

	-- 玩家剩余牌显示节点
	self.nodeLeftCards = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_LeftCards")
	for i=1,2 do
		local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_"..i)
		leftCardBg:setVisible(false)
		local leftCardNum = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_"..i)
		leftCardNum:setVisible(false)
	end
	-- self.nodeLeftCards:setVisible(false)

	-- 底牌节点
	self.mLastHandsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_LastHands")
	self.mLastHandsNode:setVisible(false)

	--玩家进入房间
	self:playerEnterRoom(enterRoomMsgTbl)

	--准备界面逻辑
	local paramTbl = {}
	paramTbl.roomID = enterRoomMsgTbl.m_deskId
	paramTbl.playerSeatPos = enterRoomMsgTbl.m_pos
	paramTbl.playTypeDesc = playTypeDesc
	paramTbl.roundMaxCount = enterRoomMsgTbl.m_maxCircle
	paramTbl.curCircle = enterRoomMsgTbl.m_curCircle
	paramTbl.gameStyle = enterRoomMsgTbl.m_gameStyle
	paramTbl.m_playtype = enterRoomMsgTbl.m_playtype
	paramTbl.m_agent = enterRoomMsgTbl.m_RoomType

	self.isRoomCreater = false
	if paramTbl.playerSeatPos == 0 then
		-- 0位置是房主
		self.isRoomCreater = true
	end

	local agentRoom = enterRoomMsgTbl.m_RoomType or 0
	if agentRoom == 1 then
		self.isRoomCreater = false
	end

	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		self.isRoomCreater = false
	end

	--解散房间
	self.applyDimissRoom = UIDissolution:create(self.roomPlayers, self.playerSeatIdx)

	self:addChild(self.applyDimissRoom, m.ZOrder.DISMISS_ROOM)

	--语音按钮
	self.yuyinBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Voice_Btn")

	--头像处语音消息
	self.yuyinChatNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_Yuyin_Dlg")

	local begin = {}
	local moved = {}

	local isSild
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

 	self:addStartGame()
 	-- 加倍
 	self.isAddDouble = 0  -- 当前不加倍
 	-- 跟
 	self.isAddGen = 0  -- 当前不跟

 	-- 保存总结算数据
 	self.lastRound = false
 	self.finalReportData = nil
 	self.curRoomPlayers = {}
	-- 接收消息分发函数
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN_SERVER, self, self.onRcvLoginServer)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ENTER_ROOM, self, self.onRcvEnterRoom) --进入房间
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ADD_PLAYER, self, self.onRcvAddPlayer) --接收玩家消息
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_REMOVE_PLAYER, self, self.onRcvRemovePlayer) --从房间移除一个玩家
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_SYNC_ROOM_STATE, self, self.onRcvSyncRoomState) --断线重连
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_READY, self, self.onRcvReady) --玩家准备手势
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_SAMEIP, self, self.IsSameIp) --相同IP
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_OFF_LINE_STATE, self, self.onRcvOffLineState) --玩家在线标识
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ROUND_STATE, self, self.onRcvRoundState) --当前局数/最大局数
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_START_GAME, self, self.onRcvStartGame) --开始游戏
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_TURN_SHOW_MJTILE, self, self.onRcvTurnShowMjTile) --通知玩家出牌
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_SYNC_SHOW_MJTILE, self, self.onRcvSyncShowMjTile) --显示玩家出牌消息
	-- gt.socketClient:registerMsgListener(NetCmd.MSG_GC_MAKE_DECISION, self, self.onRcvMakeDecision)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_CHAT_MSG, self, self.onRcvChatMsg)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ALARM_MSG, self, self.onAlarm) --通知警报灯消息
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_GET_SURPLUS, self, self.surplusCard) --最后手中剩余牌消息
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ROUND_REPORT, self, self.onRcvRoundReport) --单局游戏结束
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_FINAL_REPORT, self, self.onRcvFinalReport) --总结算界面
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ASK_DIZHU, self, self.onRcvASKDIZHU) --通知客户端抢地主
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ANS_DIZHU, self, self.onRcvANSDIZHU)--服务器广播客户端操作
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_WHO_IS_DIZHU, self, self.onRcvWHOISDIZHU)--服务器广播最终地主位置
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN, self, self.onRcvLogin)-- 断线重连
	gt.socketClient:registerMsgListener(NetCmd.MSG_MSG_S_2_C_SHOWCARDS, self, self.onRcvSHOWCARDS)

	gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_TUO_GUAN, self, self.onRcvTuoGuan)
	gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_ACTIVE_CODE, self, self.onRcvActiveCode)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_BEAT, self, self.onShowBeatOthers)

	gComm.EventBus.regEventListener(EventCmdID.UI_UPDATE_DESK_CLOTH, self, self.changeGameBg)
	gComm.EventBus.regEventListener(EventCmdID.EventType.SEND_BIAOQING,self,self.sendBiaoQing )
	gComm.EventBus.regEventListener(EventCmdID.EventType.DIRECT_LOGIN,self,self.directLogin )
	gComm.EventBus.regEventListener(EventCmdID.EventType.BACK_MAIN_SCENE, self, self.backMainSceneEvt)
	gComm.EventBus.regEventListener(EventCmdID.EventType.SEND_HEART, self, self.onSendHeart)
	gComm.EventBus.regEventListener(EventCmdID.EventType.ZJH_ADD_FINALREPORT, self , self.addFinalReport)

	--已选牌表
	self.SelectCard = {}
	-- 当前出的牌
	self.outCard = {}

	--标志
	self.tag = {0,0,0}
	self.deal = true
	self.isTouch = false
	self.isTouchPrompt = false
	self.time = 0
	self.promptIndex = 1
	self.animationNode = nil
	self.ChatLog = {}

	-- 初始化决策按钮
	self:initDecisionBtns()

	-- 触摸事件
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self.playMjLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.playMjLayer)

	-- 逻辑更新定时器
	self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
	-- gComm.SoundEngine:playMusic("bgm2", true)

	self.mSelfMenZhua = false
	self.mClearSiChuanTips = true

	self.mIsCheckCurState = false

	self:changeGameBg()
	cc.UserDefault:getInstance():setIntegerForKey("gameTotalPlayer", 3)

	self.isRoundReport = false
end


function m:changeGameBg()
	local bgIndex = cc.UserDefault:getInstance():getIntegerForKey("gameBg", 2)
	local mahjong_table = gComm.UIUtils.seekNodeByName(self.rootNode, "mahjong_table")
	local gameBgPic = "Image/BigImg/game_bg_ddz"
	gameBgPic = gameBgPic..bgIndex..".png"
	mahjong_table:initWithFile(gameBgPic)
end

function m:unregisterAllMsgListener()
	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent( self )
end

function m:clearGameData()
	if self.applyDimissRoom then
		self.applyDimissRoom:setVisible(false)
	end
	self:removeallscene()
end

function m:onRcvLogin(msgTbl)
	-- log("========重连登录3")
	if msgTbl.m_errorCode == 5 then
		-- 去掉转圈
		gComm.UIUtils.removeLoadingTips()
		local str_des = "您尚未在"..msgTbl.m_errorMsg.."退出游戏，请先退出后再登陆此游戏！"
		UINoticeTips:create(str_des, function()end)
		return
	end
	-- log("========重连登录4")
	-- 去掉转圈
	gComm.UIUtils.removeLoadingTips()

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

	self.mIsCheckCurState = true
end

--------------------------------
-- @class function
-- @description 服务器返回登录大厅结果
-- end --
function m:onRcvLoginServer(msgTbl)
	-- 去掉转圈
	gComm.UIUtils.removeLoadingTips()

	-- 发送心跳，判断链接是否已经断开
	if gt.socketClient then
		gt.socketClient:sendHeartbeat(true)
	end

	if self.mIsCheckCurState == true then
		self.mIsCheckCurState = false
		-- 判断进入大厅还是房间 msgTbl.m_state  0:当前在大厅  1:当前在牌桌内
		if msgTbl.m_state == 0 then
			self:backMainSceneEvt()
		end
	end
end

function m:initDecisionBtns()
	-- 决策按钮位置信息
	-- 隐藏玩家决策按钮（提示、出牌、不出的父节点）
	self.decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
	self.rootNode:reorderChild(self.decisionBtnNode, m.ZOrder.DECISION_BTN)
	self.decisionBtnNode:setVisible(false)

	-- 叫分
	self.nodeScore = gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_score")
	self.nodeScore:setVisible(false)

	-- 加倍
	self.nodeDouble = gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_double")
	self.nodeDouble:setVisible(false)

	-- 跟
	self.nodeGen = gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_gen")
	self.nodeGen:setVisible(false)

	-- 不叫
	local noWant = gComm.UIUtils.seekNodeByName(self.nodeScore,"Btn_no_want")
	self.scorePass = noWant
	gComm.BtnUtils.setButtonClick(noWant, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 0 --1:抢地主  0:不抢
		msgToSend.m_difen = 0
		gt.socketClient:sendMessage(msgToSend)
		self.nodeScore:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)
	-- 一份
	local scoreOne = gComm.UIUtils.seekNodeByName(self.nodeScore,"Btn_score_one")
	self.scoreOne = scoreOne
	gComm.BtnUtils.setButtonClick(scoreOne, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:抢地主  0:不抢
		msgToSend.m_difen = 1
		gt.socketClient:sendMessage(msgToSend)
		self.nodeScore:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)
	-- 二分
	local scoreTwo = gComm.UIUtils.seekNodeByName(self.nodeScore,"Btn_score_two")
	self.scoreTwo = scoreTwo
	gComm.BtnUtils.setButtonClick(scoreTwo, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:抢地主  0:不抢
		msgToSend.m_difen = 2
		gt.socketClient:sendMessage(msgToSend)
		self.nodeScore:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)
	-- 三分
	local scoreThree = gComm.UIUtils.seekNodeByName(self.nodeScore,"Btn_score_three")
	gComm.BtnUtils.setButtonClick(scoreThree, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:抢地主  0:不抢
		msgToSend.m_difen = 3
		gt.socketClient:sendMessage(msgToSend)
		self.nodeScore:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	local scoreDouble = gComm.UIUtils.seekNodeByName(self.nodeDouble,"Btn_double")
	self.scoreDouble = scoreDouble
	gComm.BtnUtils.setButtonClick(scoreDouble, function()


		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:要  0:不要
		gt.socketClient:sendMessage(msgToSend)
		self.nodeDouble:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	local scoreNoDouble = gComm.UIUtils.seekNodeByName(self.nodeDouble,"Btn_no_double")
	self.scoreNoDouble = scoreNoDouble
	gComm.BtnUtils.setButtonClick(scoreNoDouble, function()

		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 0 --1:抢地主  0:不抢
		gt.socketClient:sendMessage(msgToSend)
		self.nodeDouble:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	local scoreGen = gComm.UIUtils.seekNodeByName(self.nodeGen,"Btn_gen")
	self.scoreGen = scoreGen
	gComm.BtnUtils.setButtonClick(scoreGen, function()

		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:跟  加倍  0: 过  不跟  不加倍
		gt.socketClient:sendMessage(msgToSend)
		self.nodeGen:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	local scoreNoGen = gComm.UIUtils.seekNodeByName(self.nodeGen,"Btn_no_gen")
	self.scoreGen = scoreNoGen
	gComm.BtnUtils.setButtonClick(scoreNoGen, function()

		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 0 --1:抢地主  0:不抢
		gt.socketClient:sendMessage(msgToSend)
		self.nodeGen:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)


--=============================================================================

	self.play 		= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_1")
	self.prompt 	= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_2")
	self.pass 		= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_3")
	self.restore 	= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_4")
	self.nograb 	= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_5")
	self.grab 		= gComm.UIUtils.seekNodeByName(self.decisionBtnNode, "Btn_decision_6")
	local nodePlay 		= gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_Play")
	local nodePrompt 	= gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_Prompt")
	local nodeReset 	= gComm.UIUtils.seekNodeByName(self.decisionBtnNode,"Node_Reset")

	self.btnPlayPosition 	= cc.p(self.play:getPosition())
	self.btnPlayPosition2 	= cc.p(nodePlay:getPosition())

	self.btnPromptPosition 	= cc.p(self.prompt:getPosition())
	self.btnPromptPosition2 = cc.p(nodePrompt:getPosition())

	self.btnPassPosition 	= cc.p(self.pass:getPosition())

	self.btnResetPosition 	= cc.p(self.restore:getPosition())
	self.btnResetPosition2 	= cc.p(nodeReset:getPosition())

	gComm.BtnUtils.setButtonClick(self.prompt, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		self.SelectCard = {}
		local showCard = self.curShowMjTileInfo.m_array[self.promptIndex]
		if showCard then
			for i,v in ipairs(showCard) do
				for j=1, #roomPlayer.holdMjTiles do
					if roomPlayer.holdMjTiles[j].mjIndex == v then
						self.SelectCard[#self.SelectCard+1] = j
					end
				end
			end
			--众神归位
			for j=1, #roomPlayer.holdMjTiles do
				self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
			end
			--提起
			for j=1, #self.SelectCard do
				self:setPokerIsUp(roomPlayer.holdMjTiles[self.SelectCard[j]], true, true)
			end

			self.promptIndex = self.promptIndex-1
			if self.promptIndex == 0 then
				self.promptIndex = self.maxPromptIndex
			end
			-- self.play:setEnabled (true)
		else
			--众神归位
			for j=1, #roomPlayer.holdMjTiles do
				self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
			end
		end
	end, nil, nil)

	gComm.BtnUtils.setButtonClick(self.play, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		if #self.SelectCard == 0 then
			--未选牌时按钮变灰不可点击
			gComm.UIUtils.floatText("未选牌")
			return
		end

		local tmep_card = {}
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		local mjTilesReferPos = roomPlayer.mjTilesReferPos
		local _mjTilePos = mjTilesReferPos.holdStart
		table.foreach(self.playMjLayer:getChildren(), function(i, v)
			if v:getPositionY() == _mjTilePos.y + 26 then
				table.insert(tmep_card, tonumber(v:getName()))
			end
		end)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_SHOW_MJTILE
		msgToSend.m_flag = 0
		msgToSend.m_card = tmep_card
		gt.socketClient:sendMessage(msgToSend)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	gComm.BtnUtils.setButtonClick(self.restore, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		--众神归位
		for j=1, #roomPlayer.holdMjTiles do
			self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
		end
		self.SelectCard = {}
	end, nil, nil)

	gComm.BtnUtils.setButtonClick(self.nograb, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 0 --1:抢地主  0:不抢
		msgToSend.m_difen = 0
		gt.socketClient:sendMessage(msgToSend)
	end, nil, nil)

	gComm.BtnUtils.setButtonClick(self.grab, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_QIANG_DIZHU
		msgToSend.m_pos = self.playerSeatIdx - 1
		msgToSend.m_yaobu = 1 --1:抢地主  0:不抢
		msgToSend.m_difen = 0
		gt.socketClient:sendMessage(msgToSend)

	end, nil, nil)

	gComm.BtnUtils.setButtonClick(self.pass, function()
		gComm.SoundEngine:playEffect("common/SpecOk", false, true)
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		--众神归位
		for j=1, #roomPlayer.holdMjTiles do
			self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
		end

		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_SHOW_MJTILE
		msgToSend.m_flag = 1
		msgToSend.m_card = {}
		gt.socketClient:sendMessage(msgToSend)
		self.decisionBtnNode:setVisible(false)
	end, nil, nil)

	self.play:setPressedActionEnabled(false)
	self.prompt:setPressedActionEnabled(false)
	self.pass:setPressedActionEnabled(false)
	self.restore:setPressedActionEnabled(false)
	self.nograb:setPressedActionEnabled(false)
	self.grab:setPressedActionEnabled(false)


end

--提牌
function m:touchPoker(poker)
	if poker.mjIsTouch then
		if poker.mjIsUp then
			self:setPokerIsUp(poker, false, true)
			return false
		else
			self:setPokerIsUp(poker, true, true)
			return true
		end
	end
end

function m:setPokerIsUp( poker, isUp, action)
	poker.mjTileSpr:stopAllActions()
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local _mjTilePos = mjTilesReferPos.holdStart
	local mjTilePos = cc.p(poker.mjTileSpr:getPosition())

	if poker.mjIsUp ~= isUp then
		if poker.mjIsUp then
			if action then
				local moveAction = cc.MoveTo:create(0.05, cc.p(mjTilePos.x, _mjTilePos.y))
				poker.mjTileSpr:runAction(moveAction)
			else
				poker.mjTileSpr:setPosition(cc.p(mjTilePos.x, _mjTilePos.y))
			end
		else
			if action then
				local moveAction = cc.MoveTo:create(0.05, cc.p(mjTilePos.x, _mjTilePos.y + 26))
				poker.mjTileSpr:runAction(moveAction)
			else
				poker.mjTileSpr:setPosition(cc.p(mjTilePos.x, _mjTilePos.y + 26))
			end
		end
		poker.mjIsUp = isUp;
	end
end

--更新选择的牌
function m:updateSelectCard( result, mjTileIdx )
	local isTocuhPoker = false
	local index = 1
	for i=1, #self.SelectCard do
		if mjTileIdx == self.SelectCard[i] then
			isTocuhPoker = true
			break;
		end
		index = index + 1
	end

	if result then
		if not isTocuhPoker then
			table.insert(self.SelectCard, mjTileIdx)
		end
	else
		if isTocuhPoker then
			table.remove(self.SelectCard, index)
		end
	end
end

function m:onTouchBegan(touch, event)
	if self.isTouch == false then
		return
	end

	--获取点击到了那一张牌和牌的位置（如果没有点击到牌就返回nil）
	local touchMjTile, mjTileIdx = self:touchPlayerMjTiles(touch:getLocation())

	if not touchMjTile then
		--点击两次牌归原位
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		if not roomPlayer then
			return false
		end
		local curTimeStr = os.date("%X", os.time())
		local timeSections = string.split(curTimeStr, ":")
		local time = timeSections[3]
		if time - self.time < 0.6 then
			for j=1, #roomPlayer.holdMjTiles do
				self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, true)
			end
			self.time = 0
		else
			self.time = time
		end
		return false
	end

	self.tempTouchPoker = {}	--本次触摸操作中点击到的牌（存储原因是为了防止二次触碰）
	self.chooseMjTile = touchMjTile --点击的牌
	self.chooseMjTileIdx = mjTileIdx --点击的牌在数组中的位置
	self.mjTileOriginPos = cc.p(touchMjTile.mjTileSpr:getPosition()) --点击到的牌的位置
	self.preTouchPoint = self.playMjLayer:convertTouchToNodeSpace(touch) --点击到的坐标在牌空间内的坐标
	self.lastLocation = touch:getLocation() --存储触摸按下时的位置
	self.tempTouchPoker[#self.tempTouchPoker + 1] = self.chooseMjTileIdx --存储点击处理过的牌
	self.chooseMjTile.mjTileSpr:setColor(cc.c3b(200,200,200)) --改变点击牌的颜色
	return true
end

function m:onTouchMoved(touch, event)

	local moveTouchPoint = self.playMjLayer:convertTouchToNodeSpace(touch)
	if math.abs(moveTouchPoint.x - self.preTouchPoint.x) > 5 or math.abs(moveTouchPoint.y - self.preTouchPoint.y) > 5 then

		--获取点击到了那一张牌和牌的位置（如果没有点击到牌就返回nil）
		local touchPokerTile, pokerTileIdx = self:touchPlayerMjTiles(touch:getLocation())
		if touchPokerTile and touchPokerTile.mjIsTouch then
			self.tempTouchPoker = {};
			local roomPlayer = self.roomPlayers[self.playerSeatIdx]
			local startIndex = 0
			local endIndex = 0
			if self.chooseMjTileIdx <= pokerTileIdx then
				startIndex = self.chooseMjTileIdx
				endIndex = pokerTileIdx
			else
				startIndex = pokerTileIdx
				endIndex = self.chooseMjTileIdx
			end
			for i = startIndex,endIndex do
				self.tempTouchPoker[#self.tempTouchPoker + 1] = i
				if roomPlayer.holdMjTiles[i].mjIsTouch then
					roomPlayer.holdMjTiles[i].mjTileSpr:setColor(cc.c3b(200,200,200))
				end

			end
			for i = 1, startIndex-1 do
				if roomPlayer.holdMjTiles[i].mjIsTouch then
					roomPlayer.holdMjTiles[i].mjTileSpr:setColor(cc.c3b(255,255,255))
				end

			end
			for i = endIndex+1, #roomPlayer.holdMjTiles do
				if roomPlayer.holdMjTiles[i].mjIsTouch then
					roomPlayer.holdMjTiles[i].mjTileSpr:setColor(cc.c3b(255,255,255))
				end

			end
		end
	end
end

function m:onTouchEnded(touch, event)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]

	local isStraight, straightCountValue = self:isStraight(self.tempTouchPoker)

	local isDoubleStraight, doubleStrCountValue = self:isDoubleStraight(self.tempTouchPoker)
	local isAirplane = self:isAirplane(self.tempTouchPoker)

	if isStraight == true and isDoubleStraight == false and isAirplane == false then
		log("Straight")
		-- 如果是顺子，去除多余的牌
		local tempPokerTiles = {}
		for i,v in ipairs(self.tempTouchPoker) do
			tempPokerTiles[i] = v
		end
		for i = #tempPokerTiles, 1, -1 do
			local pokerTile = roomPlayer.holdMjTiles[tempPokerTiles[i]]
			local value, color = self:changePk(pokerTile.mjIndex)
			if straightCountValue[value] > 1 then
				pokerTile.mjTileSpr:setColor(cc.c3b(255,255,255))
				table.remove(self.tempTouchPoker,i)
				straightCountValue[value] = straightCountValue[value] - 1
			end
		end
	elseif isStraight == false and isDoubleStraight == true and isAirplane == false then
		log("Double Straight")
		-- 如果是连对，去除多余的牌
		local tempPokerTiles = {}
		for i,v in ipairs(self.tempTouchPoker) do
			tempPokerTiles[i] = v
		end
		for i = #tempPokerTiles, 1, -1 do
			local pokerTile = roomPlayer.holdMjTiles[tempPokerTiles[i]]
			local value, color = self:changePk(pokerTile.mjIndex)
			if doubleStrCountValue[value] > 2 then
				pokerTile.mjTileSpr:setColor(cc.c3b(255,255,255))
				table.remove(self.tempTouchPoker,i)
				doubleStrCountValue[value] = doubleStrCountValue[value] - 1
			end
		end
	end

	--提牌
	for i=1, #self.tempTouchPoker do
		local result = self:touchPoker(roomPlayer.holdMjTiles[self.tempTouchPoker[i]])
		if roomPlayer.holdMjTiles[self.tempTouchPoker[i]].mjIsTouch then
			roomPlayer.holdMjTiles[self.tempTouchPoker[i]].mjTileSpr:setColor(cc.c3b(255,255,255))
		end
		self:updateSelectCard(result, self.tempTouchPoker[i])
	end
	gComm.SoundEngine:playEffect("common/SpecSelectCard", false, true)

end

function m:update(delta)
	-- 更新倒计时
	self:playTimeCDUpdate(delta)

	-- 更新玩家发送表情遮盖
	self:biaoqingWaitTimeCDUpdate(delta)

	if self.gParam.isJiaoFenGame == false then
		self:aniWaitTimeCDUpdate(delta)
	end
	-- 定时上传地址
	self.scheduleLocation = self.scheduleLocation or 0
	self.scheduleLocation = self.scheduleLocation + delta
	if self.scheduleLocation > 10 then
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
-- @description 进入房间
-- @param msgTbl 消息体
-- end --
function m:onRcvEnterRoom(msgTbl)
	if msgTbl.m_RoomType == 1 then
		-- 0位置是房主
		self.isRoomCreater = false
	end

	gComm.UIUtils.removeLoadingTips()
	self.playMjLayer:removeAllChildren()
	self:playerEnterRoom(msgTbl)

	cc.UserDefault:getInstance():setIntegerForKey("gameTotalPlayer", 3)
end


--------------------------------
-- @class function
-- @description 接收房间添加玩家消息
-- @param msgTbl 消息体
-- end --
function m:onRcvAddPlayer(msgTbl)
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
	roomPlayer.displaySeatIdx = (msgTbl.m_pos + self.seatOffset) % 3 + 1
	roomPlayer.readyState = msgTbl.m_ready
	roomPlayer.score = msgTbl.m_score
	roomPlayer.leftCardsNum = 17
	roomPlayer.bombTimes = 0
	roomPlayer.isOwner = 0
	-- 房间添加玩家
	self:roomAddPlayer(roomPlayer)
end


--------------------------------
-- @class function
-- @description 从房间移除一个玩家
-- @param msgTbl 消息体
-- end --
function m:onRcvRemovePlayer(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	-- local roomPlayer = self.roomPlayers[seatIdx]
	local roomPlayer,k = self:getRemovePlayerInfo(seatIdx)
	if roomPlayer then
		-- 隐藏玩家信息
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
		playerInfoNode:setVisible(false)
		-- 隐藏玩家准备手势
		local readySignNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readySign")
		local readySignSpr = gComm.UIUtils.seekNodeByName(readySignNode, "Spr_readySign_" .. roomPlayer.displaySeatIdx)
		readySignSpr:setVisible(false)
		-- 取消头像下载监听
		local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
		if self.playerHeadMgr then
			self.playerHeadMgr:detach(headSpr)
			self.playerHeadMgr:setDefaultIcon(headSpr)
		end
		-- 播放退出动画
		self:playDisappearAction(self.rootNode,playerInfoNode:getPositionX(),playerInfoNode:getPositionY())
		-- 去除数据
		-- self.roomPlayers[seatIdx] = nil
		table.remove(self.roomPlayers,k)
	end

	cc.UserDefault:getInstance():setIntegerForKey("gameCurrentPlayer", self:getRoomPlayerAmount() or 1)
end

function m:getRemovePlayerInfo(seatIdx)
	for k,v in pairs(self.roomPlayers) do
		if v.seatIdx == seatIdx then
			return v,k
		end
	end
end

--------------------------------
-- @class function
-- @description 断线重连
-- end --
function m:onRcvSyncRoomState(msgTbl,isStart)
	gComm.UIUtils.seekNodeByName(self.rootNode , "btn_startGame"):setVisible(false)
	if msgTbl.m_state == 1 then
		if (self.m_curCircle and self.m_curCircle == 0 and self.m_isCircle == -1) or
			(self.m_curCircle and self.m_curCircle == 0 and self.m_isCircle == 0)
		 then
			-- 等待状态
			if self.isRoomCreater then
				self.UIRoomInfoExClass:setBtnBackLobby(false)
		 	else
				self.UIRoomInfoExClass:setBtnBackLobby(true)
		 	end
		end
		return
	end
	-- 隐藏等待界面元素
	local readyPlayNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readyPlay")
	readyPlayNode:setVisible(false)
	-- 游戏开始后隐藏准备标识
	self:hidePlayersReadySign()
	local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
	readyBtn:setVisible(false)

	self:removeAlarm()

	self.mBombCount = 0
	self.mBombTimes = msgTbl.m_difen or 1


	self.mTimesText:setString(self.mBombTimes)

	-- 显示游戏中按钮
	local playBtnsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playBtns")
	playBtnsNode:setVisible(true)
	if msgTbl.m_pos then
		-- 显示当前出牌座位标示
		local seatIdx = msgTbl.m_pos + 1
		self:setTurnSeatSign(seatIdx)
		if seatIdx == self.playerSeatIdx then
			-- 玩家选择出牌
			self.isPlayerShow = true
		end
	end

	-- 当前出的牌
	self.outCard = {}
	self.mGameStyle = 0

	for seatIdx, roomPlayer in ipairs(self.roomPlayers) do
		-- 玩家持有牌
		roomPlayer.holdMjTiles = {}
		roomPlayer.uselessTiles = {}
		-- 玩家已出牌
		roomPlayer.outMjTiles = {}
		self.myCard = {}
		-- 麻将放置参考点
		roomPlayer.mjTilesReferPos = self:setPlayerMjTilesReferPos(roomPlayer.displaySeatIdx)
		-- 剩余持有牌数量
		local size = cc.Director:getInstance():getWinSize()
		local realSeat = (seatIdx+self.seatOffset)%3
  		if realSeat == 0 then
  			realSeat = 3
  		end

		if isStart ~= true then
			self.isTouch = true
		end

		if self.gParam.roomType == DefineRule.RoomType.BigMatch and msgTbl.m_IsTuoguan then
			local isTuoGuan = msgTbl.m_IsTuoguan[seatIdx]
			if self.gParam.sPosSelf == seatIdx-1 then
				self.gParam.isTuoGuan = isTuoGuan
				self.UIRoomInfoExClass:setTuoGuanBtnShow(not isTuoGuan)
			else
				-- self.UIPlayer:setTuoGuanFlag(seatIdx-1,isTuoGuan)
				local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
				gComm.UIUtils.seekNodeByName(playerInfoNode, "iconTuoGuanFlag"):setVisible(isTuoGuan)
			end
		end

		if roomPlayer.seatIdx == self.playerSeatIdx then


			log("onRcvSyncRoomState self.deal = "..tostring(self.deal))


			if self.deal == true and isStart == true then --正常游戏流程，非断线重连
				if msgTbl.m_gameStyle == 1 then
					-- for i=1,17 do
					-- 	self:addOppositeMjTileToPlayer()
					-- end
					-- self:sortAninationPlayerMjTiles()
					self.start = false

					log("onRcvSyncRoomState self.start = "..tostring(self.start))
				else

					local callFunc1 = cc.CallFunc:create(function(sender)
						-- for i=1,#msgTbl.m_card do
						-- 	self:addOppositeMjTileToPlayer()
						-- end
						-- self:sortAninationPlayerMjTiles()
			     	end)

			     	local delayTime1 = cc.DelayTime:create(0.08*16)
			     	local delayTime2 = cc.DelayTime:create(0.12*16)

					local callFunc2 = cc.CallFunc:create(function(sender)
						if msgTbl.m_card then
							for _, v in ipairs(msgTbl.m_card) do
								self:addMjTileToPlayer(v)
							end
						    -- 根据花色大小排序并重新放置位置
							self:sortFinalPlayerMjTiles()
						end
			     	end)

			     	local callFunc3 = cc.CallFunc:create(function(sender)
						if #roomPlayer.uselessTiles > 0 then
							for i,v in ipairs(roomPlayer.uselessTiles) do
							v.mjTileSpr:removeFromParent()
							end
						end
						roomPlayer.uselessTiles = {}
						if msgTbl.m_diZhuPos == nil and self.doingAskIndex ~= nil then  -- m_diZhuPos==nil 正常流程 ,自己是房主，首先抢地主
							local seatIdx = self.doingAskIndex + 1
							if seatIdx == self.playerSeatIdx then
								self.decisionBtnNode:setVisible(true)
								self.prompt:setVisible(false)
								self.play:setVisible(false)
								self.pass:setVisible(false)
								self.restore:setVisible(false)
								if self.gParam.isJiaoFenGame then
									self.nograb:setVisible(false)
									self.grab:setVisible(false)
								else
									self.nograb:setVisible(true)
									self.grab:setVisible(true)
								end
								self:showPoint(true,seatIdx,12)
								self:playTimeCDStart(12,true)

								local roomPlayer = self.roomPlayers[self.playerSeatIdx]
								local isSmallKing = false
								local isBigKing = false
								local is2_1 = false
								local is2_2 = false
								local is2_3 = false
								local is2_4 = false
								if roomPlayer and roomPlayer.holdMjTiles then
									for i,v in ipairs(roomPlayer.holdMjTiles) do
										if v.mjIndex == 48 then
											is2_1 = true
										elseif v.mjIndex == 49 then
											is2_2 = true
										elseif v.mjIndex == 50 then
											is2_3 = true
										elseif v.mjIndex == 51 then
											is2_4 = true
										elseif v.mjIndex == 52 then
											isSmallKing = true
										elseif v.mjIndex == 53 then
											isBigKing = true
										end
									end
								end

								if self.gParam.isJiaoFenGame then

										if self._gameType == 2 then --抢地主
											if self.gameState == 0 then -- 如果是叫地主阶段
												self.nograb:setVisible(true)
												self.grab:setVisible(true)
												self.nodeRob:setVisible(false)
											elseif self.gameState == 1 then -- 如果是抢地主阶段
												self.nograb:setVisible(false)
												self.grab:setVisible(false)
												self.nodeRob:setVisible(true)
											end
										elseif self._gameType == 1 then

											if self.jiaofenStatus and self.jiaofenStatus == 5 then
												-- 加倍
												self.nograb:setVisible(false)
												self.grab:setVisible(false)
												self.nodeScore:setVisible(false)

												self.nodeDouble:setVisible(true)
												self.nodeGen:setVisible(false)
											elseif self.jiaofenStatus and self.jiaofenStatus == 6 then
												-- 跟
												self.nograb:setVisible(false)
												self.grab:setVisible(false)
												self.nodeScore:setVisible(false)

												self.nodeDouble:setVisible(false)
												self.nodeGen:setVisible(true)
											else
												if self.curScore == 1 then
													self.scoreOne:setEnabled(false)
													self.scoreTwo:setEnabled(true)
												elseif self.curScore == 2 then
													self.scoreOne:setEnabled(false)
													self.scoreTwo:setEnabled(false)
												else
													self.scoreOne:setEnabled(true)
													self.scoreTwo:setEnabled(true)
												end

												self.nograb:setVisible(false)
												self.grab:setVisible(false)
												self.nodeScore:setVisible(true)

												self.nodeDouble:setVisible(false)
												self.nodeGen:setVisible(false)
											end
										end
								end

								if self.gParam.isJiaoFenGame then
									if (isSmallKing and isBigKing) or (is2_1 and is2_2 and is2_3 and is2_4) then
										self.scorePass:setEnabled(false)
									else
										self.scorePass:setEnabled(true)
									end
								else
									if (isSmallKing and isBigKing) or (is2_1 and is2_2 and is2_3 and is2_4) then
										self.nograb:setEnabled(false)
									else
										self.nograb:setEnabled(true)
									end
								end
							end
							if self.mDizhuPos == nil then
								-- 显示三张底牌
								self.mLastHandsNode:setVisible(true)
								for i=1,3 do
									local pkTileBg = gComm.UIUtils.seekNodeByName(self.mLastHandsNode, "LastHand_"..i)
									pkTileBg:setVisible(true)
									pkTileBg:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
								end
							end

						end
						--显示玩家剩余牌数
						for i=1,2 do
							local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_"..i)
							leftCardBg:setVisible(true)
							local leftCardNum = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_"..i)
							if self.showShouPaiAmount then
								leftCardNum:setVisible(true)
							else
								leftCardNum:setVisible(false)
							end
						end
						self.start = false
						log("onRcvSyncRoomState self.start 2= "..tostring(self.start))
			     	end)


			     	--local sequence = cc.Sequence:create(callFunc1,delayTime1,callFunc2,delayTime2,callFunc3)
			     	local sequence = cc.Sequence:create(callFunc2,delayTime2,callFunc3)
			     	self:runAction(sequence)


				end


		     	self.deal = false
			else --断线，重新进入游戏,对自己断线的操作
				--玩家持有牌
				if msgTbl.m_card then
					if #msgTbl.m_card > 0 then
						for _, v in ipairs(msgTbl.m_card) do
							self:addMjTileToPlayer(v)
						end
						-- 根据花色大小排序并重新放置位置
						self:sortPlayerMjTiles(self.mGameStyle)
					elseif msgTbl.m_gameStyle == 1 then
						-- for i=1,17 do
						-- 	self:addOppositeMjTileToPlayer()
						-- end
						-- self:sortAninationPlayerMjTiles()
					end

				end
				-- 如果自己是地主，添加地主角标
				if msgTbl.m_diZhuPos then
					self.mDizhuPos = msgTbl.m_diZhuPos + 1
					if self.mDizhuPos == self.playerSeatIdx then
						for k, pkTile in ipairs(roomPlayer.holdMjTiles) do
							if self.mDizhuPos == self.playerSeatIdx then
								local landLordIcon = cc.Sprite:createWithSpriteFrameName("Image/CardsPoker/p_landlord_icon.png")
								landLordIcon:setAnchorPoint(cc.p(1,1))
								landLordIcon:setPosition(landlordPos)
								pkTile.mjTileSpr:addChild(landLordIcon)
							end
						end
					end
				end

				if not self.showShouPaiAmount then
					self:addAlarmTip(roomPlayer.seatIdx , #msgTbl.m_card)
				end
			end
		else
			-- 更新别人剩余牌数量显示
			if msgTbl.m_cardNum then
				roomPlayer.leftCardsNum = msgTbl.m_cardNum[roomPlayer.seatIdx]
			else
				roomPlayer.leftCardsNum = 17
			end
			local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_" .. roomPlayer.displaySeatIdx)
			leftCardBg:setVisible(true)
			local leftCardsNumLabel = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_" .. roomPlayer.displaySeatIdx)
			if leftCardsNumLabel then
				if self.showShouPaiAmount then
					leftCardsNumLabel:setVisible(true)
					leftCardsNumLabel:setString(tostring(roomPlayer.leftCardsNum))
				else
					leftCardsNumLabel:setVisible(false)
				end
			end

			if not self.showShouPaiAmount then
				if self.gParam.isJiaoFenGame then
					self:addAlarmTip(roomPlayer.seatIdx , roomPlayer.leftCardsNum)
				else
					self:addAlarmTip(roomPlayer.seatIdx , #msgTbl.m_card)
				end
			end
		end

		-- 断线重连，公共元素的操作
		-- 玩家已出牌
		local card
		if seatIdx == 1 then
			card = msgTbl.m_out0
		elseif seatIdx == 2 then
			card = msgTbl.m_out1
		elseif seatIdx == 3 then
			card = msgTbl.m_out2
		end
		if card then
			for i,v in ipairs(card) do
				self:addAlreadyOutMjTiles(seatIdx, v)
			end
		end

		-- 玩家炸弹数
		if msgTbl.m_CurBomb then
			local bombNum = msgTbl.m_CurBomb[seatIdx]

			roomPlayer.bombTimes = bombNum
			if (self.mBombCount + bombNum) <= self.mMaxFanShu then
				self.mBombCount = self.mBombCount + bombNum
				if bombNum > 0 then
					for i=1,bombNum do
						self.mBombTimes = self.mBombTimes * 2
					end
				end
			else
				self.mBombCount = self.mMaxFanShu
			end

			log("Seatidx:"..seatIdx.."   BombCount:"..bombNum .. "  TotalBomb:"..self.mBombCount)
			local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
			local bombTimesText = gComm.UIUtils.seekNodeByName(playerInfoNode, "AtlasLabel_BombTimes")
			bombTimesText:setString(roomPlayer.bombTimes)
		end

		-- 显示地主农民标识
		if msgTbl.m_diZhuPos and msgTbl.m_diZhuPos ~= -1 then --地主已抢完

			local seatIdx = msgTbl.m_diZhuPos + 1
			local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
			playerInfoNode:setVisible(true)
			local avatarSpr = gComm.UIUtils.seekNodeByName(playerInfoNode,"Spr_head")

			if seatIdx == roomPlayer.seatIdx then -- 地主
				local landLordAvatar = playerInfoNode:getChildByName("TransAvatar_" .. roomPlayer.displaySeatIdx)
				if landLordAvatar then
					landLordAvatar:removeFromParent()
				end

				landLordAvatar = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/play_flag_landlord.png")

				landLordAvatar:setAnchorPoint(cc.p(0,0))
				landLordAvatar:setPosition(cc.p(avatarSpr:getPositionX()+3,avatarSpr:getPositionY()-3))
				landLordAvatar:setName("TransAvatar_" .. roomPlayer.displaySeatIdx)
				playerInfoNode:addChild(landLordAvatar)

			end
		end


	end

	if self.gParam.isJiaoFenGame then
		if msgTbl.m_nUserBeishu and #msgTbl.m_nUserBeishu > 0 then
			self.mBombTimes = tonumber(msgTbl.m_nUserBeishu[self.playerSeatIdx])
			self.mTimesText:setString(""..self.mBombTimes)
		end
		-- 断线重连，公共元素的操作
		-- 三张底牌
		if msgTbl.m_dipai and #msgTbl.m_dipai ~= 0 and msgTbl.m_diZhuPos ~= -1 then
			self:showLastHandPoker(msgTbl.m_dipai,true)
		elseif msgTbl.m_dipai and #msgTbl.m_dipai == 0 then
			self:showLastHandPokerBg()
		end
	else
		-- 断线重连，公共元素的操作
		-- 三张底牌
		if msgTbl.m_dipai and #msgTbl.m_dipai ~= 0 and msgTbl.m_diZhuPos ~= -1 then
			self:showLastHandPoker(msgTbl.m_dipai,true)
		elseif msgTbl.m_dipai and #msgTbl.m_dipai == 0 and msgTbl.m_diZhuPos ~= -1 then
			self:showLastHandPokerBg()
		end
		if self.mGameStyle == 0 then
			self.mTimesText:setString(2^self.mBombCount)
		elseif self.mGameStyle == 1 then
			--玩家倍数
			if msgTbl.m_nUserBeishu then
				self.mBombTimes = msgTbl.m_nUserBeishu[self.playerSeatIdx]
				self.mTimesText:setString(self.mBombTimes)
			end
		end
	end

	self.mOperTipsNode:setVisible(false)
	for i = 1,3 do
		local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
		operTips:setVisible(false)

		-- local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)
		-- operTipsBg:setVisible(false)
	end
	self.UIRoomInfoExClass:setBtnBackLobby(false)
end

--------------------------------
-- @class function
-- @description 玩家准备手势
-- @param msgTbl 消息体
-- end --
function m:onRcvReady(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	if seatIdx == self.playerSeatIdx then
		local str = "第" .. (self.playmes.m_playCircle or 1).. "/" ..self.playmes.m_maxCircle .. "局"
		self.UIRoomInfoExClass:setRoundIndex(str)

		self:removeallscene()
		if self.mUISettlementOneRound and (not tolua.isnull(self.mUISettlementOneRound)) then
			self.mUISettlementOneRound:removeFromParent()
			self.mUISettlementOneRound = nil
		end
	end

	self:playerGetReady(seatIdx)
end


--------------------------------
-- @class function
-- @description 玩家在线标识
-- @param msgTbl 消息体
-- end --
function m:onRcvOffLineState(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	local roomPlayer = self.roomPlayers[seatIdx]
	local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
	-- 离线标示
	local offLineSignSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_offLineSign")
	offLineSignSpr:setZOrder(20000)
	local Spr_head = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
	local spr_headFrame = gComm.UIUtils.seekNodeByName(playerInfoNode, "spr_headFrame")
	if msgTbl.m_flag == 0 then
		-- 掉线了
		offLineSignSpr:setVisible(true)
		gComm.ShaderUtils.darkNode(Spr_head)
		gComm.ShaderUtils.darkNode(spr_headFrame)
	elseif msgTbl.m_flag == 1 then
		-- 回来了
		offLineSignSpr:setVisible(false)
		Spr_head:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
		spr_headFrame:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
	end
end

--------------------------------
-- @class function
-- @description 当前局数/最大局数量
-- @param msgTbl 消息体
-- end --
function m:onRcvRoundState(msgTbl)
	-- 牌局状态,剩余牌
	local s = string.format("%d/%d", (msgTbl.m_curCircle + 1), msgTbl.m_curMaxCircle)
	log("onRcvRoundState:"..s)
	if self.isRoomCreater or msgTbl.m_curCircle + 1 > 1 then
 		gComm.UIUtils.seekNodeByName(self.rootNode , "btn_startGame"):setVisible(false)
		self.UIRoomInfoExClass:setBtnBackLobby(false)
	else
		self.UIRoomInfoExClass:setBtnBackLobby(true)
 	end
 	self.playmes.m_playCircle = msgTbl.m_curCircle + 1

	local str = "第" .. (msgTbl.m_curCircle + 1).. "/" .. msgTbl.m_curMaxCircle .. "局"
	self.UIRoomInfoExClass:setRoundIndex(str)
 	self.m_curCircle = msgTbl.m_curCircle
 	self.m_isCircle = msgTbl.m_isCircle
end

--------------------------------
-- @class function
-- @description 游戏开始
-- @param msgTbl 消息体
-- end --
function m:onRcvStartGame(msgTbl)
	log("start game!!!!")

	-- 清理总结算数据
	self.finalReportData = nil
	self.lastRound = false
	self.curRoomPlayers = {}

	if self.playMjLayer then
		self.playMjLayer:removeAllChildren()
		-- 隐藏手牌
		self.mLastHandsNode:setVisible(false)
	end

	-- 重置炸弹倍数显示
	for seatIdx,roomPlayer in ipairs(self.roomPlayers) do
		roomPlayer.bombTimes = 0
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
		local bombTimesText = gComm.UIUtils.seekNodeByName(playerInfoNode, "AtlasLabel_BombTimes")
		bombTimesText:setString(roomPlayer.bombTimes)
	end

	self.isAddDouble = 0
	self.isAddGen = 0
	self.jiaofenStatus = 0
	--隐藏地主，农民标签
	for i = 1, 3 do
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. i)
		local avatarSpr = gComm.UIUtils.seekNodeByName(playerInfoNode,"Spr_head")
		avatarSpr:setVisible(true)
		local transAvatar = playerInfoNode:getChildByName("TransAvatar_" .. i)
		if transAvatar then
			log("RemoveTransAvatar")
			transAvatar:removeFromParent()
		end
	end

	-- 移除警报灯
	local alarmNode = gComm.UIUtils.seekNodeByName(self.rootNode , "Node_alarm")
	for i=1,3 do
		-- 移除警报灯
		local Node_alarm = gComm.UIUtils.seekNodeByName(alarmNode , "Node_alarm_"..i)
		if Node_alarm:getChildrenCount()  > 0 then
			Node_alarm:removeAllChildren()
		end
		Node_alarm:setVisible(false)
	end

	-- 显示底牌牌背
	self:showLastHandPokerBg()

	self.mBombCount = 0
	self.mBombTimes = 1
	self.mTimesText:setString(self.mBombTimes)


	self.UIRoomInfoExClass:setBtnBackLobby(false)
	self.start = true
	self.deal  = true

	log("onRcvStartGame self.start = "..tostring(self.start))

	self:onRcvSyncRoomState(msgTbl,true)

	local readyPlayNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readyPlay")
	readyPlayNode:setVisible(false)

	if self.mUISettlementOneRound and (not tolua.isnull(self.mUISettlementOneRound)) then
		self.mUISettlementOneRound:removeFromParent()
		self.mUISettlementOneRound = nil
	end
end

--------------------------------
-- @class functio
-- @description 通知玩家出牌
-- @param msgTbl 消息体
-- end --
function m:onRcvTurnShowMjTile(msgTbl)
	log("通知玩家出牌")
	local seatIdx = msgTbl.m_pos + 1
	local roomPlayer = self.roomPlayers[seatIdx]
	local sound
	-- 玩家需要处理的数据
	self.curPlayUserIdx = seatIdx
	self.curShowMjTileInfo = msgTbl
	self.promptIndex = #msgTbl.m_array
	self.maxPromptIndex = #msgTbl.m_array
	self.optimalPoker = {}
	for i,v in ipairs(roomPlayer.holdMjTiles) do
		v.mjTileSpr:setColor(cc.c3b(255,255,255))
		v.mjIsTouch = true
	end
	if self.start then
		self:showPoint(false,seatIdx,msgTbl.m_time)
	else
		self:showPoint(true,seatIdx,msgTbl.m_time)
	end



	-- --变灰牌归位
	-- for j=1, #roomPlayer.holdMjTiles do
	-- 	if roomPlayer.holdMjTiles[j].mjIsTouch == false then
	-- 		self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
	-- 	end
	-- end

	-- --该玩家出牌时自动提示玩家出牌
	-- if #msgTbl.m_array == 1 then
	-- 	if seatIdx == self.playerSeatIdx then
	-- 		self.SelectCard = {}
	-- 		local showCard = self.curShowMjTileInfo.m_array[self.promptIndex]
	-- 		for i,v in ipairs(showCard) do
	-- 			for j=1, #roomPlayer.holdMjTiles do
	-- 				if roomPlayer.holdMjTiles[j].mjIndex == v then
	-- 						self.SelectCard[#self.SelectCard+1] = j
	-- 				end
	-- 			end
	-- 		end

	-- 		--众神归位
	-- 		for j=1, #roomPlayer.holdMjTiles do
	-- 			self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
	-- 		end
	-- 		--提起
	-- 		for j=1, #self.SelectCard do
	-- 			self:setPokerIsUp(roomPlayer.holdMjTiles[self.SelectCard[j]], true, true)
	-- 		end

	-- 		self.promptIndex = self.promptIndex-1
	-- 		if self.promptIndex == 0 then
	-- 		self.promptIndex = self.maxPromptIndex
	-- 		end
	-- 		-- self.play:setEnabled (true)
	-- 		-- self.play:setColor(cc.c3b(255,255,255))
	-- 	end
	-- end

	-- 出牌倒计时
	if self.start then
		self:playTimeCDStart(msgTbl.m_time,false)
	else
		self:playTimeCDStart(msgTbl.m_time,true)
	end

	for i,v in ipairs(self.roomPlayers[seatIdx].outMjTiles) do
		v.mjTileSpr:removeFromParent()
	end
	self.roomPlayers[seatIdx].outMjTiles = {}

	-- 轮到玩家出牌 m_flag 当前是否第一个出牌 0-是（没有上家） 1-不是
	if seatIdx == self.playerSeatIdx then
		if msgTbl.m_last == 1  then -- 最后一手牌自动打出
	     	local delayTime = cc.DelayTime:create(0.3)
	     	local msgToSend = {}
			msgToSend.m_msgId = NetCmd.MSG_CG_SHOW_MJTILE
			msgToSend.m_flag = 0
			msgToSend.m_card = {}
			msgToSend.m_card = self.curShowMjTileInfo.m_array[1]
	     	local callFunc = cc.CallFunc:create(function(sender)
				gt.socketClient:sendMessage(msgToSend)
				end)
			local sequence = cc.Sequence:create(delayTime, callFunc)
			self:runAction(sequence)
		else
			if #msgTbl.m_array == 0 and msgTbl.m_flag == 0 then
				self.decisionBtnNode:setVisible(true)

				-- self.prompt:setVisible(true)
				-- self.prompt:setPosition(self.btnPromptPosition2)

				-- self.play:setVisible(true)
				-- self.play:setPosition(self.btnPlayPosition2)

				-- self.restore:setVisible(true)
				-- self.restore:setPosition(self.btnResetPosition2)

				self.play:setVisible(true)
				self.play:setPosition(cc.p(640,295))

				self.restore:setVisible(true)
				self.restore:setPosition(cc.p(549.5,295))

				self.restore:setVisible(false)


				self.prompt:setVisible(false)

				self.pass:setVisible(false)
				self.pass:setPosition(self.btnPassPosition)

				self.grab:setVisible(false)
				self.nograb:setVisible(false)
			elseif #msgTbl.m_array == 0 and msgTbl.m_flag == 1 then

				self.decisionBtnNode:setVisible(true)

				self.pass:setVisible(true)
				self.pass:setPosition(cc.p(640,296))

				self.play:setVisible(false)
				self.prompt:setVisible(false)
				self.restore:setVisible(false)
				self.grab:setVisible(false)
				self.nograb:setVisible(false)
			else
				self.decisionBtnNode:setVisible(true)

				self.prompt:setVisible(true)
				self.prompt:setPosition(self.btnPromptPosition)

				self.play:setVisible(true)
				self.play:setPosition(self.btnPlayPosition)

				self.restore:setVisible(true)
				self.restore:setPosition(self.btnResetPosition)

				self.restore:setVisible(false)

				self.pass:setVisible(true)
				self.pass:setPosition(self.btnPassPosition)

				self.grab:setVisible(false)
				self.nograb:setVisible(false)
			end

		end
	end

	if seatIdx == self.playerSeatIdx then

		if #msgTbl.m_cardUnusable > 0 then
			for i=1,#msgTbl.m_cardUnusable do
				for j=1,#roomPlayer.holdMjTiles do
					if msgTbl.m_cardUnusable[i] == roomPlayer.holdMjTiles[j].mjIndex then
						roomPlayer.holdMjTiles[j].mjTileSpr:setColor(cc.c3b(200,200,200))
						roomPlayer.holdMjTiles[j].mjIsTouch = false
						-- self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
						local poker = roomPlayer.holdMjTiles[j]
						if self.isTouch == true then
							poker.mjTileSpr:stopAllActions()
						end
						local mjTilesReferPos = roomPlayer.mjTilesReferPos
						local _mjTilePos = mjTilesReferPos.holdStart
						local mjTilePos = cc.p(poker.mjTileSpr:getPosition())
						poker.mjTileSpr:setPosition(cc.p(mjTilePos.x, _mjTilePos.y))
					end
				end
			end
		end
	end
	if self.mGameStyle == 1 and self.mClearSiChuanTips then
		self.mClearSiChuanTips = false
		local delayTime = cc.DelayTime:create(1.5)
		local callFunc = cc.CallFunc:create(function(sender)
			self.mOperTipsNode:setVisible(false)
			for i = 1,3 do
				local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
				operTips:setVisible(false)

				-- local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)
				-- operTipsBg:setVisible(false)
			end
		end)


		local seqAction = cc.Sequence:create(delayTime, callFunc)
		self:runAction(seqAction)

	end

	if self.playerSeatIdx == seatIdx then
		if self.gParam.isJiaoFenGame == true then
			self.nodeScore:setVisible(false)
			self.nodeDouble:setVisible(false)
			self.nodeGen:setVisible(false)
		end
		self.nograb:setVisible(false)
		self.grab:setVisible(false)
	end
end

-- start --
--------------------------------
-- @class function
-- @description 广播玩家出牌
-- end --
function m:onRcvSyncShowMjTile(msgTbl)
	dump(msgTbl,"===onRcvSyncShowMjTileonRcvSyncShowMjTile===")
	local seatIdx = msgTbl.m_pos + 1
	local realSeat = (seatIdx+self.seatOffset)%3
  	if realSeat == 0 then
  		realSeat = 3
  	end
  	-- self.appear = false
	-- 座位号（1，2，3）
	local roomPlayer = self.roomPlayers[seatIdx]
	local card = msgTbl.m_card
	local mjTilesReferPos
	-- 出牌成功
	if msgTbl.m_errorCode == 0 then
		if seatIdx == self.playerSeatIdx then
			self.SelectCard = {}
			-- self.prompt:setEnabled(true)
		end
		mjTilesReferPos = self:animationPlayerMjTilesReferPos(realSeat)
		self:showPoint(false,seatIdx,10)
	end

	local size = cc.Director:getInstance():getWinSize()
	if msgTbl.m_errorCode == 1 then -- 出牌失败
		self.decisionBtnNode:setVisible(true)
		gComm.UIUtils.floatText("牌型错误")
		return
	end
	-- if msgTbl.m_errorCode == 2 then -- 出牌失败
	-- 	gComm.UIUtils.floatText("必须带黑桃三")
	-- 	return
	-- end
	-- if msgTbl.m_errorCode == 3 then -- 出牌失败
	-- 		gComm.UIUtils.floatText("报单必须出最大")
	-- 	return
	-- end
	if msgTbl.m_flag == 1  then
		local num = math.random(1,4)
		local sound = "ddz/man/buyao" .. num
		if roomPlayer.sex == 1 then
			sound = "ddz/man/buyao" .. num
		else
			sound = "ddz/woman/buyao" .. num
		end
		gComm.SoundEngine:playEffect(sound)
		local realSeat = (seatIdx+self.seatOffset)%3
	  	if realSeat == 0 then
	  		realSeat = 3
	  	end
	  	self.mOperTipsNode:setVisible(true)
		for i = 1,3 do
			local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
			--local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)

			if realSeat ~= i then
				operTips:setVisible(false)
				--operTipsBg:setVisible(false)
			else
				local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("Image/GameSub/GameDDZ/play_buchu.png")
				if spriteFrame then
					operTips:setSpriteFrame(spriteFrame)
				end
				operTips:setVisible(true)
				--operTipsBg:setVisible(true)
				operTips:stopAllActions()
				local delayTime = cc.DelayTime:create(1)
				local callFunc = cc.CallFunc:create(function(sender)
					operTips:setVisible(false)
					--operTipsBg:setVisible(false)
				end)
				operTips:runAction(cc.Sequence:create(delayTime,callFunc))
			end
		end
	end
	if self.decisionBtnNode:isVisible() == true then
		self.decisionBtnNode:setVisible(false)
	end
	-- 出牌需要将之前的牌清理掉
	if #self.outCard > 0 then
		for i,v in ipairs(self.outCard) do
			v.mjTileSpr:removeFromParent()
		end
		self.outCard = {}
	end
	--如果是玩家自己出的牌
	if seatIdx == self.playerSeatIdx then
		for i,v in ipairs(roomPlayer.holdMjTiles) do
			v.mjTileSpr:setColor(cc.c3b(255,255,255))
			v.mjIsTouch = true
		end
		--self:removeAlreadyOutMjTiles(seatIdx)
		for i,v in ipairs(card) do
			self:addAlreadyOutMjTiles(seatIdx, v, nil, #card)
			--遍历当前手牌如果有就删掉一个
			for j=1, #roomPlayer.holdMjTiles do
				if roomPlayer.holdMjTiles[j].mjIndex == v then
					--删除
					roomPlayer.holdMjTiles[j].mjTileSpr:removeFromParent()
					table.remove(roomPlayer.holdMjTiles, j)
					break
				end
			end
		end
		-- 根据花色大小排序并重新放置位置x
		if  msgTbl.m_flag ~= 1 then
			self:sortPlayerMjTiles(self.mGameStyle)
		end

		if not self.showShouPaiAmount then
			self:addAlarmTip(roomPlayer.seatIdx , #roomPlayer.holdMjTiles)
		end
	else
		for i,v in ipairs(card) do
			self:addAlreadyOutMjTiles(seatIdx, v)
		end
		-- 更新别人剩余牌数量显示
		roomPlayer.leftCardsNum = roomPlayer.leftCardsNum - #card
		local leftCardsNumLabel = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_" .. roomPlayer.displaySeatIdx)
		if leftCardsNumLabel then
			if self.showShouPaiAmount then
				leftCardsNumLabel:setVisible(true)
				leftCardsNumLabel:setString(tostring(roomPlayer.leftCardsNum))
			else
				leftCardsNumLabel:setVisible(false)
			end
		end

		if not self.showShouPaiAmount then
			self:addAlarmTip(roomPlayer.seatIdx , roomPlayer.leftCardsNum)
		end
	end


	local sprActTemplateLast
	local actImageName
	local sprActTemplateFir

	local mjTileFir = roomPlayer.outMjTiles[1]
	if mjTileFir and mjTileFir.mjTileSpr then
		sprActTemplateFir = mjTileFir.mjTileSpr
	end
	local mjTileLast = roomPlayer.outMjTiles[#roomPlayer.outMjTiles]
	if mjTileLast and mjTileLast.mjTileSpr then
		sprActTemplateLast = mjTileLast.mjTileSpr
	end


	if msgTbl.m_flag ~= 1  then
		local sound
		local num = math.random(1,3)
		if msgTbl.m_dzztype == m.CardType.card_style_double then
			local value , color = self:changePk(card[1])
			if roomPlayer.sex == 1 then
				sound = string.format("ddz/man/dui%d", value)
			else
				sound = string.format("ddz/woman/dui%d",value)
			end
		elseif msgTbl.m_dzztype == m.CardType.card_style_single then
			local value , color = self:changePk(card[1])
			if roomPlayer.sex == 1 then
				sound = string.format("ddz/man/pk_%d", value)
			else
				sound = string.format("ddz/woman/pk_%d",value)
			end
		elseif msgTbl.m_dzztype == m.CardType.card_style_three then
			if msgTbl.m_flag == 2 then
				local value , color = self:changePk(card[1])
				if roomPlayer.sex == 1 then
					sound = string.format("ddz/man/Man_tuple%d",value)
				else
					sound = string.format("ddz/woman/Woman_tuple%d",value)
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end

		elseif msgTbl.m_dzztype == m.CardType.card_style_three_single then
			if msgTbl.m_flag == 2 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/sandaiyi"
				else
					sound = "ddz/woman/sandaiyi"
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end
		elseif msgTbl.m_dzztype == m.CardType.card_style_three_double then
			if msgTbl.m_flag == 2 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/sandaiyidui"
				else
					sound = "ddz/woman/sandaiyidui"
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end
		elseif msgTbl.m_dzztype == m.CardType.card_style_three_list or msgTbl.m_dzztype == m.CardType.card_style_three_list_single or msgTbl.m_dzztype == m.CardType.card_style_three_list_double then
			if msgTbl.m_flag == 2 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/feiji"
				else
					sound = "ddz/woman/feiji"
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end
			gComm.SoundEngine:playEffect("common/Special_plane", false, false)
			-- local sprite = self:playAnimation("feiji",22,mjTilesReferPos.outStart.x,mjTilesReferPos.outStart.y)
			-- self:hideAnimation(sprite,1.5,"feiji")


			actImageName = "Image/GameSub/GameDDZ/play_cardType_feiji.png"


		elseif msgTbl.m_dzztype == m.CardType.card_style_single_list then
			if msgTbl.m_flag == 2 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/shunzi"
				else
					sound = "ddz/woman/shunzi"
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end
			gComm.SoundEngine:playEffect("common/Special_star", false, false)
			-- local sprite = self:playAnimation("shunzi",27,mjTilesReferPos.outStart.x,mjTilesReferPos.outStart.y)
			-- self:hideAnimation(sprite,2.1,"shunzi")

			actImageName = "Image/GameSub/GameDDZ/play_cardType_shunzi.png"



		elseif msgTbl.m_dzztype == m.CardType.card_style_double_list then
			if msgTbl.m_flag == 2 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/liandui"
				else
					sound = "ddz/woman/liandui"
				end
			elseif msgTbl.m_flag == 0 then
				if roomPlayer.sex == 1 then
					sound = "ddz/man/dani" .. num
				else
					sound = "ddz/woman/dani" .. num
				end
			end
			gComm.SoundEngine:playEffect("common/Special_flower", false, false)
			-- local sprite = self:playAnimation("liandui",18,mjTilesReferPos.outStart.x,mjTilesReferPos.outStart.y)
			-- self:hideAnimation(sprite,1.2,"liandui")


			actImageName = "Image/GameSub/GameDDZ/play_cardType_liandui.png"


		elseif msgTbl.m_dzztype == m.CardType.card_style_bomb2 then
			if roomPlayer.sex == 1 then
				sound = "ddz/man/zhadan"
			else
				sound = "ddz/woman/zhadan"
			end
			-- local sprite = self:playAnimation("zhadan",16,mjTilesReferPos.outStart.x,mjTilesReferPos.outStart.y)
			-- self:hideAnimation(sprite,1.1,"zhadan")
			-- gComm.SoundEngine:playEffect("common/Special_Bomb_New", false, false)
			-- --炸弹动画

			self:throwBoom(roomPlayer.displaySeatIdx)


			-- 对映玩家的炸弹数增加
			roomPlayer.bombTimes = roomPlayer.bombTimes + 1
			local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
			local bombTimesText = gComm.UIUtils.seekNodeByName(playerInfoNode, "AtlasLabel_BombTimes")
			bombTimesText:setString(roomPlayer.bombTimes)
			self.mBombCount = self.mBombCount + 1
			if self.mBombCount <= self.mMaxFanShu then

				self.mBombTimes = self.mBombTimes * 2
				self.mTimesText:setString(self.mBombTimes)

				local action = cc.Sequence:create(cc.ScaleTo:create(0.2,2),cc.ScaleTo:create(0.2,1.0))
				self.mTimesText:runAction(action)
			end


		elseif msgTbl.m_dzztype == m.CardType.card_style_rocket then
			if roomPlayer.sex == 1 then
				sound = "ddz/man/wangzha"
			else
				sound = "ddz/woman/wangzha"
			end

			gComm.SoundEngine:playEffect("common/Special_Bomb_New", false, false)
			-- --王炸动画

			actImageName = "Image/GameSub/GameDDZ/play_cardType_wangzha.png"


			-- 对映玩家的炸弹数增加
			roomPlayer.bombTimes = roomPlayer.bombTimes + 1
			local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
			local bombTimesText = gComm.UIUtils.seekNodeByName(playerInfoNode, "AtlasLabel_BombTimes")
			bombTimesText:setString(roomPlayer.bombTimes)
			self.mBombCount = self.mBombCount + 1
			if self.mBombCount <= self.mMaxFanShu then

				self.mBombTimes = self.mBombTimes * 2
				self.mTimesText:setString(self.mBombTimes)
				local action = cc.Sequence:create(cc.ScaleTo:create(0.2,2),cc.ScaleTo:create(0.2,1.0))
				self.mTimesText:runAction(action)
			end


		elseif msgTbl.m_dzztype == m.CardType.card_style_four2 then
			if roomPlayer.sex == 1 then
				sound = "ddz/man/sidaier"
			else
				sound = "ddz/woman/sidaier"
			end
		end


		gComm.SoundEngine:playEffect(sound)
		gComm.SoundEngine:playEffect("common/Special_give", false, true)
	end


	if actImageName and sprActTemplateFir and sprActTemplateLast then

		local sprAct = cc.Sprite:createWithSpriteFrameName(actImageName)
		local pos = cc.p(sprActTemplateFir:getPosition())

		local dis = sprActTemplateLast:getPositionX() - sprActTemplateFir:getPositionX()

		local time

		if dis > 0 then
			pos = cc.p(sprActTemplateFir:getPosition())
		else
			pos = cc.p(sprActTemplateLast:getPosition())
			dis = 0 - dis
		end

		time = dis / 100
		sprAct:setPosition(pos)
		time = 1

		local moveBy = cc.MoveBy:create(time, cc.p(dis,0) )

		local removeSelf =  cc.RemoveSelf:create(true)

		local seq =  cc.Sequence:create( moveBy, removeSelf)

		sprAct:runAction(seq)

		--self.playMjLayer:addChild(sprAct, sprActTemplateLast:getPositionX() + 1)
		self.playMjLayer:addChild(sprAct, 2000)

	end

end

--几秒隐藏动画
function m:hideAnimation(sp,time,image)
	local delayTime = cc.DelayTime:create(time)
	local callFunc1 = cc.CallFunc:create(function(sender)
		sp:setVisible(false)
		sp:removeFromParent()
	end)
	local sequence = cc.Sequence:create(delayTime, callFunc1)
	sp:runAction(sequence)
end

--播放牌型类型效果动画plist
function m:playAnimation(image,count,x,y)
	local cache = cc.SpriteFrameCache:getInstance()
	local imagestr = ".plist"
	cache:addSpriteFrames(imagestr)
    local spritebatch = cc.Sprite:createWithSpriteFrameName(image .. "1.png")
    spritebatch:setPosition(cc.p(x,y))
   	self.rootNode:addChild(spritebatch,10)
    local animFrames = {}
    for i = 1,count do
        local frame = cache:getSpriteFrame( string.format(image .. "%d.png", i) )
        animFrames[i] = frame
    end
    local animation = cc.Animation:createWithSpriteFrames(animFrames, 1/12)

    spritebatch:runAction(cc.Sequence:create(cc.Animate:create(animation)))
    return spritebatch
end


function m:onRcvChatMsg(msgTbl)
	local weizhi = 0
	if msgTbl.m_type == 4 then
		--语音
		gComm.SoundEngine:pauseAllSound()
		local num1,num2 = string.find(msgTbl.m_musicUrl, "\\")
		local curUrl = string.sub(msgTbl.m_musicUrl,1,num2-1)
		local videoTime = string.sub(msgTbl.m_musicUrl,num2+1)
		log("the play voide url is .." .. curUrl)
		log("the play voide videoTime is .." .. videoTime)

		videoTime = tonumber(videoTime)
		local voiceData = {}
		voiceData.m_curUrl = curUrl
		voiceData.m_videoTime = videoTime
		voiceData.m_pos = msgTbl.m_pos

		self.yuYinUrl = self.yuYinUrl ~= nil and self.yuYinUrl or {}

		table.insert(self.yuYinUrl,voiceData)

		local function playVoice( voiceData )
			local curUrl = voiceData.m_curUrl
			local videoTime = voiceData.m_videoTime
			gComm.SoundEngine:pauseAllSound()

			if gComm.FunUtils.IsiOSPlatform() then
				local ok = self.luaBridge.callStaticMethod("AppController", "playVoice", {voiceUrl = curUrl})
			elseif gComm.FunUtils.IsAndroidPlatform() then
				local ok = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "playVoice", {curUrl}, "(Ljava/lang/String;)V")
			end

			log("the play voide end ")
			self.yuyinChatNode:setVisible(true)
			self.rootNode:reorderChild(self.yuyinChatNode, 110)

			local seatIdx = voiceData.m_pos + 1
			for i = 1, 4 do
				if self.voiceGroup and self.voiceGroup[i] then
					local voiceNode = self.voiceGroup[i][2]
					local voiceAni = self.voiceGroup[i][1]
					voiceNode:setVisible(false)
					voiceAni:pause()
				end
			end
			local roomPlayer = self.roomPlayers[seatIdx]
			local voiceNode = self.voiceGroup[roomPlayer.displaySeatIdx][2]
			local voiceAni = self.voiceGroup[roomPlayer.displaySeatIdx][1]
			voiceNode:setVisible(true)
			voiceAni:gotoFrameAndPlay(0, true)

			self.yuyinChatNode:stopAllActions()

			local fadeInAction = cc.FadeIn:create(1)
			local delayTime = cc.DelayTime:create(videoTime)
			local fadeOutAction = cc.FadeOut:create(0.2)
			local callFunc = cc.CallFunc:create(function(sender)
				voiceNode:setVisible(false)
				voiceAni:pause()

				gComm.SoundEngine:resumeAllSound()
				table.remove(self.yuYinUrl,1)
				if #self.yuYinUrl > 0 then
					local voiceData = self.yuYinUrl[1]
					playVoice(voiceData)
				end
			end)

			self.yuyinChatNode:runAction(cc.Sequence:create(fadeInAction, delayTime, fadeOutAction, callFunc))
		end

		if self.yuyinChatNode:getNumberOfRunningActions() <= 0 then
			if #self.yuYinUrl > 0 then
				local voiceData = self.yuYinUrl[1]
				playVoice(voiceData)
			end
		end
	else

		local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_chatBg")
		chatBgNode:setVisible(true)

		local chatAniNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_chatAni")
		for i=1,3 do
			local chatBgImg = gComm.UIUtils.seekNodeByName(chatBgNode, "Img_playerChatBg_" .. i)
			chatBgImg:setVisible(false)
		end


		local seatIdx = msgTbl.m_pos + 1

		local roomPlayer = self.roomPlayers[seatIdx]
		local chatBgImg = gComm.UIUtils.seekNodeByName(chatBgNode, "Img_playerChatBg_" .. roomPlayer.displaySeatIdx)
		chatBgImg:setVisible(true)


		local msgLabel = gComm.UIUtils.seekNodeByName(chatBgImg, "Label_msg")

		local emojiSprName = "Spr_emoji" .. roomPlayer.displaySeatIdx
		local emojiSpr = gComm.UIUtils.seekNodeByName(chatAniNode, emojiSprName)

		emojiSpr:stopAllActions()
		emojiSpr:removeAllChildren()
		emojiSpr:setVisible(true)


		local isTextMsg = false

		if msgTbl.m_type == DefineRoom.ChatType.FIX_MSG then

			isTextMsg = true

			local specFixMsgId = ""

			local specFixMsg = true


			local textStr = string.format("LTKey_0028_%d", msgTbl.m_id)
			msgLabel:setString(ConfigTxtTip.GetConfigTxt(textStr))
			isTextMsg = true

			local musicFixMsg =""

			if roomPlayer.sex == 1 then
				-- 男性
				musicFixMsg = musicFixMsg.."man/"
			else
				-- 女性
				musicFixMsg = musicFixMsg.."woman/"
			end


			local musicStr = string.format("fix_msg_%d" , msgTbl.m_id)
			musicFixMsg = musicFixMsg..musicStr

			gComm.SoundEngine:playEffect(musicFixMsg)

		elseif msgTbl.m_type == DefineRoom.ChatType.INPUT_MSG then
			msgLabel:setString(msgTbl.m_msg)
			isTextMsg = true
		elseif msgTbl.m_type == DefineRoom.ChatType.EMOJI then
			chatBgImg:setVisible(false)
			local picStr = string.sub(msgTbl.m_msg,1,10)

			local animationStr = "Csd/Animation/Expression/".. picStr .. ".csb"
			local animationNode, animationAction = gComm.UIUtils.createCSAnimation(animationStr)
			animationAction:gotoFrameAndPlay(0, true)
			animationNode:setPosition(cc.p(0,0))
			emojiSpr:addChild(animationNode)

			local chatBgNode_delayTime = cc.DelayTime:create(3)
			local chatBgNode_callFunc = cc.CallFunc:create(function(sender)

				sender:stopAllActions()
				sender:removeAllChildren()
				sender:setVisible(false)
				display.removeSpriteFrames("Texture/Animation/AnimExpression.plist","Texture/Animation/AnimExpression/biaoqing.png")
			end)

			local chatBgNode_Sequence = cc.Sequence:create(chatBgNode_delayTime,
											 chatBgNode_callFunc)
			emojiSpr:runAction(chatBgNode_Sequence)
			isTextMsg = false
		end


		if msgTbl.m_type == DefineRoom.ChatType.FIX_MSG or
			msgTbl.m_type == DefineRoom.ChatType.INPUT_MSG then

			chatBgImg:setVisible(true)

			local chatBgSize = chatBgImg:getContentSize()
			local bgWidth = chatBgSize.width

			if isTextMsg then
				local labelSize = msgLabel:getContentSize()
				bgWidth = labelSize.width + 30
				msgLabel:setPositionX(bgWidth * 0.5)
			end

			chatBgImg:setContentSize(cc.size(bgWidth, chatBgSize.height))

			chatBgNode:stopAllActions()
			local fadeInAction = cc.FadeIn:create(0.5)
			local delayTime = cc.DelayTime:create(1)
			local fadeOutAction = cc.FadeOut:create(0.5)
			local callFunc = cc.CallFunc:create(function(sender)
				chatBgImg:setVisible(false)
				chatBgNode:setVisible(true)
			end)

			chatBgNode:runAction(cc.Sequence:create(fadeInAction, delayTime, fadeOutAction, callFunc))
		end
	end
end

function m:removeAlarm()
    --隐藏动画
	for i = 1, 3 do
		local spr = self.rootNode:getChildByName("alarm" .. i)
		if spr then
			self.rootNode:removeChild(spr)
		end
	end

end

function m:onRcvRoundReport(msgTbl)
	dump(msgTbl,"====onRcvRoundReportonRcvRoundReport===" .. self.playerSeatIdx .. " " .. self.gParam.roomType)
	log("游戏结束")
	self.isRoundReport = true
	self.mClearSiChuanTips = true
	local curRoomPlayers = {}
	curRoomPlayers = self:copyTab(self.roomPlayers)

	for i,v in ipairs(msgTbl.m_chuntian) do
		if v == 1 then
			gComm.SoundEngine:playEffect("common/Special_Chuntian", false, false)
			local actImageName = "Image/GameSub/GameDDZ/play_cardType_chuntian.png"

			local sprAct = cc.Sprite:createWithSpriteFrameName(actImageName)
			sprAct:setPosition(cc.p(display.size.width /2 - 100,display.size.height/2))

			local dis = 200
			local moveBy = cc.MoveBy:create(1, cc.p(dis,0) )
			local removeSelf =  cc.RemoveSelf:create(true)

			local seq =  cc.Sequence:create( moveBy, removeSelf)
			sprAct:runAction(seq)
			self:addChild(sprAct, 2000)


			self.mBombCount = self.mBombCount + 1
			-- if self.mBombCount <= self.mMaxFanShu then

				self.mBombTimes = self.mBombTimes * 2
				self.mTimesText:setString(self.mBombTimes)
				local action = cc.Sequence:create(cc.ScaleTo:create(0.2,2),cc.ScaleTo:create(0.2,1.0))
				self.mTimesText:runAction(action)
			-- end

			break
		end
	end

	-- 停止播放倒计时警告音效
	if self.playCDAudioID then
		gComm.SoundEngine:stopEffect(self.playCDAudioID)
		self.playCDAudioID = nil
	end

	-- 清除三张底牌
	self:clearLastHand()

	self:removeAlarm()

	-- local delayTime = cc.DelayTime:create(1.9)
	local delayTime = cc.DelayTime:create(0)
	local callFunc = cc.CallFunc:create(function(sender)
		-- 停止未完成动作
		if self.startMjTileAnimation ~= nil then
			self.startMjTileAnimation:stopAllActions()
			self.startMjTileAnimation:removeFromParent()
			self.startMjTileAnimation = nil
		end
		self.SelectCard = {}
		-- 停止倒计时音效
		self.playTimeCD = nil
		self.deal = true
		self.isTouch = false
		-- self.prompt:setEnabled(false)
		-- 移除所有麻将
		--self.playMjLayer:removeAllChildren()
		-- 玩家准备手势隐藏
		self:hidePlayersReadySign()
		--隐藏闹钟
		local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_alarmbg")
	   	for i = 1, 3 do
			local point = gComm.UIUtils.seekNodeByName(chatBgNode, "Spr_point_"..i)
			point:setVisible(false)
	    end
		self.tag = {0,0,0}
		-- 隐藏倒计时
		self.playTimeCDLabel:setVisible(false)
		-- 隐藏决策
		local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
		decisionBtnNode:setVisible(false)

		-- 隐藏报警
		-- 移除警报灯
		local alarmNode = gComm.UIUtils.seekNodeByName(self.rootNode , "Node_alarm")
		for i=1,3 do
			-- 移除警报灯
			local Node_alarm = gComm.UIUtils.seekNodeByName(alarmNode , "Node_alarm_"..i)
			if Node_alarm:getChildrenCount()  > 0 then
				Node_alarm:removeAllChildren()
			end
		end

		if self.gParam.roomType == DefineRule.RoomType.BigMatch then
			if msgTbl.m_end == 0 then -- 不是最后一局
				local args = {
					msgTbl        = msgTbl,
					roomPlayers   = self.roomPlayers,
					playerSeatIdx = self.playerSeatIdx,
					isLastRound   = msgTbl.m_end == 1,
					mDizhuPos     = self.mDizhuPos,
					roomType	  = self.gParam.roomType,
				}
		   		self.mUISettlementOneRound = UISettlementOneRound:create(args)
				self:addChild(self.mUISettlementOneRound, m.ZOrder.ROUND_REPORT)
			end
		else
			-- 弹出局结算界面
			local args = {
				msgTbl        = msgTbl,
				roomPlayers   = self.roomPlayers,
				playerSeatIdx = self.playerSeatIdx,
				isLastRound   = msgTbl.m_end == 1,
				mDizhuPos     = self.mDizhuPos,
				roomType	  = self.gParam.roomType,
			}
	   		self.mUISettlementOneRound = UISettlementOneRound:create(args)
			self:addChild(self.mUISettlementOneRound, m.ZOrder.ROUND_REPORT)
		end
        self.mDizhuPos = nil

		if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
			local args = {btnOutRoom = true}
			self.UIRoomInfoExClass:setBtnVisible(args)

			for i=1,2 do
				local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_"..i):setVisible(false)
				local leftCardNum = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_"..i):setVisible(false)
			end
		end

	end)
	local seqAction = cc.Sequence:create(delayTime, callFunc)
	self:runAction(seqAction)
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

function m:onRcvFinalReport(msgTbl)
	if self.gParam.roomType == DefineRule.RoomType.BigMatch then
	else
		self.lastRound = true
		self.curRoomPlayers = self:copyTab(self.roomPlayers)
		self.finalReportData = msgTbl
		if not self.isRoundReport then
			local args = {
				curRoomPlayers = self.curRoomPlayers,
				msgTbl         = self.finalReportData,
				playerSeatIdx  = self.playerSeatIdx,
				playmes        = self.playmes,
				roomType       = self.gParam.roomType,
			}
			local finalReport = UISettlementFinal:create(args)
			self:addChild(finalReport, m.ZOrder.REPORT)
		end
	end
end

--------------------------------
-- @class function
-- @description 房间添加玩家
-- @param roomPlayer 玩家信息
-- end --
function m:roomAddPlayer(roomPlayer)
	-- 播放声音
	gComm.SoundEngine:playEffect("common/audio_enter_room",false,true)

	local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
	playerInfoNode:setVisible(true)

	gComm.UIUtils.seekNodeByName(playerInfoNode, "iconTuoGuanFlag"):setVisible(false)
	local fangFlag = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_bankerSign")
	fangFlag:setVisible(false)

	-- 头像
	local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
	self.playerHeadMgr:attach(headSpr, roomPlayer.uid, roomPlayer.headURL)
	-- 头像出现动画
	-- local orbit = cc.OrbitCamera:create(0.5, 0.3, 0, 0, 180, 0, 0)
	-- headSpr:runAction(orbit)

	-- 昵称
	local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_nickname")
	-- 名字只取四个字,并且清理掉其中的空格
	local nickname = string.gsub(roomPlayer.nickname," ","")
	nickname = string.gsub(nickname,"　","")
	nicknameLabel:setString(gComm.StringUtils.GetShortName(nickname))
	-- 积分
	local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")
    local str = roomPlayer.score
    if str > 10000 then
        str = string.format("%0.1f万",str/10000)
    end
    if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
        gComm.UIUtils.seekNodeByName(playerInfoNode, "imgCoin"):setVisible(true)
    else
        gComm.UIUtils.seekNodeByName(playerInfoNode, "imgCoin"):setVisible(false)
        scoreLabel:setPositionX(0)
    end
	scoreLabel:setString(str)
	roomPlayer.scoreLabel = scoreLabel
	-- 离线标示
	local offLineSignSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_offLineSign")
	offLineSignSpr:setVisible(false)

    -- 点击头像显示信息
	local headFrameBtn = gComm.UIUtils.seekNodeByName(playerInfoNode, "Btn_headFrame")
	headFrameBtn:setTag(roomPlayer.seatIdx)
	headFrameBtn:setZOrder(20000)
	local avatarTouchArea = gComm.UIUtils.seekNodeByName(playerInfoNode, "TouchArea")
	avatarTouchArea:setTag(roomPlayer.seatIdx)
	gComm.BtnUtils.setButtonClick(avatarTouchArea,handler(self, self.showPlayerInfo))
	-- -- 添加入缓冲
	self.roomPlayers[roomPlayer.seatIdx] = roomPlayer
	-- 准备标示
	if roomPlayer.readyState == 1 then
		self:playerGetReady(roomPlayer.seatIdx)
	end
	-- 如果已经三个人了,隐藏微信分享按钮,显示聊天,设置按钮
	if #self.roomPlayers == 3 then
		-- 隐藏等待界面元素
		local readyPlayNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readyPlay")
		readyPlayNode:setVisible(false)
		-- 显示游戏中按钮（消息，设置）
		local playBtnsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playBtns")
		playBtnsNode:setVisible(true)
	end
	cc.UserDefault:getInstance():setIntegerForKey("gameCurrentPlayer", self:getRoomPlayerAmount() or 1)
end

--------------------------------
-- @class function
-- @description 玩家自己进入房间
-- @param msgTbl 消息体
-- end --
function m:playerEnterRoom(msgTbl)
	self:getLocation()
	-- 房间中的玩家
	self.roomPlayers = {}
	-- 玩家自己放入到房间玩家中
	local roomPlayer = {}

	local selfPlayerInfo = cc.exports.gData.ModleGlobal:getSelfInfo()
		-- userID   = 0,
		-- nikeName = "",--昵称
		-- nikeNameShort = "",--简化昵称
		-- sex      = 1,--1男，2女
		-- headURL  = "",--头像地址
		-- IP       = "",--ip地址
		-- GM       = 1,--gm号. -- 是否是gm 0不是  1是
		-- isGM     = false,
	--zy
	roomPlayer.holdMjTiles = {}
	roomPlayer.outMjTiles = {}
	roomPlayer.uid = selfPlayerInfo.userID
	roomPlayer.nickname = selfPlayerInfo.nikeName
	roomPlayer.headURL = selfPlayerInfo.headURL
	roomPlayer.sex = selfPlayerInfo.sex
	roomPlayer.ip = selfPlayerInfo.IP
	roomPlayer.seatIdx = msgTbl.m_pos + 1
	-- 玩家座位显示位置
	roomPlayer.displaySeatIdx = 3
	roomPlayer.readyState = msgTbl.m_ready
	roomPlayer.score = msgTbl.m_score
	roomPlayer.leftCardsNum = 17
	roomPlayer.bombTimes = 0
	roomPlayer.isOwner = 1


	-- 房间编号
	self.roomID = msgTbl.m_deskId
	-- 玩家座位编号
	self.playerSeatIdx = roomPlayer.seatIdx
	-- 玩家显示固定座位号
	self.playerFixDispSeat = 3
	-- 逻辑座位和显示座位偏移量(从0编号开始)
	local seatOffset = (self.playerFixDispSeat - 1) - msgTbl.m_pos
	self.seatOffset = seatOffset
	-- 玩家出牌类型
	self.isPlayerShow = false
	self.isPlayerDecision = false

	-- 添加玩家自己
	self:roomAddPlayer(roomPlayer)
	self.mTimesText:setString(0)

	if roomPlayer.readyState == 0 then
		-- 未准备显示准备按钮
		local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
		readyBtn:setVisible(true)
	end
	--若打完一局玩家有一个杀死进程，其他两个玩家显示解散房间按钮
	if msgTbl.m_curCircle and msgTbl.m_curCircle >= 1 then
		self.UIRoomInfoExClass:setBtnBackLobby(false)
	end

end

--------------------------------
-- @class function
-- @description 发送玩家准备请求消息
-- end --
function m:readyBtnClickEvt()
	gComm.SoundEngine:playEffect("common/SpecOk", false, true)
	local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
	readyBtn:setVisible(false)
	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_READY
	msgToSend.m_pos = self.playerSeatIdx - 1
	gt.socketClient:sendMessage(msgToSend)
end


--------------------------------
-- @class function
-- @description 玩家进入准备状态
-- @param seatIdx 座次
-- end --
function m:playerGetReady(seatIdx)
	local roomPlayer = self.roomPlayers[seatIdx]
	-- 显示玩家准备手势
	local readySignNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readySign")
	local readySignSpr = gComm.UIUtils.seekNodeByName(readySignNode, "Spr_readySign_" .. roomPlayer.displaySeatIdx)
	readySignSpr:setVisible(true)
	readySignSpr:setZOrder(2000000000000)
	-- 玩家本身
	if seatIdx == self.playerSeatIdx then
		-- 隐藏准备按钮
		local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
		readyBtn:setVisible(false)
	end
end

--------------------------------
-- @class function
-- @description 隐藏所有玩家准备手势标识
-- end --
function m:hidePlayersReadySign()
	for i = 1, 3 do
		local readySignNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readySign")
		local readySignSpr = gComm.UIUtils.seekNodeByName(readySignNode, "Spr_readySign_" .. i)
		readySignSpr:setZOrder(2000000000000)
		readySignSpr:setVisible(false)
	end
end

--------------------------------
-- @class function
-- @description 显示玩家具体信息面板
-- @param sender
-- end --
function m:showPlayerInfo(sender)
	gComm.SoundEngine:playEffect("common/SpecOk", false, true)
	local senderTag = sender:getTag()
	local roomPlayer = self.roomPlayers[senderTag]
	if not roomPlayer then
		return
	end
	local isCanRemovePlayer = 0
	if self.playmes.m_playCircle > 1 then
		isCanRemovePlayer = 1
	end
	local playerInfoTips = UIPlayerInfoTips:create(isCanRemovePlayer,self.playerSeatIdx,roomPlayer,3)

	self.playerInfoTips = playerInfoTips
	self:addChild(playerInfoTips, m.ZOrder.PLAYER_INFO_TIPS)
end

function m:animationPlayerMjTilesReferPos(displaySeatIdx)
	local mjTilesReferPos = {}
	local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
	local mjTilesReferNode = gComm.UIUtils.seekNodeByName(playNode, "Node_playerMjTiles_" .. displaySeatIdx)
	-- 打出牌数据
	local mjTileOutSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_1")
	local mjTileOutSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_2")
	mjTilesReferPos.outStart = cc.p(mjTileOutSprF:getPosition())
	mjTilesReferPos.outSpaceH = cc.pSub(cc.p(mjTileOutSprS:getPosition()), cc.p(mjTileOutSprF:getPosition()))
	return mjTilesReferPos
end

--------------------------------
-- @class function
-- @description 设置玩家麻将基础参考位置
-- @param displaySeatIdx 显示座位编号
-- @return 玩家麻将基础参考位置
-- end --
function m:setPlayerMjTilesReferPos(displaySeatIdx)
	local mjTilesReferPos = {}
	local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
	local settingNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_alarm")
	local mjTilesReferNode = gComm.UIUtils.seekNodeByName(playNode, "Node_playerMjTiles_" .. displaySeatIdx)

	local alarm = gComm.UIUtils.seekNodeByName(settingNode,"Node_alarm_"..displaySeatIdx)
	mjTilesReferPos.alarmPosition = cc.p(alarm:getPosition())

	if displaySeatIdx == 3 then
		-- 持有牌数据
		local mjTileHoldSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_1")
		local mjTileHoldSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_2")
		mjTilesReferPos.holdStart = cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints()))
		mjTilesReferPos.holdSpace = cc.pSub(cc.p(mjTileHoldSprS:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints())),
		cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints())))
	end

	-- 打出牌数据
	local mjTileOutSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_1")
	local mjTileOutSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_2")
	local mjTileOutSprT = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_3")
	mjTilesReferPos.outStart = cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints()))
	mjTilesReferPos.outSpaceH = cc.pSub(cc.p(mjTileOutSprS:getPosition()), cc.p(mjTileOutSprF:getPosition()))
	mjTilesReferPos.outSpaceV = cc.pSub(cc.p(mjTileOutSprT:getPosition()), cc.p(mjTileOutSprF:getPosition()))
	return mjTilesReferPos
end

--------------------------------
-- @class function
-- @description 出牌倒计时
-- @param
-- @param
-- @param
-- @return
-- end --
function m:playTimeCDStart(timeDuration,appear)
	self.playTimeCD = timeDuration
	self.isVibrateAlarm = false
	self.playTimeCDLabel:setVisible(appear)
	self.playTimeCDLabel:setString(tostring(timeDuration))
end

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
	--  (self.isPlayerShow or self.isPlayerDecision) and
	if self.playTimeCD <= 3 and not self.isVibrateAlarm and self.curPlayUserIdx == self.playerSeatIdx then
		-- 剩余3s开始播放警报声音+震动一下手机
		self.isVibrateAlarm = true
		local defaultVibrate = cc.UserDefault:getInstance():getIntegerForKey("settingVibrate", 1)
		if defaultVibrate == 1 then
			-- 播放声音
			self.playCDAudioID = gComm.SoundEngine:playEffect("common/timeup_alarm",false,true)
			-- 震动提醒
			cc.Device:vibrate(1)
		end
	end
	local timeCD = math.ceil(self.playTimeCD)
	self.playTimeCDLabel:setString(tostring(timeCD))
end

function m:addOppositeMjTileToPlayer()
	local pkTileName = "Image/CardsPoker/p0_0.png"
	local pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
	self.playMjLayer:addChild(pkTileSpr)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local pkTile = {}
	pkTile.mjTileSpr = pkTileSpr
	pkTile.mjColor = 4
	pkTile.mjNumber = 0
	pkTile.mjIndex = 0
	pkTile.mjIsUp = false
	table.insert(roomPlayer.uselessTiles, pkTile)
	return pkTile
end


--------------------------------
-- @class function
-- @description 给玩家发牌
-- @param mjColor
-- @param mjNumber
-- end --
function m:addMjTileToPlayer(msg)
	local value , color = self:changePk(msg)
	log("addMjTileToPlayer==",value , color)
	local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
	local pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
	-- local pkTileSpr = gComm.SpriteUtils.createSpriteWithSpriteFrameNameEx(pkTileName,"Texture/CardsPoker.plist")
	pkTileSpr:setName(tostring(msg))
	pkTileSpr:setPosition(cc.p(-100,-100))
	self.playMjLayer:addChild(pkTileSpr)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local pkTile = {}
	pkTile.mjTileSpr = pkTileSpr
	pkTile.mjColor = color
	pkTile.mjNumber = value
	pkTile.mjIndex = msg
	pkTile.mjIsUp = false
	pkTile.mjIsTouch  = true

	if self.mDizhuPos == self.playerSeatIdx then
		local landLordIcon = cc.Sprite:createWithSpriteFrameName("Image/CardsPoker/p_landlord_icon.png")
		landLordIcon:setAnchorPoint(cc.p(1,1))
		landLordIcon:setPosition(landlordPos)
		pkTile.mjTileSpr:addChild(landLordIcon)
	end
	table.insert(roomPlayer.holdMjTiles, pkTile)
	return pkTile
end

--将消息转换为花色和牌型
function m:changePk(poker)
	local value
	local color
	if poker < 44 then
		local x =  math.modf(poker / 4)
		value = math.modf((x + 3) % 14)
		color =  math.modf(poker % 4)
	elseif poker <= 47 then
		value = 1
		color =  math.modf(poker % 4)
	elseif poker <= 51 then
		value = 2
		color =  math.modf(poker % 4)
	elseif poker == 52 then--小王
		value = 14
		color = 5
	elseif poker == 53 then-- 大王
		value = 15
		color = 6
	end

	color = self:changeColor(color)

	return value , color

end

function m:changeColor( color )
 	if color == 0 then
 		color = 4
 	elseif color == 1 then
 		color = 3
 	elseif color == 2 then
 		color = 2
 	elseif color == 3 then
 		color = 1
 	end

 	return color
 end


function m:sortFinalPlayerMjTiles()
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	-- 计算牌开始的位置
	local cardNum = #roomPlayer.holdMjTiles -- 当前手牌数量
	local tileWidth = 155
	local tileHeight = 216
	-- 计算所有牌加起来的宽度
	-- local totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	local totalWidth = 1240
	local space = (totalWidth - tileWidth) / (cardNum - 1)
	if space > tileWidth / 2 then
		mjTilesReferPos.holdSpace.x = tileWidth / 2 - 3
		totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	else
		mjTilesReferPos.holdSpace.x = space

	end

	local mjTilePos = mjTilesReferPos.holdStart
	local startX = (display.size.width - totalWidth) / 2 + tileWidth / 2
	mjTilePos.x = startX
	for k, mjTile in ipairs(roomPlayer.holdMjTiles) do
		mjTile.mjTileSpr:stopAllActions()
		mjTile.mjTileSpr:setPosition(mjTilePos.x,mjTilePos.y)
		mjTile.mjTileSpr:setVisible(false)
		self.playMjLayer:reorderChild(mjTile.mjTileSpr, mjTilePos.x)
		mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
	end
	self.isTouch = false
	local k = 1
	for i = 1, #roomPlayer.holdMjTiles do
		local mjTile = roomPlayer.holdMjTiles[i]
		local delayTime = cc.DelayTime:create(0.05*k)
		local callFunc = cc.CallFunc:create(function(sender)
			mjTile.mjTileSpr:setVisible(true)
			if i ==  #roomPlayer.holdMjTiles then
				self.isTouch = true
			end
		end)
		local sequence = cc.Sequence:create(delayTime,callFunc)
		mjTile.mjTileSpr:runAction(sequence)
		k = k + 1
	end
end

function m:sortAninationPlayerMjTiles()
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	-- 计算牌开始的位置
	local cardNum = #roomPlayer.uselessTiles -- 当前手牌数量
	local tileWidth = 155
	local tileHeight = 216
	-- 计算所有牌加起来的宽度
	-- local totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	local totalWidth = 1240
	local space = (totalWidth - tileWidth) / (cardNum - 1)
	if space > tileWidth / 2 then
		mjTilesReferPos.holdSpace.x = tileWidth / 2 - 3
		totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	else
		mjTilesReferPos.holdSpace.x = space

	end

	local mjTilePos = mjTilesReferPos.holdStart
	local startX = (display.size.width - totalWidth) / 2 + tileWidth / 2
	mjTilePos.x = startX

	for k, mjTile in ipairs(roomPlayer.uselessTiles) do
		mjTile.mjTileSpr:setPosition(2000,mjTilePos.y)
		local delayTime = cc.DelayTime:create(0.08*k)
		local moveTo = cc.MoveTo:create(0.1, cc.p(mjTilePos.x,mjTilePos.y))
		local sequence = cc.Sequence:create(delayTime,moveTo)
		mjTile.mjTileSpr:runAction(sequence)
		self.playMjLayer:reorderChild(mjTile.mjTileSpr, mjTilePos.x)
		mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
	end
end

--------------------------------
-- @class function
-- @description 玩家麻将牌根据花色，编号重新排序
-- end --
--------------------------------
-- @class function
-- @description 玩家麻将牌根据花色，编号重新排序
-- @param isgameStyle 游戏类型
-- @param isReorderPoker 是否对玩家手牌进行重新排序
-- @return
-- end --
function m:sortPlayerMjTiles(isgameStyle)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	-- 计算牌开始的位置
	local cardNum = #roomPlayer.holdMjTiles -- 当前手牌数量
	local tileWidth = 155
	local tileHeight = 216
	-- 计算所有牌总宽度
	-- local totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	local totalWidth = 1240
	local space = (totalWidth - tileWidth) / (cardNum - 1)
	if space > tileWidth / 2 then
		mjTilesReferPos.holdSpace.x = tileWidth / 2 - 3
		totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
	else
		mjTilesReferPos.holdSpace.x = space

	end

	local mjTilePos = mjTilesReferPos.holdStart
	local startX = (display.size.width - totalWidth) / 2 + tileWidth / 2
	mjTilePos.x = startX

	for k, mjTile in ipairs(roomPlayer.holdMjTiles) do
		mjTile.mjTileSpr:stopAllActions()
		mjTile.mjTileSpr:setPosition(mjTilePos.x,mjTilePos.y)
		self.playMjLayer:reorderChild(mjTile.mjTileSpr, mjTilePos.x)
		mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
	end
end

--------------------------------
-- @class function
-- @description 选中玩家麻将牌
-- @return 选中的麻将牌
-- end --
function m:touchPlayerMjTiles(touch)
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	if roomPlayer and roomPlayer.holdMjTiles then
		for i=#roomPlayer.holdMjTiles, 1, -1  do
			local mjTile = roomPlayer.holdMjTiles[i];
			local touchPoint = mjTile.mjTileSpr:convertToNodeSpace(touch)
			local mjTileSize = mjTile.mjTileSpr:getContentSize()

			local mjTileRect = cc.rect(0, 0, mjTileSize.width, mjTileSize.height)
			if cc.rectContainsPoint(mjTileRect, touchPoint) then
				return mjTile, i
			end
		end
	end
	return nil
end

--------------------------------
-- @class function
-- @description 显示已出牌
-- @param seatIdx 座位号
-- @param mjColor 麻将花色
-- @param mjNumber 麻将编号
-- end --
function m:addAlreadyOutMjTiles(seatIdx, msg, isHide, isself)
	local value , color = self:changePk(msg)
	local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
	-- 添加到已出牌列表zy
	local roomPlayer = self.roomPlayers[seatIdx]
	-- if seatIdx == self.playerSeatIdx then
	local mjTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
	local mjTile = {}
	mjTile.mjTileSpr = mjTileSpr
	mjTile.mjColor = mjColor
	mjTile.mjNumber = mjNumber
	-- 如果自己是地主，添加地主角标
	if self.mDizhuPos == seatIdx then
		local landLordIcon = cc.Sprite:createWithSpriteFrameName("Image/CardsPoker/p_landlord_icon.png")
		landLordIcon:setAnchorPoint(cc.p(1,1))
		landLordIcon:setPosition(landlordPos)
		mjTileSpr:addChild(landLordIcon)
	end
	--table.insert( self.outCard, mjTile )
	table.insert(roomPlayer.outMjTiles, mjTile)
	--出牌动画
	mjTileSpr:setScale(0.8)
	local delayTime = cc.DelayTime:create(0.005)
	local callFunc2 = cc.CallFunc:create(function(sender)
		mjTileSpr:setScale( 0.66 )
	end)
	local seqAction = cc.Sequence:create(delayTime, callFunc2)
	mjTileSpr:runAction(seqAction)
	-- 显示已出牌
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.outStart
	local addPos = 0
	if isself then
		addPos = (isself*mjTilesReferPos.outSpaceH.x)/2	- 20
	end
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, #roomPlayer.outMjTiles))
	mjTileSpr:setPosition(mjTilePos.x-addPos,mjTilePos.y)
	self.playMjLayer:addChild(mjTileSpr, mjTilePos.x)
end

function m:addAlreadyOutMjTilesFinally(seatIdx, msg, num)
	local value , color = self:changePk(msg)
	local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
	-- 添加到已出牌列表zy
	local roomPlayer = self.roomPlayers[seatIdx]
	local mjTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
	local mjTile = {}
	mjTile.mjTileSpr = mjTileSpr
	mjTile.mjColor = mjColor
	mjTile.mjNumber = mjNumber
	-- 如果自己是地主，添加地主角标
	if self.mDizhuPos == seatIdx then
		local landLordIcon = cc.Sprite:createWithSpriteFrameName("Image/CardsPoker/p_landlord_icon.png")
		landLordIcon:setAnchorPoint(cc.p(1,1))
		landLordIcon:setPosition(landlordPos)
		mjTileSpr:addChild(landLordIcon)
	end
	table.insert(roomPlayer.outMjTiles, mjTile)
	local mjTilesReferPos = roomPlayer.mjTilesReferPos
	local mjTilePos = mjTilesReferPos.outStart
	mjTileSpr:setScale(0.66)
	mjTileSpr:setVisible(false)

	local lineCount = math.ceil(#roomPlayer.outMjTiles / 9) - 1
	local lineIdx = #roomPlayer.outMjTiles - lineCount * 9 - 1
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, lineCount))
	mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))
	mjTileSpr:setPosition(mjTilePos.x, mjTilePos.y)
	if seatIdx ~= self.playerSeatIdx then
		if num > 9 and num <= 18 then
			self.playMjLayer:addChild(mjTileSpr, mjTilePos.x + 100000)
		elseif num > 18 then
			self.playMjLayer:addChild(mjTileSpr, mjTilePos.x + 200000)
		else
			self.playMjLayer:addChild(mjTileSpr, mjTilePos.x)
		end
	end
	local offsetX
	if roomPlayer.displaySeatIdx > 1 then
		offsetX = mjTileSpr:getPositionX() + 10
	else
		offsetX = mjTileSpr:getPositionX() - 10
	end

	local delayTime = cc.DelayTime:create(0.02 * num * 0.8)
	local move1 = cc.MoveTo:create(0.1,cc.p(offsetX,mjTileSpr:getPositionY()))
	local move2 = cc.MoveTo:create(0.4,cc.p(mjTileSpr:getPositionX(),mjTileSpr:getPositionY()))
	local spawn = cc.Spawn:create(cc.Show:create(),cc.Sequence:create(move1,move2))
	-- local callFunc = cc.CallFunc:create(function (sender)
	-- 	mjTileSpr:setVisible(true)
	-- end)
	local seq = cc.Sequence:create(delayTime,spawn)
	mjTileSpr:runAction(seq)
end

--删除当前显示的已出牌
function m:removeAlreadyOutMjTiles( seatIdx )
	local roomPlayer = self.roomPlayers[seatIdx]
	for i=1, #roomPlayer.outMjTiles do
		roomPlayer.outMjTiles[i].mjTileSpr:removeFromParent()
	end
	roomPlayer.outMjTiles = {}
end

function m:backMainSceneEvt()
	log("GameJiaoFen----1")
	-- 事件回调
	gComm.EventBus.unRegAllEvent(self)
	-- 消息回调
	self:unregisterAllMsgListener()

    local args = {
        isShowCoinMain = false,
    }
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		args.isShowCoinMain = true
	end
    require("app.Game.Scene.SceneManager").goSceneLobby(args)
end

function m:onSendHeart(eventType)
	local action = cc.Sequence:create(cc.ScaleTo:create(0.2,2),cc.ScaleTo:create(0.2,1.0))
	self.mTimesText:runAction(action)
end

function m:startAudio()
	gComm.CallNativeMng.NativeYaya:startVoice()
end

function m:stopAudio()
		--停止录音
	if gComm.FunUtils.IsiOSPlatform() then
		local ok, ret = self.luaBridge.callStaticMethod("AppController", "stopVoice")
	elseif gComm.FunUtils.IsAndroidPlatform() then
		local ok, ret = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "stopVoice",nil,"()Z")
	end

	self.getVoiceTime = 0

	local getUrl = function (dela)

		-- body
		local ok, ret
		if gComm.FunUtils.IsiOSPlatform() then
			ok, ret = self.luaBridge.callStaticMethod("AppController", "getVoiceUrl")
		elseif gComm.FunUtils.IsAndroidPlatform() then
			ok, ret = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "getVoiceUrl", nil, "()Ljava/lang/String;")
		end

		log("the ret = " .. ret," ok = ",ok)

		if string.len(ret) > 0 and self.checkVoiceUrlType then
			log("_______the ret is .." .. ret)

			self.checkVoiceUrlType = false

			--获得到地址上传给服务器
			local msgToSend = {}
			msgToSend.m_msgId = NetCmd.MSG_CG_CHAT_MSG
			msgToSend.m_type = 4 -- 语音聊天
			msgToSend.m_musicUrl = ret
			gt.socketClient:sendMessage(msgToSend)

			gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
			self.voiceUrlScheduleHandler = nil
		else

			self.getVoiceTime = self.getVoiceTime + dela

			if self.getVoiceTime > 10 then
				if self.voiceUrlScheduleHandler then
					gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
					self.voiceUrlScheduleHandler = nil
				end
			end
		end
	end

	log("------------------- start check voice url")
	self.checkVoiceUrlType = true
	if self.voiceUrlScheduleHandler then
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.voiceUrlScheduleHandler)
		self.voiceUrlScheduleHandler = nil
	end
	self.voiceUrlScheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(getUrl, 0.2, false)
end

function m:cancelAudio()
	if gComm.FunUtils.IsiOSPlatform() then
		local ok, ret = self.luaBridge.callStaticMethod("AppController", "cancelVoice")
	elseif gComm.FunUtils.IsAndroidPlatform() then
		local ok, ret = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "cancelVoice",nil,"()Z")
	end
end

function m:onAlarm(msgTbl)
	if msgTbl then
		local seatIdx = msgTbl.m_pos + 1
		local roomPlayer = self.roomPlayers[seatIdx]
		--播放报警音效
		local sound = "ddz/man/buyao"
		if self.tag[seatIdx] == 0 then
			if msgTbl.m_leftCards == 1 then --剩余一张牌报警
				if roomPlayer.sex == 1 then
					sound = "ddz/man/baojing1"
				else
					sound = "ddz/woman/baojing1"
				end
			elseif msgTbl.m_leftCards == 2 then -- 剩余两张牌报警
				if roomPlayer.sex == 1 then
					sound = "ddz/man/baojing2"
				else
					sound = "ddz/woman/baojing2"
				end
			end

			if self.addAlarm > 0 then
				gComm.SoundEngine:playEffect(sound)
			end
		end
	end
end

function m:showPoint(isshow,seatindex,time)
 	local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_alarmbg")
  	local realSeat = (seatindex+self.seatOffset)%3
  	if realSeat == 0 then
  		realSeat = 3
  	end

 --    local animFrames = {}
 --    for i = 1,14 do
 --        local frame = cache:getSpriteFrame( string.format("naozhong%d.png", i) )
 --        animFrames[i] = frame
 --    end
 --    local animation = cc.Animation:createWithSpriteFrames(animFrames, 3/14)
 --    local delayTime1 = cc.DelayTime:create(17)
 --    log("delayTime1delayTime1",time)
   	for i = 1, 3 do
		local  spritebatch = gComm.UIUtils.seekNodeByName(chatBgNode, "Spr_point_"..i)
		if i == realSeat  then
			-- local sequence = cc.Sequence:create(delayTime1,cc.Animate:create(animation))
			-- sequence:setTag(999)
			-- spritebatch:stopActionByTag(999)
		 --    spritebatch:runAction(sequence)
		 --    spritebatch:setSpriteFrame("naozhong1.png")
			spritebatch:setVisible(isshow)
			self.playTimeCDLabel:setVisible(isshow)
			self.playTimeCDLabel:setPosition(cc.p(spritebatch:getPositionX(), spritebatch:getPositionY() +5 ))
		else
			spritebatch:setVisible(false)
		end
    end
end

function m:surplusCard(msgTbl)
 	for i=1,3 do
		local outMjTilesAry = msgTbl["m_cards" .. i - 1]
		if #outMjTilesAry > 0 then
			self:removeAlreadyOutMjTiles(i)
		end
		if outMjTilesAry then
			for k, v in ipairs(outMjTilesAry) do
				self:addAlreadyOutMjTilesFinally(i,v,k)
			end
		end

 	end
end


function m:IsSameIp(msgTbl)
	local SameIpNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_SameIP")
	SameIpNode:setZOrder(20000000000)
	local text = gComm.UIUtils.seekNodeByName(SameIpNode, "Text_4")
	local showStr = "玩家：".. msgTbl.m_nike[1] .. "与\n玩家："..msgTbl.m_nike[2] .. "为同一IP"
	local position = cc.p(SameIpNode:getPosition())
	local callFunc1 = cc.CallFunc:create(function(sender)
		SameIpNode:setPosition(position.x,position.y + 200)
		SameIpNode:setVisible(true)
		text:setString(showStr)
	end)
	local moveTo = cc.MoveTo:create(2, cc.p(position.x, position.y))
	local delayTime = cc.DelayTime:create(3)
	local moveTo1 = cc.MoveTo:create(2, cc.p(position.x, position.y + 600))
	local sequence = cc.Sequence:create(callFunc1,moveTo,delayTime,moveTo1)
	SameIpNode:runAction(sequence)
end

function m:checkVersion()
	local ok, appVersion = nil
	if gComm.FunUtils.IsiOSPlatform() then
		ok, appVersion = self.luaBridge.callStaticMethod("AppController", "getVersionName")
	elseif gComm.FunUtils.IsAndroidPlatform() then
		ok, appVersion = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "getAppVersionName", nil, "()Ljava/lang/String;")
	end
	local versionNumber = string.split(appVersion, '.')
	if tonumber(versionNumber[3]) < 7 then
		return false
	end
	return true
end

-- 播放玩家退出房间动画
function m:playDisappearAction(parent, x, y)
	-- 播放声音
	-- gComm.SoundEngine:playEffect("common/audio_exit_room",false,true)

	-- local smoke = cc.Sprite:createWithSpriteFrameName("tuichu-yanwu01.png")
	-- smoke:setAnchorPoint(cc.p(0.5,0.5))
	-- smoke:setPosition(cc.p(x,y))
	-- parent:addChild(smoke)

	-- local animFrames = {}
	-- for i = 1, 7 do
	-- 	local frame = cache:getSpriteFrame(string.format("tuichu-yanwu0%d.png",i))
	-- 	animFrames[i] = frame
	-- end
	-- local animation = cc.Animation:createWithSpriteFrames(animFrames,0.1)

	-- local sequence = cc.Sequence:create(cc.Animate:create(animation),cc.CallFunc:create(function (sender)
	-- 	smoke:removeFromParent()
	-- end))
	-- smoke:runAction(sequence)
end

function m:onRcvASKDIZHU(msgTbl)
	if self.gParam.isJiaoFenGame then
		self:onRcvASKDIZHU_JiaoFen(msgTbl)
	else
		self:onRcvASKDIZHU_JiaoDiZhu(msgTbl)
	end
end


function m:onRcvASKDIZHU_JiaoFen(msgTbl)
	log("onRcvASKDIZHU   " .. tostring(self.start))

	self.doingAskIndex = msgTbl.m_pos

	-- 记录抢地主的阶段
	self.gameState = msgTbl.m_state
	self.curScore = msgTbl.m_difen

	-- 控制低分
	self.mTimesText:setString(self.mBombTimes)

	local seatIdx = msgTbl.m_pos + 1

	if seatIdx == self.playerSeatIdx then
		self.jiaofenStatus = msgTbl.m_state
	end
	if seatIdx == self.playerSeatIdx and not self.start then
		-- 断线重连情况下，显示抢地主阶段按钮
		self.decisionBtnNode:setVisible(true)
		self.prompt:setVisible(false)
		self.play:setVisible(false)
		self.pass:setVisible(false)
		self.restore:setVisible(false)

		if msgTbl.m_state == 5 then
			self.nograb:setVisible(false)
			self.grab:setVisible(false)
			self.nodeDouble:setVisible(true)
			self.nodeGen:setVisible(false)
			self.nodeScore:setVisible(false)
		elseif msgTbl.m_state == 6 then
			self.nograb:setVisible(false)
			self.grab:setVisible(false)
			self.nodeDouble:setVisible(false)
			self.nodeGen:setVisible(true)
			self.nodeScore:setVisible(false)
		else
			if self._gameType == 1 then
				-- 根据分数屏蔽按钮
				if self.curScore == 1 then
					self.scoreOne:setEnabled(false)
					self.scoreTwo:setEnabled(true)
				elseif self.curScore == 2 then
					self.scoreOne:setEnabled(false)
					self.scoreTwo:setEnabled(false)
				else
					self.scoreOne:setEnabled(true)
					self.scoreTwo:setEnabled(true)
				end

				self.nograb:setVisible(false)
				self.grab:setVisible(false)
				self.nodeDouble:setVisible(false)
				self.nodeGen:setVisible(false)
				log("--------345-----22-----")
				self.nodeScore:setVisible(true)

				local roomPlayer = self.roomPlayers[self.playerSeatIdx]

				local isSmallKing = false
				local isBigKing = false
				local is2_1 = false
				local is2_2 = false
				local is2_3 = false
				local is2_4 = false
				if roomPlayer and roomPlayer.holdMjTiles then
					for i,v in ipairs(roomPlayer.holdMjTiles) do
						if v.mjIndex == 48 then
							is2_1 = true
						elseif v.mjIndex == 49 then
							is2_2 = true
						elseif v.mjIndex == 50 then
							is2_3 = true
						elseif v.mjIndex == 51 then
							is2_4 = true
						elseif v.mjIndex == 52 then
							isSmallKing = true
						elseif v.mjIndex == 53 then
							isBigKing = true
						end
					end
				end

				if (isSmallKing and isBigKing) or (is2_1 and is2_2 and is2_3 and is2_4) then
					self.scorePass:setEnabled(false)
				else
					self.scorePass:setEnabled(true)
				end
			end
		end


		if self.start == nil then
			self.mLastHandsNode:setVisible(true)
			--显示玩家剩余牌数
			for i=1,2 do
				local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_"..i)
				leftCardBg:setVisible(true)
				local leftCardNum = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_"..i)
				if self.showShouPaiAmount then
					leftCardNum:setVisible(true)
				else
					leftCardNum:setVisible(false)
				end
			end
		--elseif self.start == false then --上面一家没有抢地主，自己显示抢地主阶段按钮
		end
		self:showPoint(true,seatIdx,12)
		self:playTimeCDStart(12,true)
	else
		self:showPoint(true,seatIdx,12)
		self:playTimeCDStart(12,true)
	end
end

function m:onRcvASKDIZHU_JiaoDiZhu(msgTbl)
	log("onRcvASKDIZHU   " .. tostring(self.start))

	self.doingAskIndex = msgTbl.m_pos

	local seatIdx = msgTbl.m_pos + 1

	if seatIdx == self.playerSeatIdx then
		if self.start == nil then
			-- 断线重连情况下，显示抢地主阶段按钮
			self.decisionBtnNode:setVisible(true)
			self.prompt:setVisible(false)
			self.play:setVisible(false)
			self.pass:setVisible(false)
			self.restore:setVisible(false)
			self.nograb:setVisible(true)
			self.grab:setVisible(true)
			self.mLastHandsNode:setVisible(true)
			self:showPoint(true,seatIdx,12)
			self:playTimeCDStart(12,true)
			--显示玩家剩余牌数
			for i=1,2 do
				local leftCardBg = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_bg_"..i)
				leftCardBg:setVisible(true)
				local leftCardNum = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_"..i)
				if self.showShouPaiAmount then
					leftCardNum:setVisible(true)
				else
					leftCardNum:setVisible(false)
				end
			end
		elseif self.start == false then --上面一家没有抢地主，自己显示抢地主阶段按钮
			self.decisionBtnNode:setVisible(true)
			self.prompt:setVisible(false)
			self.play:setVisible(false)
			self.pass:setVisible(false)
			self.restore:setVisible(false)
			self.nograb:setVisible(true)
			self.grab:setVisible(true)
			self:showPoint(true,seatIdx,12)
			self:playTimeCDStart(12,true)
		end

				local roomPlayer = self.roomPlayers[self.playerSeatIdx]

				local isSmallKing = false
				local isBigKing = false
				local is2_1 = false
				local is2_2 = false
				local is2_3 = false
				local is2_4 = false
				if roomPlayer and roomPlayer.holdMjTiles then
					for i,v in ipairs(roomPlayer.holdMjTiles) do
						if v.mjIndex == 48 then
							is2_1 = true
						elseif v.mjIndex == 49 then
							is2_2 = true
						elseif v.mjIndex == 50 then
							is2_3 = true
						elseif v.mjIndex == 51 then
							is2_4 = true
						elseif v.mjIndex == 52 then
							isSmallKing = true
						elseif v.mjIndex == 53 then
							isBigKing = true
						end
					end
				end

		if (isSmallKing and isBigKing) or (is2_1 and is2_2 and is2_3 and is2_4) then
			self.nograb:setEnabled(false)
		else
			self.nograb:setEnabled(true)
		end
	else
		self:showPoint(true,seatIdx,12)
		self:playTimeCDStart(12,true)
	end

end

function m:onRcvANSDIZHU(msgTbl) -- 服务器广播客户端操作
	if self.gParam.isJiaoFenGame then
		self:onRcvANSDIZHU_JiaoFen(msgTbl)
	else
		self:onRcvANSDIZHU_JiaoDiZhu(msgTbl)
	end
end


-- 叫分处理
function m:processScoreBanker(msgTbl)

	local seatIdx = msgTbl.m_pos + 1
	local realSeat = (seatIdx+self.seatOffset)%3
  	if realSeat == 0 then
  		realSeat = 3
  	end

  	local tipImg = nil
  	-- 声音
  	local roomPlayer = self.roomPlayers[seatIdx]


  	if msgTbl.m_yaobu == 0 then
  		local sound = roomPlayer.sex == 1 and "ddz/man/Man_NoOrder" or "ddz/woman/Woman_NoOrder"
		gComm.SoundEngine:playEffect(sound)
		tipImg = "Image/GameSub/GameDDZ/play_nograb.png"
	elseif msgTbl.m_yaobu == 1 then
		-- 抢地主
		if msgTbl.m_difen == 1 then

			local sound = roomPlayer.sex == 1 and "ddz/man/1fen" or "ddz/woman/1fen"
			gComm.SoundEngine:playEffect(sound)

			tipImg = "Image/GameSub/GameDDZ/play_one_score.png"
		elseif msgTbl.m_difen == 2 then

			local sound = roomPlayer.sex == 1 and "ddz/man/2fen" or "ddz/woman/2fen"
			gComm.SoundEngine:playEffect(sound)

			tipImg = "Image/GameSub/GameDDZ/play_two_score.png"

		elseif msgTbl.m_difen == 3 then

			local sound = roomPlayer.sex == 1 and "ddz/man/3fen" or "ddz/woman/3fen"
			gComm.SoundEngine:playEffect(sound)

			tipImg = "Image/GameSub/GameDDZ/play_three_score.png"
		end
	elseif msgTbl.m_yaobu == 2 then
		tipImg = "Image/GameSub/GameDDZ/img_jiabei.png"
		-- 加倍
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		local sound = "ddz/man/jiabei"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/jiabei"
		else
			sound = "ddz/woman/jiabei"
		end
		gComm.SoundEngine:playEffect(sound)
	elseif msgTbl.m_yaobu == 3 then
		tipImg = "Image/GameSub/GameDDZ/img_bujiabei.png"
		-- 不加倍
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		local sound = "ddz/man/buJiaBei"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/buJiaBei"
		else
			sound = "ddz/woman/buJiaBei"
		end
		gComm.SoundEngine:playEffect(sound)
	elseif msgTbl.m_yaobu == 4 then
		tipImg = "Image/GameSub/GameDDZ/img_gen.png"
		-- 跟
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		local sound = "ddz/man/jiabei"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/jiabei"
		else
			sound = "ddz/woman/jiabei"
		end
		gComm.SoundEngine:playEffect(sound)
	elseif msgTbl.m_yaobu == 5 then
		tipImg = "Image/GameSub/GameDDZ/img_bugen.png"
		-- 不跟
		local roomPlayer = self.roomPlayers[self.playerSeatIdx]
		local sound = "ddz/man/buJiaBei"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/buJiaBei"
		else
			sound = "ddz/woman/buJiaBei"
		end
		gComm.SoundEngine:playEffect(sound)
	end

  	-- 只有不是自己才显示提示
  	if tipImg and seatIdx ~= self.playerSeatIdx then
  		self:showOperTips(realSeat,tipImg)
  	end

  	self:showPoint(false,seatIdx,12)
	self:playTimeCDStart(12,false)
end


-- 显示tips
function m:showOperTips(realSeat,imageName)
	self.mOperTipsNode:setVisible(true)
	for i = 1,3 do
		local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
		--local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)
		if realSeat ~= i then
			-- operTips:setVisible(false)
		else
			local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imageName)
			if spriteFrame then
				operTips:setSpriteFrame(spriteFrame)
			end
			operTips:setVisible(true)
			--operTipsBg:setVisible(true)
			operTips:stopAllActions()
			local delayTime = cc.DelayTime:create(1)
			local callFunc = cc.CallFunc:create(function(sender)
				operTips:setVisible(false)
				--operTipsBg:setVisible(false)
			end)
			operTips:runAction(cc.Sequence:create(delayTime,callFunc))
		end
	end
end

function m:onRcvANSDIZHU_JiaoFen(msgTbl) -- 服务器广播客户端操作
	dump(msgTbl,"==onRcvANSDIZHUonRcvANSDIZHU==")
	local vis = self.grab:isVisible()

	if self._gameType == 1 then
		self:processScoreBanker(msgTbl)
	end

	if msgTbl.m_yaobu == 1 then
		-- 抢地主
		self.mBombTimes = msgTbl.m_difen or 1
	elseif msgTbl.m_yaobu == 2 then
		if self.playerSeatIdx == msgTbl.m_pos + 1 then
			-- 当前玩家点击加倍
			self.mBombTimes = self.mBombTimes * 2
			self.isAddDouble = 1
		end

		if ((self.mDizhuPos == msgTbl.m_pos + 1 and self.isAddDouble == 1)
			or (self.mDizhuPos == msgTbl.m_pos + 1 and self.isAddGen == 1))
			and self.mDizhuPos ~= self.playerSeatIdx then
			-- 地主点加倍
			self.mBombTimes = self.mBombTimes * 2
		end

		-- 加倍
		if self.mDizhuPos == self.playerSeatIdx and
			self.playerSeatIdx ~= msgTbl.m_pos + 1  then
			-- 自己是地主
			self.mBombTimes = self.mBombTimes * 2
		end
	elseif msgTbl.m_yaobu == 4 then
		if self.playerSeatIdx == msgTbl.m_pos + 1 then
			-- 当前玩家点击加倍
			self.mBombTimes = self.mBombTimes * 2
			self.isAddGen = 1
		end

		if self.mDizhuPos == msgTbl.m_pos + 1 and self.isAddGen == 1 then
			-- 地主点加倍
			self.mBombTimes = self.mBombTimes * 2
		end

		-- if self.mDizhuPos == self.playerSeatIdx then
		-- 	-- 自己是地主
		-- 	self.mBombTimes = self.mBombTimes * 2
		-- end

	end
	self.mTimesText:setString(self.mBombTimes)

	if msgTbl.m_restart == 1 then --三家都没有抢地主，重新开始
		self.deal = true
	end

	if self.playerSeatIdx == msgTbl.m_pos + 1 then
		self.nodeScore:setVisible(false)
		self.nodeDouble:setVisible(false)
		self.nodeGen:setVisible(false)
		self.nograb:setVisible(false)
		self.grab:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end
end

function m:onRcvANSDIZHU_JiaoDiZhu(msgTbl) -- 服务器广播客户端操作
	local seatIdx = msgTbl.m_pos + 1
	local realSeat = (seatIdx+self.seatOffset)%3
  	if realSeat == 0 then
  		realSeat = 3
  	end

	if seatIdx == self.playerSeatIdx and msgTbl.m_yaobu == 1 then --自己抢到地主

		local roomPlayer = self.roomPlayers[seatIdx]
		local sound = "ddz/man/Man_Order"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/Man_Order"
		else
			sound = "ddz/woman/Woman_Order"
		end
		gComm.SoundEngine:playEffect(sound, false, true)
		gComm.SoundEngine:playEffect(sound)

		self:showPoint(false,seatIdx,12)
		self:playTimeCDStart(12,false)

	elseif seatIdx == self.playerSeatIdx and msgTbl.m_yaobu == 0 then --自己没有抢地主
		self.prompt:setVisible(false)
		self.play:setVisible(false)
		self.pass:setVisible(false)
		self.restore:setVisible(false)
		self.nograb:setVisible(false)
		self.grab:setVisible(false)
		local roomPlayer = self.roomPlayers[seatIdx]
		local sound = "ddz/man/Man_NoOrder"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/Man_NoOrder"
		else
			sound = "ddz/woman/Woman_NoOrder"
		end
		--gComm.SoundEngine:playEffect(sound, false, true)
		gComm.SoundEngine:playEffect(sound)

		self:showPoint(false,seatIdx,12)
		self:playTimeCDStart(12,false)

	elseif seatIdx ~= self.playerSeatIdx and msgTbl.m_yaobu == 1 then --别人抢到地主
		local roomPlayer = self.roomPlayers[seatIdx]
		local sound = "ddz/man/Man_Order"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/Man_Order"
		else
			sound = "ddz/woman/Woman_Order"
		end
		--gComm.SoundEngine:playEffect(sound, false, true)
		gComm.SoundEngine:playEffect(sound)

		self:showPoint(false,seatIdx,12)
		self:playTimeCDStart(12,false)

		self.mOperTipsNode:setVisible(true)
		for i = 1,3 do
			local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
			--local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)
			if realSeat ~= i then
				operTips:setVisible(false)
				--operTipsBg:setVisible(false)
			else
				local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("Image/GameSub/GameDDZ/play_grab.png")
				if spriteFrame then
					operTips:setSpriteFrame(spriteFrame)
				end
				operTips:setVisible(true)
				--operTipsBg:setVisible(true)
				operTips:stopAllActions()
				local delayTime = cc.DelayTime:create(1)
				local callFunc = cc.CallFunc:create(function(sender)
					operTips:setVisible(false)
					--operTipsBg:setVisible(false)
				end)
				operTips:runAction(cc.Sequence:create(delayTime,callFunc))
			end
		end
	elseif seatIdx ~= self.playerSeatIdx and msgTbl.m_yaobu == 0 then --别人没有抢地主
		local roomPlayer = self.roomPlayers[seatIdx]
		local sound = "ddz/man/Man_NoOrder"
		if roomPlayer.sex == 1 then
			sound = "ddz/man/Man_NoOrder"
		else
			sound = "ddz/woman/Woman_NoOrder"
		end
		--gComm.SoundEngine:playEffect(sound, false, true)
		gComm.SoundEngine:playEffect(sound)

		self:showPoint(false,seatIdx,12)
		self:playTimeCDStart(12,false)

		self.mOperTipsNode:setVisible(true)
		for i = 1,3 do
			local operTips = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTip_"..i)
			--local operTipsBg = gComm.UIUtils.seekNodeByName(self.mOperTipsNode, "Sprite_OperTipBg_"..i)
			if realSeat ~= i then
				operTips:setVisible(false)
				--operTipsBg:setVisible(false)
			else
				local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame("Image/GameSub/GameDDZ/play_nograb.png")
				if spriteFrame then
					operTips:setSpriteFrame(spriteFrame)
				end
				operTips:setVisible(true)
				--operTipsBg:setVisible(true)
				operTips:stopAllActions()
				local delayTime = cc.DelayTime:create(1)
				local callFunc = cc.CallFunc:create(function(sender)
					operTips:setVisible(false)
					--operTipsBg:setVisible(false)
				end)
				operTips:runAction(cc.Sequence:create(delayTime,callFunc))
			end
		end
	end
	if msgTbl.m_restart == 1 then --三家都没有抢地主，重新开始
		self.deal = true
	end

	if self.playerSeatIdx == msgTbl.m_pos + 1 then
		self.nograb:setVisible(false)
		self.grab:setVisible(false)
		self.decisionBtnNode:setVisible(false)
	end
end

function m:onRcvWHOISDIZHU(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	local startX = 530
	self.mDizhuPos = seatIdx

	-- 插牌
	for k, v in ipairs(msgTbl.m_LeftCard) do
		if seatIdx == self.playerSeatIdx and self.mSelfMenZhua == false then
			self:addMjTileToPlayer(v)
		end
	end
	self:showLastHandPoker(msgTbl.m_LeftCard,false)

	if seatIdx == self.playerSeatIdx and self.mSelfMenZhua == false then --自己抢到地主
		--延迟显示插牌动画
		local action = cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function ()
			--播放插牌动画
			local roomPlayer = self.roomPlayers[self.playerSeatIdx]
			local mjTilesReferPos = roomPlayer.mjTilesReferPos
			-- 对玩家手牌重新进行排序
			table.sort(roomPlayer.holdMjTiles,function(a, b)
				return a.mjIndex > b.mjIndex
			end)

			-- 计算牌开始的位置
			local cardNum = #roomPlayer.holdMjTiles -- 当前手牌数量
			local tileWidth = 155
			local tileHeight = 216
			-- 计算所有牌加起来的宽度
			-- local totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
			local totalWidth = 1240
			local space = (totalWidth - tileWidth) / (cardNum - 1)
			if space > tileWidth / 2 then
				mjTilesReferPos.holdSpace.x = tileWidth / 2 - 3
				totalWidth = tileWidth + (cardNum - 1) * mjTilesReferPos.holdSpace.x
			else
				mjTilesReferPos.holdSpace.x = space

			end

			local mjTilePos = mjTilesReferPos.holdStart
			-- 计算牌的起始位置
			local startX = (display.size.width - totalWidth) / 2 + tileWidth / 2
			mjTilePos.x = startX

			-- 重新设置所有牌位置
			for k, pkTile in ipairs(roomPlayer.holdMjTiles) do
				pkTile.mjTileSpr:stopAllActions()
				-- 如果自己是地主，添加地主角标
				if self.mDizhuPos == self.playerSeatIdx then
					local landLordIcon = cc.Sprite:createWithSpriteFrameName("Image/CardsPoker/p_landlord_icon.png")
					landLordIcon:setAnchorPoint(cc.p(1,1))
					landLordIcon:setPosition(landlordPos)
					pkTile.mjTileSpr:addChild(landLordIcon)
				end
				pkTile.mjTileSpr:setPosition(mjTilePos.x, mjTilePos.y)
				for i,v in ipairs(msgTbl.m_LeftCard) do
					if pkTile.mjIndex == v then
						pkTile.mjTileSpr:setPositionY(mjTilePos.y + 80)
						pkTile.mjTileSpr:runAction(cc.MoveBy:create(0.3, cc.p(0, -80)))
					end
				end
				self.playMjLayer:reorderChild(pkTile.mjTileSpr, mjTilePos.x)
				mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
			end
			local delayTime = cc.DelayTime:create(1)
			local callFunc = cc.CallFunc:create(function(sender)
				--众神归位
				for j=1, #roomPlayer.holdMjTiles do
					self:setPokerIsUp(roomPlayer.holdMjTiles[j], false, false)
				end
				self.SelectCard = {}
			end)
			local sequence = cc.Sequence:create(delayTime,callFunc)
			self:runAction(sequence)

		end))
		self:runAction(action)
	else -- 别人抢到地主
		local roomPlayer = self.roomPlayers[seatIdx]
		-- 更新别人剩余牌数量显示
		roomPlayer.leftCardsNum = roomPlayer.leftCardsNum + 3
		local leftCardsNumLabel = gComm.UIUtils.seekNodeByName(self.nodeLeftCards,"LeftCard_num_" .. roomPlayer.displaySeatIdx)
		if leftCardsNumLabel then
			if self.showShouPaiAmount then
				leftCardsNumLabel:setVisible(true)
				leftCardsNumLabel:setString(tostring(roomPlayer.leftCardsNum))
			else
				leftCardsNumLabel:setVisible(false)
			end
		end
	end
	log("GameStyle:" .. self.mGameStyle)
	if self.mGameStyle == 0 then
		self:showLandlordOrFarmer(seatIdx)
	end

end

-- 清除三张底牌
function m:clearLastHand()

	self.mLastHandsNode:setVisible(false)
	for i=1,3 do
		local pkTileBg = gComm.UIUtils.seekNodeByName(self.mLastHandsNode, "LastHand_"..i)
		if pkTileBg then
			pkTileBg:setVisible(false)
			pkTileBg:runAction(cc.OrbitCamera:create(0, 1, 0, 0, 0, 0, 0))
		end

		local pkTileSpr = self.rootNode:getChildByName("HandTile_" .. i)
		if pkTileSpr then
			pkTileSpr:removeFromParent()
		end

	end
end

-- 显示底牌牌背
function m:showLastHandPokerBg()
	self.mLastHandsNode:setVisible(true)
	for i = 1,3 do
		local pkTileBg = gComm.UIUtils.seekNodeByName(self.mLastHandsNode, "LastHand_"..i)
		pkTileBg:setScale(0.3)
		pkTileBg:setVisible(true)
		pkTileBg:removeAllChildren()

		local pkShadow = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/play_poker_shadow.png")
		pkShadow:setAnchorPoint(cc.p(0, 1))
		pkShadow:setPosition(cc.p(0,pkTileBg:getContentSize().height))
		pkShadow:setScale(3.3)
		pkTileBg:removeAllChildren()
		pkTileBg:addChild(pkShadow)

		local pkTileSpr = self.rootNode:getChildByName("HandTile_"..i)
		if pkTileSpr then
			pkTileSpr:removeFromParent()
		end

	end
end

-- 显示底牌
function m:showLastHandPoker(pokers, isReconnect)
	self.mLastHandsNode:setVisible(true)
	for k, v in ipairs(pokers) do

		local pkTileBg = gComm.UIUtils.seekNodeByName(self.mLastHandsNode, "LastHand_"..k)
		pkTileBg:setScale(0.3)

		local pkTileSpr = self.rootNode:getChildByName("HandTile_"..k)
		if pkTileSpr then
			pkTileSpr:removeFromParent()
		end

		local pkValue = pokers[1]
		local value, color = self:changePk(v)
		local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
		pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
		pkTileSpr:setPosition(cc.p(pkTileBg:convertToWorldSpace(pkTileBg:getAnchorPointInPoints())))
		pkTileSpr:setName("HandTile_"..k)
		pkTileSpr:setScale(0.3)
		self.rootNode:addChild(pkTileSpr)
		-- pkTileSpr:runAction(cc.Hide:create())

		local pkShadow = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/play_poker_shadow.png")
		pkShadow:setAnchorPoint(cc.p(0, 1))
		pkShadow:setPosition(cc.p(0,pkTileSpr:getContentSize().height))
		pkShadow:setScale(3.3)
		pkTileSpr:removeAllChildren()
		pkTileSpr:addChild(pkShadow)

		-- if k == 1 then
		-- 	local lastHandFlag = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/banker_flag.png")
		-- 	lastHandFlag:setScale(3)
		-- 	pkTileSpr:addChild(lastHandFlag)
		-- end

		if isReconnect == false then
			pkTileSpr:setVisible(false)
			self:playTurnCardAction(pkTileBg, pkTileSpr, seatIdx, k)
		else
			pkTileBg:setVisible(false)
		end
	end
end

function m:showLandlordOrFarmer(seatIdx)

	for seatIndex, roomPlayer in ipairs(self.roomPlayers) do
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
		playerInfoNode:setVisible(true)
		local avatarSpr = gComm.UIUtils.seekNodeByName(playerInfoNode,"Spr_head")


		if seatIdx == seatIndex then -- 地主
			local landLordAvatar = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/play_flag_landlord.png")

			landLordAvatar:setAnchorPoint(cc.p(0,0))
				landLordAvatar:setPosition(cc.p(avatarSpr:getPositionX()+3,avatarSpr:getPositionY()-3))
			landLordAvatar:setName("TransAvatar_" .. roomPlayer.displaySeatIdx)
			playerInfoNode:addChild(landLordAvatar)

		end
	end
end

function m:onRcvSHOWCARDS(msgTbl)
	local seatIdx = msgTbl.m_pos + 1
	if seatIdx == self.playerSeatIdx then
		if msgTbl.m_MyCard then
			local roomPlayer = self.roomPlayers[seatIdx]
			for _, v in ipairs(msgTbl.m_MyCard) do
				self:addMjTileToPlayer(v)
			end
		    -- 根据花色大小排序并重新放置位置
			self:sortFinalPlayerMjTiles()

			if #roomPlayer.uselessTiles > 0 then
				for i,v in ipairs(roomPlayer.uselessTiles) do
				v.mjTileSpr:removeFromParent()
				end
			end
			roomPlayer.uselessTiles = {}
		end
	end
end

--------------------------------
-- @class function
-- @description 播放翻牌动画
-- @param pkTileBg 扑克牌背面
-- @param pkTileSpr 扑克牌正面
-- @param diZhuPos 地主的位置
-- @return
-- end --
function m:playTurnCardAction(pkTileBg, pkTileSpr, diZhuPos, index)
	--显示底牌翻牌动画
    local kOutAngleZ = 0
	local kOutDeltaZ = -90
	local kInAngleZ = 90
	local kInDeltaZ = -90
	local inDuration = 0.2
	local outDuration = 0.2

	local callFunc = cc.CallFunc:create(function(sender)
		pkTileBg:setVisible(false)
		local inAnimation = cc.Sequence:create(
			cc.Show:create(),
			--cc.OrbitCamera:create(inDuration, 1, 0, kInAngleZ, kInDeltaZ, 0, 0),
			cc.DelayTime:create(0.8),
			cc.CallFunc:create(function ()
				-- pkTileSpr:removeFromParent(true)
		end))
		if pkTileSpr and (not tolua.isnull(pkTileSpr)) then
			pkTileSpr:runAction(inAnimation)
		end
	end)

	local outAnimation = cc.Sequence:create(
			cc.Show:create(),
			cc.DelayTime:create(0.2),
			--cc.OrbitCamera:create(outDuration, 1, 0, kOutAngleZ, kOutDeltaZ, 0, 0),
			cc.Hide:create(),
		callFunc)
	pkTileBg:runAction(outAnimation)
end

-- 判断是否是顺子
function m:isStraight(pokerTiles)
	if pokerTiles == nil then
		return
	end
	local POKER_VALUE_COUNT = 14
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	if not roomPlayer then
		return
	end
	local countValue = {}
	local totalCount = 0 --记录选中的一共有几种值

	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			countValue[value] = 0
		end
	end
	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			if value >= 1 and value <= POKER_VALUE_COUNT then
				countValue[value] = countValue[value] + 1
			end
		end
	end

	for k,v in pairs(countValue) do
		totalCount = totalCount + 1
	end

	local straightLength = 0
	local count = 0
	for i=2,POKER_VALUE_COUNT do
		local index
		if i <= 13 then
			index = i
		else
			index = i % 13
		end

		if countValue[index] ~= nil then
			count = count + 1
			if index == 2 and countValue[index] > 0 then
				return false, nil
			end
			if countValue[index] > 0 then
				straightLength = straightLength + 1
			else
				return false,nil
			end
			if straightLength >= 5 and count == totalCount then
				return true, countValue
			end
		else
			if count > 0 then
				return false, nil
			end
			straightLength = 0
		end

	end


	return false, nil
end

-- 判断是否是连对
function m:isDoubleStraight(pokerTiles)
	if pokerTiles == nil then
		return
	end
	local POKER_VALUE_COUNT = 14
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local countValue = {}
	local totalCount = 0 --记录选中的一共有几种值

	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			countValue[value] = 0
		end
	end
	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			if value >= 1 and value <= 13 then
				countValue[value] = countValue[value] + 1
			end
		end
	end

	for k,v in pairs(countValue) do
		totalCount = totalCount + 1
	end

	local straightLength = 0
	local count = 0
	for i=2,POKER_VALUE_COUNT do
		local index
		if i <= 13 then
			index = i
		else
			index = i % 13
		end
		if countValue[index] ~= nil then
			count = count + 1
			if index == 2 and countValue[index] > 0 then
				return false,nil
			end
			if countValue[index] >= 2 then
				straightLength = straightLength + 1
			else
				return false,nil
			end

			if straightLength >= 3 and count == totalCount then
				return true, countValue
			end
		else
			if count > 0 then
				return false, nil
			end
			straightLength = 0
		end

	end


	return false,nil
end

-- 判断是否是飞机
function m:isAirplane(pokerTiles)
	if pokerTiles == nil then
		return
	end
	local POKER_VALUE_COUNT = 14
	local roomPlayer = self.roomPlayers[self.playerSeatIdx]
	local countValue = {}

	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			countValue[value] = 0
		end
	end
	for i,v in ipairs(pokerTiles) do
		local pokerTile = roomPlayer.holdMjTiles[v]
		if pokerTile then
			local value, color = self:changePk(pokerTile.mjIndex)
			if value >= 1 and value <= POKER_VALUE_COUNT then
				countValue[value] = countValue[value] + 1
			end
		end
	end

	local straightLength = 0
	for i=3,POKER_VALUE_COUNT do
		local index
		if i <= 13 then
			index = i
		else
			index = i % 13
		end
		if countValue[index] ~= nil then
			if countValue[index] >=3 then
				straightLength = straightLength + 1
			else
				straightLength = 0
			end
			if straightLength >= 2 then
				if #pokerTiles >= 8 then
					return true
				end
			end
		else
			straightLength = 0
		end
	end
	return false
end


function m:throwBoom( pos )
	local realPos = pos
	local boom = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/boom.png")
	boom:setScale(0.6)

	local node_boom = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_boom")
	local node = gComm.UIUtils.seekNodeByName(node_boom, "Node_"..realPos)
	local startNode = gComm.UIUtils.seekNodeByName(node, "Node_start")
	local controlNode = gComm.UIUtils.seekNodeByName(node, "Node_control")
	local endNode   = gComm.UIUtils.seekNodeByName(node, "Node_end")

	local bezier = {
		cc.p(controlNode:getPosition()),
		cc.p(controlNode:getPosition()),
		cc.p(display.size.width*0.5, display.size.height*0.5)
	}
	local bezierTo = cc.BezierTo:create(0.3, bezier)
	local rotate   = cc.RotateBy:create(0.3, 280)
	local spawn    = cc.Spawn:create(bezierTo, rotate)

	boom:setPosition(cc.p(startNode:getPosition()))

	self.rootNode:addChild(boom, 98)
	local callFunc = cc.CallFunc:create(function ()
		if boom then
			boom:removeFromParent()
			boom = nil

			self:playBoomAni()
		end
	end)
	boom:runAction(cc.Sequence:create(spawn, callFunc))
end

function m:playBoomAni()
	local center = cc.p(display.size.width*0.5, display.size.height*0.5)
	-- 添加动画
	local csbNode, action = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimBoomLight.csb")
	action:gotoFrameAndPlay(0, false)
	csbNode:setPosition(center)
	self.rootNode:addChild(csbNode, 99)

	local delay = cc.DelayTime:create(65.0/60.0)
	local func  = cc.CallFunc:create(function (  )
		csbNode:removeFromParent()
		csbNode = nil
	end)
	self:runAction(cc.Sequence:create(delay, func))

	self:boomLightAni2()
	self:boomTextAni()
	self:boomLightAni1()
end

function m:boomLightAni1(  )
	-- cc.Director:getInstance():getScheduler():setTimeScale(0.2)

	local center = cc.p(display.size.width*0.5, display.size.height*0.5-20)

	local light1 = cc.Sprite:create("Image/BigImg/ddzBoomLight2.png")
	light1:setScale(0.1)
	light1:setPosition(center)
	self.rootNode:addChild(light1, 98)
	local scaleTo = cc.ScaleTo:create(0.3, 1.0)
	local callFunc = cc.CallFunc:create(function ()
		if light1 then
			light1:removeFromParent()
			light1 = nil
		end
	end)
	light1:runAction(cc.Sequence:create(scaleTo, callFunc))
end

function m:boomLightAni2()
	local center = cc.p(display.size.width*0.5, display.size.height*0.5-20)

	local light1 = cc.Sprite:create("Image/BigImg/ddzBoomLight1.png")
	light1:setScale(0.1)
	light1:setPosition(center)
	self.rootNode:addChild(light1, 98)
	local scaleTo = cc.ScaleTo:create(0.3, 1.0)
	local callFunc = cc.CallFunc:create(function ()
		if light1 then
			light1:removeFromParent()
			light1 = nil
		end
	end)
	light1:runAction(cc.Sequence:create(scaleTo, callFunc))
end

function m:boomTextAni(  )
	local csbNode, action = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimBoomText.csb")
	action:gotoFrameAndPlay(0, false)
	csbNode:setPosition(cc.p(display.size.width*0.5, display.size.height*0.5))
	self.rootNode:addChild(csbNode, 99)

	local delay = cc.DelayTime:create(66.0/60.0)
	local func  = cc.CallFunc:create(function (  )
		csbNode:removeFromParent()
		csbNode = nil
	end)
	self:runAction(cc.Sequence:create(delay, func))
end

-- 添加表情发送倒计时
-- start --
--------------------------------
-- @class function
-- @description 更新出牌倒计时
-- @param delta 定时器周期
-- end --
function m:biaoqingWaitTimeCDUpdate(delta)
	if not self.biaoqingTimeCD then
		return
	end
	self.biaoqingTimeCD = self.biaoqingTimeCD - delta
	if self.biaoqingTimeCD < 0 then
		self.biaoqingTimeCD = 0
		self:removeBiaoqingShade()
	end
    if self.biaoqingTimeCD then
        local timeCD = math.ceil(self.biaoqingTimeCD)
        self.biaoqingCutDown:setString(tostring(timeCD))
    end
end

function m:sendBiaoQing( )
	self.biaoqingTimeCD = 3
	self.controlBiaoqingNode:setVisible(true)
end

function m:removeBiaoqingShade()
	self.controlBiaoqingNode:setVisible(false)
	self.biaoqingTimeCD = nil
end

function m:aniWaitTimeCDUpdate(delta)
	if not self.interactAniTimeCD then
		return
	end
	self.interactAniTimeCD = self.interactAniTimeCD - delta
	if self.interactAniTimeCD < 0 then
		self.interactAniTimeCD = nil
		if self.playerInfoTips then
			self.playerInfoTips:removeBiaoqingShade()
		end
	end
    if self.interactAniTimeCD and self.playerInfoTips then
        local timeCD = math.ceil(self.interactAniTimeCD)
        self.playerInfoTips:setBiaoqingWaitTimeCDUpdate(timeCD)
    end
end

function m:onShowBeatOthers(msgTbl)

	local seatIdx = msgTbl.m_srcPos + 1
	local roomPlayer = self.roomPlayers[seatIdx]
	if not roomPlayer then
		return
	end
	local src =  roomPlayer.displaySeatIdx

	seatIdx = msgTbl.m_destPos + 1
	roomPlayer = self.roomPlayers[seatIdx]

	local dest =  roomPlayer.displaySeatIdx

	local 	movetime = 0.8

	if src == 1 and dest == 2 then
		movetime = 0.8
	elseif src == 1 and dest == 3 then
		movetime = 0.7
	end

	if src == 2 and dest == 1 then
		movetime = 0.8
	elseif src == 2 and dest == 3 then
		movetime = 0.1
	end

	if src == 3 and dest == 1 then
		movetime = 0.7
	elseif src == 3 and dest == 2 then
		movetime = 0.1
	end

	local 	Ypos1 = 50
	local 	Ypos = 50
	if msgTbl.m_type == 1 then

		local 	delayttt1 = 0.4
		local 	stoptime = 0.1
		local 	delayttt2 = 0.70

		local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion1_1.csb")
		local playerNode1 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. src)
		node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion1_2.csb")
		local playerNode2 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. dest)

		local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion1_duration1.png")
		self.rootNode:addChild(toolsSpr,m.ZOrder.DECISION_SHOW)
		toolsSpr:setVisible(false)
		toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local callFunc1 = cc.CallFunc:create(function(sender)
			self.rootNode:addChild(node1,m.ZOrder.DECISION_SHOW)
			animation1:gotoFrameAndPlay(0, false)
		end)

		local callFunc2 = cc.CallFunc:create(function(sender)
			toolsSpr:setVisible(false)
			node2:setPosition(cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos)))
			self.rootNode:addChild(node2,m.ZOrder.DECISION_SHOW)
			animation2:gotoFrameAndPlay(0, false)
			gComm.SoundEngine:playEffect("beat/prop_flower")
		end)

		local callFunc3 = cc.CallFunc:create(function(sender)
			node1:setVisible(false)
			toolsSpr:setVisible(true)
		end)

		local callFunc4 = cc.CallFunc:create(function(sender)
			node1:removeFromParent()
			node2:removeFromParent()
			toolsSpr:removeFromParent()
		end)

		local seqAction = cc.Sequence:create(callFunc1, cc.DelayTime:create(delayttt1), callFunc3,cc.DelayTime:create(stoptime),
			 cc.MoveTo:create(movetime,cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos))),
			callFunc2,
			cc.DelayTime:create(delayttt2),
			callFunc4
			)
		toolsSpr:runAction(seqAction)
	elseif msgTbl.m_type == 2 then
		local 	delayttt1 = 0.4
		local 	stoptime = 0.1
		local 	delayttt2 = 0.58
		local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion2_1.csb")
		local playerNode1 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. src)
		node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion2_2.csb")
		local playerNode2 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. dest)

		local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion2_duration1.png")
		self.rootNode:addChild(toolsSpr,m.ZOrder.DECISION_SHOW)
		toolsSpr:setVisible(false)
		toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local callFunc1 = cc.CallFunc:create(function(sender)
			self.rootNode:addChild(node1,m.ZOrder.DECISION_SHOW)
			animation1:gotoFrameAndPlay(0, false)
		end)

		local callFunc2 = cc.CallFunc:create(function(sender)
			toolsSpr:setVisible(false)
			node2:setPosition(cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos)))
			self.rootNode:addChild(node2,m.ZOrder.DECISION_SHOW)
			animation2:gotoFrameAndPlay(0, false)
			gComm.SoundEngine:playEffect("beat/prop_zan")
		end)

		local callFunc3 = cc.CallFunc:create(function(sender)
			node1:setVisible(false)
			toolsSpr:setVisible(true)
		end)

		local callFunc4 = cc.CallFunc:create(function(sender)
			node1:removeFromParent()
			node2:removeFromParent()
			toolsSpr:removeFromParent()
		end)

		local seqAction = cc.Sequence:create(callFunc1, cc.DelayTime:create(delayttt1), callFunc3,cc.DelayTime:create(stoptime),
			 cc.MoveTo:create(movetime,cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos))),
			callFunc2,
			cc.DelayTime:create(delayttt2),
			callFunc4
			)
		toolsSpr:runAction(seqAction)

	elseif msgTbl.m_type == 3 then
		local 	delayttt1 = 0.4
		local 	stoptime = 0.1
		local 	delayttt2 = 0.58
		local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion3_1.csb")
		local playerNode1 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. src)
		node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))
		self.rootNode:addChild(node1,m.ZOrder.DECISION_SHOW)

		local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion3_2.csb")
		local playerNode2 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. dest)

		local callFunc1 = cc.CallFunc:create(function(sender)
			animation1:gotoFrameAndPlay(0, false)
		end)

		local callFunc2 = cc.CallFunc:create(function(sender)
			node2:setPosition(cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos)))
			self.rootNode:addChild(node2,m.ZOrder.DECISION_SHOW)
			animation2:gotoFrameAndPlay(0, false)
			gComm.SoundEngine:playEffect("beat/prop_bomb")
		end)

		local callFunc4 = cc.CallFunc:create(function(sender)
			node1:removeFromParent()
			node2:removeFromParent()
		end)

		local seqAction = cc.Sequence:create(callFunc1, cc.DelayTime:create(delayttt1),
			 cc.MoveTo:create(movetime,cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos))),
			callFunc2,
			cc.DelayTime:create(delayttt2),
			callFunc4
			)
		node1:runAction(seqAction)

	elseif msgTbl.m_type == 4 then
		local 	delayttt1 = 0.4
		local 	stoptime = 0.1
		local 	delayttt2 = 0.5
		local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion4_1.csb")
		local playerNode1 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. src)
		node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion4_2.csb")
		local playerNode2 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. dest)

		local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion4_duration1.png")
		self.rootNode:addChild(toolsSpr,m.ZOrder.DECISION_SHOW)
		toolsSpr:setVisible(false)
		toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local callFunc1 = cc.CallFunc:create(function(sender)
			self.rootNode:addChild(node1,m.ZOrder.DECISION_SHOW)
			animation1:gotoFrameAndPlay(0, false)
		end)

		local callFunc2 = cc.CallFunc:create(function(sender)
			toolsSpr:setVisible(false)
			node2:setPosition(cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos)))
			self.rootNode:addChild(node2,m.ZOrder.DECISION_SHOW)
			animation2:gotoFrameAndPlay(0, false)
			gComm.SoundEngine:playEffect("beat/prop_shoess")
		end)

		local callFunc3 = cc.CallFunc:create(function(sender)
			node1:setVisible(false)
			toolsSpr:setVisible(true)
		end)

		local callFunc4 = cc.CallFunc:create(function(sender)
			node1:removeFromParent()
			node2:removeFromParent()
			toolsSpr:removeFromParent()
		end)

		local seqAction = cc.Sequence:create(callFunc1, cc.DelayTime:create(delayttt1), callFunc3,cc.DelayTime:create(stoptime),
			 cc.MoveTo:create(movetime,cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos))),
			callFunc2,
			cc.DelayTime:create(delayttt2),
			callFunc4
			)
		toolsSpr:runAction(seqAction)

	elseif msgTbl.m_type == 5 then
		local 	delayttt1 = 0.4
		local 	stoptime = 0.1
		local 	delayttt2 = 0.92
		local playerNode1 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. src)

		local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion5_1.csb")
		local playerNode2 = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. dest)

		local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion5_duration1.png")
		self.rootNode:addChild(toolsSpr,m.ZOrder.DECISION_SHOW)
		toolsSpr:setVisible(true)
		toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

		local callFunc2 = cc.CallFunc:create(function(sender)
			toolsSpr:setVisible(false)
			node2:setPosition(cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos)))
			self.rootNode:addChild(node2,m.ZOrder.DECISION_SHOW)
			animation2:gotoFrameAndPlay(0, false)

			gComm.SoundEngine:playEffect("beat/prop_egg")
		end)

		local callFunc4 = cc.CallFunc:create(function(sender)
			node2:removeFromParent()
			toolsSpr:removeFromParent()
		end)

		local seqAction = cc.Sequence:create(cc.DelayTime:create(stoptime),
			 cc.MoveTo:create(movetime,cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(0,Ypos))),
			callFunc2,
			cc.DelayTime:create(delayttt2),
			callFunc4
			)
		toolsSpr:runAction(seqAction)
	end
end

-- 房主开始按钮
function m:addStartGame()
	local btn_startGame = gComm.UIUtils.seekNodeByName(self.rootNode , "btn_startGame")
	btn_startGame:setVisible(false)
end

-- 获取当前房间人数
function m:getRoomPlayerAmount()
	local amount = 0
	for k,v in pairs(self.roomPlayers) do
		amount = amount + 1
	end
	return amount
end

-- 添加总结算界面
function m:addFinalReport()
	self.isRoundReport = false
	if self.lastRound then
		-- 停止播放倒计时警告音效
		if self.playCDAudioID then
			gComm.SoundEngine:stopEffect(self.playCDAudioID)
			self.playCDAudioID = nil
		end
		local delayTime = cc.DelayTime:create(0)
		local callFunc = cc.CallFunc:create(function(sender)
			-- -- 弹出总结算界面
			local args = {
				curRoomPlayers = self.curRoomPlayers,
				msgTbl         = self.finalReportData,
				playerSeatIdx  = self.playerSeatIdx,
				playmes        = self.playmes,
				roomType       = self.gParam.roomType,
			}
			local finalReport = UISettlementFinal:create(args)
			self:addChild(finalReport, m.ZOrder.REPORT)
		end)
		local seqAction = cc.Sequence:create(delayTime, callFunc)
		self:runAction(seqAction)
	end
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
function m:onError( socket ,errorInfo)
	gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0001"))
	socket:close()
	self:reLogin()
	gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip,cc.exports.gGameConfig.LoginServer.port,true)
end

-- 断线重连,走一次登录流程
function m:reLogin()
	self:clearGameData()

	-- log("========重连登录1")
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
	msgToSend.m_accessToken = accessToken
	msgToSend.m_refreshToken = refreshToken
	msgToSend.m_openId = openid
	msgToSend.m_severID = 13001
	msgToSend.m_uuid = unionid
	msgToSend.m_sex = tonumber(sex)
	msgToSend.m_nikename = nickname
	msgToSend.m_imageUrl = headimgurl


	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview or
		 		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		msgToSend.m_plate = "local"
	end

	local catStr = string.format("%s%s%s%s", openid, accessToken, refreshToken, unionid)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))
	self.loginMsg = msgToSend

	--gt.socketClient:sendMessage(msgToSend)
	-- log("========重连登录2")
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

function m:removeallscene()

	log("m:removeallscene")

	-- 显示准备按钮
	local readyBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Btn_ready")
	readyBtn:setVisible(true)

	-- 停止未完成动作
	if self.startMjTileAnimation ~= nil then
		self.startMjTileAnimation:stopAllActions()
		self.startMjTileAnimation:removeFromParent()
		self.startMjTileAnimation = nil
	end

	-- 停止播放倒计时警告音效
	if self.playCDAudioID then
		gComm.SoundEngine:stopEffect(self.playCDAudioID)
		self.playCDAudioID = nil
	end

	-- 清除三张底牌
	self:clearLastHand()

	self:removeAlarm()
	-- 移除所有麻将
	self.playMjLayer:removeAllChildren()

	-- 停止未完成动作
	if self.startMjTileAnimation ~= nil then
		self.startMjTileAnimation:stopAllActions()
		self.startMjTileAnimation:removeFromParent()
		self.startMjTileAnimation = nil
	end
	self.SelectCard = {}
	-- 停止倒计时音效
	self.playTimeCD = nil
	self.deal = true
	self.isTouch = false
	self:hidePlayersReadySign()
	--隐藏闹钟
	local chatBgNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_alarmbg")
   	for i = 1, 3 do
		local point = gComm.UIUtils.seekNodeByName(chatBgNode, "Spr_point_"..i)
		point:setVisible(false)
    end
	self.tag = {0,0,0}
	-- 隐藏倒计时
	self.playTimeCDLabel:setVisible(false)
	-- 隐藏决策
	local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
	decisionBtnNode:setVisible(false)


	self:removePlayerForRoom()
end

-- 从房间移除要给玩家
function m:removePlayerForRoom()
	if #self.removePlayers == 0 then
		return
	end
	for _, msgTbl in pairs(self.removePlayers) do
		local seatIdx = msgTbl.m_pos + 1
		local roomPlayer = self.roomPlayers[seatIdx]
		-- 隐藏玩家信息
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
		playerInfoNode:setVisible(false)

		-- 隐藏玩家准备手势
		local readySignNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_readySign")
		local readySignSpr = gComm.UIUtils.seekNodeByName(readySignNode, "Spr_readySign_" .. roomPlayer.displaySeatIdx)
		readySignSpr:setVisible(false)

		-- 取消头像下载监听
		local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
		if self.playerHeadMgr then
			self.playerHeadMgr:detach(headSpr)
		end

		-- 去除数据
		self.roomPlayers[seatIdx] = nil
	end
	self.removePlayers = {}
end


-- 添加出牌警报
--[[
	seatIdx  当前玩家idx
	amount   当前手牌的剩余数量
--]]
function m:addAlarmTip(seatIdx , amount)
	-- 判断是否添加警报
	local isShowAlarm = true
	local roomPlayer = self.roomPlayers[seatIdx]

	if self.addAlarm == 0 or (self.addAlarm == 1 and amount > 3) or
		(self.addAlarm == 2 and amount > 5 ) then
		isShowAlarm = false
	end

	log("[log-zxh] seatIdx:"..seatIdx.."  displaySeatIdx:"..roomPlayer.displaySeatIdx)
	if isShowAlarm then
		log("[log_zxh] ============ isShowAlarm ========")
		local node = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_LeftCards")
		local text_remain_cards = gComm.UIUtils.seekNodeByName(node, "LeftCard_num_" .. roomPlayer.displaySeatIdx)
		--播放报警动画
		local settingNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_alarm")
		local alarm = gComm.UIUtils.seekNodeByName(settingNode,"Node_alarm_"..roomPlayer.displaySeatIdx)
		alarm:setVisible(true)

		if alarm:getChildrenCount()  == 0  then
			local alarmAnimateNode, alarmAnimate = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimPokerAlarm.csb")
			alarm:addChild(alarmAnimateNode)
			alarmAnimate:gotoFrameAndPlay(0,true)
		end

		if roomPlayer.displaySeatIdx ~= 3 then
			-- 显示底牌
			-- text_remain_cards:setVisible(true)
			-- text_remain_cards:setString(tostring(amount))
		end
	end
end

function m:onRcvTuoGuan(msgTbl)
	dump(msgTbl,"m:onRcvTuoGuan")

	if self.gParam.sPosSelf == msgTbl.m_pos then
-- //1.进入托管  2.取消托管
		local flag = (msgTbl.m_type == 2)
		self.UIRoomInfoExClass:setTuoGuanBtnShow(flag)
		self.gParam.isTuoGuan = (msgTbl.m_type == 1)
		if self.gParam.isTuoGuan then
			local decisionBtnNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_decisionBtn")
			decisionBtnNode:setVisible(false)
		end
	else
		local flag = (msgTbl.m_type == 1)
		-- self.UIPlayer:setTuoGuanFlag(msgTbl.m_pos,flag)

		local seatIdx = msgTbl.m_pos + 1
		local roomPlayer = self.roomPlayers[seatIdx]
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displaySeatIdx)
		gComm.UIUtils.seekNodeByName(playerInfoNode, "iconTuoGuanFlag"):setVisible(flag)
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
	        isPoker  = true,
		}
		local layer = UICertificate:create(param)
		self:addChild(layer,ConfigGameScene.ZOrder.REPORT)
	end
end


function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")

	self.biaoqingTimeCD = nil  -- 更新倒计时
	self.interactAniTimeCD = nil

	local tipsNode, tipsAnimation = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimVoiceTip.csb")
	tipsAnimation:gotoFrameAndPlay(0, false)
	tipsAnimation:pause()
	tipsNode:setPosition(display.center)
	tipsNode:setVisible(false)

	self:addChild(tipsNode,2000)
	self.voiceTip = tipsAnimation
	self.voiceNode = tipsNode

	self.yuyinChatNode:setVisible(true)
	self.voiceGroup = {}


	for i= 1,3 do
		local voicePlayNode, voicePlayAni = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimVoicePlay.csb")
		voicePlayNode:setVisible(false)
		table.insert(self.voiceGroup,{voicePlayAni,voicePlayNode})
		local chatBgImg = gComm.UIUtils.seekNodeByName(self.yuyinChatNode, "Node_" .. i)
		chatBgImg:addChild(voicePlayNode)
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames("Texture/CardsPoker.plist")
end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")
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
	-- gComm.SoundEngine:playMusic("bgm1", true)
	-- gComm.SoundEngine:playEffect("bgm1", true, false)
	gComm.EventBus.unRegEventByName(self,EventCmdID.EventType.UPDATE_BG_GAME)
	display.removeSpriteFrames("Texture/CardsPoker.plist","Texture/CardsPoker.png")
	-- display.removeUnusedSpriteFrames()

	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent( self )
end


function m:I_ShowCoinCard(args)
    -- local args = {
    --     coinNum = msgTbl.m_coin,
    --     cardNum = msgTbl.m_card2,
    -- }
	if self.gParam.roomType == DefineRule.RoomType.CoinRoom then
		local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_3")
		local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")
	    local str = args.coinNum
	    if str > 10000 then
	        str = string.format("%0.1f万",str/10000)
	    end
		scoreLabel:setString(str)
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
			for i=1,3 do
				local info = self.roomPlayers[i]
				if info and info.uid == args.userId then
					fInfo = info
					break
				end
			end
			if fInfo then
				fInfo.score = args.finalCoin

				local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. fInfo.displaySeatIdx)
				local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")
			    local str = args.finalCoin
			    if str > 10000 then
			        str = string.format("%0.1f万",str/10000)
			    end
				scoreLabel:setString(str)
			end
		end
	end
end

return m
