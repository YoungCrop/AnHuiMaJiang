
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local csbFile = "Csd/ILobby/UIUpdateVersion.csb"

local n = {}
local m = class("UIUpdateVersion",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnCancel = "btnCancel",
    btnUpdate = "btnUpdate",
}
n.nodeMap = {
    txtUpdateMsg = "txtUpdateMsg",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    -- --更新文本
    -- local textLabel = gComm.UIUtils.seekNodeByName(csbNode,"txtUpdateMsg")
    -- textLabel:setString(msg)

    -- if tonumber(state) == 0 then
    --     --强制更新
    --     qianNode:setVisible(true)
    --     chooseNode:setVisible(false)
    -- elseif tonumber(state) == 1 then
    --     --可选择更新
    --     qianNode:setVisible(false)
    --     chooseNode:setVisible(true)
    -- end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnCancel then
        self:removeFromParent()
    elseif s_name == n.btnMap.btnUpdate then
        local url = gCallNativeMng.AppNative:getAppDownLoadUrl()
        gCallNativeMng.AppNative:openWebURL(url)
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