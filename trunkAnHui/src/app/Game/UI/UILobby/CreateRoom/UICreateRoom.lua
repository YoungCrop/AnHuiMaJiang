
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig

local DefineRule = require("app.Common.Config.DefineRule")
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local UIPeiPai = require("app.Game.UI.UICommon.UIPeiPai")
local UIAgentRoom = require("app.Game.UI.UILobby.UIAgentRoom")

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local csbFile = "Csd/ILobby/CreateRoom/CreateRoomPoker.csb"

gt.textCard = {}
gt.textCard[1] = ""
gt.textCard[2] = ""
gt.textCard[3] = ""
gt.textCard[4] = ""
gt.textCard[5] = ""
gt.textCard[6] = ""


local m = class("UICreateRoom", gComm.UIMaskLayer)

function m:ctor(data)
    m.super.ctor(self)
    self:enableNodeEvents()
    self.data = data or {}
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
end

function m:initUI()
    self.lastActivityIndex = nil
    self.nodeSet = {}
    self:loadCSB()
end

m.btnMap = {
    btnExit      = "btnExit",
    btnOK        = "btnOK",
    btnAgentRoom = "btnAgentRoom",
    btnPeiPai    = "btnPeiPai",
}

m.nodeMap = {
    lvBtn = "lvBtn",
}
-- m.btnRuleTypeMap = {
--     [2] = {"btnType1" ,"app.Game.UI.UILobby.CreateRoom.RuleDDZ",},
--     [1] = {"btnType2" ,"app.Game.UI.UILobby.CreateRoom.RuleAnQing",},
-- }

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)

    for k,v in pairs(m.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        if btn then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
            self.nodeSet[k] = btn
        end
    end
    for k,v in pairs(m.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeSet[k] = btn
    end
    self:handleBtn()
    -- if cc.exports.gData.ModleGlobal.isGM then
    --     self.nodeSet[m.btnMap.btnAgentRoom]:setVisible(true)
    -- else
        self.nodeSet[m.btnMap.btnAgentRoom]:setVisible(false)
    -- end

    self.csbNode = csbNode
    if gConfig.CurServerIndex < gConfig.ServerTypeKey.sTestOuter then
        self.nodeSet[m.btnMap.btnPeiPai]:setVisible(false)
    end
end

function m:handleBtn()
    self.nodeSet["lvBtn"]:removeAllItems()
    for k,v in pairs(m.btnRuleTypeMap) do
        local btn = ccui.Button:create()
        btn:loadTextures(v[3],v[3],v[4],ccui.TextureResType.plistType)--localType,plistType
        self.nodeSet["lvBtn"]:pushBackCustomItem(btn)
        if btn then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onRuleTypeBtnClick))
            btn:setTag(k)
            self.nodeSet[k] = btn
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == m.btnMap.btnExit then
        self:removeFromParent()
    elseif s_name == m.btnMap.btnOK then
        self:createRoomHandle(self.data.roomType or DefineRule.RoomType.General)
    elseif s_name == m.btnMap.btnAgentRoom then
        self:createRoomHandle(DefineRule.RoomType.Agent)
    elseif s_name == m.btnMap.btnPeiPai then
        if self.layerPeiPai then
            --tagIndex:1长春，2斗地主，3填大坑
            self.layerPeiPai:showView(self.peiPaiType)
        else
            self.layerPeiPai = UIPeiPai:create(self.peiPaiType)
            self:addChild(self.layerPeiPai) 
        end
    end
end 

function m:onRuleTypeBtnClick( _sender )
    if not _sender then
        return
    end
    local s_name = _sender:getName()
    print("onRuleTypeBtnClick--s_name=",s_name)

    local _tag = _sender:getTag()
    local nodeRule = self.csbNode
    if self.lastActivityIndex then
        self.nodeSet[self.lastActivityIndex]:setTouchEnabled(true)
        self.nodeSet[self.lastActivityIndex]:setBright(true)
        nodeRule:getChildByTag(self.lastActivityIndex):setVisible(false)
    end
    if nodeRule:getChildByTag(_tag) then
        nodeRule:getChildByTag(_tag):setVisible(true)
    else
        local layer = require(m.btnRuleTypeMap[_tag][2]):create()
        layer:setTag(_tag)
        nodeRule:addChild(layer)
    end

    _sender:setBright(false)
    _sender:setTouchEnabled(false)
    self.lastActivityIndex = _tag
end

function m:createRoomHandle(roomType)
    local layer = self.csbNode:getChildByTag(self.lastActivityIndex)
    local data = layer:getRuleData()
    if gConfig.CurServerIndex >= gConfig.ServerTypeKey.sTestOuter and self.layerPeiPai then
        local pData = self.layerPeiPai:getPeipaiData()
        data.m_robotNum = pData.m_robotNum
        -- data.m_cardValue = pData.m_cardValue
        dump(pData,"data")
        if self.lastActivityIndex == 1 then
            for i=1,4 do            
                data["m_cardValue"..i] = pData["m_cardValue"..i]
            end
        else
            for i=1,5 do
                data["m_cardValue"..i] = pData["m_cardValue"..i]
            end
        end
    end
    data.m_RoomType = roomType

    if gConfig.CurServerIndex == gConfig.ServerTypeKey.sAndroidInReview then
        data.m_robotNum = data.m_playerNum - 1
    end
    
    data.clubID     = self.data.clubID or 0
    dump(data,"===createRoomHandle===")
    NetLobbyMng.SendCreateRoom(data)
end

function m:regEvent()
end

function m:unRegEvent()
end
function m:onEnter()
    log(self.__TAG,"onEnter")
    self:regEvent()
end

function m:onExit()
    log(self.__TAG,"onExit")
    self:unRegEvent()
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m