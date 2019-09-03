--
-- 消息处理中心
--

local gt = cc.exports.gt
local gComm = cc.exports.gComm

local gRoomMdl = cc.exports.gData.roomSys
local gSelfUserModle = cc.exports.gData.SelfUserModle
local gRoomSys = cc.exports.gData.roomSys

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local NetCmd = require("app.Common.NetMng.NetCmd")
local EventCmdID = require("app.Common.Config.EventCmdID")
local proto = require("Game.NetMng.ProtocolDDZ")

local n = {}
local m = class("NetMngDDZ")
function m:ctor(delegate)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self.delegate = delegate
	
	gt.socketClient:setDelegate(self)
	-- self:regEvent()
end

function m:regEvent()
	print("MsgCenter:regEvent")
	local str = ""
	for k,v in pairs(proto.msgID_S2CFun) do
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
	-- for k,v in pairs(proto.msgID_S2CFun) do
	-- 	-- gComm.EventSys:unRegEvent("MsgCenter",k)
	-- 	gt.socketClient:unregisterMsgListener(k)
	-- end

	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent( self )
end

function m:onError( socket ,errorInfo)
	local kFun = "onError"
	n.printTable("S2C_ " .. kFun .. " ,onError----errorInfo= ",errorInfo)
	if self.delegate[kFun] then
		self.delegate[kFun](self.delegate,socket,errorInfo) 
	end 
end

function m:getMsgID(kFun)
	for k,v in pairs(proto.msgID_S2CFun) do
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
                        
function m:onRcvEnterRoom(_msg)--", },--进入房间
	local kFun = "onRcvEnterRoom"
	self:onRevHandle(kFun,_msg)  
end        

function m:onRcvAddPlayer(_msg)--", },--玩家加入房间
	local kFun = "onRcvAddPlayer"
	self:onRevHandle(kFun,_msg)

	local info = gRoomMdl:addPlayer(_msg)
	
    dump(info,self.__TAG .. "onRcvAddPlayer")
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_ADD_PLAYER,info)      
end

function m:onRcvRemovePlayer(_msg)--", },--玩家离开房间
	local kFun = "onRcvRemovePlayer"
	self:onRevHandle(kFun,_msg)
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_REMOVE_PLAYER,_msg)
	gRoomMdl:removePlayer(_msg)
end

function m:onRcvSyncRoomState(_msg)--", },--广播房间状态
	local kFun = "onRcvSyncRoomState"
	self:onRevHandle(kFun,_msg)              
end

function m:onRcvReady(_msg)--", },--准备
	local kFun = "onRcvReady"
	self:onRevHandle(kFun,_msg) 
       
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_READY,_msg.m_pos)
end

function m:onRcvOffLineState(_msg)--", },--玩家掉线 
	local kFun = "onRcvOffLineState"
	self:onRevHandle(kFun,_msg)        
end

function m:onRcvRoundState(_msg)--", },--游戏一局开始  
	local kFun = "onRcvRoundState"
	self:onRevHandle(kFun,_msg)  

	gRoomSys:updateRoomInfo(_msg)
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_ROUND_STATE,_msg.m_curCircle,_msg.m_curMaxCircle)  
end

function m:onRcvStartGame(_msg)--", },--开始游戏
	local kFun = "onRcvStartGame"
	self:onRevHandle(kFun,_msg)

	local roomInfo = gRoomSys:updateRoomInfo(_msg)
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_START_GAME,roomInfo)  
end

function m:onRcvTurnShowMjTile(_msg)--", },--
	local kFun = "onRcvTurnShowMjTile"
	self:onRevHandle(kFun,_msg)

	local roomInfo = gRoomSys:updateRoomInfo(_msg)
	gComm.EventBus.dispatchEvent(NetCmd.MSG_GC_TURN_SHOW_MJTILE,roomInfo)  
end

function m:onRcvSyncShowMjTile(_msg)--", },--
	local kFun = "onRcvSyncShowMjTile"
	self:onRevHandle(kFun,_msg)  
end

function m:onRcvChatMsg(_msg)--", },--聊天
	local kFun = "onRcvChatMsg"
	self:onRevHandle(kFun,_msg)  
end

function m:onRcvRoundReport(_msg)--", },--游戏单局结算
	local kFun = "onRcvRoundReport"
	self:onRevHandle(kFun,_msg)  
end

function m:onRcvFinalReport(_msg)--", },--游戏总结算
	local kFun = "onRcvFinalReport"
	self:onRevHandle(kFun,_msg)  
end

function m:onRcvLogin(_msg)--", },--登录
	local kFun = "onRcvLogin"
	self:onRevHandle(kFun,_msg)  
end

function m:onRcvLoginSerVer(_msg)--", },--登录服务器
	local kFun = "onRcvLoginSerVer"
	self:onRevHandle(kFun,_msg)  
end

function m:onShowBeatOthers(_msg)--", },--表情互动
	local kFun = "onShowBeatOthers"
	self:onRevHandle(kFun,_msg)  
end

function m:onRevQuitRoom(_msg)--", },--返回大厅
	local kFun = "onRevQuitRoom"
	local msgID = self:getMsgID(kFun)
	n.printTable("S2C_ " .. kFun .. " ,msgID=[ " .. msgID .. " ]",_msg)
	
	gComm.UIUtils.removeLoadingTips()
	if _msg.m_errorCode == 0 then
		gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE, gRoomSys.mRoomInfo.m_pos == 0, gRoomSys.mRoomInfo.m_deskId)
	else
		-- 提示返回大厅失败
		local str2 = mTxtTipConfig.GetConfigTxt("LTKey_0045")
		UINoticeTips:create(str2)
	end
end

function m:onRcvDismissRoom(_msg)--", },--解散房间
	local kFun = "onRcvDismissRoom"
	local msgID = self:getMsgID(kFun)
	n.printTable("S2C_ " .. kFun .. " ,msgID=[ " .. msgID .. " ]",_msg)
	
	-- if _msg.m_errorCode == 1 then
	-- 	-- 游戏未开始解散成功
		gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
	-- elseif _msg.m_errorCode ==  2 then 
		
	-- 	gComm.EventBus.dispatchEvent(EventCmdID.EventType.APPLY_DIMISS_ROOM, _msg)
	-- 	gComm.EventBus.dispatchEvent(EventCmdID.EventType.SHOW_FINALREPORT)
	-- else

	-- 	-- 游戏中玩家申请解散房间
	-- 	gComm.EventBus.dispatchEvent(EventCmdID.EventType.APPLY_DIMISS_ROOM, _msg)
	-- end
end

function m:onRcvSameIp(_msg)
	local kFun = "onRcvSameIp"
	self:onRevHandle(kFun,_msg)  
end

n.printTable = function(_title, _t, _n)
    -- if DEBUG == 0 then return end
    local traceback = string.split(debug.traceback("", 2), "\n")
    -- print("MsgCenter dump from: " .. string.trim(traceback[3]))
    dump(_t, _title, _n or 10)
end


return m