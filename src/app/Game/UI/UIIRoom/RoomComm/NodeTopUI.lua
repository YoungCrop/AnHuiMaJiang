
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local UIDistance = require("app.Game.UI.UIIRoom.UIDistance")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UISetting = require("app.Game.UI.UILobby.UISetting")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")
local UIRule = require("app.Game.UI.UIIRoom.RoomComm.UIRule")
local UISetBtnList = require("app.Game.UI.UIIRoom.RoomComm.UISetBtnList")

local csbFile = "Csd/IRoom/RoomComm/NodeTopUI.csb"
local n = {}
local m = class("NodeTopUI", function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG_BASE = "[[" .. self.__cname .. "-Base]] --===-- "

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,
        roomType  = param.roomType,
        ruleType  = param.ruleType,
        roomPeopleNum = param.roomPeopleNum,
    }

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnOutRoom     = "btnOutRoom",
    btnDimissRoom  = "btnDimissRoom",
    btnSetting     = "btnSetting",
    btnRule        = "btnRule",
    btnFZB         = "btnFZB",
    btnTuoGuan     = "btnTuoGuan",
    btnRepair      = "btnRepair",
}
n.nodeMap = {
    --key --{name,defaultValue}
    imgBG            = {"imgBG",            },
    txtRoomID        = {"txtRoomID",     "",},
    txtDateTime      = {"txtDateTime",   "",},
    sliderElec       = {"sliderElec",       },
    spriteWifiSignal = {"spriteWifiSignal", },
    txtNetworkSpeed  = {"txtNetworkSpeed","",},
    imgGameName      = {"imgGameName",     },
    -- txtRemainRound   = {"txtRemainRound","",},
    -- txtRule          = {"txtRule",       },
    -- svRuleTxt        = {"svRuleTxt",     },
}
n.ImgGameNameCfg = {
    [DefineRule.GameID.POKER_DDZ] = "Image/IRoom/RoomTop/TitleDoudizhu.png",
    [DefineRule.GameID.AnQinDianPao] = "Image/IRoom/RoomTop/TitleAnQing.png",
    [DefineRule.GameID.MJHuaiBei] = "Image/IRoom/RoomTop/TitleHuaiBei.png",
}

