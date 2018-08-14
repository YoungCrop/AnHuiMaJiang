--
-- 个人信息
--

local m = class("ModleSelfUser")

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self:init()
end

function m:init()
	self.uid = nil
	self.sPos = 0  --服务器端位置，是从0开始的
	self.s2uiPos = self.sPos + 1 --服务器端位置对应UI位置，UI是从1开始的
	self.uiPos = 4 --UI位置
end

function m:clean()
	self:init()
end

function m:printInfo()
	local str = self.__TAG .. "=========print myself info\n"
	str = str .. "     uid= " .. self.uid .. " \n"
	str = str .. "    sPos= " .. self.sPos .. " \n"
	str = str .. " s2uiPos= " .. self.s2uiPos .. " \n"
	str = str .. "   uiPos= " .. self.uiPos .. " \n"
	str = str .. "=============================\n"
	print(str)
end

return m