--[[
根据msgId得到S2C回调函数
]]
local NetCmd = require("app.Common.NetMng.NetCmd")
local m = {}

m.msgID_S2CFun = {                           
--[[ 30 ]]	[NetCmd.MSG_GC_ENTER_ROOM]       = { "onRcvEnterRoom", },--进入房间         
--[[ 31 ]]	[NetCmd.MSG_GC_ADD_PLAYER]       = { "onRcvAddPlayer", },--玩家加入房间         
--[[ 32 ]]	[NetCmd.MSG_GC_REMOVE_PLAYER]    = { "onRcvRemovePlayer", },--玩家离开房间            
--[[ 35 ]]	[NetCmd.MSG_GC_SYNC_ROOM_STATE]  = { "onRcvSyncRoomState", },--断线重连              
--[[ 37 ]]	[NetCmd.MSG_GC_READY]            = { "onRcvReady", },--玩家准备手势 
--[[ 205 ]]	[NetCmd.MSG_GC_SAMEIP]           = { "onRcvSameIp", },--相同IP               
--[[ 40 ]]	[NetCmd.MSG_GC_OFF_LINE_STATE]   = { "onRcvOffLineState", },--玩家掉线在线标识            
--[[ 41 ]]	[NetCmd.MSG_GC_ROUND_STATE]      = { "onRcvRoundState", },--当前局数/最大局数          
--[[ 50 ]]	[NetCmd.MSG_GC_START_GAME]       = { "onRcvStartGame", },--开始游戏         
--[[ 51 ]]	[NetCmd.MSG_GC_TURN_SHOW_MJTILE] = { "onRcvTurnShowMjTile", },--通知玩家出牌               
--[[ 53 ]]	[NetCmd.MSG_GC_SYNC_SHOW_MJTILE] = { "onRcvSyncShowMjTile", },--显示玩家出牌消息
--[[ 58 ]]	[NetCmd.MSG_GC_CHAT_MSG]         = { "onRcvChatMsg", },--聊天
               
--[[ 60 ]]	[NetCmd.MSG_GC_ROUND_REPORT]     = { "onRcvRoundReport", },--单局游戏结束          
--[[ 80 ]]	[NetCmd.MSG_GC_FINAL_REPORT]     = { "onRcvFinalReport", },--总结算界面 
--[[ 1 ]]	[NetCmd.MSG_GC_LOGIN]            = { "onRcvLogin", },--断线重连
--[[ 12 ]]	[NetCmd.MSG_GC_LOGIN_SERVER]     = { "onRcvLoginSerVer", },--登录服务器 

--[[ 59 ]]	[NetCmd.MSG_GC_ALARM_MSG]        = { "onRcvAlarm", },--通知警报灯消息
--[[ 203 ]]	[NetCmd.MSG_GC_GET_SURPLUS]      = { "onRcvsurplusCard", },--最后手中剩余牌消息
--[[ 215 ]]	[NetCmd.MSG_GC_ASK_DIZHU]        = { "onRcvAskDiZhu", },--通知客户端抢地主
--[[ 217 ]]	[NetCmd.MSG_GC_ANS_DIZHU]        = { "onRcvAnsDiZhu", },--服务器广播客户端操作
--[[ 218 ]]	[NetCmd.MSG_GC_WHO_IS_DIZHU]     = { "onRcvWhoIsDiZhu", },--服务器广播最终地主位置
--[[ 1118]] [NetCmd.MSG_MSG_S_2_C_SHOWCARDS] = { "onRcvShowCard", },--结算后显示扑克牌

--[[ 113 ]]	[NetCmd.MSG_GC_BEAT]                       = { "onShowBeatOthers", },--表情互动    
--[[ 25 ]]	[NetCmd.MSG_GC_QUIT_ROOM]                  = { "onRevQuitRoom", },--返回大厅
--[[ 27 ]]	[NetCmd.MSG_GC_SHOWCARDS]                  = { "onRcvDismissRoom", },--解散房间

}

return m