function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    -- csbNode:addTo(self)

    local csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "FileNodeTopUI")
    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        csbNode = gComm.UIUtils.seekNodeByName(csbNode, "FileNodeTopBase")
    end
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        if v[2] then
            btn:setString(v[2])
        end
        self.btnMap[k] = btn
    end

    -- self.btnMap["txtRemainRound"]:setString("第0/" .. self.param.roundMaxCount .. "局")
    self.btnMap["txtRoomID"]:setString(self.param.roomID)
    -- gComm.Debug:logUD(self.btnMap["imgGameName"],"--====imgGameName====-")
    -- self.btnMap["imgGameName"]:setString(n.ImgGameNameCfg[self.param.gameID])
    -- self.btnMap["imgGameName"]:loadTexture(n.ImgGameNameCfg[self.param.gameID],ccui.TextureResType.plistType)--localType,--plistType

    self.btnMap["imgGameName"]:setSpriteFrame(n.ImgGameNameCfg[self.param.gameID])

    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_QUIT_ROOM, self, self.onRcvQuitRoom)
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_DISMISS_ROOM, self, self.onRcvDismissRoom)

    if not gt.networkSpeed then
        gt.networkSpeed = 0.05
    end
    self:onRcvHeartbeat()
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_HEARTBEAT, self, self.onRcvHeartbeat)

    if cc.exports.gGameConfig.isiOSAppInReview then
        self.btnMap["btnFZB"]:setVisible(false)
        self.btnMap["btnSetting"]:setVisible(false)
    end

    if self.param.sPos == 0 then --房主
        self.btnMap["btnOutRoom"]:setVisible(false)
        self.btnMap["btnDimissRoom"]:setVisible(true)
    else
        self.btnMap["btnOutRoom"]:setVisible(true)
        self.btnMap["btnDimissRoom"]:setVisible(false)
    end

    self.btnMap["btnTuoGuan"]:setVisible(false)
    if self.param.roomType == DefineRule.RoomType.BigMatch then
        self.btnMap["btnTuoGuan"]:setVisible(true)

        self.btnMap["btnOutRoom"]:setVisible(false)
        self.btnMap["btnDimissRoom"]:setVisible(false)
        self.btnMap["btnFZB"]:setVisible(false)
        self.btnMap["btnRepair"]:setVisible(false)
    elseif self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.btnMap["btnTuoGuan"]:setVisible(true)

        self.btnMap["btnOutRoom"]:setVisible(true)
        self.btnMap["btnDimissRoom"]:setVisible(false)
        self.btnMap["btnFZB"]:setVisible(false)
        self.btnMap["btnRepair"]:setVisible(false)
    elseif self.param.roomType == DefineRule.RoomType.ClubQuickRoom then
        self.btnMap["btnOutRoom"]:setVisible(true)
        self.btnMap["btnDimissRoom"]:setVisible(false)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    gComm.SoundEngine:playEffect("common/SpecOk", false, true)
    if s_name == n.btnMap.btnOutRoom then
        UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0019"),function()
                gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0016"))
                NetMngRoom.sendQuitRoom(self.param.sPos)
        end,function()
            -- body
        end)

    elseif s_name == n.btnMap.btnDimissRoom then
        UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0012_1"),function()
                NetMngRoom.sendDimissRoom(self.param.sPos)
        end,function()
            -- body
        end)

    elseif s_name == n.btnMap.btnSetting    then
        local h = self.btnMap["imgBG"]:getContentSize().height
        local x,y = _sender:getPositionX(),display.height*0.5 - h

        local args = {
            pos      = cc.p(_sender:getWorldPosition().x,display.height - h),
        }
        self._UISetBtnList = UISetBtnList:create(args)
        self._UISetBtnList:addTo(self.param.csbNode,ConfigGameScene.ZOrder.HAIDILAOYUE)
        -- self._UISetBtnList:addTo(self.param.csbNode,ConfigGameScene.ZOrder.MJTILES+10)
        -- self._UISetBtnList:setPosition(x,y)

        _sender:setEnabled(false)
        if self._UIRule and (not tolua.isnull(self._UIRule)) then
            self._UIRule:removeFromParent()
            self:onBtnEnableHandle(nil,{btnRule = true})
        end
    elseif s_name == n.btnMap.btnRule then
        local h = self.btnMap["imgBG"]:getContentSize().height
        local x,y = _sender:getPositionX(),display.height*0.5 - h

        local args = {
            manNum   = self.param.roomPeopleNum,
            roundNum = self.param.roundMaxCount,
            ruleType = self.param.ruleType,
            pos      = cc.p(_sender:getWorldPosition().x,display.height - h),
        }
        self._UIRule = UIRule:create(args)
        self._UIRule:addTo(self.param.csbNode,ConfigGameScene.ZOrder.HAIDILAOYUE)
        -- self._UIRule:addTo(self.param.csbNode,ConfigGameScene.ZOrder.MJTILES+10)

        -- self._UIRule:setPosition(x,y)

        _sender:setEnabled(false)

        if self._UISetBtnList and (not tolua.isnull(self._UISetBtnList)) then
            self._UISetBtnList:removeFromParent()
            self:onBtnEnableHandle(nil,{btnSetting = true})
        end
    elseif s_name == n.btnMap.btnFZB then
        local layer = UIDistance:create()
        layer:addTo(self.param.csbNode,ConfigGameScene.ZOrder.ROUND_REPORT)

    elseif s_name == n.btnMap.btnTuoGuan then
        NetMngRoom.sendTuoGuan(true)

    elseif s_name == n.btnMap.btnRepair then
        UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_ReLogin"), function()
            -- 确定
            gComm.EventBus.dispatchEvent(EventCmdID.EventType.DIRECT_LOGIN)
            gt.socketClient:close()
            require("app.Game.Scene.SceneManager").goSceneLogin()
        end, function()

        end)
    end
end

function m:setTuoGuanBtnVisible(isShow)
    self.btnMap["btnTuoGuan"]:setVisible(isShow)
end

function m:getDeviceValue()
    local bat = gCallNativeMng.AppNative:getDeviceBattery()
    bat = tonumber(bat)
    self.btnMap["sliderElec"]:setPercent(bat)
    local level = gCallNativeMng.AppNative:getDeviceSignalLevel()

    log("getDeviceValuegetDeviceValue",bat,level)

    level = tonumber(level)
    if level > 4 then
        level = 4
    elseif level <= 0 then
        level = math.random(0,2)
    end
    -- self.btnMap["spriteWifiSignal"]:setSpriteFrame("Image/IRoom/CommomRoom/game_wifi_signal".. level..".png")
    local img = "Image/IRoom/RoomTop/game_wifi_signal".. level..".png"
    -- display.removeSpriteFrame(img)
    gComm.SpriteUtils.setSpriteFrameEx(self.btnMap["spriteWifiSignal"],img,"Texture/IRoom/RoomTop.plist")
