
local gt = cc.exports.gt

local UIJoinRoom = require("app.Game.UI.UILobby.UIJoinRoom")
local UIAgentRoom = require("app.Game.UI.UILobby.UIAgentRoom")
local UICoinMain = require("app.Game.UI.UILobby.Coin.UICoinMain")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local NodeMarquee = require("app.Game.UI.UILobby.NodeMarquee")
local DefineRule = require("app.Common.Config.DefineRule")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local UICreateRoomMJ = require("app.Game.UI.UILobby.CreateRoom.UICreateRoomMJ")
local UICreateRoomPoker = require("app.Game.UI.UILobby.CreateRoom.UICreateRoomPoker")
local NetCmd = require("app.Common.NetMng.NetCmd")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local UIBigWinMatch = require("app.Game.UI.UILobby.BigWinMatch.UIBigWinMatch")
local ClubMyAll = require("app.Game.UI.UILobby.Club.ClubMyAll")

local resCsb = "Csd/Scene/SceneLobby.csb"
local m = class("UILobbyCenter", function()
    return display.newNode()
end)

local n = {}

n.btnMap = {
    btnCreateRoomMJ    = "btnCreateRoomMJ",
    btnCreateRoomPoker = "btnCreateRoomPoker",
    btnBigWinMatch     = "btnBigWinMatch",
    btnJoinRoom        = "btnJoinRoom",
    btnCoinGame        = "btnCoinGame",
    btnClub            = "btnClub",
    btnCopyWXCode      = "btnCopyWXCode",
    txtWXGZH           = "txtWXGZH",
}
n.nodeMap = {
    imgBG            = "imgBG",
    nodeMarquee      = "nodeMarquee",
    nodeAnimFileGirl = "nodeAnimFileGirl",
    lobby_notice_bg  = "lobby_notice_bg",
    txtVersionInfo   = "txtVersionInfo",
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
    self.btnMap["imgBG"]:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

    -- self.btnMap["imgGuang"]:runAction(cc.RepeatForever:create(cc.RotateBy:create(4, 360)))

    self.NodeMarquee = NodeMarquee:create()
    self.btnMap["nodeMarquee"]:addChild(self.NodeMarquee)
    self:showMarquee()

    self:initInfo()
    self:hideBtn()
end

function m:showMarquee()
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview then
        self.NodeMarquee:showMsg(ConfigTxtTip.GetConfigTxt("LTKey_0048"))
    else
        self.NodeMarquee:showMsg(cc.exports.gData.ModleGlobal.marqueeStr)
    end
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
            btnClub            = "btnClub",
            btnCreateRoomPoker = "btnCreateRoomPoker",
            btnBigWinMatch     = "btnBigWinMatch",
            btnCoinGame        = "btnCoinGame",
            lobby_notice_bg    = "lobby_notice_bg",
        }
        self:setNodeHide(nodeNameTb)

        local str_des = ConfigTxtTip.GetConfigTxt("LTKey_0048")
        self.marqueeMsg:showMsg(str_des)
    end
    local nodeNameTb = {}
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        nodeNameTb.btnClub            = "btnClub"
        nodeNameTb.btnBigWinMatch     = "btnBigWinMatch"
        nodeNameTb.btnCreateRoomPoker = "btnCreateRoomPoker"
        nodeNameTb.btnCoinGame        = "btnCoinGame"
    end
    nodeNameTb.btnBigWinMatch        = "btnBigWinMatch"
    self:setNodeHide(nodeNameTb)
end

function m:initInfo()
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    log("--s_name---" .. s_name)
    if s_name == n.btnMap.btnHelp then


    elseif s_name == n.btnMap.btnHuoDong then
        if not cc.exports.gData.ModleGlobal.isGM then --测试
            gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_0085"))
        else
            local layer = UIAgentRoom:create()
            cc.Director:getInstance():getRunningScene():addChild(layer)
        end

    elseif s_name == n.btnMap.btnCreateRoomMJ then
        if gGameConfig.isiOSAppInReview then
            local data = {
                ruleArray = {16,18,5},
                m_RoomType = 0,  --1代开
                m_robotNum = 3,
                m_gameID = DefineRule.GameID.AnQinDianPao,
                m_MaxCircle = 6,
                m_playerNum = 4,
            }
            NetLobbyMng.SendCreateRoom(data)
        else
            local layer = UICreateRoomMJ:create()
            cc.Director:getInstance():getRunningScene():addChild(layer)
        end
    elseif s_name == n.btnMap.btnJoinRoom then
        local layer = UIJoinRoom:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)

    elseif s_name == n.btnMap.btnAgentRoom then
        if not cc.exports.gData.ModleGlobal.isGM then
            gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_0085"))
        else
            local layer = UIAgentRoom:create()
            cc.Director:getInstance():getRunningScene():addChild(layer)
        end

    elseif s_name == n.btnMap.btnCreateRoomPoker then
        local layer = UICreateRoomPoker:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)
    elseif s_name == n.btnMap.btnBigWinMatch then
        local layer = UIBigWinMatch:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)

    elseif s_name == n.btnMap.txtWXGZH or s_name == n.btnMap.btnCopyWXCode then
        local copyStr = self.btnMap["txtWXGZH"]:getString() or ""
        gComm.CallNativeMng.AppNative:copyText(copyStr)
        gComm.UIUtils.floatText(ConfigTxtTip.GetConfigTxt("LTKey_CopySuccess"))

    elseif s_name == n.btnMap.btnClub then
        local layer = ClubMyAll:create()
        cc.Director:getInstance():getRunningScene():addChild(layer)
    elseif s_name == n.btnMap.btnCoinGame then
        local lay = UICoinMain:create()
        cc.Director:getInstance():getRunningScene():addChild(lay)
    end
