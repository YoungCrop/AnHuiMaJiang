
local gt = cc.exports.gt
local gComm = cc.exports.gComm

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local DefineRule = require("app.Common.Config.DefineRule")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")

local csbFile = "Csd/ILobby/UISetting.csb"

local n = {}
local m = class("UISetting",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        isInLobby = args.isInLobby,
        isShowBtnLogout = args.isShowBtnLogout,
        sPos      = args.sPos,
        csbNode   = args.csbNode,
        isBackLobby = args.isBackLobby,
        roomType    = args.roomType,
        isInGaming  = args.isInGaming or false,
    }
    dump(self.param,"======setting==")
    self.playerSeatPos = playerSeatPos
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose = "btnClose",
    btnExit = "btnExit",
    btnExitRoom = "btnExitRoom",
    btnFang = "btnFang",
    btnReLogin = "btnReLogin",
    btnDismissRoom = "btnDismissRoom",
    txtVibrate = "txtVibrate",
    txtFangYan1 = "txtFangYan1",
    txtFangYan2 = "txtFangYan2",
    btnMaxSoundEffect = "btnMaxSoundEffect",
    btnMinSoundEffect = "btnMinSoundEffect",
    btnMaxMusic = "btnMaxMusic",
    btnMinMusic = "btnMinMusic",
    imgCloth1 = "imgCloth1",
    imgCloth2 = "imgCloth2",
    imgCloth3 = "imgCloth3",
    imgCloth4 = "imgCloth4",
    nodeBGMusic1 = "nodeBGMusic1",
    nodeBGMusic2 = "nodeBGMusic2",
    nodeBGMusic3 = "nodeBGMusic3",

}
n.nodeMap = {
    sliderMusic = "sliderMusic",
    sliderSoundEffect = "sliderSoundEffect",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
        if string.sub(k,1,-2) == "nodeBGMusic" then
            btn = btn:getChildByName("txt")
        end
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        btn:addEventListener(handler(self,self.sliderEventHandler))
        self.btnMap[k] = btn
    end

    for i=1,4 do
        self:changeClothByIndex(i,false)
    end

    -- 音效调节
    local soundEftPercent = gComm.SoundEngine:getSoundEffectVolume()
    soundEftPercent = math.floor(soundEftPercent)
    self.btnMap["sliderSoundEffect"]:setPercent(soundEftPercent)
    self:setBtnVisible(true,soundEftPercent == 0,false)
    -- 音乐调节
    local musicPercent = gComm.SoundEngine:getMusicVolume()
    musicPercent = math.floor(musicPercent)
    self.btnMap["sliderMusic"]:setPercent(musicPercent)
    self:setBtnVisible(false,musicPercent == 0,false)

    if self.param.isInLobby then
        self.btnMap["btnExit"]:setVisible(true)

        self.btnMap["btnExitRoom"]:setVisible(false)
        self.btnMap["btnFang"]:setVisible(false)
        self.btnMap["btnReLogin"]:setVisible(false)
        self.btnMap["btnDismissRoom"]:setVisible(false)
    else
        self.btnMap["btnExit"]:setVisible(false)

        self.btnMap["btnExitRoom"]:setVisible(true)
        self.btnMap["btnFang"]:setVisible(true)
        self.btnMap["btnReLogin"]:setVisible(true)
        self.btnMap["btnDismissRoom"]:setVisible(true)
        if self.param.sPos == 0 or self.param.isBackLobby == false then --房主
            self.btnMap["btnExitRoom"]:setVisible(false)
            self.btnMap["btnDismissRoom"]:setVisible(true)
        else
            self.btnMap["btnExitRoom"]:setVisible(true)
            self.btnMap["btnDismissRoom"]:setVisible(false)
        end
        if self.param.roomType == DefineRule.RoomType.BigMatch then
            self.btnMap["btnExitRoom"]:setVisible(false)
            self.btnMap["btnDismissRoom"]:setVisible(false)
            self.btnMap["btnFang"]:setVisible(false)
            self.btnMap["btnReLogin"]:setVisible(false)
        elseif self.param.roomType == DefineRule.RoomType.CoinRoom then
            self.btnMap["btnExitRoom"]:setVisible(true)
            self.btnMap["btnDismissRoom"]:setVisible(false)
            self.btnMap["btnFang"]:setVisible(false)
            self.btnMap["btnReLogin"]:setVisible(false)
            if self.param.isInGaming then
                self.btnMap["btnExitRoom"]:setVisible(false)
            end

        elseif self.param.roomType == DefineRule.RoomType.ClubQuickRoom then
            if self.param.isBackLobby then
                self.btnMap["btnExitRoom"]:setVisible(true)
                self.btnMap["btnDismissRoom"]:setVisible(false)
            else
                self.btnMap["btnExitRoom"]:setVisible(false)
                self.btnMap["btnDismissRoom"]:setVisible(true)
            end
        end
    end
    if self.param.isShowBtnLogout == false then
        self.btnMap["btnExit"]:setVisible(false)
    end
end

function m:sliderEventHandler(_sender, eventType)
    local s_name = _sender:getName()
    print("sliderEventHandler s_name=",s_name)
    if eventType == ccui.SliderEventType.percentChanged then
        local percent = _sender:getPercent()
        if s_name == "sliderSoundEffect" then
            gComm.SoundEngine:setSoundEffectVolume(percent)
            if percent >= 1 then
                self:setBtnVisible(true,false,false)
            else
                self:setBtnVisible(true,true,false)
            end
        else
            gComm.SoundEngine:setMusicVolume(percent)
            if percent >= 1 then
                self:setBtnVisible(false,false,false)
            else
                self:setBtnVisible(false,true,false)
            end
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnExit then
            self:removeFromParent()
            cc.UserDefault:getInstance():setStringForKey("WX_Access_Token", "")
            cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token", "")
            cc.UserDefault:getInstance():setStringForKey("WX_Access_Token_Time", "")
            cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token_Time", "")
            cc.UserDefault:getInstance():setStringForKey("WX_OpenId", "")
            cc.UserDefault:getInstance():setStringForKey("WX_uuId", "")

            gt.socketClient:close()
            local scene = cc.Director:getInstance():getRunningScene()
            gt.socketClient:unRegisterMsgListenerByTarget(scene)

            require("app.Game.Scene.SceneManager").goSceneLogin({isReset = true})

    elseif s_name == n.btnMap.btnDismissRoom then
        local sPos = self.param.sPos
        UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_0012_1"),
            function()
                NetMngRoom.sendDimissRoom(sPos)
            end,function()
                -- body
            end)
        self:removeFromParent()
    elseif s_name == n.btnMap.txtVibrate then
        local ckBox = _sender:getChildByName("cb")
        local isSelected = ckBox:isSelected()
        ckBox:setSelected(not isSelected)
        self.defaultVibrate = isSelected and 0 or 1

    elseif s_name == n.btnMap.btnFang then
        local layer = require("app.Game.UI.UIIRoom.UIDistance"):create()
        layer:addTo(self.param.csbNode,ConfigGameScene.ZOrder.ROUND_REPORT)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnExitRoom then
        local sPos = self.param.sPos
        UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_0019"),
            function()
                gComm.UIUtils.showLoadingTips(mTxtTipConfig.GetConfigTxt("LTKey_0016"))
                NetMngRoom.sendQuitRoom(sPos)
            end,function()
                -- body
            end)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnReLogin then
        self:removeFromParent()
        UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_ReLogin"), function()
            -- 确定
            gComm.EventBus.dispatchEvent(EventCmdID.EventType.DIRECT_LOGIN)
            gt.socketClient:close()
            require("app.Game.Scene.SceneManager").goSceneLogin()
        end, function()

        end)

    elseif s_name == n.btnMap.txtFangYan1 then
        _sender:getChildByName("cb"):setSelected(false)
        gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0038"))
    elseif s_name == n.btnMap.txtFangYan2 then
        _sender:getChildByName("cb"):setSelected(true)

    elseif s_name == n.btnMap.btnMaxSoundEffect then
        self:setBtnVisible(true,true,true)
    elseif s_name == n.btnMap.btnMinSoundEffect then
        self:setBtnVisible(true,false,true)

    elseif s_name == n.btnMap.btnMaxMusic then
        self:setBtnVisible(false,true,true)
    elseif s_name == n.btnMap.btnMinMusic then
        self:setBtnVisible(false,false,true)

    elseif s_name == n.btnMap.imgCloth1 then
        self:changeCloth(1)
    elseif s_name == n.btnMap.imgCloth2 then
        self:changeCloth(2)
    elseif s_name == n.btnMap.imgCloth3 then
        self:changeCloth(3)
    elseif s_name == n.btnMap.imgCloth4 then
        self:changeCloth(4)
    elseif s_name == "txt" then
        local name = _sender:getParent():getName()
        local index = string.sub(name,-1)
        self:changeBGMusic(index)
    end
