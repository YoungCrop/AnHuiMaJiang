
local gComm = cc.exports.gComm

local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local DefineRule = require("app.Common.Config.DefineRule")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local DefineShieldWord = require("app.Common.Config.DefineShieldWord")
local DefineRoom = require("app.Common.Config.DefineRoom")
local DefineChat = require("app.Common.Config.DefineChat")
local ItemChatSpeak = require("app.Game.UI.UILobby.Item.ItemChatSpeak")
local ItemChatExp = require("app.Game.UI.UILobby.Item.ItemChatExp")

local csbFile = "Csd/IRoom/UIChatNew.csb"

local n = {}
local m = class("UIChatNew",gComm.UIMaskLayer)

function m:ctor(param)
    local args = {
        opacity = 85,
    }
    m.super.ctor(self,args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        gameID    = param.gameID,
        roomType  = param.roomType,
        pos       = param.pos,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnSpeak = "btnSpeak",
    btnExp   = "btnExp",
    btnChat  = "btnChat",
    btnSendChat = "btnSendChat",
}
n.nodeMap = {
    imgBG    = "imgBG",
    imgInputBG = "imgInputBG",
    lvSpeak  = "lvSpeak",
    svExp    = "svExp",
    tfInput  = "tfInput",
    nodeChat = "nodeChat",
}
n.group = {
    [1] = {"btnSpeak","lvSpeak",},
    [2] = {"btnExp","svExp",},
    [3] = {"btnChat","nodeChat",},
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    -- csbNode:setPosition(display.center)
    csbNode:setPosition(self.param.pos)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self:onBtnClick(self.btnMap["btnSpeak"])
    self.btnMap["lvSpeak"]:setScrollBarAutoHideEnabled(false)

    for i = 1, 12 do
        local buttonName = string.format("biaoqing%02d", i)
        local button = gComm.UIUtils.seekNodeByName(csbNode, buttonName)
        gComm.BtnUtils.setButtonClick(button,handler(self,self.expressionHandle))
    end
    
    if self.param.roomType == DefineRule.RoomType.BigMatch then
        self.btnMap["imgInputBG"]:setVisible(false)
    end
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        self.btnMap["imgInputBG"]:setVisible(false)
        self.btnMap["btnChat"]:setVisible(false)
    end
end

function m:setSelectIndex(btn,isSelected)
    if not btn then
        return
    end
    btn:setBright(isSelected)
    btn:setTouchEnabled(isSelected)
end

function m:initExp()
    self.btnMap["svExp"]:setVisible(true)
end

function m:initSpeak()
    self.btnMap["lvSpeak"]:removeAllItems()
    local speaks = DefineChat.SpeakMJ
    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        speaks = DefineChat.SpeakPoker
    end
    for k,v in pairs(speaks) do
        local args = {
            index = k,
            speakStr = v,
            clickHandle = handler(self,self.speakHandle),
        }
        local item = ItemChatSpeak:create(args)
        self.btnMap["lvSpeak"]:pushBackCustomItem(item)
    end
    self.btnMap["lvSpeak"]:setVisible(true)
end

function m:initChat()
    self.btnMap["nodeChat"]:setVisible(true)
end

function m:setHide()
    self.btnMap["svExp"]:setVisible(false)
    self.btnMap["lvSpeak"]:setVisible(false)
    self.btnMap["nodeChat"]:setVisible(false)
end

function m:expressionHandle( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    self:sendChatMsg(DefineRoom.ChatType.EMOJI,0,s_name)
end

function m:speakHandle( index )
    print("speakHandle=",index)
    self:sendChatMsg(DefineRoom.ChatType.FIX_MSG,index)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnSendChat then
        local inputString = self.btnMap["tfInput"]:getString()
        if string.len(inputString) > 0 then
            if DefineShieldWord.CheckShieldWord(inputString) then
                UINoticeTips:create("您输入的词语含有敏感词,请重新输入!")
            else
                self:sendChatMsg(DefineRoom.ChatType.INPUT_MSG, 0, inputString)
            end
        end
    else
        self:setSelectIndex(self._lastSelectedBtn,true)
        self:setSelectIndex(_sender,false)
        self._lastSelectedBtn = _sender
        self:setHide()
        if s_name == n.btnMap.btnSpeak then
            self:initSpeak()
        elseif s_name == n.btnMap.btnExp then
            self:initExp()
        elseif s_name == n.btnMap.btnChat then
            self:initChat()
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