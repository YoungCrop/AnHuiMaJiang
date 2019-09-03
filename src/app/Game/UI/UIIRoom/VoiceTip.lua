
local gComm = cc.exports.gComm
local csbFile = "Csd/Animation/AnimVoiceTip.csb"

local m = class("VoiceTip", function()
    return display.newNode()
end)

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self:loadCSB()
end
function m:loadCSB()
    local tipsNode, tipsAnimation = gComm.UIUtils.createCSAnimation(csbFile)
    tipsAnimation:gotoFrameAndPlay(0, false)
    tipsAnimation:pause()
    tipsNode:setPosition(display.center)
    tipsNode:setVisible(false)
    tipsNode:addTo(self)
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