end

function m:changeBGMusic(selectedIndex)
    if self.defaultBGMusicIndex == selectedIndex then
        return
    end
    self.btnMap["nodeBGMusic" .. self.defaultBGMusicIndex]:getChildByName("checkbox"):setSelected(false)
    self.defaultBGMusicIndex = selectedIndex
    self.btnMap["nodeBGMusic" .. self.defaultBGMusicIndex]:getChildByName("checkbox"):setSelected(true)

    gComm.SoundEngine:stopMusic()
    gComm.SoundEngine:playMusic("bgm" .. self.defaultBGMusicIndex, true)
end

function m:setBtnVisible(isSoundEffect,isShowMinValue,isHandleSlider)
    local percent = isShowMinValue and 0 or 100
    if isSoundEffect then
        if isHandleSlider then
            self.btnMap["sliderSoundEffect"]:setPercent(percent)
            gComm.SoundEngine:setSoundEffectVolume(percent)
        end
        self.btnMap["btnMaxSoundEffect"]:setVisible(not isShowMinValue)
        self.btnMap["btnMinSoundEffect"]:setVisible(isShowMinValue)
    else
        if isHandleSlider then
            self.btnMap["sliderMusic"]:setPercent(percent)
            gComm.SoundEngine:setMusicVolume(percent)
        end
        self.btnMap["btnMaxMusic"]:setVisible(not isShowMinValue)
        self.btnMap["btnMinMusic"]:setVisible(isShowMinValue)
    end
