
local gt = cc.exports.gt

local NetCmd = require("app.Common.NetMng.NetCmd")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")

local resCsb = "Csd/Scene/SceneLogin.csb"

local n = {}
n.btnMap = {
	btnLoginLocal = "btnLoginLocal",
	btnLoginWX    = "btnLoginWX",
	txtAgreement  = "txtAgreement",
}
n.nodeMap = {
	tfUserName   = "tfUserName",
	nodeUserName = "nodeUserName",
	txtVersion   = "txtVersion",
	cbAgreement  = "cbAgreement",
	imgBG        = "imgBG",
	spriteLogo      = "spriteLogo",
	spriteLogoCheck = "spriteLogoCheck",
}

local m = class("SceneLogin",gComm.SceneBase)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    args = args or {}
    self.param = {
    	isReset = args.isReset,
	}
	self.nodeMap = {}
	self:init()
end

function m:init()
	self.needLoginWXState = 0 -- 本地微信登录状态

	local csbNode = cc.CSLoader:createNodeWithVisibleSize(resCsb)
	self.rootNode = csbNode
	self:addChild(csbNode)
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.nodeMap[k] = btn
    end
    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end

	self.nodeMap["imgBG"]:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

	if gt.socketClient then
        gt.socketClient:close()
    end

    gt.socketClient = require("app.Core.Net.SocketClient"):create()
    gt.socketClient:setDelegate(self)

	-- 初始化呀呀云sdk
	gComm.CallNativeMng.NativeYaya:createYayaSDK()


	self:regEventSceneBase()
    self:regEvent()

	-- 自动登录
	self.autoLoginRet = self:checkAutoLogin()

	-- 资源版本号
	local appVersion = gComm.CallNativeMng.AppNative:getAppVersionName()
	local resVersion = gComm.FunUtils.getResVersion()
	self.nodeMap["txtVersion"]:setString("resVersion:" .. resVersion .. "\nappVersion:" .. appVersion)

	cc.exports.gData.ModleGlobal.appVersion = appVersion

	self:initDebugServer()

	if gGameConfig.debugMode then
		self.nodeMap["btnLoginLocal"]:setVisible(true)
		self.nodeMap["nodeUserName"]:setVisible(true)
	else
		self.nodeMap["btnLoginLocal"]:setVisible(false)
		self.nodeMap["nodeUserName"]:setVisible(false)
		self.nodeMap["btnLoginWX"]:setVisible(true)
	end

	if gGameConfig.isiOSAppInReview or gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		self.nodeMap["btnLoginLocal"]:setVisible(true)
		self.nodeMap["btnLoginWX"]:setVisible(false)
		self.nodeMap["btnLoginLocal"]:setPosition(self.nodeMap["btnLoginWX"]:getPosition())
	end

	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		self.nodeMap["spriteLogoCheck"]:setVisible(true)
		self.nodeMap["spriteLogo"]:setVisible(false)
	else
		self.nodeMap["spriteLogoCheck"]:setVisible(false)
		self.nodeMap["spriteLogo"]:setVisible(true)
	end
end

function m:initDebugServer()
	if gGameConfig.CurServerIndex > gGameConfig.ServerTypeKey.sTestOuter then
		local chooseServerNum = cc.UserDefault:getInstance():getIntegerForKey("chooseServerNum",gGameConfig.CurServerIndex)
		for j=1,#gGameConfig.debugServer do
			local button = ccui.Button:create()
			button:setPosition(cc.p(150,450-j*60))
			button:setTag(j)
			button:setTitleFontSize(32)
			button:setTitleText(gGameConfig.debugServer[j]["sName"])
			button:setTitleColor(cc.c4b(255,0,0,255))
			self.rootNode:addChild(button)

			button:addClickEventListener(handler(self, self.chooseServer))
			if j == chooseServerNum then
				self:chooseServer(button)
			end
		end
	end
end

function m:chooseServer(senderLabel)
	local sendTag = senderLabel:getTag()
	for i=1,#gGameConfig.debugServer do
		local bnt = self.rootNode:getChildByTag(i)
		if sendTag == i then
			bnt:setTitleColor(cc.c4b(0,255,0,255))
			cc.exports.gGameConfig.SetConfig(sendTag)
			cc.UserDefault:getInstance():setIntegerForKey("chooseServerNum",sendTag)
			cc.UserDefault:getInstance():flush()
		else
			if bnt then
				bnt:setTitleColor(cc.c4b(255,0,0,255))
			end
		end
	end