end

function m:getLocalVersion()
    local writePath = cc.FileUtils:getInstance():getWritablePath()
    local version_filename = "version.manifest"
    local isExist = cc.FileUtils:getInstance():isFileExist(writePath .. version_filename)
    local version = ""
    if isExist then
        local fileData = cc.FileUtils:getInstance():getStringFromFile(writePath .. version_filename)
        local fileList = json.decode(fileData)
        version = fileList.version
    else
        isExist = cc.FileUtils:getInstance():isFileExist(version_filename)
        if isExist then
            local fileData = cc.FileUtils:getInstance():getStringFromFile(version_filename)
            local fileList = json.decode(fileData)
            version = fileList.version
        end
    end
    return (version or "1.0.1")
end

function m:doDebugInfo()
    if "windows" == device.platform then
        gComm.BtnUtils.setButtonClick(self.btnMap["iconLogo"],handler(self,self.onBtnClick))
    end

    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sDis or
        gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sIOSInReview or
        gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        self.btnMap["txtVersionInfo"]:setVisible(false)
    else
        local info = (gGameConfig.debugServer[gGameConfig.CurServerIndex].sName or "")
        info = info .. "\nresVersion:" .. self:getLocalVersion()
        info = info .. "\nappVersion:" .. gComm.CallNativeMng.AppNative:getAppVersionName()
        self.btnMap["txtVersionInfo"]:setString(info)
        self.btnMap["txtVersionInfo"]:setVisible(true)
    end
end

function m:onRcvJoinRoom(msgTbl)
    gComm.UIUtils.removeLoadingTips()
    if msgTbl.m_errorCode ~= 0 then -- 2桌子不存在, 3已经在桌子里面, 4房间已经开始游戏了, 5人满,
        -- 进入房间失败
        local errorList = {
            [2] = ConfigTxtTip.GetConfigTxt("LTKey_0015"),
            [3] = ConfigTxtTip.GetConfigTxt("LTKey_0082"),
            [4] = ConfigTxtTip.GetConfigTxt("LTKey_0083"),
            [5] = ConfigTxtTip.GetConfigTxt("LTKey_0018"),
            [6] = "您已报名大奖赛，无法加入",
            [7] = "已加入金币赛",
            [8] = "此房间为金币场房间，无法手动加入",
            [100] = "亲友圈不存在",
            [101] = "非本亲友圈成员，不能加入",
        }
        local str = errorList[msgTbl.m_errorCode] or ("未知错误ErrorCode:" .. msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.GETIN_EVENT_JONIN, msgTbl)
    end
end

function m:revCreateRoom(msgTbl)
    dump(msgTbl,"m:revCreateRoom======")

    gComm.UIUtils.removeLoadingTips()

    local errorList = {
        [1]   = "提示房卡不足，请联系客服，rrah001",
        [2]   = "其他未知错误",
        [5]   = "没有空闲桌子",
        [6]   = "您已报名大奖赛，无法加入",--"已参加红包赛",
        [7]   = "已参加金币赛",
        [11]  = "亲友圈部长暂未保存快速创建方案，无法快速创建",
        [100] = "亲友圈不存在",
        [101] = "玩家不在亲友圈中",
        [103] = "亲友圈房卡不足",
        [104] = "当前用户再创建房间将超出当日房卡上限",
    }
    if msgTbl.m_errorCode == 0 then  --m_errorCode;//0-成功，1-房卡不够，2-其他未知错误 10 代开房成功

    elseif msgTbl.m_errorCode == 10 then
        -- 房卡不足提示
        UINoticeTips:create("代开房成功，房间号："..msgTbl.m_deskId,function()
            local agentRoomLayer = UIAgentRoom:create()
            cc.Director:getInstance():getRunningScene():addChild(agentRoomLayer, 10)
        end, function()
        end)
    else
        -- 创建失败
        local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end


function m:onEnter()
    log(self.__TAG,"onEnter")

    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_CREATE_ROOM, self, self.revCreateRoom)
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_JOIN_ROOM, self, self.onRcvJoinRoom)

    local btn = self.btnMap["nodeAnimFileGirl"]
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimLobbyGirlCheck.csb")
        btn:getParent():addChild(node1)
        node1:setPosition(cc.p(btn:getPosition()))
        animation1:gotoFrameAndPlay(0,true)
        btn:removeFromParent(true)
    else
        local action = cc.CSLoader:createTimeline("Csd/Animation/AnimLobbyGirl.csb")
        btn:runAction(action)
        action:gotoFrameAndPlay(0,true)
    end

    self:doDebugInfo()
end

function m:onExit()
    log(self.__TAG,"onExit")
    gComm.EventBus.unRegAllEvent(self)
    gt.socketClient:unRegisterMsgListenerByTarget(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end

function m:setShareAnimation( isShow )
    --local orbitCamera = cc.OrbitCamera:create(2, self.shareBtn:getContentSize().width / 2, 0, 0, -360, 0, 0)
    --cc.OrbitCamera:create(t, radius, deltaRadius, angleZ, deltaAngleZ, angleX, deltaAngleX)
    -- local delay = cc.DelayTime:create(2)
    -- local seq = cc.Sequence:create(orbitCamera,delay)
    -- local repeatForever = cc.RepeatForever:create(seq)
    -- self.shareBtn:stopAllActions()
    -- self.shareBtn:setPosition(self.shareOpt)
    -- self.shareBtn:runAction(repeatForever)
    -- cc.Sprite:createWithSpriteFrameName("raindrop/raindrop.png")
end

return m
