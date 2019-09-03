
--*******************************
--* Created by liuyl.
--*******************************
local gt = cc.exports.gt
local gComm = cc.exports.gComm

local NetCmd = require("app.Common.NetMng.NetCmd")
local socket = require("socket")

local msgPackLib = require("app.Core.Net.LuaMessagePack")
msgPackLib.set_number("integer")
msgPackLib.set_string("string")
msgPackLib.set_array("without_hole")


local socketHeaderLen = 12
local heartbeatCD = 3
local maxHeartBeatMissCount = 2
local maxConnectTime = 3

local m = class("SocketClient")

function m:ctor( socketName )
	self.socketName = socketName or "Socket"
	
	self.rcvMsgListeners = {}

	self.delayTime = 0
	
	self:initSocket()
end

function m:whichSocket( )
	return self.isLogin 
end

function m:connect(serverIp, serverPort,isLogin)
	if not serverIp or not serverPort then
		return false
	end

	self:close()	
	self.serverIp = serverIp
	self.serverPort = tostring(serverPort)
	self.isLogin = isLogin

	log("["..self.socketName.."]".." Connect serverIp == ", serverIp, " | serverPort == " , serverPort)

	local tcpConn, errorInfo = self:getTcp(serverIp)
 	if not tcpConn then
		log(string.format("["..self.socketName.."]".." Error Connect failed when creating socket | %s", errorInfo))		
		self:initSocket()
		self:onError()
		return false
	end

	tcpConn:setoption("tcp-nodelay",true)
	tcpConn:settimeout( 0 )
	tcpConn:connect(serverIp, serverPort)
	self.tcpConn = tcpConn

	if not self.scheduleHandler then 
		self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1 / 30, false)
	end

	return true
end

function m:getTcp(host)
	local isipv6_only = false
	local addrinfo, err = socket.dns.getaddrinfo(host);
	if addrinfo then
		for i,v in ipairs(addrinfo) do
			if v.family == "inet6" then
				isipv6_only = true;
				break
			end
		end
	end
	dump(addrinfo,"[addrinfo=== ]")
-- [LUA-print] - "[addrinfo=== ]" = {
-- [LUA-print] -     1 = {
-- [LUA-print] -         "addr"   = "2001:2:0:1baa::761f:b938"
-- [LUA-print] -         "family" = "inet6"
-- [LUA-print] -     }
-- [LUA-print] -     2 = {
-- [LUA-print] -         "addr"   = "118.31.185.56"
-- [LUA-print] -         "family" = "inet"
-- [LUA-print] -     }
-- [LUA-print] - }

-- [LUA-print] - "[addrinfo=== ]" = {
-- [LUA-print] -     1 = {
-- [LUA-print] -         "addr"   = "118.31.185.56"
-- [LUA-print] -         "family" = "inet"
-- [LUA-print] -     }
-- [LUA-print] -     2 = {
-- [LUA-print] -         "addr"   = "2002::761f:b938"
-- [LUA-print] -         "family" = "inet6"
-- [LUA-print] -     }
-- [LUA-print] - }

	log("["..self.socketName.."]".." isipv6_only == ", isipv6_only)
	if isipv6_only then
		return socket.tcp6()
	else
		return socket.tcp()
	end
end

function m:sendMessage(msgTbl)
	if self.isLogin and msgTbl.m_msgId ~= 1 then 
		return false
	end

	local msgPackData = msgPackLib.pack(msgTbl)
	local msgLength = string.len(msgPackData)
	local len = self:luaToCByShort(msgLength)

	local curTime = os.time()
	local time = self:luaToCByInt(curTime)
	local msgId = self:luaToCByInt(msgTbl.m_msgId * ((curTime % 10000) + 1))
	local checksum = self:getCheckSum(time .. msgId, msgLength, msgPackData)
	local msgToSend = len .. checksum .. time .. msgId .. msgPackData

	return self:send(msgToSend,msgTbl)
