
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngMJAnQin = require("app.Common.NetMng.NetMngMJAnQin")
local DefineRule = require("app.Common.Config.DefineRule")
local NetCoinGameMng = require("app.Common.NetMng.NetCoinGameMng")

local csbFile = "Csd/SubGame/PokerDDZ/UISettlementOneRound.csb"
local n = {}
local m = class("UISettlementOneRound", gComm.UIMaskLayer)

n.nodeMap = {
    spriteTitleLose = "spriteTitleLose",
    spriteTitleWin = "spriteTitleWin",
}
n.btnMap = {
    btnNext      = "btnNext",
    btnExitRoom  = "btnExitRoom",
    btnAgain     = "btnAgain",
}

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        msgTbl        = args.msgTbl,
        roomPlayers   = args.roomPlayers,
        playerSeatIdx = args.playerSeatIdx,
        isLastRound   = args.isLastRound,
        mDizhuPos     = args.mDizhuPos,
        roomType      = args.roomType,
    }
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center.x,display.center.y)
    self:addChild(csbNode)

    self.nodeMap = {}
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.nodeMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end

    self.nodeMap["spriteTitleWin"]:setVisible(false)
    self.nodeMap["spriteTitleLose"]:setVisible(false)
    local mScore = self.param.msgTbl.m_score[self.param.playerSeatIdx]
    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        mScore = self.param.msgTbl.m_scoreSum[self.param.playerSeatIdx]
    end

    if mScore > 0 then--赢的标题
        self.nodeMap["spriteTitleWin"]:setVisible(true)
    else--输的标题
        self.nodeMap["spriteTitleLose"]:setVisible(true)
    end

    for seatIdx, roomPlayer in ipairs(self.param.roomPlayers) do
        local playerReportNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_playerReport_" .. seatIdx)
        -- 昵称
        -- local nicknameLabel = gComm.UIUtils.seekNodeByName(playerReportNode, "Label_nickname")
        -- nicknameLabel:setString(gComm.StringUtils.GetShortName(roomPlayer.nickname))
        -- 积分
        local scoreLabel = gComm.UIUtils.seekNodeByName(playerReportNode, "Label_score")
        scoreLabel:setString(tostring(self.param.msgTbl.m_score[seatIdx]))
        -- 更新积分
        roomPlayer.score = roomPlayer.score + self.param.msgTbl.m_score[seatIdx]
        roomPlayer.scoreLabel:setString(tostring(roomPlayer.score))

        if self.param.roomType == DefineRule.RoomType.CoinRoom then
            scoreLabel:setString(self.param.msgTbl.m_scoreSum[seatIdx])
            roomPlayer.score = self.param.msgTbl.m_score[seatIdx]
            roomPlayer.scoreLabel:setString(roomPlayer.score)
        end
    end

    for i = 1 ,3 do
        local playerNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_playerReport_".. i)
        local scorelabel = gComm.UIUtils.seekNodeByName(playerNode,"Label_score")
        scorelabel:setString(self.param.msgTbl.m_score[i])

        if self.param.roomType == DefineRule.RoomType.CoinRoom then
            scorelabel:setString(self.param.msgTbl.m_scoreSum[i])
        end

        local nicknamelabel = gComm.UIUtils.seekNodeByName(playerNode,"Label_nickname")
        nicknamelabel:setString(gComm.StringUtils.GetShortName(self.param.msgTbl.m_nike[i]))

        local bombenumlabel = gComm.UIUtils.seekNodeByName(playerNode,"Label_bombenum")
        bombenumlabel:setString(self.param.msgTbl.m_bomb[i])

        local sprFlagDiZhu = gComm.UIUtils.seekNodeByName(playerNode,"sprFlagDiZhu")
        if self.param.mDizhuPos then
            if self.param.mDizhuPos ~= i then
                sprFlagDiZhu:setVisible(false)
            else
                sprFlagDiZhu:setVisible(true)
            end
        else
            sprFlagDiZhu:setVisible(false)
        end
    end

    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.nodeMap["btnExitRoom"]:setVisible(true)
        self.nodeMap["btnAgain"]:setVisible(true)
        self.nodeMap["btnNext"]:setVisible(false)
    else
        self.nodeMap["btnExitRoom"]:setVisible(false)
        self.nodeMap["btnAgain"]:setVisible(false)
        self.nodeMap["btnNext"]:setVisible(true)
        if self.param.isLastRound then-- 结束
            local mjTileName = "Image/IRoom/CommomRoom/game_btn_gameover.png"
            self.nodeMap["btnNext"]:loadTextures(mjTileName,mjTileName,mjTileName,ccui.TextureResType.plistType)
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnNext then
        gComm.SoundEngine:playEffect("common/SpecOk", false, true)
        local m_pos = self.param.playerSeatIdx - 1
        local notLastRound = (not self.param.isLastRound)
        self:removeFromParent()
        if notLastRound then
            NetMngMJAnQin.sendReady(m_pos)
        else
            gComm.EventBus.dispatchEvent(EventCmdID.EventType.ZJH_ADD_FINALREPORT)
        end
    elseif s_name == n.btnMap.btnAgain then
        NetCoinGameMng.joinCoinGameNext()
        -- self:removeFromParent()
    elseif s_name == n.btnMap.btnExitRoom then
        local args = {
            isShowCoinMain = true,
        }
        require("app.Common.NetMng.NetCoinGameMng").coinReturn()
        require("app.Game.Scene.SceneManager").goSceneLobby(args)
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
