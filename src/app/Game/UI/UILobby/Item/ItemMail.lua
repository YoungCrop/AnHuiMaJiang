
local gComm = cc.exports.gComm

local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local csbFile = "Csd/ILobby/Item/ItemMail.csb"

local n = {}
local m = class("ItemMail", function()
    return display.newLayer()
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
    btnRefuse   = "btnRefuse",
    btnAgree    = "btnAgree",
}
n.nodeMap = {
    imgBG       = "imgBG",
    txtMsg      = "txtMsg",
    txtDateTime = "txtDateTime",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    local size = self.btnMap["imgBG"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    -- btn:setString(self.data[v[2]])
    self.btnMap["txtDateTime"]:setString(self.data.dateTime)
    local str = "玩家[[" .. (self.data.m_nike or "") .. "]]邀请您加入" .. self.data.clubName
    self.btnMap["txtMsg"]:setString(str)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    local tag = _sender:getTag()
    if s_name == n.btnMap.btnRefuse then
        -- // 1入会，2离会,3 代理后台邀请时,前端同意 4 代理后台邀请时,前端不同意
        -- NetLobbyMng.RespondClub(self.data.clubID,false)
        NetLobbyMng.joinAndQuitClub(4,self.data.clubID)
        self:getParent():removeFromParent()
    elseif s_name == n.btnMap.btnAgree then
        -- NetLobbyMng.RespondClub(self.data.clubID,true)
        NetLobbyMng.joinAndQuitClub(3,self.data.clubID)
        self:getParent():removeFromParent()
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