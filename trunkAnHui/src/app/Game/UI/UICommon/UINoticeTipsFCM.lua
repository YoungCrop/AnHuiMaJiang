
local gComm = cc.exports.gComm

local csbFile = "Csd/ICommon/NoticeTipsFCM.csb"

local m = class("UINoticeTipsFCM",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    

    local btnOK = gComm.UIUtils.seekNodeByName(csbNode, "btnOK")
    gComm.BtnUtils.setButtonClick(btnOK,function()
        cc.UserDefault:getInstance():setIntegerForKey("GlobalCountDownFCM", 0)
        cc.exports.gData.ModleGlobal.countDownTime = 0
        cc.exports.gData.ModleGlobal.isShowFCMLayer = false
        self:removeFromParent()
    end)
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