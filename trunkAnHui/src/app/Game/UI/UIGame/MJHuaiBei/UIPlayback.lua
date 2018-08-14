
local gComm = cc.exports.gComm
local MngPlayback = require("app.Game.UI.UIGame.MJHuaiBei.MngPlayback")

local DecisionType = {

    -- 接炮胡
    TAKE_CANNON_WIN             = 1,
    -- 自摸胡
    SELF_DRAWN_WIN              = 2,
    -- 明杠
    BRIGHT_BAR                  = 3,
    -- 暗杠
    DARK_BAR                    = 4,
    -- 碰
    PUNG                        = 5,
    -- 吃
    EAT                         = 6,
    --眀补
    BRIGHT_BU                   = 7,
    --暗补
    DARK_BU                     = 8,
    --过
    GUO                         = 9,
    --听
    TING                        = 10
}

local ROOM_TYPE_CHANGSHA = 3

local m = class("UIPlayback", gComm.UIMaskLayer)

local csbFile = "Csd/SubGame/MJHuaiBei/UIPlayback.csb"
function m:ctor(replayData)
    m.super.ctor(self)
    dump(replayData,"=m:ctor(replayData)=")

    -- 注册节点事件
    self:registerScriptHandler(handler(self, self.onNodeEvent))

    self.replayStepsData = replayData.m_oper
    self.replayData = replayData

    -- 加载界面资源
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    self.rootNode = csbNode

    local Spr_bg = gComm.UIUtils.seekNodeByName(csbNode, "mahjong_table")
    Spr_bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))
    
    self.playType = replayData.m_playtype
    self.gameID = replayData.m_gameID
    
    local roundStateNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_roundState")
    local remainTilesLabel = gComm.UIUtils.seekNodeByName(roundStateNode, "Label_remainRounds")
    remainTilesLabel:setString(string.format("%d/%d", (replayData.m_curCircle + 1), replayData.m_maxCircle))

    -- 容错处理，默认1
    self.playerSeatIdx = 1
    for seatIdx, uid in ipairs(replayData.m_userid) do
        if cc.exports.gData.ModleGlobal.userID == uid then
            self.playerSeatIdx = seatIdx
            break
        end
    end

    self.m_playMode = replayData.m_playMode


    if not replayData.m_gameID then
        replayData.m_gameID = 1
    end

    local paramTbl = {}
    paramTbl.roomID = replayData.m_deskId
    paramTbl.playType = replayData.m_playtype
    paramTbl.playerSeatIdx = self.playerSeatIdx
    paramTbl.m_flag = replayData.m_flag
    paramTbl.m_zhuang = replayData.m_zhuang
    paramTbl.m_playerNum = replayData.m_playerNum
    paramTbl.m_gameID = replayData.m_gameID
    self.Manager = MngPlayback:create(self.rootNode, paramTbl)

    self:initRoomPlayersData(replayData)

    -- 更新打牌时间
    -- self.time_now = 1469700778
    self.time_now = replayData.m_time --获取当前时间
    log("更新打牌时间")
    self.holdTime = 0
    self:updateCurrentTime()

    self.isPause = false
    local optBtnsSpr = gComm.UIUtils.seekNodeByName(csbNode, "Spr_optBtns")
    -- 播放按键
    local playBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_play")
    playBtn:setVisible(false)
    self.playBtn = playBtn
    -- 暂停
    local pauseBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_pause")
    self.pauseBtn = pauseBtn
    gComm.BtnUtils.setButtonClick(playBtn, function()
        self:setPause(false)
    end)
    gComm.BtnUtils.setButtonClick(pauseBtn, function()
        self:setPause(true)
    end)
    -- 退出
    local exitBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_exit")
    gComm.BtnUtils.setButtonClick(exitBtn, function()
        self:removeFromParent()
    end)
    -- 后退
    local preBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_pre")
    if preBtn then
        gComm.BtnUtils.setButtonClick(preBtn, function()
            self:preRound(4)
        end)
    end
    -- 前进
    local nextBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_next")
    if nextBtn then
        gComm.BtnUtils.setButtonClick(nextBtn, function()
            self:nextRound(4)
        end)
    end

    self.txtProgress = gComm.UIUtils.seekNodeByName(self.rootNode, "txtProgress")

    self:changeGameBg()
