

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/IRoom/UIPlayerInfoTips.csb"

local n = {}
local m = class("UIPlayerInfo",gComm.UIMaskLayer)
function m:ctor(args)
    m.super.ctor(self)
    self.param = {
        isMySelf = args.isMySelf,
        nickname = args.nickname,
        ID       = args.ID,
        IP       = args.IP,
        sPos     = args.sPos,
    }
    self.countdownTime = 0

    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self:initUI()
end
n.btnMap = {
    btntools1 = "btntools1",
    btntools2 = "btntools2",
    btntools3 = "btntools3",
    btntools4 = "btntools4",
    btntools5 = "btntools5",
}
n.nodeMap = {
    imgBG = "imgBG",
    spriteHeadIcon = "spriteHeadIcon",
    txtNickname    = "txtNickname",

    txtIP          = "txtIP",
    txtUID         = "txtUID",
    txtAddr        = "txtAddr",
    txtCutdown     = "txtCutdown",
    nodeWaitCDTime = "nodeWaitCDTime",
    Image1 = "Image1",
    Image2 = "Image2",
    Image3 = "Image3",
    Image4 = "Image4",
    Image5 = "Image5",
}

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end
function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end
    
    local imgPath = cc.FileUtils:getInstance():getWritablePath() .. "head_img_" .. self.param.ID .. ".png"
    if io.exists(imgPath) then
        self.btnMap["spriteHeadIcon"]:setTexture(imgPath)
    end

    self.btnMap["txtNickname"]:setString(self.param.nickname)
    self.btnMap["txtUID"]:setString("ID: " .. self.param.ID)
    self.btnMap["txtIP"]:setString("IP: " .. self.param.IP)
    self.btnMap["txtAddr"]:setString("")
    self.btnMap["nodeWaitCDTime"]:setVisible(false)

    if self.param.isMySelf then
        for i=1,5 do
            self.btnMap["Image" .. i]:setVisible(false)
            self.btnMap["btntools" .. i]:setVisible(false)
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    local index = string.sub(s_name,9,9)
    NetMngRoom.sendBeatExp(self.param.sPos,tonumber(index))
    gComm.EventBus.dispatchEvent(EventCmdID.EventType.SEND_INTERACT_ANI)

    self.btnMap["nodeWaitCDTime"]:setVisible(true)
    self.countdownTime = 5
    self.btnMap["txtCutdown"]:setString(self.countdownTime)
    for i=1,5 do
        self.btnMap["btntools" .. i]:setEnabled(false)
    end
end

function m:onTouchBegan(touch, event)
    return true
end

function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)
    if not cc.rectContainsPoint(Rect, touchPoint) then
        self:removeFromParent()
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.REMOVE_INTERACT_ANI)
    end
end

function m:update(delta)
    if self.countdownTime > 0 then
        self.countdownTime = self.countdownTime - 1
        self.btnMap["txtCutdown"]:setString(self.countdownTime)
        if self.countdownTime <= 0 then
            self.btnMap["nodeWaitCDTime"]:setVisible(false)
            for i=1,5 do
                self.btnMap["btntools" .. i]:setEnabled(true)
            end
        end
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)
end

function m:onExit()
    log(self.__TAG,"onExit")

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListenersForTarget(self)

    if self.scheduleHandler then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
        self.scheduleHandler = nil
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m