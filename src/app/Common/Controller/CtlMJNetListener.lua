
--CtlMJNetListener
local gt = cc.exports.gt
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local ModleMJAnQin = require("app.Common.Modle.ModleMJAnQin")
local ModleMJHuaiBei = require("app.Common.Modle.ModleMJHuaiBei")
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")
local m = class("CtlMJNetListener")
local n = {}
--[[
根据msgId得到S2C回调函数
]]

n.msgID_S2CFun = {
-- [[ 30 ]]	[NetCmd.MSG_GC_ENTER_ROOM]       = { "onRcvEnterRoom"       , },--进入房间 --不需要
--[[ 1 ]]	[NetCmd.MSG_GC_LOGIN]            = { "onRcvLogin"           , },--断线重连
--[[ 12 ]]	[NetCmd.MSG_GC_LOGIN_SERVER]     = { "onRcvLoginSerVer"     , },--登录服务器
--[[ 31 ]]	[NetCmd.MSG_GC_ADD_PLAYER]       = { "onRcvAddPlayer"       , },--玩家加入房间
--[[ 32 ]]	[NetCmd.MSG_GC_REMOVE_PLAYER]    = { "onRcvRemovePlayer"    , },--玩家离开房间
--[[ 35 ]]	[NetCmd.MSG_GC_SYNC_ROOM_STATE]  = { "onRcvSyncRoomState"   , },--断线重连
--[[ 37 ]]	[NetCmd.MSG_GC_READY]            = { "onRcvReady"           , },--玩家准备手势
--[[ 40 ]]	[NetCmd.MSG_GC_OFF_LINE_STATE]   = { "onRcvOffLineState"    , },--玩家掉线在线标识
--[[ 41 ]]	[NetCmd.MSG_GC_ROUND_STATE]      = { "onRcvRoundState"      , },--当前局数/最大局数
--[[ 50 ]]	[NetCmd.MSG_GC_START_GAME]       = { "onRcvStartGame"       , },--开始游戏
--[[ 51 ]]	[NetCmd.MSG_GC_TURN_SHOW_MJTILE] = { "onRcvTurnShowMjTile"  , },--服务器发给某玩家一张牌,包含决策选择提示
--[[ 53 ]]	[NetCmd.MSG_GC_SYNC_SHOW_MJTILE] = { "onRcvSyncShowMjTile"  , },--显示玩家出牌消息
--[[ 113 ]]	[NetCmd.MSG_GC_BEAT]             = { "onShowBeatOthers"     , },--表情互动
--[[ 58 ]]	[NetCmd.MSG_GC_CHAT_MSG]         = { "onRcvChatMsg"         , },--聊天
--[[ 60 ]]	[NetCmd.MSG_GC_ROUND_REPORT]     = { "onRcvRoundReport"     , },--单局游戏结束
--[[ 80 ]]	[NetCmd.MSG_GC_FINAL_REPORT]     = { "onRcvFinalReport"     , },--总结算界面
--[[ 54 ]]	[NetCmd.MSC_GC_NOTICE_DECISION]  = { "onRcvMakeDecision"    , },--别人出的牌，服务器通知自己的决策选择提示
--[[ 56 ]]	[NetCmd.MSC_BROADCAST_DECISION]  = { "onRcvSyncMakeDecision", },--玩家决策选择
--[[ 131 ]]	[NetCmd.MSG_GC_DEL_CARD]         = { "onRcvDeleteCard"      , },--删牌
--[[ 165 ]]	[NetCmd.MSG_S_2_C_GAME_EXT]      = { "onRcvGameExt"         , },--游戏逻辑扩展
--[[ 176 ]]	[NetCmd.MSG_S_2_C_TUO_GUAN]      = { "onRcvTuoGuan"         , },--托管
--[[ 177 ]]	[NetCmd.MSG_S_2_C_ACTIVE_CODE]   = { "onRcvActiveCode"      , },--比赛场总结算发送激活码
}

function m:ctor(delegate,gameID)
	self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self.delegate = delegate
	if gameID == DefineRule.GameID.MJHuaiBei then
		self.modle = ModleMJHuaiBei:create()
	else
		self.modle = ModleMJAnQin:create()
	end
end

function m:getMsgID(kFun)
	for k,v in pairs(n.msgID_S2CFun) do
		if v[1] == kFun then
			return k
		end
	end
	return "nil"
end

function m:onRevHandle(kFun,_msg)
	local msgID = self:getMsgID(kFun)
	n.printTable("S2C_ " .. kFun .. " ,msgID=[ " .. msgID .. " ]",_msg)
	if self.delegate[kFun] then
		self.delegate[kFun](self.delegate,_msg)
	else
		print("MsgCenter[not has]: " .. kFun)
	end
end

function m:onRcvAddPlayer(_msg)--"       , },--玩家加入房间
	local kFun = "onRcvAddPlayer"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvRemovePlayer(_msg)--"    , },--玩家离开房间
	local kFun = "onRcvRemovePlayer"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvSyncRoomState(_msg)--"   , },--断线重连
	local kFun = "onRcvSyncRoomState"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvReady(_msg)--"           , },--玩家准备手势
	local kFun = "onRcvReady"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvOffLineState(_msg)--"    , },--玩家掉线在线标识
	local kFun = "onRcvOffLineState"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvRoundState(_msg)--"      , },--当前局数/最大局数
	local kFun = "onRcvRoundState"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvStartGame(_msg)--"       , },--开始游戏
	local kFun = "onRcvStartGame"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvTurnShowMjTile(_msg)--"  , },--通知玩家出牌
	local kFun = "onRcvTurnShowMjTile"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvSyncShowMjTile(_msg)--"  , },--显示玩家出牌消息
	local kFun = "onRcvSyncShowMjTile"
	self:onRevHandle(kFun,_msg)