end

function m:getCheckSum(time, msgLength, msgPackData)
	local crc = ""
	local len = string.len(time) + msgLength
	if len < 8 then
		crc = self:CRC(time .. msgPackData, len)
	else
		crc = self:CRC(time .. msgPackData, 8)
	end
	return self:luaToCByShort(crc)
end

--循环冗余校验
function m:CRC(data, length)
    local sum = 65535
    for i = 1, length do
        local d = string.byte(data, i)    
        sum = self:ByteCRC(sum, d)
    end
    return sum
end

function m:ByteCRC(sum, data)
    local sum = bit.bxor(sum, data)
    for i = 0, 3 do     
        if (bit.band(sum, 1) == 0) then
            sum = sum / 2
        else
            sum = bit.bxor((sum / 2), 0x70B1)
        end
    end
    return sum
end

function m:luaToCByInt(value)
	local lowByte1 = string.char(math.floor(value / (256 * 256 * 256)))
	local lowByte2 = string.char(math.floor(value / (256 * 256)) % 256)
	local lowByte3 = string.char(math.floor(value / 256) % 256)
	local lowByte4 = string.char(value % 256)
	return lowByte4 .. lowByte3 .. lowByte2 .. lowByte1
end

function m:luaToCByShort(value)
	return string.char(value % 256) .. string.char(math.floor(value / 256))
end


function m:send(msgToSend,msgTbl)
	if not self.tcpConnSucc or not self.tcpConn then
		return false
	end

	log("["..self.socketName.."]".." Send message length : " .. string.len(msgToSend))
	
	if msgTbl.m_msgId ~= 15 then
		dump(msgTbl,"["..self.socketName.."]")
	end

	local sendLength, errorInfo = self.tcpConn:send(msgToSend)
	if sendLength then
		log("["..self.socketName.."]".." Send message Success length : " .. string.len(msgToSend) )
	else
		log("["..self.socketName.."]".." Error Send Failed  errorInfo : " .. errorInfo )
		self:initSocket()
		self:onError()
		return false
	end

	return true
end

function m:sendHeartbeat()
	if not self.tcpConn then
		return
	end
	local msgTbl = {}
	msgTbl.m_msgId = NetCmd.MSG_CG_HEARTBEAT
	self.networkSpeedTime_ = socket.gettime()

	if self:sendMessage(msgTbl) then
		if self.delayTime <= 0 then  
			self.hearBeatCounter = self.hearBeatCounter + 1
		else
			self.hearBeatCounter = 0
		end
	end
end

function m:onRcvHeartbeat(msgTbl)
	self.hearBeatCounter = 0
	gt.networkSpeed = socket.gettime() - self.networkSpeedTime_
end

function m:update(dt)
	if not self.tcpConn then 
		return 
	end
	local connectCode, errorInfo 
	if not self.tcpConnSucc then 
		connectCode, errorInfo = self.tcpConn:connect(self.serverIp, self.serverPort)
	end

	if self.tcpConnSucc or connectCode == 1 or errorInfo == "already connected" then 
		
		if not self.tcpConnSucc then
			
			log("["..self.socketName.."]".." Connect Success")
			self.tcpConnSucc = true
			self:registerMsgListener(NetCmd.MSG_GC_HEARTBEAT, self, self.onRcvHeartbeat) 
			self:onConnect()
		end

		self:receive(dt)

		if self.hearBeatCounter >= maxHeartBeatMissCount then 
			log("["..self.socketName.."]".." Error Greater maxHeartBeatMissCount == ",maxHeartBeatMissCount)
			self:initSocket()
			self:onError()

			return 
		end

		
		if self.heartbeatCD < 0 then
			self:sendHeartbeat()
			self.heartbeatCD = heartbeatCD
		else
			self.heartbeatCD = self.heartbeatCD - dt
		end

	else
		if  errorInfo == "connection refused" 
			or errorInfo == "closed"
			or errorInfo == "permission denied"  
			-- or errorInfo == "Operation already in progress"  
			or errorInfo == "Network is unreachable" then 
			
			log("Socket Connect Error  ", errorInfo)	
			self:initSocket()
			self:onError(errorInfo)

		else
			if self.connectTime > maxConnectTime then 
				log("Socket Connect Error : ", errorInfo)	
				self:initSocket()
				self:onError("timeout" .. (errorInfo or ""))
			else
				self.connectTime = self.connectTime + dt
			end 
		end
	end
