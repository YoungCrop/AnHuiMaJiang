
local gt = cc.exports.gt
local UICoinMain = require("app.Game.UI.UILobby.Coin.UICoinMain")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local UILobbyBottomTop = require("app.Game.UI.UILobby.UILobbyBottomTop")
local UILobbyCenter = require("app.Game.UI.UILobby.UILobbyCenter")

local m = class("SceneLobby", gComm.SceneBase)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:setName("SceneLobby")
    args = args or {}
    self.param = {
    	isNewPlayer    = args.isNewPlayer,
    	isShowCoinMain = args.isShowCoinMain,
	}

	self.UILobbyCenter = UILobbyCenter:create(self.param)
	self.UILobbyCenter:addTo(self)

	self.UILobbyBottomTop = UILobbyBottomTop:create(self.param)
	self.UILobbyBottomTop:addTo(self)

    gt.socketClient:setDelegate(self)
end

-- 断线重连,走一次登录流程
function m:reLogin()
	print("========重连登录1")
	local accessToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Access_Token" )
	local refreshToken 	= cc.UserDefault:getInstance():getStringForKey( "WX_Refresh_Token" )
	local openid 		= cc.UserDefault:getInstance():getStringForKey( "WX_OpenId" )

	local unionid 		= cc.UserDefault:getInstance():getStringForKey( "WX_Uuid" )
	local sex 			= cc.UserDefault:getInstance():getStringForKey( "WX_Sex" )
	local nickname 		= gt.nickname
	local headimgurl 	= cc.UserDefault:getInstance():getStringForKey( "WX_ImageUrl" )

	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN

	msgToSend.m_plate = "wechat"
	msgToSend.m_accessToken = accessToken
	msgToSend.m_refreshToken = refreshToken
	msgToSend.m_openId = openid
	msgToSend.m_severID = 13001
	msgToSend.m_uuid = unionid
	msgToSend.m_sex = tonumber(sex)
	msgToSend.m_nikename = nickname
	msgToSend.m_imageUrl = headimgurl
	msgToSend.m_nAppId =17002


	if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview or
		 		gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
		msgToSend.m_plate = "local"
	end

	local catStr = string.format("%s%s%s%s", openid, accessToken, refreshToken, unionid)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))

	self.loginMsg = msgToSend

	--gt.socketClient:sendMessage(msgToSend)
	-- print("========重连登录2")
end


function m:onRcvLogin(msgTbl)
	dump(msgTbl,"=====Lobby_onRcvLogin=====")
	-- print("========重连登录3")
	-- //0-成功，1-服务器还没启动成功 2-微信登陆失败 3- 微信返回失败 4-创建角色失败 5- 在原APP未退 6. 7.账号封禁状态,8,uuid为空或过长
	if msgTbl.m_errorCode == 5 then
		-- 去掉转圈
		gComm.UIUtils.removeLoadingTips()
		UINoticeTips:create("您尚未在"..msgTbl.m_errorMsg.."退出游戏，请先退出后再登陆此游戏！")
		return
	end
	-- print("========重连登录4")
	-- 去掉转圈
	gComm.UIUtils.removeLoadingTips()

	-- 发送登录gate消息
	gt.socketClient:close()
	gt.socketClient:connect(msgTbl.m_gateIp, msgTbl.m_gatePort)

	local msgToSend = {}
	msgToSend.m_msgId = NetCmd.MSG_CG_LOGIN_SERVER
	msgToSend.m_seed = msgTbl.m_seed
	msgToSend.m_id = msgTbl.m_id
	local catStr = tostring(msgTbl.m_seed)
	msgToSend.m_md5 = cc.UtilityExtension:generateMD5(catStr, string.len(catStr))
	self.gateMsg = msgToSend
	--gt.socketClient:sendMessage(msgToSend)
	-- print("========重连登录5")
end

function m:onRcvLoginServer(msgTbl)
	dump(msgTbl,"====onRcvLoginServer====")
	-- 去除正在返回游戏提示
	gComm.UIUtils.removeLoadingTips()

	NetLobbyMng.getVersionNumber()
end

function m:onGetVersion( msgTbl )
	local lversion = self:getLocalVersion()--gComm.FunUtils.getResVersion()
	dump(msgTbl,"onGetVersion msgTbl = " .. lversion)

	local ret = gComm.StringUtils.compareVersion(lversion,msgTbl.m_Version)
 	if ret == -1 then
		UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0061"),
		function()
			require("app.Game.Scene.SceneManager").goSceneUpdate()
		end)
	else
		gComm.EventBus.regEventListener(EventCmdID.EventType.APP_ENTER_FOREGROUND_EVENT, self, self.urlEnterRoom)
		self:urlEnterRoom()
	end
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
	gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0001"))
	socket:close()
	self:reLogin()
	gt.socketClient:connect(cc.exports.gGameConfig.LoginServer.ip,cc.exports.gGameConfig.LoginServer.port,true)