end

function m:onShowBeatOthers(_msg)--"     , },--表情互动
	local kFun = "onShowBeatOthers"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvChatMsg(_msg)--"         , },--聊天
	local kFun = "onRcvChatMsg"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvRoundReport(_msg)--"     , },--单局游戏结束--onRcvSettlement
	local kFun = "onRcvRoundReport"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvFinalReport(_msg)--"     , },--总结算界面
	local kFun = "onRcvFinalReport"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvLogin(_msg)--"           , },--断线重连
	local kFun = "onRcvLogin"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvLoginSerVer(_msg)--"     , },--登录服务器
	local kFun = "onRcvLoginSerVer"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvMakeDecision(_msg)--"    , },--别人出的牌，服务器通知自己的决策选择提示
	local kFun = "onRcvMakeDecision"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvSyncMakeDecision(_msg)--", },--玩家决策选择
	local kFun = "onRcvSyncMakeDecision"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvDeleteCard(_msg)--", },--删牌
	local kFun = "onRcvDeleteCard"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvTuoGuan(_msg)--", },--托管
	local kFun = "onRcvTuoGuan"
	self:onRevHandle(kFun,_msg)
end

function m:onRcvActiveCode(_msg)--", },--比赛场总结算发送激活码
	local kFun = "onRcvActiveCode"
	self:onRevHandle(kFun,_msg)
end


function m:onRcvGameExt(_msg)--", },--游戏逻辑扩展
	local kFun = "onRcvGameExt"
	n.printTable(kFun,_msg)
	log("====onRcvGameExt----" .. string.len(_msg.array))

	if _msg.m_buffLen == string.len(_msg.array) then
		local subMsg = gt.socketClient:HandlerPack(_msg.array)
		n.printTable(kFun .. "===onRcvGameExt==qqqqq====" .. type(subMsg.m_sub_msgId),subMsg)


		if subMsg.m_sub_msgId == NetCmd.MSG_GAME_EXT.MSG_S_2_C_TING_ONE_GROUP then
			local kFun = "ShowTingTipLayer"
			n.printTable(kFun .. "===onRcvGameExt==qqqqq====",subMsg.m_TingCardsOnOne)
			self.modle.gameState.flagReqedTingInfo = true
			if self.delegate[kFun] then
				self.delegate[kFun](self.delegate,subMsg.m_TingCardsOnOne)
			end

		elseif subMsg.m_sub_msgId == NetCmd.MSG_GAME_EXT.MSG_S_2_C_TO_SAN_KOU then
			-- subMsg.nShunPos
			-- subMsg.nFanPos
			local kFun = "showAnimZhengFan"
			if self.delegate[kFun] then
				self.delegate[kFun](self.delegate,subMsg.nShunPos,subMsg.nFanPos)
			end

		elseif subMsg.m_sub_msgId == NetCmd.MSG_GAME_EXT.MSG_S_2_C_DUNLAPAO then--服务器广播蹲拉跑
		-- elseif subMsg.m_msgId == NetCmd.MSG_GAME_EXT.MSG_S_2_C_DUNLAPAO then--服务器广播蹲拉跑
	-- Lint		m_zhuangPos;
	-- Lint		m_maNum1[4];
	-- Lint		m_maNum2[4];
	-- Lint		m_maState[4]; //0未开始买码 1 已经买好
	-- Lint		m_isBroast;
			local kFun = "setZuoLaPao"
			local param = {
				zhuangPos = subMsg.m_zhuangPos,
				maNum1    = subMsg.m_maNum1,
				maNum2    = subMsg.m_maNum2,
				maState   = subMsg.m_maState,--0未开始买码 1 已经买好
				isBroast  = subMsg.m_isBroast,
				countDown = subMsg.m_time,
			}
			if self.delegate[kFun] then
				self.delegate[kFun](self.delegate,param)
			end

		end

	else
		local str = "数据长度不一致，m_buffLen=" .. _msg.m_buffLen .. " array.len=" .. string.len(_msg.array)
    	UINoticeTips:create(str)
	end
end

function m:regEvent()
	print("MsgCenter:regEvent")
	local str = ""
	for k,v in pairs(n.msgID_S2CFun) do
		local fun = self[v[1]]
		if fun then
			-- gComm.EventSys:regEvent("MsgCenter",handler(self,fun),k)
			gt.socketClient:registerMsgListener(k, self, fun)
		else
			str = "[[not has]] function MsgCenter:" .. v[1] .. "(_msg)" .. "\nend\n"
			print(str)
		end
	end
end

function m:unRegEvent()
	--不用用事件号来注销事件，因为事件号不唯一，会注销全局的事件
	-- for k,v in pairs(n.msgID_S2CFun) do
	-- 	gt.socketClient:unregisterMsgListener(k)
	-- end
	gt.socketClient:unRegisterMsgListenerByTarget(self)
end

n.printTable = function(_title, _t, _n)
    -- if DEBUG == 0 then return end
    local traceback = string.split(debug.traceback("", 2), "\n")
    -- print("MsgCenter dump from: " .. string.trim(traceback[3]))
    dump(_t, _title, _n or 10)
end

return m
