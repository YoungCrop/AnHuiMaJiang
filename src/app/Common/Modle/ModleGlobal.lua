--
-- 全局变量
--

--ModleGlobal
local gComm = cc.exports.gComm

local m = class("ModleGlobal")

function m:ctor(gSelfUserModle)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self:initData()
end

function m:initData()
	self.EnumCountDownFCM = 3 * 3600 --3小时
    self.countDownTime = 0
    self.isShowFCMLayer = false
    self.appVersion = "1.0.1"
    self.marqueeStr = ""

	self.isGM = false
	self.userID = ""
	self.roomCardsCount = {}
	
	self.SelfInfo = {--玩家自己的信息
		userID   = 0,
		nikeName = "",--昵称
		nikeNameShort = "",--简化昵称
		sex      = 1,--1男，2女
		headURL  = "",--头像地址
		IP       = "",--ip地址
		GM       = 1,--gm号. -- 是否是gm 0不是  1是
		isGM     = false,
		coinNum  = 0,--金币
		m_coinBig= 4,--大玩法，4斗地主,5安庆点炮,6淮北麻将
	}
end

function m:setSelfInfo(param)
	if param.userID then
		self.SelfInfo.userID   = param.userID
		self.userID   = param.userID
	end
	if param.nikeName then
		self.SelfInfo.nikeName = param.nikeName
		self.SelfInfo.nikeNameShort = gComm.StringUtils.GetShortName(param.nikeName)
	end
	if param.sex then
		self.SelfInfo.sex      = param.sex
	end
	if param.headURL then
		self.SelfInfo.headURL  = param.headURL
	end
	if param.IP then
		self.SelfInfo.IP  	   = param.IP
	end
	if param.GM then
		self.SelfInfo.GM       = param.GM
		self.SelfInfo.isGM     = (param.GM == 1)
	end
	if param.coinNum then
		self.SelfInfo.coinNum   = param.coinNum
	end
	if param.m_coinBig then
		self.SelfInfo.m_coinBig = param.m_coinBig
	end
	-- cc.exports.gData.ModleGlobal.userID
end

function m:getSelfInfo()
	return self.SelfInfo
end

function m:clean()
	self:initData()
end

function m:printAllInfo()
	dump(self.SelfInfo,self.__TAG .. "==printAllInfo==")
end

return m
