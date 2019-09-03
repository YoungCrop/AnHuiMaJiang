
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local NetCmd = require("app.Common.NetMng.NetCmd")
local UIHeadBase = require("app.Game.UI.UIIRoom.UIHead.UIHeadBase")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")

local n = {}
local m = class("UIHeadDirection", function()
    return display.newNode()
end)
-- local m = class("UIHeadDirection")

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,
        roomType  = param.roomType,
        uiPos     = param.uiPos,
    }

    self:initUI()
    -- self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
}
n.nodeMap = {
--key--{name,defaultVisble,zorder}
    FileNodeHeadUIBase = {"FileNodeHeadUIBase",  true, },           
    ImgBGChatMsg       = {"ImgBGChatMsg",        false,900000},     
    txtChatMsg         = {"txtChatMsg",          true, 900000},   
    nodeVoice          = {"nodeVoice",           true, 900000},  
    nodeEmoji          = {"nodeEmoji",           true, 900000},  
    -- txtZuoLaPao        = {"txtZuoLaPao",         false,}, 
}

function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    -- csbNode:addTo(self)

    -- local csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "FileNodeHeadUIBase")
    local csbNode = self.param.csbNode
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        btn:setVisible(v[2])
        if v[3] then
            -- btn:setZOrder(v[3])
            -- btn:setGlobalZOrder(v[3])
            -- btn:setLocalZOrder(v[3])
        end
        self.btnMap[k] = btn
    end
    -- csbNode:reorderChild(self.btnMap["ImgBGChatMsg"], ConfigGameScene.ZOrder.CHAT)
    -- csbNode:reorderChild(self.btnMap["nodeVoice"], ConfigGameScene.ZOrder.CHAT)
    -- csbNode:reorderChild(self.btnMap["nodeEmoji"], ConfigGameScene.ZOrder.CHAT)

    local args = self.param
    args.csbNode = self.btnMap["FileNodeHeadUIBase"]
    self._UIHeadBase = UIHeadBase:create(args)
    self._UIHeadBase:addTo(csbNode)
end

--key:score,nickname,zuoLaPao,chatMsg
function m:setTxt(args)
    args = args or {}
    self._UIHeadBase:setTxt(args)
    for k,v in pairs(args) do
        if k == "chatMsg" then
            self.btnMap["txtChatMsg"]:setString(v)
            self.btnMap["txtChatMsg"]:setVisible(true)
        end
    end
end

--key:fang,zhuang,offline,tuoGuan,chatMsgBG,nodeVoice,nodeEmoji
function m:setFlagVisible(args)
    args = args or {} 
    self._UIHeadBase:setFlagVisible(args)
    for k,v in pairs(args) do
        if k == "chatMsgBG" then
            self.btnMap["ImgBGChatMsg"]:setVisible(v)
        elseif k == "nodeVoice" then
            self.btnMap["nodeVoice"]:setVisible(v)
        elseif k == "nodeEmoji" then
            self.btnMap["nodeEmoji"]:setVisible(v)
        end
    end
end
function m:getSpriteHead()
    return self._UIHeadBase:getSpriteHead()
end

function m:getBtn()
    local btn = {
        ImgBGChatMsg = self.btnMap["ImgBGChatMsg"],     
        txtChatMsg   = self.btnMap["txtChatMsg"],  
        nodeVoice    = self.btnMap["nodeVoice"], 
        nodeEmoji    = self.btnMap["nodeEmoji"],
    }
    return btn
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnHeadFrame then
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