end

function m:receive(dt)
	if not self.tcpConnSucc or not self.tcpConn then
		return
	end
	self:receiveMessage(dt)
end

function m:receiveMessage(dt)
	if self.delayTime > 0 then 
		self.delayTime = self.delayTime - dt
		return 
	end

	local recvContent,errorInfo,otherContent = self.tcpConn:receive(1024)
	if errorInfo ~= nil then

		if errorInfo == "timeout" then 
			if otherContent ~= nil and #otherContent > 0 then
				self.recvBuffer = self.recvBuffer..otherContent
				log("["..self.socketName.."]".." Recv timeout, but had other content length : " .. #otherContent)
			end
		else
			log("["..self.socketName.."]".." Error Recv failed errorinfo : " .. errorInfo)
			self:initSocket()
			self:onError()
		end
	else

		log("["..self.socketName.."]".." Recv content length : "..#recvContent)
		self.recvBuffer = self.recvBuffer .. recvContent
	end

	self:socketDataReceived()

	for i=#self.recvMsgCache ,1 ,-1 do 
		local v = self.recvMsgCache[i]
		if v[2] then 
			table.remove(self.recvMsgCache, i)
		end
	end

	self:dealMessage()
end

function m:dealMessage()
	for i,v in ipairs(self.recvMsgCache) do 
		v[2] = true
		self:dispatchMessage(v[1])
	end
end

function m:socketDataReceived(  )
	local recvBufferLen = string.len(self.recvBuffer)
	if recvBufferLen <= socketHeaderLen then 
		return 
	end

	local index = 1
	local body = ""

	local bodyLenthFir = string.byte(self.recvBuffer, index)
	local bodyLenthSec = string.byte(self.recvBuffer, index+1) * 256
	local bodyLength = bodyLenthFir + bodyLenthSec
	
	local bodyStartIndex = index + socketHeaderLen 
	
	while  recvBufferLen - bodyStartIndex + 1 >= bodyLength  do

		body = string.sub(self.recvBuffer, bodyStartIndex , bodyStartIndex + bodyLength - 1)
		body = msgPackLib.unpack(body)
		
		table.insert(self.recvMsgCache,{body,false})
		
		index = index + socketHeaderLen + bodyLength
		if recvBufferLen - index  + 1 <=  socketHeaderLen  then 
			break
		end

		bodyLenthFir = string.byte(self.recvBuffer, index)
	 	bodyLenthSec = string.byte(self.recvBuffer, index+1) * 256
		bodyLength = bodyLenthFir + bodyLenthSec

		bodyStartIndex = index + socketHeaderLen 
	end

	if index > 1 then 
		self.recvBuffer = string.sub(self.recvBuffer, index, recvBufferLen)
	end
end

function m:HandlerPack(packstr)
	local res = {}

	local recvBufferLen = string.len(packstr)
	if recvBufferLen <= socketHeaderLen then 
		return {}
	end

	local index = 1
	local body = ""

	local bodyLenthFir = string.byte(packstr, index)
	local bodyLenthSec = string.byte(packstr, index+1) * 256
	local bodyLength = bodyLenthFir + bodyLenthSec
	
	local bodyStartIndex = index + socketHeaderLen 
	
	while  recvBufferLen - bodyStartIndex + 1 >= bodyLength  do

		body = string.sub(packstr, bodyStartIndex , bodyStartIndex + bodyLength - 1)
		body = msgPackLib.unpack(body)
		
		-- table.insert(res,body)

		index = index + socketHeaderLen + bodyLength
		if recvBufferLen - index  + 1 <=  socketHeaderLen  then 
			break
		end

		bodyLenthFir = string.byte(packstr, index)
	 	bodyLenthSec = string.byte(packstr, index+1) * 256
		bodyLength = bodyLenthFir + bodyLenthSec

		bodyStartIndex = index + socketHeaderLen 
	end
	return body
end


function m:dispatchMessage(msgTbl)
	if msgTbl.m_msgId ~= 16 then
		dump(msgTbl,"["..self.socketName.."]")
	end

	local rcvMsgListener = self.rcvMsgListeners[msgTbl.m_msgId] 
	
	if rcvMsgListener then
		for i = #rcvMsgListener,1,-1 do 
			local v = rcvMsgListener[i] 
			if not v[1] or not v[2] or not v[1].ctor then 
				table.remove(rcvMsgListener,i)
				log("["..self.socketName.."]".." Warning not unRegister Message MsgId == " .. tostring(msgTbl.m_msgId))
			else
				v[2](v[1], msgTbl)	
			end 
		end
	else
		log("["..self.socketName.."]".." Warning Could not handle Message MsgId == " .. tostring(msgTbl.m_msgId))
	end
end

function m:registerMsgListener(msgId, msgTarget, msgFunc)
	if not msgTarget or not msgFunc or not msgId then 
		assert(false,"msgTarget , msgFunc , msgId  Invalid arguments")
		return 
	end

	for _msgId,_listener in pairs(self.rcvMsgListeners) do 
		for k,v in ipairs(_listener) do 
			if _msgId == msgId and msgTarget == v[1] and msgFunc == v[2] then 
				return 
			end
		end
	end

	self.rcvMsgListeners[msgId] = self.rcvMsgListeners[msgId] or {}
	table.insert(self.rcvMsgListeners[msgId], {msgTarget, msgFunc})
end

function m:unregisterMsgListener(msgId)
	self.rcvMsgListeners[msgId] = nil 
end

function m:unRegisterMsgListenerByTarget( target )
	for msgId, listener in pairs(self.rcvMsgListeners) do 

		for i=#listener,1,-1 do 
			local v = listener[i]
			if v[1] == target then 
				table.remove(listener,i)
			end
		end

		if #self.rcvMsgListeners[msgId] == 0 then 
			self.rcvMsgListeners[msgId] = nil 
		end
	end
end

function m:setDelayTime( delayTime )
	log("["..self.socketName.."] delayTime =  "..delayTime .. "  self.delayTime = "..self.delayTime )
	if self.delayTime < delayTime then 
		self.delayTime = delayTime
	end
end

function m:cancelDelayTime( )
	log("["..self.socketName.."] cancelDelayTime")
	self.delayTime = 0
end

function m:close()
	self:initSocket()
end

function m:initSocket()
	self.tcpConnSucc = false
	
	if self.tcpConn then
		self.tcpConn:close()
		self.tcpConn = nil
	end

	if self.scheduleHandler then 
		gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
		self.scheduleHandler = nil 
	end

	self.recvBuffer = ""
	self.recvMsgCache = {}

	self.hearBeatCounter = 0
	self.connectTime = 0

	self.heartbeatCD = heartbeatCD

	self.isLogin = true

	self.delayTime = 0 

	self:unRegisterMsgListenerByTarget(self)
end

function m:setDelegate(delegate)
	self.delegate = delegate
end

function m:onConnect()
	log("["..self.socketName.."]".. " onConnect")
	
	if self.delegate and self.delegate.onConnect then 
		self.delegate:onConnect(self)
	end
end

function m:onError(errorInfo)
	log("["..self.socketName.."]".. " onError")

	if self.delegate and self.delegate.onError then 
		self.delegate:onError(self,errorInfo)
	end
end

return m