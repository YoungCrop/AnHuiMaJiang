
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local UIDistance = require("app.Game.UI.UIIRoom.UIDistance")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local UISetting = require("app.Game.UI.UILobby.UISetting")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/IRoom/RoomComm/NodeTopBarNew.csb"
local n = {}
local m = class("NodeTopBarNew", function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,
        roomType  = param.roomType,
        ruleType  = param.ruleType,
    }
    self.stateParam = {
        isBackLobby = true,
        isInGaming  = false,
    }

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnSetting     = "btnSetting",
    btnTuoGuan     = "btnTuoGuan",
}
n.nodeMap = {
    --key --{name,defaultValue}
    txtDateTime      = {"txtDateTime",   "",},
    txtRemainRound   = {"txtRemainRound","",},
    txtRoomID        = {"txtRoomID",     "",},
    txtNetworkSpeed  = {"txtNetworkSpeed","",},
    spriteWifiSignal = {"spriteWifiSignal", },
    sliderElec       = {"sliderElec",       },
    txtRule          = {"txtRule",       },
    svRuleTxt        = {"svRuleTxt",     },
}

function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    -- csbNode:addTo(self)

    self.csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "nodeTopBar")
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(self.csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(self.csbNode, k)
        if v[2] then
            btn:setString(v[2])
        end
        self.btnMap[k] = btn
    end

    self.btnMap["txtRemainRound"]:setString("第0/" .. self.param.roundMaxCount .. "局")
    self.btnMap["txtRoomID"]:setString(self.param.roomID)

    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_QUIT_ROOM, self, self.onRcvQuitRoom)
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_DISMISS_ROOM, self, self.onRcvDismissRoom)

    if not gt.networkSpeed then
        gt.networkSpeed = 0.05
    end
    self:onRcvHeartbeat()
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_HEARTBEAT, self, self.onRcvHeartbeat)

    self.btnMap["btnTuoGuan"]:setVisible(false)
    if self.param.roomType == DefineRule.RoomType.BigMatch then
        self.btnMap["btnTuoGuan"]:setVisible(true)
    elseif self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.btnMap["btnTuoGuan"]:setVisible(true)
    end
    self:showRule()
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnSetting    then
        gComm.SoundEngine:playEffect("common/SpecOk", false, true)
        local args = {
            isInLobby = false,
            sPos      = self.param.sPos,
            roomType  = self.param.roomType,
            csbNode   = self.param.csbNode,
            isBackLobby = self.stateParam.isBackLobby,
            isInGaming  = self.stateParam.isInGaming,
        }
        local layer = UISetting:create(args)
        layer:addTo(self.param.csbNode,ConfigGameScene.ZOrder.HAIDILAOYUE)
    elseif s_name == n.btnMap.btnTuoGuan then
        NetMngRoom.sendTuoGuan(true)
    end
end

function m:showRule()
    local description = ""
    for _,v in pairs(self.param.ruleType) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            description = description .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            description = description .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end

    local scrollVwSize = self.btnMap["svRuleTxt"]:getContentSize()
    local txt = gComm.LabelUtils.createTTFLabel(description, 22)
    txt:setAnchorPoint(0.5, 0.5)
    txt:setTextColor(cc.WHITE)
    -- txt:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)--VERTICAL_TEXT_ALIGNMENT_TOP)
    txt:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    local w = txt:getContentSize().width
    if w > scrollVwSize.width then
        -- txt:setWidth(scrollVwSize.width)
        txt:setWidth(w * 0.5 + 10)
    end
    local labelSize = txt:getContentSize()
    self.btnMap["svRuleTxt"]:setInnerContainerSize(labelSize)
    self.btnMap["svRuleTxt"]:setContentSize(labelSize)
    txt:setPosition(txt:getContentSize().width * 0.5, labelSize.height * 0.5)
    self.btnMap["svRuleTxt"]:addChild(txt)
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
    local img = "Image/IRoom/CommomRoom/game_wifi_signal".. level..".png"
    -- display.removeSpriteFrame(img)
    gComm.SpriteUtils.setSpriteFrameEx(self.btnMap["spriteWifiSignal"],img,"Texture/IRoom/CommomRoom.plist")
end

function m:setRoundIndex(str)
    self.btnMap["txtRemainRound"]:setString(str)
end
function m:setRoundBtnHide()
    self.btnMap["txtRemainRound"]:setVisible(false)
end

function m:setBtnBackLobby(isShow)
    log("setBtnBackLobby=====",isShow)
    if self.param.roomType ~= DefineRule.RoomType.BigMatch then
        -- self.btnMap["btnOutRoom"]:setVisible(isShow)-- 返回大厅,退出房间
        -- self.btnMap["btnDimissRoom"]:setVisible(not isShow)-- 解散房间
        self.stateParam.isBackLobby = isShow
    end
    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        if isShow == false then
            self.stateParam.isInGaming = true
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
        UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_0045"))
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

function m:update(delta)
    self.updateTimeCD = self.updateTimeCD - delta
    if self.updateTimeCD <= 0 then
        self.updateTimeCD = 60
        self:updateCurTime()
        self:getDeviceValue()
    end
end

function m:unRegisterAllMsgListener()
    gt.socketClient:unRegisterMsgListenerByTarget(self)
    gComm.EventBus.unRegAllEvent(self)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    self.updateTimeCD = 60 - tonumber(os.date("%S", os.time()))
    self:updateCurTime()
    self:getDeviceValue()

    self.scheduleCurTime = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)
end

function m:onExit()
    log(self.__TAG,"onExit")

    if self.scheduleCurTime then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleCurTime)
        self.scheduleCurTime = nil
    end
    self:unRegisterAllMsgListener()
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end


return m
