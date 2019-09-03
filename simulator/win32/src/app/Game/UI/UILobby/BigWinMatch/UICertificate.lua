
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/ILobby/BigWinMatch/UICertificate.csb"

local n = {}
local m = class("UICertificate",gComm.UIMaskLayer)

function m:ctor(param)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        activityCode = param.activityCode,
        nickName = param.nickName,
        isPoker  = param.isPoker,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit = "btnExit",
    btnCopy = "btnCopy",
}
n.nodeMap = {
    txtWinningCode = "txtWinningCode",
    txtHongBao     = "txtHongBao",
    txtName        = "txtName",
    icon_seal_mj   = "icon_seal_mj",
    icon_seal_poker= "icon_seal_poker",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["txtWinningCode"]:setString(self.param.activityCode)
    self.btnMap["txtName"]:setString(self.param.nickName)
    if self.param.isPoker then
        self.btnMap["icon_seal_mj"]:setVisible(false)
        self.btnMap["icon_seal_poker"]:setVisible(true)
    else
        self.btnMap["icon_seal_mj"]:setVisible(true)
        self.btnMap["icon_seal_poker"]:setVisible(false)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
        self:removeFromParent()
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
    elseif s_name == n.btnMap.btnCopy then
        local str = self.btnMap["txtWinningCode"]:getString()
        gCallNativeMng.AppNative:copyText(str)
        gComm.UIUtils.floatText("复制成功")
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
    
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m