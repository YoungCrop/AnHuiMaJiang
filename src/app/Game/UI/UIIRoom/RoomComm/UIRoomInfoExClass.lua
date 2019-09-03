
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig
local gRoomData = cc.exports.gData.ModleRoom
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local UIChat = require("app.Game.UI.UIIRoom.UIChat")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local NetCmd = require("app.Common.NetMng.NetCmd")
local NodeTopUI = require("app.Game.UI.UIIRoom.RoomComm.NodeTopUI")
local NodeTopUIPoker = require("app.Game.UI.UIIRoom.RoomComm.NodeTopUIPoker")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")
local SpriteTileOpen = require("app.Common.Tiles.SpriteTileOpen")
local DefineRoom = require("app.Common.Config.DefineRoom")

local n = {}
local m = class("UIRoomInfoExClass")

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	dump(param,"===UIRoomInfo===")

	self.csbNode = param.csbNode
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
    self.NodeTopUI:addTo(self.csbNode)
    self:loadCSB()
end

n.btnMap = {
    Btn_inviteFriend    = "Btn_inviteFriend",
    btnCopyInviteFriend = "btnCopyInviteFriend",
    Btn_message         = "Btn_message",

--斗地主没有一下控件
    btnCancelTuoGuan    = "btnCancelTuoGuan",
    imgBGTingTip        = "imgBGTingTip",
    lvTingMJ            = "lvTingMJ",
}
n.nodeMap = {
	--key --{name,defaultShowFlag,}
    imgDeskCloth           = {"imgDeskCloth",    true,},-- 背景
    Node_decisionBtn       = {"Node_decisionBtn",false},
    Node_selfDrawnDecision = {"Node_selfDrawnDecision",false},
}

function m:loadCSB()
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(self.csbNode, k)
        if btn then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
            self.btnMap[k] = btn
        end
    end

    self.btnMap["btnCancelTuoGuan"]:setLocalZOrder(ConfigGameScene.ZOrder.DECISION_SHOW+1)
    self.btnMap["btnCancelTuoGuan"]:setVisible(false)
    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.btnMap["Btn_inviteFriend"]:setVisible(false)
    end

    -- self.csbNode:reorderChild(self.btnMap["Node_decisionBtn"], ConfigGameScene.ZOrder.DECISION_BTN)
    -- self.csbNode:reorderChild(self.btnMap["Node_selfDrawnDecision"], ConfigGameScene.ZOrder.DECISION_BTN)

    if self.param.gameID == DefineRule.GameID.POKER_DDZ then
        return
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(self.csbNode, k)
        btn:setVisible(v[2])
        self.btnMap[k] = btn
    end
    self.btnMap["imgDeskCloth"]:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

    self.btnMap["imgBGTingTip"]:setLocalZOrder(ConfigGameScene.ZOrder.CHAT+1)
    self:changeGameBg()
    self:showMJTing(false)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.Btn_inviteFriend    then
        local titleLocal,description = self:inviteFriendUrl()
        local shareurl = gCallNativeMng.NativeMeChuang:getMCURLParam(self.param.roomID,self.param.uid)

        local _type = gCallNativeMng.shareType.WeiXin
        local handle = nil
        gCallNativeMng:shareURL(_type,shareurl,titleLocal,description,handle)

    elseif s_name == n.btnMap.btnCopyInviteFriend then
        local titleLocal,description = self:inviteFriendUrl()
        local copyStr = titleLocal .. "\n" ..description
        copyStr = copyStr .. "\n"..gCallNativeMng.NativeMeChuang:getMCURL()

        gCallNativeMng.AppNative:copyText(copyStr)
        gComm.UIUtils.floatText("复制成功")

    elseif s_name == n.btnMap.btnCancelTuoGuan then
        NetMngRoom.sendTuoGuan(false)

    elseif     s_name == n.btnMap.Voice_Btn  then

    elseif s_name == n.btnMap.Btn_message then
        local args = {
            gameID    = self.param.gameID,
            roomType  = self.param.roomType,
        }
        local Chat = UIChat:create(args)
        self.csbNode:addChild(Chat, ConfigGameScene.ZOrder.CHAT)
    end
end

function m:inviteFriendUrl()
    local description = ""
    for _,v in pairs(self.param.ruleType) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            description = description .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            description = description .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end
    description = description.."!"

    local titleLocal = (DefineRule.GameTypeName[self.param.gameID] or "") .. ": 房号:[%d] %d局 %d缺%d"
    local curPlayerAmount = cc.UserDefault:getInstance():getIntegerForKey("gameCurrentPlayer", 0)
    titleLocal = string.format(titleLocal,self.param.roomID,self.param.roundMaxCount,curPlayerAmount,self.param.roomPeopleNum-curPlayerAmount)

    return titleLocal,description
end

function m:setTuoGuanBtnShow(isShow)
    self.NodeTopUI:setTuoGuanBtnVisible(isShow)
    self.btnMap["btnCancelTuoGuan"]:setVisible(not isShow)
end

function m:changeGameBg()
    local bgIndex = cc.UserDefault:getInstance():getIntegerForKey("gameBg", 2)
    -- local gameBgPic = "Image/BigImg/game_bg"..bgIndex..".png"
    local gameBgPic = DefineRoom.DeskClothImgRes[bgIndex][1]
    self.btnMap["imgDeskCloth"]:loadTexture(gameBgPic,ccui.TextureResType.localType)
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

function m:regEvent()
    gComm.EventBus.regEventListener(EventCmdID.UI_UPDATE_DESK_CLOTH,self,self.changeGameBg)
end

function m:unRegEvent()
    gComm.EventBus.unRegAllEvent(self)
end


return m
