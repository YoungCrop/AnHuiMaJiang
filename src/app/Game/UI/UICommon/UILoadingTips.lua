
local gComm = cc.exports.gComm

local csbFile = "Csd/ICommon/LoadingTips.csb"

local m = class("UILoadingTips",gComm.UIMaskLayer)

function m:ctor(tipsText)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI(tipsText)
end

function m:initUI(tipsText)
    self:setName("LoadingTips")
    local csbNode, tipsAnimation = gComm.UIUtils.createCSAnimation(csbFile)
    tipsAnimation:play("run", true)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)

    local runningScene = cc.Director:getInstance():getRunningScene()
    if runningScene then
        runningScene:addChild(self,66)
    end

    self.tipsLabel = gComm.UIUtils.seekNodeByName(self, "txtTips")
    if tipsText then
        self.tipsLabel:setString(tipsText)
    end
end

function m:setTipsText(tipsText)
    self.tipsLabel:setString(tipsText or "")
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