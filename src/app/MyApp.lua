
local EventCmdID = require("app.Common.Config.EventCmdID")

local m = class("MyApp", cc.load("mvc").AppBase)

cc.exports.gApp = cc.exports.gApp or m

function m:ctor()
    --初始化随机种子
    math.newrandomseed()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	self:initResPath()
    self:resetDisplay()

	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local customListenerBg = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",
								handler(self, self.onEnterBackground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
	local customListenerFg = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT",
								handler(self, self.onEnterForeground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

	cc.Device:setKeepScreenOn(true)
	self.m_enterBackGroundTime = os.time()
	require("app.Init").init()
	cc.exports.gData.ModleGlobal.countDownTime = cc.UserDefault:getInstance():getIntegerForKey("GlobalCountDownFCM", 0)
    gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)
end

function m:run()
	local logoScene = require("app.Game.Scene.SceneLaunch"):create()
	cc.Director:getInstance():runWithScene(logoScene)
end


--初始化资源路径
function m:initResPath()
    print("=============m:initResPath=============")

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
end


function m:resetDisplay()
        -- 重置display 参数
    local winSize = cc.Director:getInstance():getWinSize()
    display.size               = {width = winSize.width, height = winSize.height}
    display.width              = display.size.width
    display.height             = display.size.height
    display.cx                 = display.width / 2
    display.cy                 = display.height / 2
    display.c_left             = -display.width / 2
    display.c_right            = display.width / 2
    display.c_top              = display.height / 2
    display.c_bottom           = -display.height / 2
    display.left               = 0
    display.right              = display.width
    display.top                = display.height
    display.bottom             = 0
    display.widthInPixels      = display.sizeInPixels.width
    display.heightInPixels     = display.sizeInPixels.height

    printInfo("##################### m:resetDisplay #####################")
    printInfo(string.format("# CONFIG_SCREEN_WIDTH          = %0.2f", CONFIG_SCREEN_WIDTH))
    printInfo(string.format("# CONFIG_SCREEN_HEIGHT         = %0.2f", CONFIG_SCREEN_HEIGHT))
    printInfo(string.format("# display.widthInPixels        = %0.2f", display.widthInPixels))
    printInfo(string.format("# display.heightInPixels       = %0.2f", display.heightInPixels))
    printInfo(string.format("# display.contentScaleFactor   = %0.2f", display.contentScaleFactor))
    printInfo(string.format("# display.width                = %0.2f", display.width))
    printInfo(string.format("# display.height               = %0.2f", display.height))
    printInfo(string.format("# display.cx                   = %0.2f", display.cx))
    printInfo(string.format("# display.cy                   = %0.2f", display.cy))
    printInfo(string.format("# display.left                 = %0.2f", display.left))
    printInfo(string.format("# display.right                = %0.2f", display.right))
    printInfo(string.format("# display.top                  = %0.2f", display.top))
    printInfo(string.format("# display.bottom               = %0.2f", display.bottom))
    printInfo(string.format("# display.c_left               = %0.2f", display.c_left))
    printInfo(string.format("# display.c_right              = %0.2f", display.c_right))
    printInfo(string.format("# display.c_top                = %0.2f", display.c_top))
    printInfo(string.format("# display.c_bottom             = %0.2f", display.c_bottom))
    printInfo("##################### m:resetDisplay End ####################")
end

function m:onEnterBackground()
    print("======== m:onEnterBackground ==========")
	-- 音效引擎
	if cc.exports.gComm.SoundEngine then
		cc.exports.gComm.SoundEngine:pauseAllSound()
	end

	self.m_enterBackGroundTime = os.time()

	if EventCmdID.EventType and EventCmdID.EventType.APP_ENTER_BACKGROUND_EVENT then
		cc.exports.gComm.EventBus.dispatchEvent( EventCmdID.EventType.APP_ENTER_BACKGROUND_EVENT )
	end
end

function m:onEnterForeground()
    print("======== m:onEnterForeground ==========")

	-- 音效引擎
	if cc.exports.gComm.SoundEngine then
		cc.exports.gComm.SoundEngine:resumeAllSound()
	end
	
	-- 发送心跳，判断链接是否已经断开
	if cc.exports.gt.socketClient then
		cc.exports.gt.socketClient:sendHeartbeat(true)
	end

	if not cc.exports.gGameConfig.isiOSAppInReview then
    	print("======== m:onEnterForeground ========2==")
		local diffTime = os.difftime(os.time(),self.m_enterBackGroundTime)
		if diffTime > 10 * 60  then ---默认5s
		-- if diffTime > 0.015 * 60  then --为了测试
    		print("======== m:onEnterForeground ========3==")
			
			cc.SpriteFrameCache:getInstance():removeSpriteFrames()
			cc.Director:getInstance():getTextureCache():removeAllTextures()
			require("app.Game.Scene.SceneManager").goSceneUpdate()
		else
			self.m_enterBackGroundTime = os.time()
		end
		if EventCmdID.EventType and EventCmdID.EventType.APP_ENTER_FOREGROUND_EVENT then
			cc.exports.gComm.EventBus.dispatchEvent(EventCmdID.EventType.APP_ENTER_FOREGROUND_EVENT)
		end	
	end
end

function m:update(delta)
	-- log("self.countDownTime=",cc.exports.gData.ModleGlobal.countDownTime)
	if cc.exports.gData.ModleGlobal.isShowFCMLayer == false then
	    cc.exports.gData.ModleGlobal.countDownTime = cc.exports.gData.ModleGlobal.countDownTime + 1
	    if cc.exports.gData.ModleGlobal.countDownTime % 60 == 0 then
	    	cc.UserDefault:getInstance():setIntegerForKey("GlobalCountDownFCM", cc.exports.gData.ModleGlobal.countDownTime)
	    end
		if cc.exports.gData.ModleGlobal.countDownTime >= cc.exports.gData.ModleGlobal.EnumCountDownFCM then
	    	local runningScene = cc.Director:getInstance():getRunningScene()
	    	if runningScene and runningScene:getName() == "SceneLobby" then
	    		local layer = require("app.Game.UI.UICommon.UINoticeTipsFCM"):create()
	    		runningScene:addChild(layer, 1234)
	    		cc.exports.gData.ModleGlobal.isShowFCMLayer = true
	    	end
		end
	end
end

return m
