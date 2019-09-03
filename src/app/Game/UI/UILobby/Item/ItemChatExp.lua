
local gComm = cc.exports.gComm
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Item/ItemChatExp.csb"

local n = {}
local m = class("ItemChatExp", function()
    return display.newLayer()
end)

function m:ctor(args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        speakStr = args.speakStr,
    }
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExp   = "btnExp",
}
n.nodeMap = {
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

    local size = self.btnMap["btnExp"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    -- self.btnMap["btnExp"]: 
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    local tag = _sender:getTag()
    if s_name == n.btnMap.btnExp then

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