end


function m:changeGameBg()

    local bgIndex = cc.UserDefault:getInstance():getIntegerForKey("bgselect", 2)
    local mahjong_table = gComm.UIUtils.seekNodeByName(self.rootNode, "mahjong_table")
    local gameBgPic = "Image/BigImg/game_bg"
    gameBgPic = gameBgPic..bgIndex..".png"
    mahjong_table:initWithFile(gameBgPic)
end

function m:onNodeEvent(eventName)
    if "enter" == eventName then
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

        -- 逻辑更新定时器
        self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
    elseif "exit" == eventName then

        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:removeEventListenersForTarget(self)

        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)
    end
end

function m:onTouchBegan(touch, event)
    return true
end

function m:preRound(num)
    if self.isPause or self.isReplayFinish then
        return
    end

    
    local curShowNum = self.curReplayStep - num
    if self.curReplayStep <= 4 then
        self.isPause = false
        return
    end
    self.Manager:reInit()   
    self.Manager:initUI()
    self:initRoomPlayersData(self.replayData, false)

    self.curReplayStep = 1
    for i=1,curShowNum do
        self.holdTime = self.holdTime + 1
        self:updateCurrentTime()

        self.showDelayTime = 0

        log("curReplayStep=----" .. self.curReplayStep)

        local replayStepData = self.replayStepsData[self.curReplayStep]

        -- -- 如果展示杠后的两张牌则需要3秒
        -- if replayStepData[2] == 18 then
        --  self.showDelayTime = -2
        -- end

        local seatIdx = replayStepData[1] + 1
        local optType = replayStepData[2]
        local mjColor = replayStepData[3][1][1]
        local mjNumber = replayStepData[3][1][2]

        if self.playType ~= ROOM_TYPE_CHANGSHA then
            if optType == 11 then -- 明补自己
                optType = 4
            elseif optType == 12 then -- 明补别人
                optType = 6
            elseif optType == 13 then -- 暗补
                optType = 3
            end
        end

        self.Manager:setTurnSeatSign(seatIdx)
        if optType == 1 then
            -- 摸牌
            self.Manager:drawMjTile(seatIdx, mjColor, mjNumber)
        elseif optType == 2 then
            -- 出牌
            self.Manager:playOutMjTileQuick(seatIdx, mjColor, mjNumber)
        elseif optType == 3 or optType == 19 then
            -- 暗杠
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)
        elseif optType == 4 then
            -- 自摸明杠
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)
        elseif optType == 5 then
            -- 碰
            self.Manager:addMjTilePung(seatIdx, mjColor, mjNumber)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 6 or optType == 18 then
            -- 别人打的牌,自己可以明杠之
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 7 then
            -- 接炮胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TAKE_CANNON_WIN)
        elseif optType == 8 then
            -- 自摸胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.SELF_DRAWN_WIN)
        elseif optType == 9 then
            -- 流局
        elseif optType == 10 then
            --吃
            local eatGroup = {}
            table.insert(eatGroup,{replayStepData[3][1][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][2][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][3][2], 1, replayStepData[3][1][1]})

            --table.sort(eatGroup, function(a, b)
                --return a[1] < b[1]
            --end)

            self.Manager:addMjTileChi(seatIdx,eatGroup)
            -- self.Manager:pungBarReorderMjTiles(seatIdx, replayStepData[3][1][1], eatGroup)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 11 then
            -- 明补自己
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)
        elseif optType == 12 then
            -- 明补他人
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)
            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 13 then
            -- 暗补
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)
        elseif optType == 21 then 
            --思考决策
        elseif optType == 20 then 
            -- 听
            self.Manager:playOutMjTile(seatIdx, mjColor, mjNumber)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TING)
            self.Manager:showtTingSign(seatIdx)
        elseif optType == 70 then 
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.GUO)
        elseif optType >= 14 and optType <= 17 then
            --特殊杠    
            local tsBarArray = {}
            local function checkSameType(card)
                for i,v in ipairs(tsBarArray) do
                    if v[1] == card[1] and v[2] == card[2] then
                        return i
                    end
                end
                return false
            end
            local tmpTbl = self:copyTab(replayStepData[3])
            for i,v in ipairs(tmpTbl) do
                local key = checkSameType(v)
                if key then
                    tsBarArray[key][3] = tsBarArray[key][3]+1
                else
                    table.insert(v,1)
                    table.insert(tsBarArray,v)
                end
            end
            self.Manager:addMjTileSpecialBar(seatIdx,tsBarArray,optType-13)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType >= 40 and optType <= 43 then
            --特殊补杠
            self.Manager:changeSpecialBar(seatIdx,replayStepData[3],optType-39)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType == 44 then
        end
        
        self.curReplayStep = self.curReplayStep + 1
        
        if self.curReplayStep > #self.replayStepsData then
            self.isReplayFinish = true
            self.curReplayStep = #self.replayStepsData
        end

        self.txtProgress:setString(self.curReplayStep.." / "..(#self.replayData.m_oper))

    end
end

-- 快速回合播放
function m:nextRound( round )
    if self.isPause or self.isReplayFinish then
        return
    end
    for i=1,1 do
        self.showDelayTime = 0

        local replayStepData = self.replayStepsData[self.curReplayStep]

        local seatIdx = replayStepData[1] + 1
        local optType = replayStepData[2]
        local mjColor = replayStepData[3][1][1]
        local mjNumber = replayStepData[3][1][2]

        if self.playType ~= ROOM_TYPE_CHANGSHA then
            if optType == 11 then -- 明补自己
                optType = 4
            elseif optType == 12 then -- 明补别人
                optType = 6
            elseif optType == 13 then -- 暗补
                optType = 3
            end
        end

        self.Manager:setTurnSeatSign(seatIdx)
        if optType == 1 then
            -- 摸牌
            self.Manager:drawMjTile(seatIdx, mjColor, mjNumber)
        elseif optType == 2 then
            -- 出牌
            self.Manager:playOutMjTileQuick(seatIdx, mjColor, mjNumber)
        elseif optType == 3 or optType == 19 then
            -- 暗杠
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)
        elseif optType == 4 then
            -- 自摸明杠
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)
        elseif optType == 5 then
            -- 碰
            self.Manager:addMjTilePung(seatIdx, mjColor, mjNumber)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 6 or optType == 18 then
            -- 别人打的牌,自己可以明杠之
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 7 then
            -- 接炮胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TAKE_CANNON_WIN)
        elseif optType == 8 then
            -- 自摸胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.SELF_DRAWN_WIN)
        elseif optType == 9 then
            -- 流局
        elseif optType == 10 then
            --吃
            local eatGroup = {}
            table.insert(eatGroup,{replayStepData[3][1][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][2][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][3][2], 1, replayStepData[3][1][1]})

            --table.sort(eatGroup, function(a, b)
                --return a[1] < b[1]
            --end)

            self.Manager:pungBarReorderMjTiles(seatIdx, replayStepData[3][1][1], eatGroup)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 11 then
            -- 明补自己
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)
        elseif optType == 12 then
            -- 明补他人
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)
            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 13 then
            -- 暗补
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)
        elseif optType == 21 then 
            --思考决策
        elseif optType == 20 then 
            -- 听
            self.Manager:playOutMjTile(seatIdx, mjColor, mjNumber)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TING)
            self.Manager:showtTingSign(seatIdx)
        elseif optType == 70 then 
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.GUO)
        elseif optType >= 14 and optType <= 17 then
            --特殊杠    
            local tsBarArray = {}
            local function checkSameType(card)
                for i,v in ipairs(tsBarArray) do
                    if v[1] == card[1] and v[2] == card[2] then
                        return i
                    end
                end
                return false
            end
            local tmpTbl = self:copyTab(replayStepData[3])
            for i,v in ipairs(tmpTbl) do
                local key = checkSameType(v)
                if key then
                    tsBarArray[key][3] = tsBarArray[key][3]+1
                else
                    table.insert(v,1)
                    table.insert(tsBarArray,v)
                end
            end
            self.Manager:addMjTileSpecialBar(seatIdx,tsBarArray,optType-13)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType >= 40 and optType <= 43 then
            --特殊补杠
            self.Manager:changeSpecialBar(seatIdx,replayStepData[3],optType-39)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType == 44 then
        end

        self.curReplayStep = self.curReplayStep + 1

        

        if self.curReplayStep > #self.replayStepsData then
            self.isReplayFinish = true
            self.curReplayStep  = #self.replayStepsData
        end

        self.txtProgress:setString(self.curReplayStep.." / "..(#self.replayData.m_oper))
    end
end

function m:update(delta)
    if self.isPause or self.isReplayFinish then
        return
    end

    self.holdTime = self.holdTime + delta
    self:updateCurrentTime()

    self.showDelayTime = self.showDelayTime + delta
    if self.showDelayTime > 1.5 then

        dump("m:update" .. self.curReplayStep)
        
        self.showDelayTime = 0

        local replayStepData = self.replayStepsData[self.curReplayStep]

        self.txtProgress:setString(self.curReplayStep.." / "..(#self.replayData.m_oper))

        -- 如果展示杠后的两张牌则需要3秒
        if replayStepData[2] == 18 then
            self.showDelayTime = -2
        end

        local seatIdx = replayStepData[1] + 1
        local optType = replayStepData[2]
        local mjColor = replayStepData[3][1][1]
        local mjNumber = replayStepData[3][1][2]

        if self.playType ~= ROOM_TYPE_CHANGSHA then
            if optType == 11 then -- 明补自己
                optType = 4
            elseif optType == 12 then -- 明补别人
                optType = 6
            elseif optType == 13 then -- 暗补
                optType = 3
            end
        end

        self.Manager:setTurnSeatSign(seatIdx)
        if optType == 1 then
            -- 摸牌
            self.Manager:drawMjTile(seatIdx, mjColor, mjNumber)
        elseif optType == 2 then
            -- 出牌
            self.Manager:playOutMjTile(seatIdx, mjColor, mjNumber)
        elseif optType == 3 or optType == 19 then
            -- 暗杠
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)

            self.Manager:showDecisionAnimation(seatIdx, DecisionType.DARK_BAR)
        elseif optType == 4 then
            -- 自摸明杠
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)

            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType == 5 then
            -- 碰
            self.Manager:addMjTilePung(seatIdx, mjColor, mjNumber)

            self.Manager:showDecisionAnimation(seatIdx, DecisionType.PUNG)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 6 or optType == 18 then
            -- 别人打的牌,自己可以明杠之
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)

            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 7 then
            -- 接炮胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TAKE_CANNON_WIN)
        elseif optType == 8 then
            -- 自摸胡
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.SELF_DRAWN_WIN)
        elseif optType == 9 then
            -- 流局
        elseif optType == 10 then
            --吃
            local eatGroup = {}
            table.insert(eatGroup,{replayStepData[3][1][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][2][2], 0, replayStepData[3][1][1]})
            table.insert(eatGroup,{replayStepData[3][3][2], 1, replayStepData[3][1][1]})

            --table.sort(eatGroup, function(a, b)
                --return a[1] < b[1]
            --end)

            self.Manager:pungBarReorderMjTiles(seatIdx, replayStepData[3][1][1], eatGroup)

            self.Manager:showDecisionAnimation(seatIdx, DecisionType.EAT)

            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 11 then
            -- 明补自己
            self.Manager:changePungToBrightBar(seatIdx, mjColor, mjNumber)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BU)
        elseif optType == 12 then
            -- 明补他人
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, true)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BU)
            self.Manager:removePrePlayerOutMjTile()
        elseif optType == 13 then
            -- 暗补
            self.Manager:addMjTileBar(seatIdx, mjColor, mjNumber, false)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.DARK_BU)
        elseif optType == 21 then 
            --思考决策
        elseif optType == 20 then 
            -- 听
            self.Manager:playOutMjTile(seatIdx, mjColor, mjNumber)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.TING)
            self.Manager:showtTingSign(seatIdx)
        elseif optType == 70 then 
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.GUO)
        elseif optType >= 14 and optType <= 17 then
            --特殊杠    
            local tsBarArray = {}
            local function checkSameType(card)
                for i,v in ipairs(tsBarArray) do
                    if v[1] == card[1] and v[2] == card[2] then
                        return i
                    end
                end
                return false
            end
            local tmpTbl = self:copyTab(replayStepData[3])
            for i,v in ipairs(tmpTbl) do
                local key = checkSameType(v)
                if key then
                    tsBarArray[key][3] = tsBarArray[key][3]+1
                else
                    table.insert(v,1)
                    table.insert(tsBarArray,v)
                end
            end
            self.Manager:addMjTileSpecialBar(seatIdx,tsBarArray,optType-13)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType >= 40 and optType <= 43 then
            --特殊补杠
            self.Manager:changeSpecialBar(seatIdx,replayStepData[3],optType-39)
            self.Manager:showDecisionAnimation(seatIdx, DecisionType.BRIGHT_BAR)
        elseif optType == 44 then
        end

        self.curReplayStep = self.curReplayStep + 1
        if self.curReplayStep > #self.replayStepsData then
            self.isReplayFinish = true
        end
    end
