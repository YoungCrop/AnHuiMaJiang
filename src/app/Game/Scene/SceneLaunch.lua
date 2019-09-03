
local m = class("SceneLaunch", gComm.SceneBase)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    if "android" == device.platform then
		local spriteLaunch = cc.Sprite:create("Image/BigImg/android_start_up_logo.png")
		spriteLaunch:setPosition(display.cx, display.cy)
		self:addChild(spriteLaunch)
	end
end

function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")
    
    local function cbFun()
		require("app.Game.Scene.SceneManager").goSceneLogin()
		-- 30s启动Lua垃圾回收器
		cc.Director:getInstance():getScheduler():scheduleScriptFunc(function(delta)
			local preMem = collectgarbage("count")
			-- 调用lua垃圾回收器
			for i = 1, 3 do
				collectgarbage("collect")
			end
			local curMem = collectgarbage("count")
			log(string.format("Collect lua memory:[%d] cur cost memory:[%d]", (curMem - preMem), curMem))
			local luaMemLimit = 30720
			if curMem > luaMemLimit then
				log("Lua memory limit exceeded!")
			end
		end, 30, false)
    end

    if "android" == device.platform then
		local callFunc = cc.CallFunc:create(cbFun)
		local seqAction = cc.Sequence:create(callFunc)
		self:runAction(seqAction)
	else
		cbFun()
	end

end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    m.super.onCleanup(self)
    log(self.__TAG,"onCleanup")
end

return m