end

function m:setBtnBackLobby(isShow)
    log("setBtnBackLobby===NodeTopUI==",isShow)
    if self.param.roomType ~= DefineRule.RoomType.BigMatch then
        self.btnMap["btnOutRoom"]:setVisible(isShow)-- 返回大厅,退出房间
        self.btnMap["btnDimissRoom"]:setVisible(not isShow)-- 解散房间
    end

    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        if isShow == false then
            self.btnMap["btnOutRoom"]:setVisible(false)
            self.btnMap["btnDimissRoom"]:setVisible(false)
        end
    end
end

function m:updateCurTime()
    local curTimeStr = os.date("%H:%M")
    self.btnMap["txtDateTime"]:setString(curTimeStr)
end

function m:onRcvHeartbeat(msgTbl)
    local str = math.floor(gt.networkSpeed * 1000)  .. "ms"
    self.btnMap["txtNetworkSpeed"]:setString(str)
end

-- start --
--------------------------------
-- @class function
-- @description 返回大厅
-- end --
function m:onRcvQuitRoom(msgTbl)
    gComm.UIUtils.removeLoadingTips()

    if msgTbl.m_errorCode == 0 then
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
    elseif msgTbl.m_errorCode == 3 then
        --不操作，DLT_NO_READY  准备时间到,玩家未准备,则从金币场当前桌子踢出玩家
    else
        -- 提示返回大厅失败
        UINoticeTips:create(ConfigTxtTip.GetConfigTxt("LTKey_0045"))
    end
end

-- start --
--------------------------------
-- @class function
-- @description 房间创建者解散房间
-- end --
function m:onRcvDismissRoom(msgTbl)
    dump(msgTbl,"m:onRcvDismissRoom")
    --//0-等待操作中，1-未开始直接解算，2-三个人同意，解算成功，3-时间到，解算成功，4-有一个人拒绝，解算失败, 5 系统强制解散
    if msgTbl.m_errorCode == 1 then
        -- 游戏未开始解散成功
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
    elseif msgTbl.m_errorCode ==  2 then

        gComm.EventBus.dispatchEvent(EventCmdID.EventType.APPLY_DIMISS_ROOM, msgTbl)
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.SHOW_FINALREPORT)
    else
        -- 游戏中玩家申请解散房间
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.APPLY_DIMISS_ROOM, msgTbl)
    end
end

function m:onBtnEnableHandle(eventName,args)
    args = args or {}
    for k,v in pairs(args) do
        if k == "btnRule" then
            self.btnMap["btnRule"]:setEnabled(v)
        elseif k == "btnSetting" then
            self.btnMap["btnSetting"]:setEnabled(v)
        end
    end
end

--key:btnOutRoom,btnDimissRoom,btnTuoGuan
function m:setTopUIBtnVisible(args)
    dump(args,"setFlagVisiblesetFlagVisibleTopUI")
    args = args or {}
    for k,v in pairs(args) do
        if k == "btnOutRoom" then
            self.btnMap["btnOutRoom"]:setVisible(v)
        elseif k == "btnDimissRoom" then
            self.btnMap["btnDimissRoom"]:setVisible(v)
        elseif k == "btnTuoGuan" then
            self.btnMap["btnTuoGuan"]:setVisible(v)
        end
    end
end

function m:update(delta)
    self.updateTimeCD = self.updateTimeCD - delta
    if self.updateTimeCD <= 0 then
        self.updateTimeCD = 60
        self:updateCurTime()
        self:getDeviceValue()
    end
end

function m:onEnter()
    log(self.__TAG_BASE,"onEnter")
    self.updateTimeCD = 60 - tonumber(os.date("%S", os.time()))
    self:updateCurTime()
    self:getDeviceValue()
    self.scheduleCurTime = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)
    gComm.EventBus.regEventListener(EventCmdID.UI_ROOM_BTN_ENABLE, self, self.onBtnEnableHandle)
end

function m:unRegisterAllMsgListener()
    gt.socketClient:unRegisterMsgListenerByTarget(self)
    gComm.EventBus.unRegAllEvent(self)
end

function m:onExit()
    log(self.__TAG_BASE,"onExit")

    if self.scheduleCurTime then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleCurTime)
        self.scheduleCurTime = nil
    end
    self:unRegisterAllMsgListener()
end

function m:onCleanup()
    log(self.__TAG_BASE,"onCleanup")

end


return m