end

function m:onRecvIsActivities(msgTbl)
	-- 苹果审核 无活动
	if cc.exports.gGameConfig.isiOSAppInReview then
	end
end

function m:godNick(text)
	local s = string.find(text, "\"nickname\":\"")
	if not s then
		return text
	end
	local e = string.find(text, "\",\"sex\"")
	local n = string.sub(text, s + 12, e - 1)
	local m = string.gsub(n, '"', '\\\"')
	local i = string.sub(text, 0, s + 11)
	local j = string.sub(text, e, string.len(text))
	return i .. m .. j
end

function m:checkAutoLogin()
	-- 获取记录中的token,freshtoken时间
	local accessTokenTime  = cc.UserDefault:getInstance():getStringForKey( "WX_Access_Token_Time" )
	local refreshTokenTime = cc.UserDefault:getInstance():getStringForKey( "WX_Refresh_Token_Time" )

	if self.param.isReset then
		return false
	end

	if string.len(accessTokenTime) == 0 or string.len(refreshTokenTime) == 0 then -- 未记录过微信token,freshtoken,说明是第一次登录
		return false
	end

	-- 检测是否超时
	local curTime = os.time()
	local accessTokenReconnectTime  = 5400    -- 3600*1.5   微信accesstoken默认有效时间未2小时,这里取1.5,1.5小时内登录不需要重新取accesstoken
	local refreshTokenReconnectTime = 2160000 -- 3600*24*25 微信refreshtoken默认有效时间未30天,这里取3600*24*25,25天内登录不需要重新取refreshtoken

	-- 需要重新获取refrshtoken即进行一次完整的微信登录流程
	if curTime - refreshTokenTime >= refreshTokenReconnectTime then -- refreshtoken超过25天
		-- 提示"您的微信授权信息已失效, 请重新登录！"
		-- UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0030"))
		return false
	end

	-- 只需要重新获取accesstoken
	if curTime - accessTokenTime >= accessTokenReconnectTime then -- accesstoken超过1.5小时
		self.xhrRefreshToken = cc.XMLHttpRequest:new()
		self.xhrRefreshToken.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
		local refresh_token = cc.UserDefault:getInstance():getStringForKey( "WX_Refresh_Token")
		local refreshTokenURL = gComm.CallNativeMng.NativeWeiXin:getRefreshTokenUrl(authCode)
		self.xhrRefreshToken:open("GET", refreshTokenURL)
		local function onResp()
			log("xhrRefreshToken.readyState is:" .. self.xhrRefreshToken.readyState .. " xhrRefreshToken.status is: " .. self.xhrRefreshToken.status)
			gComm.UIUtils.removeLoadingTips()
			if self.xhrRefreshToken.readyState == 4 and (self.xhrRefreshToken.status >= 200 and self.xhrRefreshToken.status < 207) then
				local response = self.xhrRefreshToken.response
				local respJson = json.decode(response)
				if respJson.errcode then
					-- 申请失败,清除accessToken,refreshToken等信息
					cc.UserDefault:getInstance():setStringForKey("WX_Access_Token", "")
					cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token", "")
					cc.UserDefault:getInstance():setStringForKey("WX_Access_Token_Time", "")
					cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token_Time", "")
					cc.UserDefault:getInstance():setStringForKey("WX_OpenId", "")
					cc.UserDefault:getInstance():setStringForKey("WX_uuId", "")

					self.autoLoginRet = false

					log("checkAutoLogin respJson.errcode = "..respJson.errcode)

					return false
				else
					self.needLoginWXState = 2 -- 需要更新accesstoken以及其时间

					local accessToken = respJson.access_token
					local refreshToken = respJson.refresh_token
					local openid = respJson.openid
					self:loginServerWeChat(accessToken, refreshToken, openid)

					log("checkAutoLogin self:loginServerWeChat ")

				end
			elseif self.xhrRefreshToken.readyState == 1 and self.xhrRefreshToken.status == 0 then

				log("checkAutoLogin xhrRefreshToken.readyState = "..self.xhrRefreshToken.readyState)

				self.autoLoginRet = false
				-- 本地网络连接断开
				UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0014"))
			end
			self.xhrRefreshToken:unregisterScriptHandler()
		end
		self.xhrRefreshToken:registerScriptHandler(onResp)
		self.xhrRefreshToken:send()
		gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))

		return true
	end

	-- accesstoken未过期,freshtoken未过期 则直接登录即可
	self.needLoginWXState = 1

	local accessToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Access_Token" )
	local refreshToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Refresh_Token" )
	local openid 		= cc.UserDefault:getInstance():getStringForKey( "WX_OpenId" )
	local unionid		= cc.UserDefault:getInstance():getStringForKey( "WX_uuId" )

	gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))

	self:loginServerWeChat(accessToken, refreshToken, openid)

	return true
