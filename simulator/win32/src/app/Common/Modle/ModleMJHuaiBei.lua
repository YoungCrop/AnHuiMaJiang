

--ModleMJHuaiBei

local m = class("ModleMJHuaiBei")
local n = {}

function m:ctor()    
	self.__TAG = "[[" .. self.__cname .. "]] --===-- "

	self:init()
end

function m:init()
	--玩家信息
	self.playerInfo = {}

	--玩家状态
	self.playerState = {}

	--游戏状态
	self.gameState = {
		flagReqedTingInfo = false,--已经请求听的信息
	}
end

function m:clear()
end

function m:IsHuaCard(color,num)
	return false
end


return m