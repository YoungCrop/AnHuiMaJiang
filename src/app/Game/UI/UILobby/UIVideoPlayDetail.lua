
local gComm = cc.exports.gComm

local csbFile = "Csd/ILobby/UIVideoPlayDetail.csb"
local ItemVideoPlayDetail = require("app.Game.UI.UILobby.Item.ItemVideoPlayDetail")

local n = {}
local m = class("UIVideoPlayDetail",gComm.UIMaskLayer)

function m:ctor(data)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.data = data
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnExit = "btnExit",
}
n.nodeMap = {
    lvContent = "lvContent",
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
    for i=1,5 do
        local nicknameLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_nickname_" .. i)
        nicknameLabel:setString("")
    end
    for i, v in ipairs(self.data.m_nike) do
        local nicknameLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_nickname_" .. i)
        nicknameLabel:setString(gComm.StringUtils.GetShortName(v))
    end

    for i, v in ipairs(self.data.m_match) do
        v.index = i
        local item = ItemVideoPlayDetail:create(v)
        local cellSize = item:getContentSize()
        local detailItem = ccui.Widget:create()
        detailItem:setContentSize(cellSize)
        detailItem:addChild(item)
        self.btnMap["lvContent"]:pushBackCustomItem(detailItem)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
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