end

function m:changeCloth(index)
    if index == self.clothIndex then
        return
    end
    self:changeClothByIndex(self.clothIndex,false)
    self:changeClothByIndex(index,true)

    self.clothIndex = index
    cc.UserDefault:getInstance():setIntegerForKey("gameBg", index)
    gComm.EventBus.dispatchEvent(EventCmdID.UI_UPDATE_DESK_CLOTH)
end

function m:changeClothByIndex(index,isUsing)
    self.btnMap["imgCloth" .. index]:getChildByName("imgUsing"):setVisible(isUsing)
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    self.clothIndex = cc.UserDefault:getInstance():getIntegerForKey("gameBg", 2)
    self:changeClothByIndex(self.clothIndex,true)

    self.defaultVibrate = cc.UserDefault:getInstance():getIntegerForKey("settingVibrate", 1)
    self.btnMap["txtVibrate"]:getChildByName("cb"):setSelected(self.defaultVibrate == 1)

    self.defaultBGMusicIndex = cc.UserDefault:getInstance():getIntegerForKey("settingBGMusicIndex", 1)
    for i=1,3 do
        self.btnMap["nodeBGMusic" .. i]:getChildByName("checkbox"):setSelected(false)
    end
    self.btnMap["nodeBGMusic" .. self.defaultBGMusicIndex]:getChildByName("checkbox"):setSelected(true)
end

function m:onExit()
    log(self.__TAG,"onExit")
    cc.UserDefault:getInstance():setIntegerForKey("settingVibrate", self.defaultVibrate)
    cc.UserDefault:getInstance():setIntegerForKey("settingBGMusicIndex", self.defaultBGMusicIndex)

end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end


return m