end

function m:onRcvLogin(msgTbl)
	dump(msgTbl,"====login==onRcvLogin===")
	if msgTbl.m_errorCode == 5 then
		gComm.UIUtils.removeLoadingTips()
		self.autoLoginRet = false
		-- UINoticeTips:create("您尚未在"..msgTbl.m_errorMsg.."退出游戏，请先退出后再登陆此游戏！")
		return
	end
	-- 如果有进入此函数则说明token,refreshtoken,openid是有效的,可以记录.
	if self.needLoginWXState == 0 then
		-- 重新登录,因此需要全部保存一次
		cc.UserDefault:getInstance():setStringForKey( "WX_Access_Token", self.m_accessToken )
		cc.UserDefault:getInstance():setStringForKey( "WX_Refresh_Token", self.m_refreshToken )
		cc.UserDefault:getInstance():setStringForKey( "WX_OpenId", self.m_openid )
		cc.UserDefault:getInstance():setStringForKey( "WX_uuId", self.m_uuid )


		cc.UserDefault:getInstance():setStringForKey( "WX_Access_Token_Time", os.time() )
		cc.UserDefault:getInstance():setStringForKey( "WX_Refresh_Token_Time", os.time() )
	elseif self.needLoginWXState == 1 then
		-- 无需更改
		-- ...
	elseif self.needLoginWXState == 2 then
		-- 需更改accesstoken
		cc.UserDefault:getInstance():setStringForKey( "WX_Access_Token", self.m_accessToken )
		cc.UserDefault:getInstance():setStringForKey( "WX_Access_Token_Time", os.time() )
	end
	gt.socketClient:close()

	gt.socketClient:connect(msgTbl.m_gateIp, msgTbl.m_gatePort)

	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN_SERVER
	msgToSend.m_seed = msgTbl.m_seed
	msgToSend.m_id = msgTbl.m_id
	local catStr = tostring(msgTbl.m_seed)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))
	--gt.socketClient:sendMessage(msgToSend)
	self.gateMsg = msgToSend
end

-- start --
--------------------------------
-- @class function
-- @description 服务器返回登录大厅结果
-- end --
function m:onRcvLoginServer(msgTbl)
	dump(msgTbl,"---onRcvLoginServer---onRcvLoginServer")
	-- 取消登录超时弹出提示
	self.rootNode:stopAllActions()

	dump(msgTbl,"onRcvLoginServeronRcvLoginServer")

	if msgTbl.m_errorCode ~= 0 then
		gComm.UIUtils.removeLoadingTips()
		gComm.UIUtils.floatText("你好,登录失败,错误码为:" .. msgTbl.m_errorCode)
		return
	end

	-- 是否是gm 0不是  1是
	cc.exports.gData.ModleGlobal.isGM = (msgTbl.m_gm == 1)

	-- 玩家信息
	local headURL = msgTbl.m_face
	if string.sub(headURL, -2) == "/0" then
		headURL = string.sub(headURL, 1, -3) .."/96"
	elseif string.sub(headURL, -4) == "/132" then
		headURL = string.sub(headURL, 1, -5) .."/96"
	end
	local param = {
		userID    = msgTbl.m_id,
		nikeName  = msgTbl.m_nike,
		sex       = msgTbl.m_sex,
		headURL   = headURL,
		IP        = msgTbl.m_ip,
		GM        = msgTbl.m_gm,
		-- coinNum   = msgTbl.m_coin,
		m_coinBig = msgTbl.m_coinBig,
	}
	cc.exports.gData.ModleGlobal:setSelfInfo(param)

    -- report lua exception
    if gComm.FunUtils.IsiOSPlatform() or gComm.FunUtils.IsAndroidPlatform() then
 		buglySetUserId(tostring(param.userID))
    end

	-- 登录呀呀云语音sdk
	gComm.CallNativeMng.NativeYaya:loginYayaSDK(tostring(param.nikeName),tostring(param.userID))

	-- 判断进入大厅还是房间
	if msgTbl.m_state == 1 then
		-- msgTbl.m_version
		if msgTbl.m_version and msgTbl.m_version ~= "" then
			local res = gComm.StringUtils.compareVersion(gComm.FunUtils.getResVersion(),msgTbl.m_version)
			if ret == -1 then
				UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0061"),
				function()
					require("app.Game.Scene.SceneManager").goSceneUpdate()
				end)
				return
			end
		end
	else
		local isNewPlayer = msgTbl.m_new == 0 and true or false
		self.isNewPlayer = isNewPlayer

		gt.socketClient:unRegisterMsgListenerByTarget(self)
		gComm.EventBus.unRegAllEvent(self)

		-- 进入大厅主场景
		-- 判断是否是新玩家
    	cc.SpriteFrameCache:getInstance():removeSpriteFrames()
		cc.Director:getInstance():getTextureCache():removeAllTextures()

		local args = {isNewPlayer = isNewPlayer}
		require("app.Game.Scene.SceneManager").goSceneLobby(args)
	end
	gComm.UIUtils.removeLoadingTips()
