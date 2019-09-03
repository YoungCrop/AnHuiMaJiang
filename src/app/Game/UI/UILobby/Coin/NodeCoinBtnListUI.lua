
local gComm = cc.exports.gComm
local DefineRule = require("app.Common.Config.DefineRule")
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/ILobby/Coin/NodeCoinBtnListUI.csb"

local n = {}
local m = class("NodeCoinBtnListUI",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        curGameID = args.curGameID,
        pos      = args.pos,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnAnQing  = {"btnAnQing", DefineRule.GameID.AnQinDianPao  },
    btnHuaiBei = {"btnHuaiBei",DefineRule.GameID.MJHuaiBei     },
    btnDDZ     = {"btnDDZ",    DefineRule.GameID.POKER_DDZ     },
    btnReturn  = {"btnReturn", -1     },
}

n.nodeMap = {
    imgBG       = "imgBG",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
        if v[2] == self.param.curGameID then
            btn:setBright(false)
            btn:setTouchEnabled(false)
        end
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["imgBG"]:setPosition(self.param.pos)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnReturn[1] then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnAnQing[1] then
        local args = {gameID = DefineRule.GameID.AnQinDianPao}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_COIN_BTN_SELECTED,args)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnHuaiBei[1] then
        local args = {gameID = DefineRule.GameID.MJHuaiBei}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_COIN_BTN_SELECTED,args)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnDDZ[1] then
        local args = {gameID = DefineRule.GameID.POKER_DDZ}
        gComm.EventBus.dispatchEvent(EventCmdID.UI_COIN_BTN_SELECTED,args)
        self:removeFromParent()
    end
end
 
function m:onTouchEnded(touch, event)
    local touchPoint = self.btnMap["imgBG"]:convertTouchToNodeSpace(touch)
    local Size = self.btnMap["imgBG"]:getContentSize()
    local Rect = cc.rect(0, 0, Size.width, Size.height)
    if not cc.rectContainsPoint(Rect, touchPoint) then
        -- local args = {btnSetting = true}
        -- gComm.EventBus.dispatchEvent(EventCmdID.UI_ROOM_BTN_ENABLE,args)
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