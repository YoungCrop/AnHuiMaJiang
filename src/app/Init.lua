
--app.Init
local m = {}
-- 全局变量
cc.exports.log = function(msg, ...)
    msg = tostring(msg) .. " "
    local args = {...}
    for i,v in ipairs(args) do
        msg = msg .. tostring(v) .. " "
    end
    print(os.date("%Y-%m-%d %H:%M:%S") .. " : " ..msg)
end

cc.exports.handlerEx = function(obj, method,args1,args2)
    return function(...)
    	if args1 then
            if args2 then
                return method(obj,args1,args2,...)
            end
        	return method(obj,args1,...)
    	end
        return method(obj, ...)
    end
end

cc.exports.gt = cc.exports.gt or {}

function m.init()
    package.loaded["app.GameConfig"] = nil
    cc.exports.gGameConfig = require("app.GameConfig")

    package.loaded["app.Common.FacadeService"] = nil
    cc.exports.gComm = require("app.Common.FacadeService").init()

    package.loaded["app.Common.Modle.DataCenter"] = nil
    cc.exports.gData = require("app.Common.Modle.DataCenter").new()
end

return m