end

function m:pushWXAuthCode(authCode)
	local desc = {
		["-2"] = "用户取消",
		["-4"] = "用户拒绝授权",
		["-5"] = "未知",
	}
	if authCode == "-2" or authCode == "-4" or authCode == "-5" then
		-- UINoticeTips:create(desc[authCode]) --android这时候资源还没有加载，图片是黑框
		gComm.UIUtils.floatText(desc[authCode])
		return
	end

	self.xhrAccessToken = cc.XMLHttpRequest:new()
	self.xhrAccessToken.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

	local accessTokenURL = gComm.CallNativeMng.NativeWeiXin:getAccessTokenUrl(authCode)
	self.xhrAccessToken:open("GET", accessTokenURL)
	function m:onRespPushWXAuthCode()
		if self.xhrAccessToken.readyState == 4 and (self.xhrAccessToken.status >= 200 and self.xhrAccessToken.status < 207) then
			local response = self.xhrAccessToken.response
			local respJson = json.decode(response)
			if respJson.errcode then
				-- 申请失败
				cc.UserDefault:getInstance():setStringForKey("WX_Access_Token", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Access_Token_Time", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token_Time", "")
				cc.UserDefault:getInstance():setStringForKey("WX_OpenId", "")
				cc.UserDefault:getInstance():setStringForKey("WX_uuId", "")

				self.autoLoginRet = false
				-- UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0030"))
			else
				local accessToken = respJson.access_token
				local refreshToken = respJson.refresh_token
				local openid = respJson.openid
				-- self:requestUserInfo(accessToken, openid)
				self:loginServerWeChat(accessToken, refreshToken, openid)
			end
		elseif self.xhrAccessToken.readyState == 1 and self.xhrAccessToken.status == 0 then
			self.autoLoginRet = false
			-- 本地网络连接断开
			UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0014"))
		end
		self.xhrAccessToken:unregisterScriptHandler()
	end
	self.xhrAccessToken:registerScriptHandler(handler(self,self.onRespPushWXAuthCode))
	self.xhrAccessToken:send()
end

