

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local netMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/BigWinMatch/UIBigWinRecord.csb"

local ItemBigWinRecord = require("app.Game.UI.UILobby.Item.ItemBigWinRecord")

local n = {}
local m = class("UIBigWinRecord",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
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
    txtEmpty = "txtEmpty",
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
    self.btnMap["txtEmpty"]:setVisible(false)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_RED_CODE_LOG, self, self.onRcvBigWinRecord)
    netMng.getBigWinRecord()
end

function m:onRcvBigWinRecord(msg)
    dump(msg,"m:onRcvBigWinRecord---")

    if #msg.m_data == 0 then
        self.btnMap["txtEmpty"]:setVisible(true)
    else
        self.btnMap["txtEmpty"]:setVisible(false)
        for i,v in ipairs(msg.m_data) do
            local data = {
                dateTime    = v.m_time,
                winningCode = v.m_activeCode,
                WinningDesc = "1234",
                isGeted     = (v.m_status == 1),--0未领取,1已领取
            }
            local item = ItemBigWinRecord:create(data)
            local cellSize = item:getContentSize()
            local cellItem = ccui.Widget:create()
            cellItem:setContentSize(cellSize)
            cellItem:addChild(item)
            self.btnMap["lvContent"]:pushBackCustomItem(cellItem)
        end
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
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m