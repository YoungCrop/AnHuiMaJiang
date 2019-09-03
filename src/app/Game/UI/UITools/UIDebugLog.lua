
local gComm = cc.exports.gComm
local csbFile = "Csd/ICommon/DebugLog.csb"

local n = {}
local m = class("UIDebugLog", function()
    return display.newNode()
end)

function m:ctor(txtLog)
    self._txtLog = txtLog
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self:loadCSB()
end

n.btnMap = {
    btnOK = "btnOK",
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

    gComm.UIUtils.seekNodeByName(csbNode, "txtLog"):setString(self._txtLog or "")
    

    local runningScene = cc.Director:getInstance():getRunningScene()
    self:addTo(runningScene,90000)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnOK then
        self:removeFromParent()
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