-- 此函数可以去微信请求个人 昵称,性别,头像url等内容
function m:requestUserInfo(accessToken, refreshToken, openid)
    if self.xhrUserInfo then
        self.xhrUserInfo:unregisterScriptHandler()
        self.xhrUserInfo = nil
    end

	self.xhrUserInfo = cc.XMLHttpRequest:new()
	self.xhrUserInfo.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
	local userInfoURL = gComm.CallNativeMng.NativeWeiXin:getUerInfoUrl(accessToken, openid)

	self.xhrUserInfo:open("GET", userInfoURL)
	function m:onRespRequestUserInfo()
		if self.xhrUserInfo.readyState == 4 and (self.xhrUserInfo.status >= 200 and self.xhrUserInfo.status < 207) then
			local response = self.xhrUserInfo.response
			log("requestUserInforequestUserInfo===",response)
			response = string.gsub(response,"\\","")
			response = self:godNick(response)

			local respJson = json.decode(response)
			if respJson.errcode then
				-- 申请失败
				cc.UserDefault:getInstance():setStringForKey("WX_Access_Token", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Access_Token_Time", "")
				cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token_Time", "")
				cc.UserDefault:getInstance():setStringForKey("WX_OpenId", "")

				self.autoLoginRet = false
				if cc.exports.gGameConfig.isiOSAppInReview then
				else
					-- UINoticeTips:create( ConfigTxtTip.GetConfigTxt("LTKey_0030"))
				end

				gComm.UIUtils.removeLoadingTips()

				log("requestUserInfo respJson.errcode = "..respJson.errcode)
			else
				local sex 			= respJson.sex
				local nickname 		= respJson.nickname
				local headimgurl 	= respJson.headimgurl
				local unionid 		= respJson.unionid
				-- 登录
				self:sendRealLogin( accessToken, refreshToken, openid, sex, nickname, headimgurl, unionid)
				log("requestUserInfo sendRealLogin ",accessToken, refreshToken, openid, sex, nickname, headimgurl, unionid)
			end
		elseif self.xhrUserInfo.readyState == 1 and self.xhrUserInfo.status == 0 then
			self.autoLoginRet = false
			log("requestUserInfo xhrUserInfo.readyState =  "..self.xhrUserInfo.readyState)

			gComm.UIUtils.removeLoadingTips()
		end
		self.xhrUserInfo:unregisterScriptHandler()
	end
	self.xhrUserInfo:registerScriptHandler(handler(self,self.onRespRequestUserInfo))
	self.xhrUserInfo:send()
end

function m:sendRealLogin( accessToken, refreshToken, openid, sex, nickname, headimgurl, unionid )
	gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))

	gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip, cc.exports.gGameConfig.LoginServer.port,true)

	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN
	msgToSend.m_plate = "wechat"
	msgToSend.m_accessToken = accessToken
	msgToSend.m_refreshToken = refreshToken
	msgToSend.m_openId = openid
	msgToSend.m_severID = 13001
	msgToSend.m_sex = tonumber(sex)
	msgToSend.m_nikename = nickname
	msgToSend.m_imageUrl = headimgurl
	msgToSend.m_uuid = unionid
	msgToSend.m_nAppId =17002
	
	dump(msgToSend.m_imageUrl,"m_imageUrl")

	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview or
		 		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		msgToSend.m_plate = "local"
	end
	
	
	local isTest = false
	if isTest then
		msgToSend.m_openId = "of-HIv4uot2qiOCNd03b0CiV6zvo"
		msgToSend.m_sex = 1
		msgToSend.m_nikename = "云海飞鹰（艺）"
		msgToSend.m_imageUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eoyAW2AOvon90jiaXnyzl9ln9gcvWP7GspTNvT58LFnsaXpLeqerf8la41lletllCNTIXzsl0s4QXw/132"
		msgToSend.m_uuid = "o3bPawKBsaMFw9_mF9MqOhx1vUgE"
		
		-- msgToSend.m_openId = "of-HIvzIM9CU14CkCO_nMWbg39eE"
		-- msgToSend.m_sex = 1
		-- msgToSend.m_nikename = "小博"
		-- msgToSend.m_imageUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLT4GLNI0ChQTykaQxzEP7OGMTib2iawYkyvHK31urnDrza7XeeaMUPDnZQcq57UfN1GfDYUmibwQjFg/132"
		-- msgToSend.m_uuid = "o3bPawKr5i1qyhHkPXP9uZiAADww"
		
		
		msgToSend.m_openId = "of-HIv3NRDJ5Obg-8e-xfPo5U96E"
		msgToSend.m_sex = 2
		msgToSend.m_nikename = "~霐～"
		msgToSend.m_imageUrl = "http://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83epEJtI248ss3F0VBroImF62S4M6zVqC63GdzkYvDc9Bg2vMNt24d62I7Gia7LHqVDcT6du80kVhRVw/132"
		msgToSend.m_uuid = "o3bPawFpaxyLOPnzE7zUFZywNIj0"
		
		openid = msgToSend.m_openId
		unionid = msgToSend.m_uuid
	end

	-- msgToSend.m_unionid = unionid
	-- 保存sex,nikename,headimgurl,uuid,serverid等内容
	cc.UserDefault:getInstance():setStringForKey( "WX_Sex", tostring(sex) )
	cc.UserDefault:getInstance():setStringForKey( "WX_Uuid", unionid )
	-- cc.UserDefault:getInstance():setStringForKey( "WX_Nickname", nickname )
	gt.nickname = nickname
	cc.UserDefault:getInstance():setStringForKey( "WX_ImageUrl", headimgurl )

	local catStr = string.format("%s%s%s%s", openid, accessToken, refreshToken,unionid)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))
	--gt.socketClient:sendMessage(msgToSend)
	self.loginMsg = msgToSend

