--
-- 房间信息系统，用户进入房间后，各玩家信息的管理
--
--

local m = class("ModleRoom")

--opCode,1左操作，2自操作，3右操作，4对门操作
m.opCodeEnum = {
	LeftOp     = 1,
	RightOp    = 2,
	SelfOp     = 3,
	OppositeOp = 4,
}

function m:ctor(gSelfUserModle)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self.gSelfUserModle = gSelfUserModle
	self:initData()
end

function m:initData()
	self.mRoomInfo = {} --房间信息
	-- self.mUidPlayers = {} --房间玩家 uid = {}--暂时不用
	self.sPosPlayers = {} --房间玩家 serverPos = {}
	self.uiPosPlayers = {} --UI座位 玩家数据 UIseatPos = {}
	self.gSelfUserModle:clean()
end

--ui位置编号
--   2
--3     1
--   4

function m:enterRoom(info)
	dump(info,self.__TAG .. "===enterRoom===")

    local roomPlayer = {
    	UID       = info.uid,
    	nickname  = info.nickname,
        headURL   = info.headURL,
        sex       = info.sex,
	    IP        = info.ip,

	    sPos       = info.m_pos,--服务器端从0开始
	    readyState = info.readyState, --0未准备，1️已准备
		score      = info.score,
		uiPos      = info.displaySeatIdx,
	}
	-- -- 逻辑座位和显示座位偏移量(从0编号开始)
	-- self.seatOffset = 3 - info.m_pos
	-- self.mRoomInfo["seatOffset"] = self.seatOffset

 --    self.gSelfUserModle.uid = info.uid
 --    self.gSelfUserModle.sPos = info.m_pos
 --    self.gSelfUserModle.s2uiPos = info.m_pos + 1
 --    self.gSelfUserModle.uiPos = 4


    self:addPlayer(roomPlayer)
end


function m:updateRoomInfo(info)
	local data = {
		roomType     = info.m_RoomType  ,--房间类别，0普通，1代开，2大奖赛
		roomID       = info.m_deskId    ,--房间号
		gameID       = info.m_gameID    ,--游戏编号；4斗地主；5安庆点炮
		maxCircle    = info.m_maxCircle ,--最大局数
		sumPlayerNum = info.m_playerNum ,--总玩家
		ruleTypeArray= info.m_playtype  ,--玩法规则
	}

	for k,v in pairs(info.m_playtype) do
		if v > 10000 then
			data.diFen = v % 10000 --淮北麻将
		end
	end

	self.mRoomInfo = data
	return self.mRoomInfo
end

function m:getRoomInfo()
	return self.mRoomInfo
end

function m:getRules()
	-- body
end


function m:clean()
	self:initData()
end

function m:addPlayer(playerInfo)
	local info = {}
	for k,v in pairs(playerInfo) do
		info[k] = v
	end

	info.isReady = (info.readyState == 1) --已经准备
	info.isBanker = false --庄家，默认值
	info.isFangZhu = (info.sPos == 0) --房主，服务器端sPos为房主


	self.sPosPlayers[info.sPos] = info
	self.uiPosPlayers[info.uiPos] = info

	dump(info,self.__TAG .. "===addPlayer===")
	return info
end

function m:removePlayerByUIPos(uiPos)
	local info = self.uiPosPlayers[uiPos]
	if info then
		-- self.mUidPlayers[info.UID] = nil
		self.sPosPlayers[info.sPos] = nil
		self.uiPosPlayers[info.uiPos] = nil
	else
		log(self.__TAG .. "===removePlayerBySPos===",uiPos)
		dump(self.uiPosPlayers,"removePlayerByUIPos====")
	end
end

function m:removePlayer(infoTemp)
	local info = self.sPosPlayers[infoTemp.sPos]
	if info then
		-- self.mUidPlayers[info.UID] = nil
		self.sPosPlayers[info.sPos] = nil
		self.uiPosPlayers[info.uiPos] = nil
	else
		dump(infoTemp,self.__TAG .. "===removePlayer===")
	end
end

function m:getPlayerInfoBySPos(sPos)
	dump(self.sPosPlayers,"====getPlayerInfoBySPos===")
	return self.sPosPlayers[sPos]
end

-- m.opCodeEnum = {
-- 	LeftOp     = 1,
-- 	RightOp    = 2,
-- 	SelfOp     = 3,
-- 	OppositeOp = 4,
-- }
--opCode,1左操作，2自操作，3右操作，4对门操作
m.OpCode3Person = {
	[1] = {
		[1] = m.opCodeEnum.SelfOp,
		[3] = m.opCodeEnum.OppositeOp,
		-- [4] = m.opCodeEnum.LeftOp,
		[4] = m.opCodeEnum.RightOp,
		},
	[3] = {
		[1] = m.opCodeEnum.OppositeOp,
		[3] = m.opCodeEnum.SelfOp,
		[4] = m.opCodeEnum.RightOp,
		},
	[4] = {
		[1] = m.opCodeEnum.RightOp,
		[3] = m.opCodeEnum.LeftOp,
		[4] = m.opCodeEnum.SelfOp,
		},
}

m.OpCode4Person = {
	[1] = {
		[2] = m.opCodeEnum.RightOp,
		[4] = m.opCodeEnum.LeftOp,
		},
	[2] = {
		[1] = m.opCodeEnum.LeftOp,
		[3] = m.opCodeEnum.RightOp,
		},
	[3] = {
		[2] = m.opCodeEnum.LeftOp,
		[4] = m.opCodeEnum.RightOp,
		},
	[4] = {
		[1] = m.opCodeEnum.RightOp,
		[3] = m.opCodeEnum.LeftOp,
		},
}
function m:getOprateCodeName(selfSPos,oprateSPos)
	log("getOprateCodeName(selfSPos,oprateSPos)==",selfSPos,oprateSPos)
	local selfUiPos = self.sPosPlayers[selfSPos] and self.sPosPlayers[selfSPos].uiPos or nil
	local oprateUiPos = self.sPosPlayers[oprateSPos] and self.sPosPlayers[oprateSPos].uiPos or nil
	if (not selfUiPos) or (not oprateUiPos) then
		log("selfSPos=,oprateSPos= ==",selfSPos,oprateSPos)
		dump(self.sPosPlayers)
		return m.opCodeEnum.SelfOp
	end
	log("getOprateCodeName(selfUiPos,oprateUiPos)==",selfUiPos,oprateUiPos)
	if self.mRoomInfo.sumPlayerNum == 2 then
		if selfUiPos == oprateUiPos then
			return m.opCodeEnum.SelfOp
		else
			return m.opCodeEnum.OppositeOp
		end
	elseif self.mRoomInfo.sumPlayerNum == 3 then
		return m.OpCode3Person[selfUiPos][oprateUiPos]
	elseif self.mRoomInfo.sumPlayerNum == 4 then
		if selfUiPos == oprateUiPos then
			return m.opCodeEnum.SelfOp
		elseif math.abs(selfUiPos-oprateUiPos) == 2 then
			return m.opCodeEnum.OppositeOp
		else
			return m.OpCode4Person[selfUiPos][oprateUiPos]
		end
	end
end

--回放
function m:setUIPosBySPos(sPos,uiPos,sumPlayerNum)
	self.sPosPlayers[sPos] = {uiPos = uiPos}
	self.mRoomInfo.sumPlayerNum = sumPlayerNum
end

function m:getPlayerInfo( ... )
	-- body
end

function m:updatePlayerInfo( ... )
	-- body
end

return m