end


function m:urlEnterRoom()
	log("urlEnterRoomurlEnterRoomurlEnterRoom====")
	-- 等待提示
	-- self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
	self:runAction(cc.Sequence:create(cc.CallFunc:create(function()
		log("urlEnterRoomurlEnterRoomurlEnterRoom===22222=")
		gComm.UIUtils.removeLoadingTips()
		local roomID = gComm.CallNativeMng.NativeMeChuang:getUrlRoomID()
		log("urlEnterRoomurlEnterRoomurlEnterRoom===22222=roomID=",roomID)
		if roomID and roomID ~= "" and roomID ~= '' and tonumber(roomID) ~= 0 then
			log("urlEnterRoomurlEnterRoomurlEnterRoom===444444=")
			gComm.CallNativeMng.NativeMeChuang:clearUrlRoomID()
			NetLobbyMng.SendJoinRoom(tonumber(roomID))
			gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0006"))
		else
			gComm.CallNativeMng.NativeMeChuang:clearUrlRoomID()
		end
	end)))
end

function m:regEvent()
	-- 注册消息回调
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN_SERVER, self, self.onRcvLoginServer)
	-- 断线重连
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_LOGIN, self, self.onRcvLogin)
	gt.socketClient:registerMsgListener(NetCmd.MSG_GC_UPDATE, self, self.onGetVersion)
end

function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")

	display.loadSpriteFrames("Texture/GComm.plist","Texture/GComm.png")

    self:regEvent()
	gComm.SoundEngine:stopMusic()
	local index = cc.UserDefault:getInstance():getIntegerForKey("settingBGMusicIndex", 1)
	gComm.SoundEngine:playMusic("bgm" .. index, true)

	local function okCallback()
		NetLobbyMng.getVersionNumber()
	end

	if self.param.isNewPlayer then
		-- 显示新玩家奖励牌提示
		local str_des = string.format("第一次登陆送房卡%d张",cc.exports.gData.ModleGlobal.roomCardsCount[2])
		if cc.exports.gGameConfig.isiOSAppInReview then
			str_des = ConfigTxtTip.GetConfigTxt("LTKey_0029_1")
		end
		UINoticeTips:create(str_des, okCallback)
	else
		NetLobbyMng.getVersionNumber()
	end

	local time = cc.UserDefault:getInstance():getIntegerForKey("GlobalCountDownFCM", 0)
	if time >= cc.exports.gData.ModleGlobal.EnumCountDownFCM then
		local layer = require("app.Game.UI.UICommon.UINoticeTipsFCM"):create()
		self:addChild(layer,1234)
		cc.exports.gData.ModleGlobal.isShowFCMLayer = true
	end

   if self.param.isShowCoinMain then
	    local lay = UICoinMain:create()
	    self:addChild(lay)
   end
end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")
	gt.socketClient:unRegisterMsgListenerByTarget(self)
	gComm.EventBus.unRegAllEvent(self)
end

function m:onCleanup()
    m.super.onCleanup(self)
    log(self.__TAG,"onCleanup")
end

function m:getLocalVersion()
	local writePath = cc.FileUtils:getInstance():getWritablePath()
	local version_filename = "version.manifest"
	local isExist = cc.FileUtils:getInstance():isFileExist(writePath .. version_filename)
	local version = ""
	if isExist then
		local fileData = cc.FileUtils:getInstance():getStringFromFile(writePath .. version_filename)
        local fileList = json.decode(fileData)
     	version = fileList.version
    else
		isExist = cc.FileUtils:getInstance():isFileExist(version_filename)
		if isExist then
			local fileData = cc.FileUtils:getInstance():getStringFromFile(version_filename)
	        local fileList = json.decode(fileData)
	     	version = fileList.version
		end
	end
	return (version or "1.0.1")
end

function m:I_ShowCoinCard(args)
    -- local args = {
    --     coinNum = msgTbl.m_coin,
    --     cardNum = msgTbl.m_card2,
    -- }
    args = args or {}
	self.UILobbyBottomTop:setCardNum(args.cardNum)
end


function m:I_ShowMarquee()
	self.UILobbyCenter:showMarquee()
end

return m
