
local gComm = cc.exports.gComm

local DefineRule = require("app.Common.Config.DefineRule")
local UICreateRoomMJ = require("app.Game.UI.UILobby.CreateRoom.UICreateRoomMJ")
local UICreateRoomPoker = require("app.Game.UI.UILobby.CreateRoom.UICreateRoomPoker")

local csbFile = "Csd/ILobby/Club/ClubCreateRoom.csb"

local n = {}
local m = class("ClubCreateRoom",gComm.UIMaskLayer)

function m:ctor(data)
    m.super.ctor(self)
    self.data = data
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose       = "btnClose",
    btnCreateMJ    = "btnCreateMJ",
    btnCreatePoker = "btnCreatePoker",
}
n.nodeMap = {
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
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
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnCreateMJ then
        local args = {
            roomType = DefineRule.RoomType.Club,
            clubID   = self.data.clubID,
        }
        local layer = UICreateRoomMJ:create(args)
        self:getParent():addChild(layer)
        self:removeFromParent()
    elseif s_name == n.btnMap.btnCreatePoker then
        local args = {
            roomType = DefineRule.RoomType.Club,
            clubID   = self.data.clubID,
        }
        local layer = UICreateRoomPoker:create(args)
        self:getParent():addChild(layer)
        self:removeFromParent()
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