end

function m:loginServerWeChat(accessToken, refreshToken, openid)
	-- 保存下token相关信息,若验证通过,存储到本地
	self.m_accessToken 	= accessToken
	self.m_refreshToken = refreshToken
	self.m_openid 		= openid

	-- 请求昵称,头像等信息
	self:requestUserInfo( accessToken, refreshToken, openid )
end

function m:checkAgreement()
	if not self.nodeMap["cbAgreement"]:isSelected() then
		UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0041"))
		return false
	end

	return true
end


function m:onConnect( socket )
	if socket:whichSocket() then
		if self.loginMsg then
			gt.socketClient:sendMessage(self.loginMsg)
		end
	else
		if self.gateMsg then
			gt.socketClient:sendMessage(self.gateMsg)
		end
	end
end

function m:onError( socket ,errorInfo)
	gComm.UIUtils.removeLoadingTips()
	self.autoLoginRet = false
	socket:close()
	if errorInfo == "Network is unreachable" then
		UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0014"))
	elseif errorInfo == "connection refused" then
		UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_ConnectRefused"))
	elseif errorInfo == "Operation already in progress" then
		-- UINoticeTips:create("呵呵，链接进行中，请切换网络或关闭进程再试试！？！")
	else
		-- if errorInfo then
		-- 	UINoticeTips:create(errorInfo)
		-- end
	end
	--gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip,cc.exports.gGameConfig.LoginServer.port,true)
end
function m:onRcvJoinRoom(msgTbl)
	if msgTbl.m_errorCode ~= 0 then
		-- 进入房间失败
		gComm.UIUtils.removeLoadingTips()
		if msgTbl.m_errorCode == 1 then
			-- 房间人已满
			gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_0018"))
		else
			-- 房间不存在
			gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_0015"))
		end
	else
		gt.socketClient:unRegisterMsgListenerByTarget(self)
		gComm.EventBus.unRegAllEvent(self)

		-- 进入大厅主场景
		-- 判断是否是新玩家
    	cc.SpriteFrameCache:getInstance():removeSpriteFrames()
		cc.Director:getInstance():getTextureCache():removeAllTextures()

		local args = {isNewPlayer = self.isNewPlayer}
		require("app.Game.Scene.SceneManager").goSceneLobby(args)
	end
