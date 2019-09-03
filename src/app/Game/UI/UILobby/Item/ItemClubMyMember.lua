
local gComm = cc.exports.gComm
local csbFile = "Csd/ILobby/Item/ItemClubMyMember.csb"

local n = {}
local m = class("ItemClubMyMember", function()
    return display.newNode()
end)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.data = data
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.nodeMap = {
    imgBG          = "imgBG",
    txtName        = "txtName",
    txtID          = "txtID",
    txtOnlineState = "txtOnlineState",
    spriteHead     = "spriteHead",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    -- local size = self.btnMap["imgBG"]:getContentSize()
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    self.btnMap["txtName"]:setString(gComm.StringUtils.GetShortName(self.data.nikeName))
    self.btnMap["txtID"]:setString("ID:" .. self.data.userID)
    local str = self.data.isOnline == 1 and "在线" or "离线"
    self.btnMap["txtOnlineState"]:setString("(" .. str .. ")")

    local color = self.data.isOnline == 1 and cc.c3b(0,128,0) or cc.c3b(127,127,127)
    self.btnMap["txtOnlineState"]:setColor(color)
    -- if self.data.isAdmin == 1 then
    --     self.btnMap["txtOnlineState"]:setString("部长")
    --     self.btnMap["txtOnlineState"]:setColor(cc.c3b(0,0,255))
    -- end

    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    playerHeadMgr:attach(self.btnMap["spriteHead"], self.data.userID, self.data.headURL)
    self:addChild(playerHeadMgr)
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