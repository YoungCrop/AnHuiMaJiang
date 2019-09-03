

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/IRoom/UIPlayerInfoTips.csb"

local n = {}
local m = class("UIPlayerInfoTips",gComm.UIMaskLayer)
--[[
    参数: playerSeatIdx 玩家位置id （playerSeatIdx == 1  房主）
         isGaming    0 没有开始游戏   1 开始游戏
--]]
function m:ctor(isGaming , playerSeatIdx,playerData,playerNum)
    m.super.ctor(self)
    self.isGaming = isGaming
    self.playerSeatIdx = playerSeatIdx
    self.playerData = playerData
    self.playerNum = playerNum
    self.seatIdx = playerData.seatIdx
    self.displaySeatIdx = playerData.displaySeatIdx

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
    imgBG          = "imgBG",
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
    
    local imgPath = cc.FileUtils:getInstance():getWritablePath() .. "head_img_" .. self.playerData.uid .. ".png"
    if io.exists(imgPath) then
        self.btnMap["spriteHeadIcon"]:setTexture(imgPath)
    end

    self.btnMap["txtNickname"]:setString(gComm.StringUtils.GetShortName(self.playerData.nickname))
    self.btnMap["txtUID"]:setString("ID: " .. self.playerData.uid)
    self.btnMap["txtIP"]:setString("IP: " .. self.playerData.ip)
    self.btnMap["txtAddr"]:setString("")

    --冷却时间
    -- self.btnMap["txtAddr"]:setVisible(false)
    self.btnMap["nodeWaitCDTime"]:setVisible(false)

    local mydisplaySeatIdx = 4
    if self.playerNum and self.playerNum == 5 then 
        mydisplaySeatIdx = 5
    elseif self.playerNum and self.playerNum == 3 then
        mydisplaySeatIdx = 4
    else
        mydisplaySeatIdx = 4
    end

    if self.playerData.isOwner and self.playerData.isOwner == 1 then
        for i=1,5 do
            self.btnMap["Image" .. i]:setVisible(false)
            self.btnMap["btntools" .. i]:setVisible(false)
        end
    end

    if mydisplaySeatIdx == self.displaySeatIdx then
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
    NetMngRoom.sendBeatExp(self.seatIdx-1,tonumber(index))
    gComm.EventBus.dispatchEvent(EventCmdID.EventType.SEND_INTERACT_ANI)

    self.btnMap["nodeWaitCDTime"]:setVisible(true)
    self.countdownTime = 5
    self.btnMap["txtCutdown"]:setString(self.countdownTime)
    for i=1,5 do
        self.btnMap["btntools" .. i]:setEnabled(false)
    end
end

function m:onRcvAddress(msgTbl)
    dump(msgTbl,"===onRcvAddress===")
    for k,v in pairs(msgTbl.m_POS) do
        if self.playerData.uid == v.m_id then 
            if v.m_adress == "" then
                self.btnMap["txtAddr"]:setString("未知")
            else
                local distance = "未知"
                local loc1, loc2 = self:getLocs(v.m_points)
                if loc1.la and loc2.la then
                    distance = gComm.CallNativeMng.NativeGaoDe:getDisByTwoPoint(loc1.la, loc1.lt, loc2.la, loc2.lt)
                    if distance then
                        distance = string.format("%0.2f", distance)
                    end
                end
                self.btnMap["txtAddr"]:setString(v.m_adress.."("..distance.."米)")
            end
            break
        end
    end
end

function m:getLocs( locs )
    local strTab = string.split(locs, "_")
    local temp = {}
    temp.la = tonumber(strTab[1])
    temp.lt = tonumber(strTab[2])

    local loc = gComm.CallNativeMng.NativeGaoDe:getLocation()
    if loc == nil or loc == "" then
        loc = "0_0"
    end
    local strTab1 = string.split(loc, "_")
    local temp1 = {}
    temp1.la = tonumber(strTab1[1])
    temp1.lt = tonumber(strTab1[2])

    return temp,temp1
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
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_GET_USER_ADDR, self, self.onRcvAddress)
    -- NetMngRoom.getUserAdress()--self.playerData.uid)

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
    
    gt.socketClient:unregisterMsgListener(NetCmd.MSG_GC_GET_USER_ADDR)

    if self.scheduleHandler then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
        self.scheduleHandler = nil
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m