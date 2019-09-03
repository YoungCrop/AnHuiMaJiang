
local csbFile = "Csd/ICommon/NoticeTips.csb"
local m = class("UINoticeTips",cc.exports.gComm.UIMaskLayer)
function m:ctor(tipsText, okFunc, cancelFunc)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    
    cc.exports.gComm.UIUtils.seekNodeByName(csbNode, "txtTips"):setString(tipsText or "")

    local btnOK = cc.exports.gComm.UIUtils.seekNodeByName(csbNode, "btnOK")
    cc.exports.gComm.BtnUtils.setButtonClick(btnOK,function()
        self:removeFromParent()
        if okFunc then
            okFunc()
        end
    end)

    local btnCancel = cc.exports.gComm.UIUtils.seekNodeByName(csbNode, "btnCancel")
    cc.exports.gComm.BtnUtils.setButtonClick(btnCancel,function()
        self:removeFromParent()
        if cancelFunc then
            cancelFunc()
        end
    end)

    if not cancelFunc then
        btnOK:setPositionX(0)
        btnCancel:setVisible(false)
    end

    local runningScene = cc.Director:getInstance():getRunningScene()
    if runningScene then
        runningScene:addChild(self, 67)
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