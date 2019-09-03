cc.FileUtils:getInstance():setPopupNotify(false)

local writePath = cc.FileUtils:getInstance():getWritablePath()
local resSearchPaths = {
	writePath,
	writePath .. "src_et/",
	writePath .. "src/",
	writePath .. "res/",
	"src_et/",
	"src/",
	"res/"
}
cc.FileUtils:getInstance():setSearchPaths(resSearchPaths)

require("config")
require("cocos.init")

--谨记在心，热更新没有走这里
-- cc.exports.log = function(msg, ...)
--     msg = msg .. " "
--     local args = {...}
--     for i,v in ipairs(args) do
--         msg = msg .. tostring(v) .. " "
--     end
--     print(os.date("%Y-%m-%d %H:%M:%S") .. " : " ..msg)
-- end

__G__TRACKBACK__ = function(msg)
    -- record the message
    local message = msg

    print(message)

    -- auto genretated
    local msg = debug.traceback(msg, 3)

    if require("app.GameConfig").upLoadBugly then
		-- report lua exception
        if device.platform == "android" or device.platform == "ios" then
            buglyReportLuaException(tostring(message), debug.traceback())
        end
    end
    if require("app.GameConfig").isPrintLog then
        require("app.Game.UI.UITools.UIDebugLog"):create(msg)
	end

    return msg
end


local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
