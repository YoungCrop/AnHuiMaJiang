
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local UIDistance = require("app.Game.UI.UIIRoom.UIDistance")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UISetting = require("app.Game.UI.UILobby.UISetting")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCmd = require("app.Common.NetMng.NetCmd")
local DefineRule = require("app.Common.Config.DefineRule")
local UIRule = require("app.Game.UI.UIIRoom.RoomComm.UIRule")
local UISetBtnList = require("app.Game.UI.UIIRoom.RoomComm.UISetBtnList")
local NodeTopUI = require("app.Game.UI.UIIRoom.RoomComm.NodeTopUI")

local csbFile = "Csd/IRoom/RoomComm/NodeTopUIPoker.csb"
local n = {}
local m = class("NodeTopUIPoker",NodeTopUI)

-- local m = class("NodeTopUIPoker", function()
--     return display.newNode()
-- end)

function m:ctor(param)
    m.super.ctor(self,param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self:initUI_()
end
function m:initUI_()
    self._btnMap = {}
    self:loadCSB_()
end

n.btnMap = {
    -- btnOutRoom     = "btnOutRoom",
}
n.nodeMap = {
    --key --{name,defaultVisible,defaultValue} 
    nodeLastHand  = {"nodeLastHand", false,}, 
    LastHand_1    = {"LastHand_1",   true, }, 
    LastHand_2    = {"LastHand_2",   true, }, 
    LastHand_3    = {"LastHand_3",   true, }, 
}

function m:loadCSB_()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    -- csbNode:addTo(self)

    local csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "FileNodeTopUI")
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick_))
        self._btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        btn:setVisible(v[2])
        if v[3] then
            btn:setString(v[3])
        end
        self._btnMap[k] = btn
    end
    
end

function m:onBtnClick_( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    gComm.SoundEngine:playEffect("common/SpecOk", false, true)
    if s_name == n.btnMap.btnOutRoom then
    end
end

function m:onEnter()
    m.super.onEnter(self)
    log(self.__TAG,"onEnter")
end

function m:onExit()
    m.super.onExit(self)
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    m.super.onCleanup(self)
    log(self.__TAG,"onCleanup")
    
end


return m