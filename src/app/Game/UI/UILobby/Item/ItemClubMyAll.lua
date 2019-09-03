
local gComm = cc.exports.gComm
local netMng = require("app.Common.NetMng.NetLobbyMng")
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/ILobby/Item/ItemClubMyAll.csb"

local n = {}
local m = class("ItemClubMyAll", function()
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

n.btnMap = {
    btnEnter = "btnEnter",
}
n.nodeMap = {
    imgBG        = "imgBG",
    txtClubName  = "txtClubName",
    txtManNum    = "txtManNum",
    spriteHead   = "spriteHead",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
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
    -- local size = self.btnMap["imgBG"]:getContentSize()
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    self.btnMap["txtClubName"]:setString(self.data.clubName)
    local str = "人数:" .. self.data.curMemberNum .. "/" .. self.data.memberNumLimit
    self.btnMap["txtManNum"]:setString(str)
    
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    playerHeadMgr:attach(self.btnMap["spriteHead"], self.data.clubID, self.data.headUrl)
    self:addChild(playerHeadMgr)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    --self.data.clubID
    if s_name == n.btnMap.btnEnter then
        netMng.getClubDetailInfo(self.data.clubID)
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
