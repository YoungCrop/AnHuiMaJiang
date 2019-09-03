
local gComm = cc.exports.gComm

local UIVideoPlay = require("app.Game.UI.UILobby.UIVideoPlay")
local csbFile = "Csd/ICommon/UIGMSelect.csb"

local n = {}
local m = class("UIGMSelect",gComm.UIMaskLayer)

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
    btnOK = "btnOK",
    btnCancel = "btnCancel",
}
n.nodeMap = {
    tfUID = "tfUID",
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
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnOK then
        local uid = self.btnMap["tfUID"]:getString()
        uid = tonumber(uid)
        self:enterVideo(uid)
    elseif s_name == n.btnMap.btnCancel then
        self:enterVideo()
    end
end

function m:enterVideo(uid)
    self:removeFromParent()
    local layer = UIVideoPlay:create(uid)
    
    local runningScene = cc.Director:getInstance():getRunningScene()
    layer:addTo(runningScene)
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