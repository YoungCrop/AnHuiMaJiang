
local gComm = cc.exports.gComm
local csbFile = "Csd/Animation/AnimVoicePlay.csb"

local n = {}
local m = class("VoicePlay", function()
    return display.newNode()
end)

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self:initUI()
    self:enableNodeEvents()
end
n.nodeMap = {
}

function m:initUI()
    self:loadCSB()
end
function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
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