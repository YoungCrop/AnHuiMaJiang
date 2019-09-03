
local gComm = cc.exports.gComm
local DefineHuPai = require("app.Common.Config.DefineHuPai")
local DefineRule = require("app.Common.Config.DefineRule")
local ItemSettlementOneRound = require("app.Game.UI.UIGame.UIGameComm.ItemSettlementOneRound")
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/IRoom/UISettlementOneRound.csb"

local n = {}
local m = class("UISettlementOneRound",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        msgTbl        = args.msgTbl,
        roomPlayers   = args.roomPlayers,
        playerSeatIdx = args.playerSeatIdx,
        isLastRound   = args.isLastRound,
        playmes       = args.playmes,
        roomType      = args.roomType,
    }
    self:printArgs()
    self:initUI()
end

function m:printArgs()
    dump(self.param,self.__TAG .. "self.param")
end

function m:initUI()
    self.nodeMap = {}
    self:loadCSB()
end
n.nodeMap = {
    txtWanFa   = "txtWanFa",
    imgTitle   = "imgTitle",
    txtRoomID  = "txtRoomID",
    txtTime    = "txtTime",
    txtJuShu   = "txtJuShu",
    lvItem     = "lvItem",
}
n.btnMap = {
    btnShare     = "btnShare",
    btnNext      = "btnNext",
    btnExitRoom  = "btnExitRoom",
}
function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.center)
    csbNode:addTo(self)
    self.rootNode = csbNode

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.nodeMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end
    local description = ""
    for i,v in ipairs(self.param.playmes.m_playtype) do
        if i%5 == 0 then
            description = description .. "\n"
        end
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            description = description .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            description = description .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end
    self.nodeMap["txtWanFa"]:setString(description)

    local img = "settlement_title_tie.png"
    if self.param.msgTbl.m_result == 2 then
        img = "settlement_title_tie.png"
    else
        local winIndex = self.param.msgTbl.m_win[self.param.playerSeatIdx]
        if winIndex == 1 or winIndex == 2 then
            img = "settlement_title_win.png"
        else
            img = "settlement_title_fail.png"
        end
    end
    -- self.nodeMap["imgTitle"]:setSpriteFrame("Image/IRoom/UISettlement/" .. img)

    gComm.SpriteUtils.setSpriteFrameEx(self.nodeMap["imgTitle"],"Image/IRoom/UISettlement/" .. img,"Texture/IRoom/UISettlement.plist")

    local str = "房间:" .. self.param.playmes.roomId .. "  " .. self.param.playmes.jushu
    self.nodeMap["txtJuShu"]:setString(str)
    self.nodeMap["txtRoomID"]:setVisible(false)

    local time = os.date("%x") .. " ".. os.date("%X")
    self.nodeMap["txtTime"]:setString(time)
    self:handleData()

    if cc.exports.gGameConfig.isiOSAppInReview then
        self.btnMap["btnShare"]:setVisible(false)
    end

    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.nodeMap["btnExitRoom"]:setVisible(true)
        self.nodeMap["btnNext"]:setTitleText("再来一局")
    else
        self.nodeMap["btnExitRoom"]:setVisible(false)
        if self.param.isLastRound then
            -- 结束
            self.nodeMap["btnNext"]:setTitleText("结束")
        end
    end
end

