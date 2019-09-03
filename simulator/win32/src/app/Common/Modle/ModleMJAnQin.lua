

--ModleMJAnQin

local m = class("ModleMJAnQin")
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

-- 4：风牌：东，南，西，北
-- 5：箭牌：中，发，白
n.HuaCard = {
	["4_1"] = true,
	["5_1"] = true,
	["5_2"] = true,
	["5_3"] = true,
}
function m:IsHuaCard(color,num)
	--中发白东风
	local key = color .. "_" .. num
	return n.HuaCard[key]
end


return m