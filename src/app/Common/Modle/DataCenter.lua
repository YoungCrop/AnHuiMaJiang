--
-- 数据中心
--
local m = class("DataCenter")

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initModule()
end

--清除数据
function m:clear()
    self:initModule()
end

function m:initModule()

    self.ModleSelfUser = require("app.Common.Modle.ModleSelfUser").new()
    self.ModleRoom = require("app.Common.Modle.ModleRoom").new(self.ModleSelfUser)
    self.ModleMJAnQin = require("app.Common.Modle.ModleMJAnQin").new()
    self.ModleGlobal = require("app.Common.Modle.ModleGlobal").new()
     


    print(self.__TAG .. "DataCenter:initModule")
end


return m