function m:handleData()
    local txtHuFlag = {
        [1] = {"自摸",true},
        [2] = {"接炮",true},
        [3] = {"点炮",false},
    }
    local isZiMe = false
    for i = 1, #self.param.roomPlayers do
        if self.param.msgTbl.m_win[i] == 1 then
            isZiMe = true
        end
    end

    for i = 1, #self.param.roomPlayers do
        local roomPlayer = self.param.roomPlayers[i]
        local data = {}
        data.nickname = roomPlayer.nickname
        data.uid = roomPlayer.uid
        data.isZhuang = self.param.msgTbl.m_zhuangPos and self.param.msgTbl.m_zhuangPos + 1 == i
        data.isTing = self.param.msgTbl.m_isTingState and self.param.msgTbl.m_isTingState[i]
        if txtHuFlag[self.param.msgTbl.m_win[i]] then
            data.txtHuFlag = txtHuFlag[self.param.msgTbl.m_win[i]][1]
            data.isWin = txtHuFlag[self.param.msgTbl.m_win[i]][2]
        else
            data.txtHuFlag = ""
            data.isWin = false
        end
        data.score = self.param.msgTbl.m_scoreSum[i]

        local txtHuType = ""
        for n = 1, #self.param.msgTbl["m_huScore" .. i] do
            local huTypeIndex = self.param.msgTbl["m_huScore" .. i][n][1]
            if huTypeIndex == DefineHuPai.huTpye.HU_HUAIBEI_RATIO then
                txtHuType = txtHuType .. self.param.msgTbl["m_huScore" .. i][n][2]
            elseif huTypeIndex >= DefineHuPai.huTpye.HU_SHISANBUKAO_X and huTypeIndex <= DefineHuPai.huTpye.HU_GANGSHANGPAO_X then
                txtHuType = txtHuType  .. "*" .. DefineHuPai.huTpyeStr[huTypeIndex] .. self.param.msgTbl["m_huScore" .. i][n][2]
            else
                local score = math.abs(self.param.msgTbl["m_huScore" .. i][n][2])
                if self.param.msgTbl["m_huScore" .. i][n][2] > 0 then
                    txtHuType = txtHuType  .. "+" .. DefineHuPai.huTpyeStr[huTypeIndex] .. score
                else
                    txtHuType = txtHuType  .. "-" .. DefineHuPai.huTpyeStr[huTypeIndex] .. score
                end
            end
        end
        data.txtHuType = txtHuType

        --持有牌
        data.m_holdmj = self.param.msgTbl["array" .. (i - 1)]
        --吃
        data.m_ccards = self.param.msgTbl["m_ccards" .. (i - 1)]
        --碰
        data.m_pcards = self.param.msgTbl["m_pcards" .. (i - 1)]
        --明杠
        data.m_mcards = self.param.msgTbl["m_mcards" .. (i - 1)]
        --暗杠
        data.m_acards = self.param.msgTbl["m_acards" .. (i - 1)]

        --胡牌
        data.m_hucards = self.param.msgTbl.m_hucards
        data.m_win = self.param.msgTbl.m_win
        data.itemIndex = i

        --花牌
        data.m_huaCards = self.param.msgTbl["m_huaCards" .. (i - 1)]
        -- local num = math.random(1,9)
        -- for i=1,num do
        --     local da = {5,math.random(1,3)}
        --     table.insert(data.m_huaCards,da)
        -- end


        local cell = ItemSettlementOneRound:create(data)
        local layout = ccui.Layout:create()
        layout:setTouchEnabled(true)
        layout:setContentSize(cell:getContentSize())
        dump(cell:getContentSize(),"===cell:getContentSize()===")
        layout:addChild(cell)
        self.nodeMap["lvItem"]:pushBackCustomItem(layout)

        --玩家的分数更新
        roomPlayer.score = self.param.msgTbl.m_score[i]
    end

end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnShare then
        _sender:setEnabled(false)
        self:screenshotShareToWX()

    elseif s_name == n.btnMap.btnNext then
        if self.param.roomType == DefineRule.RoomType.CoinRoom then
            -- gComm.EventBus.dispatchEvent(EventCmdID.EventType.NEXTONEGAME_EVENT)
            require("app.Common.NetMng.NetCoinGameMng").joinCoinGameNext()
        else
            if self.param.isLastRound then
                gComm.EventBus.dispatchEvent(EventCmdID.EventType.SHOW_FINALREPORT)
            else
                gComm.EventBus.dispatchEvent(EventCmdID.EventType.NEXTONEGAME_EVENT)
            end
            self:removeFromParent()
        end
    elseif s_name == n.btnMap.btnExitRoom then
        local args = {
            isShowCoinMain = true,
        }
        require("app.Common.NetMng.NetCoinGameMng").coinReturn()
        require("app.Game.Scene.SceneManager").goSceneLobby(args)
    end
end

function m:screenshotShareToWX()
    local screenshotFileName = string.format("wx-%s.jpg", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
    gComm.UIUtils.screenshot(screenshotFileName)

    self.shareImgFilePath = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName
    self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
end

function m:update()
    if self.shareImgFilePath and io.exists(self.shareImgFilePath) then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
        self.scheduleHandler = nil
        self.nodeMap["btnShare"]:setEnabled(true)

        gComm.CallNativeMng:shareImage(gComm.CallNativeMng.shareType.WeiXin,self.shareImgFilePath)
        self.shareImgFilePath = nil
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
    if self.scheduleHandler then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end

return m
