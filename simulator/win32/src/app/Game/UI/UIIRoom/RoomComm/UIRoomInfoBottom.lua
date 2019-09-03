
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

local csbFile = "Csd/IRoom/RoomComm/UIRoomInfoBottom.csb"

local n = {}
local m = class("UIRoomInfoBottom", function()
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
    self:loadCSB()
end

n.btnMap = {
    --key --{name,defaultShowFlag,}
    btnMessage       = {"btnMessage",       true,},
    btnInviteFriend  = {"btnInviteFriend",  true,},
    btnCopyRoomID    = {"btnCopyRoomID",    true,},
    btnReady         = {"btnReady",         false,},
    btnCancelTuoGuan = {"btnCancelTuoGuan", false,},
}
n.nodeMap = {
    --key --{name,defaultShowFlag,}
    imgDeskCloth    = {"imgDeskCloth",    true,},
    btnVoice        = {"btnVoice",        true,}, --touch事件
    txtRemainTile   = {"txtRemainTile",   true,},
    txtRoundNum     = {"txtRoundNum",     true,},
    txtCountDown    = {"txtCountDown",    true,},
    layoutRoundState= {"layoutRoundState",false,},-- 隐藏牌局状态（倒计时，剩余牌局，剩余牌数）
    spriteTurnPosBG = {"spriteTurnPosBG", false,},
    spriteTurnPos1  = {"spriteTurnPos1",  false,},
    spriteTurnPos2  = {"spriteTurnPos2",  false,},
    spriteTurnPos3  = {"spriteTurnPos3",  false,},
    spriteTurnPos4  = {"spriteTurnPos4",  false,},
}

function m:loadCSB()
    -- do return end
    self:setPosition(display.center)
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    local bg = gComm.UIUtils.seekNodeByName(self.param.csbNode, "imgDeskCloth")
    bg:setVisible(false)
    -- self:setLocalZOrder(bg:getLocalZOrder())

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

    self.btnMap["btnCancelTuoGuan"]:setLocalZOrder(ConfigGameScene.ZOrder.DECISION_SHOW+1)
    if self.param.roomType == DefineRule.RoomType.BigMatch then
        self.btnMap["btnVoice"]:setVisible(false)
    elseif self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.btnMap["btnInviteFriend"]:setVisible(false)
    end

    -- if self.param.gameID == DefineRule.GameID.POKER_DDZ then
    --     return
    -- end
    self.btnMap["txtCountDown"]:setString("")
    self.btnMap["imgDeskCloth"]:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))
    self:changeGameBg()
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("UIRoomInfoNode=s_name=",s_name)

    if s_name == n.btnMap.btnInviteFriend[1]    then
        local titleLocal,description = self:inviteFriendUrl()
        local shareurl = gCallNativeMng.NativeMeChuang:getMCURLParam(self.param.roomID,self.param.uid)

        local _type = gCallNativeMng.shareType.WeiXin
        local handle = nil
        gCallNativeMng:shareURL(_type,shareurl,titleLocal,description,handle)

    elseif s_name == n.btnMap.btnCopyRoomID[1] then
        local titleLocal,description = self:inviteFriendUrl()
        local copyStr = titleLocal .. "\n" ..description
        copyStr = copyStr .. "\n"..gCallNativeMng.NativeMeChuang:getMCURL()

        gCallNativeMng.AppNative:copyText(copyStr)
        gComm.UIUtils.floatText("复制成功")

    elseif s_name == n.btnMap.btnCancelTuoGuan[1] then
        NetMngRoom.sendTuoGuan(false)

    elseif s_name == n.btnMap.btnMessage[1] then
        local args = {
            gameID    = self.param.gameID,
            roomType  = self.param.roomType,
            pos      = cc.p(_sender:getWorldPosition().x - 270,display.height * 0.5),
        }
        local layer = UIChat:create(args)
        -- self.csbNode:addChild(layer, ConfigGameScene.ZOrder.CHAT)
        cc.Director:getInstance():getRunningScene():addChild(layer)
    elseif s_name == n.btnMap.btnReady[1] then
        _sender:setVisible(false)
        NetMngMJAnQin.sendReady(self.param.sPos)
    end
end

--self.UIRoomInfoNode:setBtnVisible(args)
--btnInviteFriend,btnReady,btnCancelTuoGuan,btnMessage
--kNodeRound,kTurnPosBG

--TopUI
--key:btnOutRoom,btnDimissRoom,btnTuoGuan
function m:setBtnVisible(args)
    args = args or {}
    for k,v in pairs(args) do
        if k == "btnInviteFriend" then
            self.btnMap["btnInviteFriend"]:setVisible(v)
            if self.param.roomType == DefineRule.RoomType.CoinRoom then
                self.btnMap["btnInviteFriend"]:setVisible(false)
            end
        elseif k == "btnReady" then
            self.btnMap["btnReady"]:setVisible(v)
        elseif k == "btnCancelTuoGuan" then
            self.btnMap["btnCancelTuoGuan"]:setVisible(v)
        elseif k == "btnMessage" then
            self.btnMap["btnMessage"]:setVisible(v)
        elseif k == "kNodeRound" then
            self.btnMap["layoutRoundState"]:setVisible(v)
        elseif k == "kTurnPosBG" then
            self.btnMap["spriteTurnPosBG"]:setVisible(v)
        end
    end
end


--self.UIRoomInfoNode:setTxt(args)
--remainTile,roundNum,countDown,
function m:setTxt(args)
    args = args or {}
    for k,v in pairs(args) do
        if k == "remainTile" then
            self.btnMap["txtRemainTile"]:setString(v)
        elseif k == "roundNum" then
            -- local v = string.sub(v,4,-4)--中文一个字占2个字节
            self.btnMap["txtRoundNum"]:setString(v)
        elseif k == "countDown" then
            self.btnMap["txtCountDown"]:setString(v)
        end
    end
end

--self.UIRoomInfoNode:getBtnMap().kTurnPosBG

function m:getBtnMap()
    local map = {
        btnVoice = self.btnMap["btnVoice"],
        kTurnPosBG = self.btnMap["spriteTurnPosBG"],
    }
    return map
end

function m:setTuoGuanBtnShow(isShow)
    self.btnMap["btnCancelTuoGuan"]:setVisible(not isShow)
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

function m:changeGameBg()
    --Sprite用initWithFile
    --ImageView
    -- self.btnMap["imgDeskCloth"]:loadTexture(gameBgPic,ccui.TextureResType.localType)
    local bgIndex = cc.UserDefault:getInstance():getIntegerForKey("gameBg", 2)
    local gameBgPic = DefineRoom.DeskClothImgRes[bgIndex][1]
    self.btnMap["imgDeskCloth"]:loadTexture(gameBgPic,ccui.TextureResType.localType)

    local msgRes = DefineRoom.BtnMsgImgRes[bgIndex]
    local voiceRes = DefineRoom.BtnVoiceImgRes[bgIndex]
    self.btnMap["btnVoice"]:loadTextures(voiceRes[1],voiceRes[2],voiceRes[3],ccui.TextureResType.plistType)
    self.btnMap["btnMessage"]:loadTextures(msgRes[1],msgRes[2],msgRes[3],ccui.TextureResType.plistType)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gComm.EventBus.regEventListener(EventCmdID.UI_UPDATE_DESK_CLOTH,self,self.changeGameBg)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gComm.EventBus.unRegAllEvent(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end


return m