end


--初始化持有牌
function m:initRoomPlayersData(replayData)
    local zuoLaPaoList = string.split(replayData.m_strExtData,";")
    for seatIdx, uid in ipairs(replayData.m_userid) do 
        local roomPlayer = {}
        roomPlayer.seatIdx = seatIdx
        roomPlayer.uid = uid
        roomPlayer.nickname = replayData.m_nike[seatIdx]
        roomPlayer.headURL = replayData.m_imageUrl[seatIdx]
        roomPlayer.sex = replayData.m_sex[seatIdx]
        roomPlayer.score = replayData.m_score[seatIdx]
        roomPlayer.zuoLaPao = zuoLaPaoList[seatIdx] or ""
        

        self.Manager:roomAddPlayer(roomPlayer)

        -- 添加持有牌
        for _, v in ipairs(replayData["m_card" .. (seatIdx - 1)]) do
            self.Manager:addMjTile(roomPlayer, v[1], v[2])
        end
        self.Manager:sortHoldMjTiles(roomPlayer)
    end

    self.curReplayStep = 1
    self.showDelayTime = 2
    self.isReplayFinish = false
end

function m:setPause(isPause)
    self.isPause = isPause

    self.pauseBtn:setVisible(not isPause)
    self.playBtn:setVisible(isPause)
end

--更新时间
function m:updateCurrentTime()
    local presentTime = math.ceil(self.time_now + self.holdTime)

    local curTimeStr = os.date("%X", presentTime)

    local timeSections = string.split(curTimeStr, ":")


    local timeLabel = gComm.UIUtils.seekNodeByName(self, "Label_time")
    
    -- 时:分
    timeLabel:setString(string.format("%s:%s", timeSections[1], timeSections[2]))
end
function m:copyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
end


return m