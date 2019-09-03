
local gComm = cc.exports.gComm

local MngPlaybackClassic = require("app.Game.UI.UIGame.PokerDDZ.MngPlaybackClassic")

local csbFile = "Csd/SubGame/PokerDDZ/UIPlaybackClassic.csb"
local m = class("UIPlaybackClassic", function()
    return cc.Layer:create()
end)

function m:ctor(replayData,gameType)
    -- 注册节点事件
    self:registerScriptHandler(handler(self, self.onNodeEvent))

    dump(replayData)
    -- 加载界面资源
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    self.rootNode = csbNode

    local Spr_bgNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_bg")
    local Spr_bg = gComm.UIUtils.seekNodeByName(Spr_bgNode, "bg_left")
    Spr_bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

    -- 桌号
    -- replayData.m_deskId

    -- 时间
    --replayData.m_time
    self.time_now = replayData.m_time
    log("----------nowtime---------",replayData.m_time,gameType)
    self.holdTime = 0
    self:updateCurrentTime()

    -- 玩家id
    -- replayData.m_userid

    -- 玩家昵称
    -- replayData.m_nike

    -- 玩家性别
    -- replayData.m_sex

    -- 玩家积分
    -- replayData.m_score

    -- 玩家头像
    -- replayData.m_imageUrl

    -- 1号位置牌
    -- replayData.m_card0

    -- 2号位置牌
    -- replayData.m_card1

    -- 3号位置牌
    -- replayData.m_card2

    -- 如果是四川斗地主显示标记
    self.gameType = gameType
    if  gameType == 1 then
    end

    -- 玩家操作记录
    self.replayStepsData = replayData.m_oper
    -- 容错处理，默认1
    self.playerSeatIdx = 2
    self.playerFixDispSeat = 3

    for seatIdx, uid in ipairs(replayData.m_userid) do
        if cc.exports.gData.ModleGlobal.userID == uid then
            self.playerSeatIdx = seatIdx
            -- 逻辑座位和显示座位偏移量(从0编号开始)
            local seatOffset = (self.playerFixDispSeat - 1) - (seatIdx - 1)
            self.seatOffset = seatOffset
            break
        end
    end



    local paramTbl = {}
    paramTbl.roomID = replayData.m_deskId
    paramTbl.playerSeatIdx = self.playerSeatIdx
    paramTbl.playerFixDispSeat = self.playerFixDispSeat
    paramTbl.m_playtype = replayData.m_playtype

    paramTbl.m_lastScore = replayData.m_score
    
    self.playManager = MngPlaybackClassic:create(self.rootNode, paramTbl, self.gameType )

    self.m_text_progress = gComm.UIUtils.seekNodeByName(csbNode,"Text_progress")
    self.m_text_progress:setLocalZOrder(10000)
    self:initRoomPlayersData(replayData)
    self.replayData = replayData

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

    --前进
    local nextBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_next")
    gComm.BtnUtils.setButtonClick(nextBtn,function ()
        self:nextRound()
    end)

    --后退
    local preBtn = gComm.UIUtils.seekNodeByName(optBtnsSpr, "Btn_pre")
    gComm.BtnUtils.setButtonClick(preBtn,function ()
        self:preRound()
    end)

    -- 快进或者快退的步数
    self.quickStepNum   = 1
    -- 点击快进/快退开始的时间
    self.quickStartTime = 0

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

        display.removeSpriteFrames("Texture/CardsPoker.plist","Texture/CardsPoker.png")
    end
end

function m:onTouchBegan(touch, event)
    return true
end

-- 快推的话,原理是将牌恢复到最初始状态
-- 然后快速行进到当前状态
function m:preRound()
    if self.curReplayStep <= 1 then
        return
    end

    self.quickStartTime = os.time()

    -- 计算回退到何步骤
    local wihldReplayStep = self.curReplayStep - self.quickStepNum - 1
    if wihldReplayStep < 0 then
        wihldReplayStep = 0
    end

    log("快退==============",self.curReplayStep,self.quickStepNum)

    -- 清理桌面上的牌
    self.playManager:cleanMjFormLayer()
    self:initRoomPlayersData(self.replayData)
    -- 步数设置为1
    self.curReplayStep = 1

    for i = 1,wihldReplayStep do
        if not self.isReplayFinish then
            self:doAction( self.curReplayStep, true, true )
        end
    end

