
local gComm = cc.exports.gComm
local EventCmdID = require("app.Common.Config.EventCmdID")
local DefineRule = require("app.Common.Config.DefineRule")
local UIHelp = require("app.Game.UI.UILobby.UIHelp")
local UISetting = require("app.Game.UI.UILobby.UISetting")
local csbFile = "Csd/IRoom/RoomComm/NodeSetBtnListUI.csb"

local n = {}
local m = class("UISetBtnList", gComm.UIMaskLayer)
-- local m = class("UISetBtnList", function()
--     return display.newNode()
-- end)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        pos      = args.pos,
    }
    self.btnMap = {}
    self:initUI()
end

n.btnMap = {
    btnGameSetting = "btnGameSetting",
    btnRuleDesc    = "btnRuleDesc",
    btnReturn      = "btnReturn",
}
n.nodeMap = {
    imgBG       = "imgBG",
}

function m:initUI()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)
    csbNode:setPosition(self.param.pos)

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
end


function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnGameSetting then
        local args = {
            isInLobby = true,
            isShowBtnLogout = false,
        }
        local layer = UISetting:create(args)
        -- layer:addTo(self.param.csbNode,ConfigGameScene.ZOrder.HAIDILAOYUE)
        cc.Director:getInstance():getRunningScene():addChild(layer)

    elseif s_name == n.btnMap.btnRuleDesc then
        local layer = UIHelp:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)

    elseif s_name == n.btnMap.btnReturn then
        local args = {btnSetting = true}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_ROOM_BTN_ENABLE,args)
        self:removeFromParent()
    end
end

function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)
    if not cc.rectContainsPoint(Rect, touchPoint) then
        local args = {btnSetting = true}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_ROOM_BTN_ENABLE,args)
        self:removeFromParent()
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    self:setTouchEndedHandle(handler(self,self.onTouchEnded))
end

function m:onExit()
    log(self.__TAG,"onExit")

end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end

return m