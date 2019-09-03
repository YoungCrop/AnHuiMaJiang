

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")

local csbFile = "Csd/IRoom/UIDissolution.csb"

local n = {}
local m = class("UIDissolution", gComm.UIMaskLayer)

function m:ctor(roomPlayers, playerSeatIdx)
    local args = {
        opacity = 85,
    }
    m.super.ctor(self,args)
    self:unlock()

    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.roomPlayers = roomPlayers
    self.playerSeatIdx = playerSeatIdx
    self.btnMap = {}
    self.isHaveTheUI = false
    -- self:initUI()

    self:setVisible(false)
end
n.btnMap = {
    btnOK = "btnOK",
    btnCancel = "btnCancel",
}
n.nodeMap = {
    txtContent = "txtContent",
    txtCountDown = "txtCountDown",
    
}

function m:initUI()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)
    self.rootNode = csbNode

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    self.btnMap["btnOK"]:setTag(1)
    self.btnMap["btnCancel"]:setTag(2)
    
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    self.btnMap["btnOK"]:setVisible(false)
    self.btnMap["btnCancel"]:setVisible(false)

    NetMngRoom.applyDimissRoom(self.playerSeatIdx - 1,_sender:getTag())
end

function m:dismissRoomEvt(eventType, msgTbl)
    dump(msgTbl,"====dismissRoomEvt==12345=")
    self:setVisible(true)

    if msgTbl.m_errorCode == 0 then
        -- 等待操作中
        if not self.rootNode then
            self:initUI()
        end
        self.dimissTimeCD = msgTbl.m_time
        self.btnMap["txtCountDown"]:setString(self.dimissTimeCD)

        local contentString = ""
        if msgTbl.m_flag == 0 then
            -- 等待同意或者拒绝
            contentString = mTxtTipConfig.GetConfigTxt("LTKey_0022", msgTbl.m_apply,msgTbl.m_time)

            self.btnMap["btnOK"]:setVisible(true)
            self.btnMap["btnCancel"]:setVisible(true)
        else
            -- 已经同意或者拒绝
            contentString = mTxtTipConfig.GetConfigTxt("LTKey_0023", msgTbl.m_apply,msgTbl.m_time)
            -- 隐藏操作按钮
            self.btnMap["btnOK"]:setVisible(false)
            self.btnMap["btnCancel"]:setVisible(false)
        end
        for _, v in ipairs(msgTbl.m_agree) do
            if v ~= msgTbl.m_apply then
                contentString = contentString .. mTxtTipConfig.GetConfigTxt("LTKey_0025", v)
            end
        end
        for _, v in ipairs(msgTbl.m_wait) do
            contentString = contentString .. mTxtTipConfig.GetConfigTxt("LTKey_0024", v)
        end
        self.btnMap["txtContent"]:setString(contentString)
    elseif msgTbl.m_errorCode == 2 then
        -- 三个人同意，解散成功
        local strKey = "LTKey_0027"
        if #msgTbl.m_agree == 1 then
            strKey = "LTKey_0027_2"
        elseif #msgTbl.m_agree == 2 then
            strKey = "LTKey_0027_1"
        else

        end
        if not self.isHaveTheUI then
            UINoticeTips:create(mTxtTipConfig.GetConfigTxt(strKey, unpack(msgTbl.m_agree)),
                function()
                    self.isHaveTheUI = false
                    self:setVisible(false)
                end)
            self.isHaveTheUI = true
        end
        
    elseif msgTbl.m_errorCode == 3 then
        -- 时间到，解散成功
        UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_0044"),
            function()
                self:setVisible(false)
            end)
    elseif msgTbl.m_errorCode == 4 then
        if not gConfig.isiOSAppInReview then
            -- 有一个人拒绝，解散失败
            if not self.isHaveTheUI then
                UINoticeTips:create(mTxtTipConfig.GetConfigTxt("LTKey_0026", msgTbl.m_refuse),
                function()
                    self.isHaveTheUI = false
                    if not self.rootNode then
                        self:setVisible(false)
                    end
                end)
                self.isHaveTheUI = true
            end
        end
    end

    if msgTbl.m_errorCode ~= 0 then
        if self.rootNode then
            self.rootNode:removeFromParent()
            self.rootNode = nil
        end
    end
end

function m:update(delta)
    if (not self.rootNode) or (not self.dimissTimeCD) then
        return
    end
    self.dimissTimeCD = self.dimissTimeCD - delta
    if self.dimissTimeCD < 0 then
        self.dimissTimeCD = 0
    end
    local timeCD = math.ceil(self.dimissTimeCD)
    self.btnMap["txtCountDown"]:setString(timeCD)
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
    -- 注册解散房间事件
    gComm.EventBus.regEventListener(EventCmdID.EventType.APPLY_DIMISS_ROOM, self, self.dismissRoomEvt)
end

function m:onExit()
    log(self.__TAG,"onExit")

    gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
    -- 事件回调
    gComm.EventBus.unRegAllEvent(self)
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m