end

-- 快速回合播放
function m:nextRound()
    self.quickStartTime = os.time()

    for i = 1,self.quickStepNum do
        if not self.isReplayFinish then
            self:doAction( self.curReplayStep, true )
        end
    end
end

function m:doAction(curReplayStep, isQuick, isPre )
    local replayStepData = self.replayStepsData[self.curReplayStep]
    if replayStepData then
        local seatIdx = replayStepData[1] + 1
        local optType = replayStepData[2]
        local card = replayStepData[3]

        local isLast = (#self.replayStepsData == self.curReplayStep and {true} or {false})[1]

        self.playManager:playOperation(seatIdx,optType, card, isPre,self.curReplayStep,isLast)
        if isPre == nil then
            self.playManager:playSound(seatIdx, optType, card)
        end
        

        self.curReplayStep = self.curReplayStep + 1
        
        if self.curReplayStep > #self.replayStepsData then
            self.isReplayFinish = true
            self.curReplayStep = #self.replayStepsData
        end
    end

    self:updateProgress()

    -- 23(拿底牌) 和 98 倍数都不要占用时间
    if optType == 23 or optType == 98 then
        self:doAction(self.curReplayStep)
    end
end

function m:updateProgress()
    local amount = #self.replayStepsData
    if amount == nil or self.curReplayStep == nil then
        return false
    end

    if self.curReplayStep > amount then
        self.curReplayStep = amount
    end

    local number = string.format("%0" .. string.len(amount) .. "d", self.curReplayStep)
    self.m_text_progress:setString("进度:" .. number .. "/" .. amount)

end


function m:update(delta)
    if self.isPause or self.isReplayFinish then
        return
    end

    if os.time() - self.quickStartTime < 2 then-- 如果已经有2s没有触摸快进/快退按钮了,那么可以播放自动录像了
        return
    end

    self.holdTime = self.holdTime + delta
    self:updateCurrentTime()

    self.showDelayTime = self.showDelayTime + delta
    if self.showDelayTime > 1.5 then
        self.showDelayTime = 0

        self:doAction(self.curReplayStep)
    end
end

function m:initRoomPlayersData(replayData)
    for seatIdx, uid in ipairs(replayData.m_userid) do

        if seatIdx <= self.playerFixDispSeat then
            local roomPlayer = {}
            roomPlayer.seatIdx = seatIdx
            roomPlayer.uid = uid
            roomPlayer.nickname = replayData.m_nike[seatIdx]
            roomPlayer.headURL = replayData.m_imageUrl[seatIdx]
            roomPlayer.sex = replayData.m_sex[seatIdx]
            roomPlayer.score = replayData.m_score[seatIdx]

            self.playManager:roomAddPlayer(roomPlayer)

            -- 添加持有牌
            if self.gameType == 1 then
                for _, v in ipairs(replayData["m_card" .. (seatIdx - 1)]) do
                    -- 如果是四川斗地主添加牌的背面
                    self.playManager:addOppositeMjTileToPlayer(roomPlayer,v)
                end

                self.playManager:sortHoldMjTiles(roomPlayer,true)
            else
                for _, v in ipairs(replayData["m_card" .. (seatIdx - 1)]) do
                    -- 如果是四川斗地主添加牌的背面
                    self.playManager:addMjTile(roomPlayer, v)
                end

                self.playManager:sortHoldMjTiles(roomPlayer)    
            end
        end

    end

    self.curReplayStep = 1
    self.showDelayTime = 2
    self.isReplayFinish = false
    self:updateProgress()
end

function m:setPause(isPause)
    self.isPause = isPause

    self.pauseBtn:setVisible(not isPause)
    self.playBtn:setVisible(isPause)
end

function m:updateCurrentTime()
    local presentTime = math.ceil(self.time_now+self.holdTime)

    local curTimeStr = os.date("%X", presentTime)
    local timeSections = string.split(curTimeStr, ":")
    local timeLabel = gComm.UIUtils.seekNodeByName(self, "Label_time")
    --timeLabel:setVisible(false)

    -- 时:分
    timeLabel:setString(string.format("%s:%s", timeSections[1], timeSections[2]))
end

return m