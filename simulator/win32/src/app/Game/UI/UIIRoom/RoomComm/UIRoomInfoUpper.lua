
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig
local gRoomData = cc.exports.gData.ModleRoom
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local UIChat = require("app.Game.UI.UIIRoom.UIChatNew")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local NetCmd = require("app.Common.NetMng.NetCmd")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local SpriteTileOpen = require("app.Common.Tiles.SpriteTileOpen")
local NetMngMJAnQin = require("app.Common.NetMng.NetMngMJAnQin")
local DefineRoom = require("app.Common.Config.DefineRoom")
local NodeTopUI = require("app.Game.UI.UIIRoom.RoomComm.NodeTopUI")

local csbFile = "Csd/IRoom/RoomComm/UIRoomInfoUpper.csb"

local n = {}
local m = class("UIRoomInfoUpper", function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	dump(param,"===UIRoomInfoNode===")

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,

        ruleType  = param.ruleType,
        uid           = param.uid,
        roomPeopleNum = param.roomPeopleNum,
        roomType      = param.roomType,
    }
	self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
--ui位置编号
--   2
--3     1
--   4
--
    self.btnMap = {}
    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        self.NodeTopUI = NodeTopUIPoker:create(self.param)
    else
        self.NodeTopUI = NodeTopUI:create(self.param)
    end
    self.NodeTopUI:addTo(self.param.csbNode)

    self:loadCSB()
end

n.btnMap = {
    --key --{name,defaultShowFlag,}
    btnCancelTuoGuan    = {"btnCancelTuoGuan", false,},
}
n.nodeMap = {
    --key --{name,defaultShowFlag,}
    imgDeskCloth        = {"imgDeskCloth",false,},
    imgBGTingTip        = {"imgBGTingTip",false,},
    lvTingMJ            = {"lvTingMJ",    true,},
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        if btn then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
            self.btnMap[k] = btn
            btn:setVisible(v[2])
        end
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
        btn:setVisible(v[2])
    end

    -- self.btnMap["btnCancelTuoGuan"]:setLocalZOrder(ConfigGameScene.ZOrder.DECISION_SHOW+1)
    self:setLocalZOrder(ConfigGameScene.ZOrder.DECISION_SHOW+1)

    self:showMJTing(false)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("UIRoomInfoNode=s_name=",s_name)

    if s_name == n.btnMap.btnCancelTuoGuan[1]    then
        NetMngRoom.sendTuoGuan(false)
    end
end

--TopUI
--key:btnOutRoom,btnDimissRoom,btnTuoGuan
function m:setBtnVisible(args)
    args = args or {}
    for k,v in pairs(args) do
        if k == "btnInviteFriend" then
        end
    end
end

function m:setTuoGuanBtnShow(isShow)
    self.NodeTopUI:setTuoGuanBtnVisible(isShow)
    self.btnMap["btnCancelTuoGuan"]:setVisible(not isShow)
end

function m:setRoundIndex(str)
    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        -- self.NodeTopUI:setRoundIndex(str)--需要重写
    else
        local s = string.sub(str,4,-4)--中文一个字占2个字节
        -- self.btnMap["txtRoundNum"]:setString(s)
        self.NodeTopUI:setRoundBtnHide()
    end
end

function m:showMJTing(isShow,cardsList)
    self.btnMap["imgBGTingTip"]:setVisible(isShow)
    if isShow then
        self.btnMap["lvTingMJ"]:removeAllChildren()
        local scale = 0.4625--0.55
        local sumWidth = 0
        dump(cardsList,"--showMJTingshowMJTing--")
        for i,v in ipairs(cardsList) do
            local mjTileSpr = SpriteTileOpen:create(v[1], v[2],scale)
            -- local cellItem = ccui.ImageView:create()--ccui.Layout:create()--ccui.Widget:create()
            local cellItem = ccui.Layout:create()
            local s = mjTileSpr:getBoundingBox()--getContentSize()
            cellItem:setContentSize(cc.size(s.width,s.height))
            mjTileSpr:setPosition(cc.p(s.width*0.5,s.height*0.5))
            cellItem:addChild(mjTileSpr)
            self.btnMap["lvTingMJ"]:pushBackCustomItem(cellItem)
            if i < 4 then
                sumWidth = sumWidth + s.width + 2
            elseif i == 4 then
                sumWidth = sumWidth + s.width*0.5
            end
            log("sumWidthsumWidth==",sumWidth)
        end
        self.btnMap["lvTingMJ"]:setContentSize(cc.size(sumWidth,57))
        self.btnMap["lvTingMJ"]:setScrollBarEnabled(false)
        self.btnMap["imgBGTingTip"]:setContentSize(cc.size(sumWidth+80,70))
    end
end

function m:setBtnBackLobby(isShow)
    self.NodeTopUI:setBtnBackLobby(isShow)
end


--key:btnOutRoom,btnDimissRoom,btnTuoGuan
function m:setBtnVisible(args)
    args = args or {}
    self.NodeTopUI:setTopUIBtnVisible(args)
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
