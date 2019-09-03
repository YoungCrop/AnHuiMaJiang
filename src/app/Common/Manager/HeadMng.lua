
local m = class("HeadMng", function()
	return display.newNode()
end)

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	self.headImageObservers = {}
    self:enableNodeEvents()
end

function m:update(delta)
	for i=#self.headImageObservers,1,-1 do
		local data = self.headImageObservers[i]
		if cc.FileUtils:getInstance():isFileExist(data.imgFileName) then
			data.headSpr:setTexture(data.imgFileName)
			-- 更新下载后的url
			cc.UserDefault:getInstance():setStringForKey(data.headURLKey, data.headURL)
			table.remove(self.headImageObservers,i)
		end
	end
end

function m:attach(headSpr, playerUID, headURL)
	log("====attachattach=====",headSpr,playerUID,headURL)
	if (not headSpr) or (not headURL) or (string.len(headURL) < 10) then
		return
	end

	if string.sub(headURL, -2) == "/0" then
		headURL = string.sub(headURL, 1, -3) .."/96"
	elseif string.sub(headURL, -4) == "/132" then
		headURL = string.sub(headURL, 1, -5) .."/96"
	end

	local imgFileName = string.format("head_img_%s.png", playerUID .. "")
	local observerData = {
		headSpr = headSpr,
		imgFileName = cc.FileUtils:getInstance():getWritablePath() .. imgFileName,
		headURL = headURL,
		headURLKey = "headURLKey_" .. playerUID,
	}
	if cc.FileUtils:getInstance():isFileExist(observerData.imgFileName) then
		observerData.headSpr:setTexture(observerData.imgFileName)
	end
	
	local saveHeadURL = cc.UserDefault:getInstance():getStringForKey(observerData.headURLKey)
	if saveHeadURL ~= headURL then
		log("====attachattach====headURL=",saveHeadURL,headURL)
		-- if cc.FileUtils:getInstance():isFileExist(observerData.imgFileName) then
		-- 	-- self:removeFile(observerData.imgFileName)
		-- end
		cc.UtilityExtension:httpDownloadImage(headURL, playerUID)
		table.insert(self.headImageObservers, observerData)
	 end
end

function m:detach(headSpr)
	for i=#self.headImageObservers,1,-1 do
		if self.headImageObservers[i].headSpr == headSpr then
			table.remove(self.headImageObservers, i)
		end
	end
end

function m:detachAgentIcon( playerUID )
	local key = "headURLKey_" .. playerUID
	for i=#self.headImageObservers,1,-1 do
		if self.headImageObservers[i].headURLKey == key then
			table.remove(self.headImageObservers, i)
		end
	end
end

function m:setDefaultIcon(headSpr)
	if headSpr then
		headSpr:setSpriteFrame("Image/GComm/comm_head_icon.png")
	end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
	self.scheduleHandler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.update), 2, false)
end

function m:onExit()
    log(self.__TAG,"onExit")
	if self.scheduleHandler then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleHandler)
	end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end

function m:removeFile( path )
    io.writefile(path, "")
    if device.platform == "windows" then
        os.remove(string.gsub(path, '/', '\\'))
    else
        cc.FileUtils:getInstance():removeFile( path )
    end
end

return m