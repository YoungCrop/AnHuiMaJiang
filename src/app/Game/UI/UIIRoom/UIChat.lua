
local gComm = cc.exports.gComm

local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local DefineRule = require("app.Common.Config.DefineRule")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local DefineShieldWord = require("app.Common.Config.DefineShieldWord")
local DefineRoom = require("app.Common.Config.DefineRoom")
local csbFile = "Csd/IRoom/UIChat.csb"

local n = {}
local m = class("UIChat",gComm.UIMaskLayer)

function m:ctor(param)
    local args = {
        opacity = 85,
    }
    m.super.ctor(self,args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        gameID    = param.gameID,
        roomType  = param.roomType,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnSend = "btnSend",
}
n.nodeMap = {
    tfInputMsg = "tfInputMsg",
    imgBG      = "imgBG",
    lvSpeak    = "lvSpeak",
    imgBGInput = "imgBGInput",
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

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    self.btnMap["lvSpeak"]:setScrollBarAutoHideEnabled(false)

    for i = 1, 12 do
        local buttonName = string.format("biaoqing%02d", i)
        local button = gComm.UIUtils.seekNodeByName(csbNode, buttonName)
        gComm.BtnUtils.setButtonClick(button,handler(self,self.expressionHandle))
    end
    
    for i = 1, 11 do
        local button = gComm.UIUtils.seekNodeByName(csbNode, "speak" .. i)
        gComm.BtnUtils.setButtonClick(button,handler(self,self.speakHandle))
    end

    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        self.btnMap["lvSpeak"]:removeItem(0)
        self.btnMap["lvSpeak"]:removeItem(4)
    end
    if self.param.roomType == DefineRule.RoomType.BigMatch then
        self.btnMap["tfInputMsg"]:setEnabled(false)
    end
end

function m:expressionHandle( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    self:sendChatMsg(DefineRoom.ChatType.EMOJI,0,s_name)
end

function m:speakHandle( _sender )
    local s_name = _sender:getName()
    local index = string.sub(s_name,6,string.len(s_name))
    print("s_name=",s_name,index)
    self:sendChatMsg(DefineRoom.ChatType.FIX_MSG,tonumber(index))
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnSend then
        local inputString = self.btnMap["tfInputMsg"]:getString()
        if string.len(inputString) > 0 then
            if DefineShieldWord.CheckShieldWord(inputString) then
                UINoticeTips:create("您输入的词语含有敏感词,请重新输入!")
            else
                self:sendChatMsg(DefineRoom.ChatType.INPUT_MSG, 0, inputString)
            end
        end
    end
end

function m:sendChatMsg(chatType, chatIdx, chatString)
    chatIdx = chatIdx or 1
    chatString = chatString or ""
    NetMngRoom.sendChat(chatType, chatIdx, chatString)
    self:removeFromParent()
end


function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)
    if not cc.rectContainsPoint(Rect, touchPoint) then
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