
local gt = cc.exports.gt

local UIShare = require("app.Game.UI.UILobby.UIShare")
local UIHelp = require("app.Game.UI.UILobby.UIHelp")
local UIShareAll = require("app.Game.UI.UILobby.UIShareAll")
local UIMessage = require("app.Game.UI.UILobby.UIMessage")
local UISetting = require("app.Game.UI.UILobby.UISetting")
local UIShop = require("app.Game.UI.UILobby.UIShop")
local UIBuyCard = require("app.Game.UI.UILobby.UIBuyCard")
local UIVideoPlay = require("app.Game.UI.UILobby.UIVideoPlay")
local UIGMSelect = require("app.Game.UI.UITools.UIGMSelect")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local UIServerDebug = require("app.Game.UI.UICommon.UIServerDebug")

local resCsb = "Csd/ILobby/UILobbyBottomTop.csb"
local m = class("UILobbyBottomTop", function()
    return display.newNode()
end)

local n = {}

n.btnMap = {
    btnShare           = "btnShare",
    btnHistory         = "btnHistory",
    btnHelp            = "btnHelp",
    btnMessage         = "btnMessage",
    btnSetting         = "btnSetting",

    btnAward           = "btnAward",
    btnRecharge        = "btnRecharge",
    btnAuth            = "btnAuth",

    btnCopyID          = "btnCopyID",

    btnBuyCard         = "btnBuyCard",
    imgBGBuyCard       = "imgBGBuyCard",
}

n.nodeMap = {
    imgBG       = "imgBG",
    iconLogo    = "iconLogo",
    txtID       = "txtID",
    txtNickname = "txtNickname",
    txtCardNum  = "txtCardNum",
    spriteHead  = "spriteHead",
    imgGuang    = "imgGuang",
    newMsgFlag  = "newMsgFlag",
}

function m:ctor(args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    args = args or {}
    self.param = {
        isNewPlayer    = args.isNewPlayer,
        isShowCoinMain = args.isShowCoinMain,
    }
    self._gParam = {
        isShared = true,
    }
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

function m:loadCSB()
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(resCsb)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end
    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["imgBG"]:setVisible(false)
    self:initHeadInfo()
    self:hideBtn()

end

function m:setNodeHide( nodeNameTb )
    for k,v in pairs(nodeNameTb) do
        if self.btnMap[v] then
            self.btnMap[v]:setVisible(false)
        end
    end
end

function m:hideBtn()
    if gGameConfig.isiOSAppInReview then
        local nodeNameTb = {
            btnHistory = "btnHistory",
            btnMessage = "btnMessage",
            btnSetting = "btnSetting",
            btnAuth    = "btnAuth",
            btnShare   = "btnShare",
            btnAward   = "btnAward",
            btnHelp    = "btnHelp",
        }
        self:setNodeHide(nodeNameTb)
    end

    local nodeNameTb = {
        btnRecharge = "btnRecharge",
        btnAward    = "btnAward",
        imgGuang    = "imgGuang",
        btnAuth     = "btnAuth",
    }
    self:setNodeHide(nodeNameTb)
end

function m:initHeadInfo()
    local selfInfo = cc.exports.gData.ModleGlobal:getSelfInfo()
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    cc.exports.gData.ModleGlobal:printAllInfo()
    playerHeadMgr:attach(self.btnMap["spriteHead"], selfInfo.userID, selfInfo.headURL)
    self:addChild(playerHeadMgr)

    -- self.btnMap["txtNickname"]:setString(selfInfo.nikeNameShort)
    self.btnMap["txtNickname"]:setString(gComm.StringUtils.GetShortName(selfInfo.nikeName,8))
    self.btnMap["txtID"]:setString("ID:" .. selfInfo.userID)

    local playerData = cc.exports.gData.ModleGlobal
    self.btnMap["txtCardNum"]:setString(playerData.roomCardsCount[2])
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    log("--s_name---" .. s_name)

    if     s_name == n.btnMap.btnShare   then
        local layer = UIShare:create(self._gParam.isShared)
        self:addChild(layer)
    elseif s_name == n.btnMap.btnHistory then
        if cc.exports.gData.ModleGlobal.isGM then
            local layer = UIGMSelect:create()
            self:addChild(layer)
        else
            local layer = UIVideoPlay:create()
            self:addChild(layer)
        end
    elseif s_name == n.btnMap.btnHelp then
        local layer = UIHelp:create()
        self:addChild(layer)
    elseif s_name == n.btnMap.btnMessage then
        -- if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        --     local layer = UIMessage:create()
        --     self:addChild(layer)
        -- else
        --     gComm.UIUtils.showLoadingTips(ConfigTxtTip.GetConfigTxt("LTKey_0005"))
        --     NetLobbyMng.getMailList()
        -- end
        local layer = UIMessage:create()
        self:addChild(layer)
    elseif s_name == n.btnMap.btnSetting then
        local layer = UISetting:create({isInLobby = true,})
        self:addChild(layer)

    elseif s_name == n.btnMap.btnAward    then
    elseif s_name == n.btnMap.btnRecharge then
        local layer = UIShop:create()
        self:addChild(layer)
    elseif s_name == n.btnMap.btnAuth then
        gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_0038"))
    elseif s_name == n.btnMap.btnCopyID then
        local str = self.btnMap["txtID"]:getString()--"ID:" .. playerData.uid)
        str = string.sub(str,4)
        gComm.CallNativeMng.AppNative:copyText(str)
        gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_CopySuccess"))

    elseif s_name == n.nodeMap.iconLogo then
        local layer = UIServerDebug:create()
        self:addChild(layer)

    elseif s_name == n.btnMap.btnBuyCard or s_name == n.btnMap.imgBGBuyCard then
        if "ios" == device.platform then
            local layer = UIShop:create()
            self:addChild(layer)
        else
            local layer = UIBuyCard:create()
            self:addChild(layer)
        end
    end