end
function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    log("--s_name---" .. s_name)
    gComm.BtnUtils.setButtonLockTime(_sender,0.5)
    if s_name == n.btnMap.btnLoginLocal then

		if not self:checkAgreement() then
			return
		end

		gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))
		local openUDID = "855899"

		openUDID = self.nodeMap["tfUserName"]:getStringValue()

		if not openUDID or openUDID == "" then
			openUDID = "855899"
		end

		local nickname = cc.UserDefault:getInstance():getStringForKey("openUDID")
		if string.len(nickname) == 0 then
			nickname = "游客:" .. gComm.StringUtils.getRangeRandom(1, 9999)

			cc.UserDefault:getInstance():setStringForKey("openUDID", nickname)
		end

		if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview
			or gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
			openUDID = gComm.CallNativeMng.AppNative:getOpenUDID()
			if "windows" == device.platform then
				nickname = gComm.StringUtils.getRangeRandom(1, 9999)
				openUDID = nickname
			end
		end


		gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0003"))
		gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip, cc.exports.gGameConfig.LoginServer.port,true)

		local msgToSend = {}
		msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN
		msgToSend.m_openId = openUDID
		msgToSend.m_nike = nickname
		msgToSend.m_sign = 123987
		msgToSend.m_plate = "local"
		msgToSend.m_severID = 17002
		msgToSend.m_nAppId =17002


		msgToSend.m_uuid = msgToSend.m_openId
		msgToSend.m_sex = 1
		msgToSend.m_nikename = nickname

		msgToSend.m_imageUrl = ""

		self.loginMsg = msgToSend

		--gt.socketClient:sendMessage(msgToSend)

		-- 保存sex,nikename,headimgurl,uuid,serverid等内容
		cc.UserDefault:getInstance():setStringForKey( "WX_Sex", tostring(1) )
		cc.UserDefault:getInstance():setStringForKey( "WX_Uuid", msgToSend.m_uuid )
		gt.wxNickName = msgToSend.m_nikename
		cc.UserDefault:getInstance():setStringForKey( "WX_OpenId" ,msgToSend.m_openId)
		cc.UserDefault:getInstance():setStringForKey( "WX_ImageUrl", msgToSend.m_imageUrl )
		self.m_openid = msgToSend.m_openId
		self.m_uuid = msgToSend.m_openId

    elseif s_name == n.btnMap.btnLoginWX then
		if not self:checkAgreement() then
			return
		end

		if self.autoLoginRet == true then
			return
		end

		-- 判断是否安装微信客户端
		local isWXAppInstalled = gComm.CallNativeMng:checkIsInstalled(gComm.CallNativeMng.shareType.WeiXin)

		-- 提示安装微信客户端
		if not isWXAppInstalled and (gComm.FunUtils.IsAndroidPlatform() or
			(gComm.FunUtils.IsiOSPlatform() and not cc.exports.gGameConfig.isiOSAppInReview)) then
			-- 安卓一直显示微信登录按钮
			-- 苹果审核通过
			UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0031"))
			return
		end
		_sender:setTouchEnabled(false)
		gComm.CallNativeMng.NativeWeiXin:sendAuthRequest(handler(self, self.pushWXAuthCode))
		_sender:setTouchEnabled(true)

    elseif s_name == n.btnMap.txtAgreement then
		local agreementPanel = require("app.Game.UI.UILobby.UIAgreement"):create()
		self:addChild(agreementPanel)
    end
end

function m:regEvent()
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN, self, self.onRcvLogin)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN_SERVER, self, self.onRcvLoginServer)
	-- 服务器进入游戏自动推送是否有活动
	--gt.socketClient:registerMsgListener(NetCmd.MSG_GC_IS_ACTIVITIES, self, self.onRecvIsActivities)
end

function m:reqVersionFileHandle(jsonStr)
	dump(jsonStr,"reqVersionFileHandle---VersionManifest")
	local localVersion = gComm.FunUtils.getResVersion()
	local versionRet = gComm.StringUtils.compareVersion(jsonStr.version, localVersion)
	if versionRet == 0 then--要更新
		UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0061"),
		function()
			require("app.Game.Scene.SceneManager").goSceneUpdate()
		end)
	end
end

function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")
    -- self:regEvent()

	gComm.SoundEngine:stopMusic()
	local index = cc.UserDefault:getInstance():getIntegerForKey("settingBGMusicIndex", 1)
	gComm.SoundEngine:playMusic("bgm" .. index, true)

	display.loadSpriteFrames("Texture/GComm.plist","Texture/GComm.png")

    local url = cc.exports.gGameConfig.LoginServer.versionUrl
    if url and self.autoLoginRet == false then
    	self.xhr = gComm.XMLHttpMng.reqJSON(url,handler(self,self.reqVersionFileHandle))
    end

	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sTestInner or
		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sLaoDuDev then

	    local localLoginName = cc.UserDefault:getInstance():getStringForKey("localLoginName", gGameConfig.debugNickname)
	    self.nodeMap["tfUserName"]:setString(localLoginName)
	end
end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")
	gt.socketClient:unRegisterMsgListenerByTarget(self)

    if self.xhr then
        self.xhr:unregisterScriptHandler()
        self.xhr = nil
    end
    if self.xhrUserInfo then
		self.xhrUserInfo:unregisterScriptHandler()
		self.xhrUserInfo = nil
    end
    
    if self.xhrRefreshToken then
		self.xhrRefreshToken:unregisterScriptHandler()
		self.xhrRefreshToken = nil
    end
    
    if self.xhrAccessToken then
		self.xhrAccessToken:unregisterScriptHandler()
		self.xhrAccessToken = nil
    end
    
	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sTestInner or
		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sLaoDuDev then

		local localLoginName = self.nodeMap["tfUserName"]:getStringValue()
		cc.UserDefault:getInstance():setStringForKey("localLoginName", localLoginName)
	end
end

function m:onCleanup()
    m.super.onCleanup(self)
    log(self.__TAG,"onCleanup")
end

return m
