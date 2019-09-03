
local gComm = cc.exports.gComm
local EventCmdID = require("app.Common.Config.EventCmdID")
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/IRoom/RoomComm/NodeRuleUI.csb"

local n = {}
local m = class("UIRule", gComm.UIMaskLayer)
-- local m = class("UIRule", function()
--     return display.newNode()
-- end)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        manNum   = args.manNum,
        roundNum = args.roundNum,
        ruleType = args.ruleType,
        pos      = args.pos,
    }
    self.btnMap = {}
    self:initUI()
end

n.btnMap = {
    btnReturn = "btnReturn",
}
n.nodeMap = {
    imgBG       = "imgBG",
    txtManNum   = "txtManNum",
    txtRoundNum = "txtRoundNum",
    txtRuleTitle = "txtRuleTitle",
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
    self.btnMap["txtManNum"]:setString(self.param.manNum .. "人")
    self.btnMap["txtRoundNum"]:setString(self.param.roundNum .. "局")
    self:showRule()
end

function m:showRule()
    local description = ""
    for _,v in pairs(self.param.ruleType) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            description = description .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            description = description .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end

    local size = self.btnMap["txtRuleTitle"]:getContentSize()
    local txt = gComm.LabelUtils.createTTFLabel(description, 22)
    txt:setAnchorPoint(0, 1)
    txt:setTextColor(cc.RED)--cc.c3b(124,165,130)
    txt:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
    txt:setWidth(size.width)
    txt:setPosition(cc.p(0,-5))
    self.btnMap["txtRuleTitle"]:addChild(txt)
    local labelSize = txt:getContentSize()
    local size = self.btnMap["imgBG"]:getContentSize()
    local s = cc.size(size.width,170+labelSize.height)
    self.btnMap["imgBG"]:setContentSize(s)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnReturn then
        local args = {btnRule = true}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_ROOM_BTN_ENABLE,args)
        self:removeFromParent()
    end
end
function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)
    if not cc.rectContainsPoint(Rect, touchPoint) then
        local args = {btnRule = true}
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