end

function m:onRcvShare( msgTbl )
    dump(msgTbl,"--onRcvShareonRcvShare--")
    --0：领取房卡成功 7:可以领取，8:不可领取
    if msgTbl.m_errorCode == 0 then
        local str = "运气不佳，明天再来~~"
        if msgTbl.m_getNum > 0 then
            str = "成功领取房卡" .. msgTbl.m_getNum .. "张!"
        end
        gComm.UIUtils.floatText(str)
        self._gParam.isShared = true --是否已经分享
    elseif msgTbl.m_errorCode == 7 then
        self._gParam.isShared = false --是否已经分享
    elseif msgTbl.m_errorCode == 8 then
        self._gParam.isShared = true --是否已经分享
    end
end

function m:revClubMail(msgTbl)
    dump(msgTbl,"m:revClubMail======")
    gComm.UIUtils.removeLoadingTips()
    local args = {
        m_data = msgTbl.m_data,
    }
    local layer = UIMessage:create(args)
    self:addChild(layer)
    self:onHandleNewMessage(1,#msgTbl.m_data ~= 0)
end

function m:onHandleNewMessage(eventName,isHasMsg)
    self.btnMap["newMsgFlag"]:setVisible(isHasMsg)
end

function m:revInviteAddClub(msgTbl)
    dump(msgTbl,"m:revInviteAddClub======")
    self:onHandleNewMessage(1,true)
end

function m:setCardNum(cardNum)
    self.btnMap["txtCardNum"]:setString(cardNum)
end
function m:doServerDebug()
    if "windows" == device.platform then
        gComm.BtnUtils.setButtonClick(self.btnMap["iconLogo"],handler(self,self.onBtnClick))
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_GET_FANGKA_HUODONG, self, self.onRcvShare)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_INVITE_ADD_CLUB, self, self.revInviteAddClub)
    gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_CLUB_MAIL, self, self.revClubMail)
    gComm.EventBus.regEventListener(EventCmdID.UI_HAS_NEW_MESSAGE, self, self.onHandleNewMessage)

    self._gParam.isShared = true --是否已经分享
    NetLobbyMng.canGenCardByShare()

    self:doServerDebug()
end

function m:onExit()
    log(self.__TAG,"onExit")
    gComm.EventBus.unRegAllEvent(self)
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end


return m
