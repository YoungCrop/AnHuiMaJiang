
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local DefineRoom = require("app.Common.Config.DefineRoom")

local m = class("MngPlaybackClassic")

-- shuffle洗牌，cut切牌，deal发牌，sort理牌，draw摸牌，play打出，discard弃牌

local soundList = {
    "buyao", -- 不要0
    "pk_", -- 单张1
    "dui", -- 对子2
    "sange", -- 三个3
    "sandaiyi", -- 三带一4
    "sandaiyidui", -- 三带一对5
    "feiji", -- 飞机6
    "feiji", -- 飞机7
    "feiji", -- 飞机8
    "",
    "",
    "shunzi", -- 11 顺子
    "liandui", -- 12 连对
    "zhadan", -- 13 炸弹
    "zhadan", -- 13 炸弹

}

m.VIDEOOPER = {
    VIDEO_OPER_NULL             = 0,--不出;
    VIDEO_OPER_SINGLE           = 1,--单张;
    VIDEO_OPER_DOUNLE           = 2,--对子;
    VIDEO_OPER_THREE            = 3,--三个;
    VIDEO_OPER_THREE_ONE        = 4,--三带1张;
    VIDEO_OPER_THREE_TWO        = 5,--三带2张;
    VIDEO_OPER_THREE_LIST       = 6,--飞机;
    VIDEO_OPER_THREE_LIST_ONE   = 7,--飞机带单;
    VIDEO_OPER_THREE_LIST_TWO   = 8,--飞机带双;

    VIDEO_OPER_SINGLE_LIST      = 11,--单顺;
    VIDEO_OPER_DOUBLE_LIST      = 12,--连对;
    VIDEO_OPER_BOMB3            = 13,--带癞子的炸弹
    VIDEO_OPER_BOMB2            = 14,--纯粹硬炸弹
    VIDEO_OPER_BOMB1            = 15,--纯粹软炸弹
    VIDEO_OPER_ROCKET           = 16,--火箭
    VIDEO_OPER_FOUR2            = 17,--四带二

    VIDEO_OPER_QIANGDIZHU       = 21,--抢地主;
    VIDEO_OPER_BUQIANG          = 22,--不抢地主;
    VIDEO_OPER_DIPAI            = 23,--地主拿底牌;
    VIDEO_OPER_REDEALCARD       = 24,--无人抢地主，重新发牌;

    VIDEO_OPER_JIAO             = 201,--叫地主;
    VIDEO_OPER_BUJIAO           = 200,--不叫地主;

    VIDEO_OPER_CHUNTIAN         = 50, --春天
    VIDEO_OPER_FANCHUN          = 51, --玩家反春;

}

-- 四川麻将特殊操作
m.OPER_SICHUAN = {
    MEN = 1,
    ZHUA = 2,
    DAO = 3,
    LA = 4,
}

local landlordPos = cc.p(149, 210)


function m:ctor(rootNode, paramTbl, gameType)
    self.rootNode = rootNode
    self.gameType = gameType

    -- 房间号
    self.roomID = paramTbl.roomID

    -- 玩家显示固定座位号
    self.playerDisplayIdx = 3
    self.playerSeatIdx = paramTbl.playerSeatIdx
    self.playerFixDispSeat = paramTbl.playerFixDispSeat
    -- 头像下载管理器
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    self.rootNode:addChild(playerHeadMgr)
    self.playerHeadMgr = playerHeadMgr

    --隐藏要不起
    local passNode = gComm.UIUtils.seekNodeByName(self.rootNode,  "Node_pass")
    passNode:setVisible(false)

    -- 隐藏抢地主消息
    local grabNode = gComm.UIUtils.seekNodeByName(self.rootNode,  "Node_grab")
    grabNode:setVisible(false)

    self:initUI()

    -- 计算倍数
    self.bomptimes = 1
    local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
    nd:setString(tostring(self.bomptimes))
    self.bombNum = 0
    self.bombLimit = paramTbl.m_playtype[2]
    if self.bombLimit == 125 then
        self.bombLimit = 3
    elseif self.bombLimit == 126 then
        self.bombLimit = 4
    elseif self.bombLimit == 127 then
        self.bombLimit = 5
    end


    self.bombs ={}

    self.m_lastScore = paramTbl.m_lastScore


    --已选牌表
    self.SelectCard = {}
    -- 当前出的牌
    self.outCard = {}

    local bombLimit = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_BombUpLimit")
    bombLimit:setString(tostring(self.bombLimit))
end

function m:initUI()
    -- 隐藏玩家麻将参考位置
    local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
    playNode:setVisible(false)

    -- 房间号
    local roomIDLabel = gComm.UIUtils.seekNodeByName(self.rootNode, "Label_roomID")
    -- roomIDLabel:setString(mTxtTipConfig.GetConfigTxt("LTKey_0013", self.roomID))
    roomIDLabel:setString(self.roomID)

    -- 麻将层
    local playMjLayer = cc.Layer:create()
    self.rootNode:addChild(playMjLayer, DefineRoom.PlayZOrder.MJTILES_LAYER)
    self.playMjLayer = playMjLayer

    -- 逻辑座位和显示座位偏移量(从0编号开始)
    local seatOffset = self.playerDisplayIdx - self.playerSeatIdx
    self.seatOffset = seatOffset

end

-- start --
--------------------------------
-- @class function
-- @description 房间添加玩家
-- @param playerData 玩家数据
-- end --
function m:roomAddPlayer(roomPlayer)
    -- 玩家自己
    roomPlayer.isOneself = false
    if roomPlayer.seatIdx == self.playerSeatIdx then
        roomPlayer.isOneself = true
    end
    -- 显示索引
    --roomPlayer.displayIdx = (roomPlayer.seatIdx - 1 + self.seatOffset) % 3 + 1

    local displayIdx = (roomPlayer.seatIdx + self.seatOffset ) % self.playerFixDispSeat
    roomPlayer.displayIdx = ( displayIdx == 0 and {self.playerFixDispSeat} or {displayIdx} )[1]


    log("m:roomAddPlayer",roomPlayer.seatIdx,roomPlayer.displayIdx)

    -- 玩家信息
    local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displayIdx)
    playerInfoNode:setVisible(true)

    local spr_dizhu = gComm.UIUtils.seekNodeByName(playerInfoNode , "spr_dizhu")
    spr_dizhu:setVisible(false)
    -- 头像
    roomPlayer.headURL = roomPlayer.headURL
    local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
    self.playerHeadMgr:attach(headSpr, roomPlayer.uid, roomPlayer.headURL)
    -- 昵称
    local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_nickname")
    nicknameLabel:setString(gComm.StringUtils.GetShortName(roomPlayer.nickname))
    -- 积分
    local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")
    scoreLabel:setString(tostring(roomPlayer.score))
    roomPlayer.scoreLabel = scoreLabel

    -- 牌背面
    roomPlayer.uselessTiles = {}

    -- 玩家持有牌
    roomPlayer.holdMjTiles = {}


    roomPlayer.isLandlord = false

    -- 玩家已出牌
    roomPlayer.outMjTiles = {}
    -- 麻将放置参考点
    roomPlayer.mjTilesReferPos = self:getPlayerMjTilesReferPos(roomPlayer.displayIdx)

    -- 添加入缓冲
    if not self.roomPlayers then
        self.roomPlayers = {}
    end
    self.roomPlayers[roomPlayer.seatIdx] = roomPlayer
end

-- 清理掉所有出的牌
function m:cleanMjFormLayer()
    self.playMjLayer:removeAllChildren()
end


-- 显示牌的背面
function m:addOppositeMjTileToPlayer(roomPlayer,msg)
    local value , color = self:changePk(msg)
    local pkTileName = "p.png"
    local pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
    self.playMjLayer:addChild(pkTileSpr)
    local pkTile = {}
    pkTile.mjTileSpr = pkTileSpr
    pkTile.mjColor = color
    pkTile.mjNumber = value
    pkTile.mjIndex = msg
    pkTile.mjIsUp = false
    table.insert(roomPlayer.uselessTiles, pkTile)
    return pkTile
end

-- @class function
-- @description 给玩家发牌
-- @param mjColor
-- @param mjNumber
-- end --
function m:addMjTile(roomPlayer, msg, opposite)
    log("m:addMjTile",roomPlayer.seatIdx, msg)

    local value , color = self:changePk(msg)
    local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
    if  opposite then
        pkTileName = "p.png"
    end
    local pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
    self.playMjLayer:addChild(pkTileSpr)

    local pkTile = {}
    pkTile.mjTileSpr = pkTileSpr
    pkTile.mjColor = color
    pkTile.mjNumber = value
    pkTile.mjIndex = msg
    pkTile.mjIsUp = false

    table.insert(roomPlayer.holdMjTiles, pkTile)

    return pkTile
end

--将消息转换为花色和牌型
function m:changePk(poker)
    log("[log_zxh]  poker:"..poker)
    local value
    local color
    if poker < 44 and poker >= 0 then
        local x =  math.modf(poker / 4)
        value = math.modf((x + 3) % 14)
        color =  math.modf(poker % 4)
    elseif poker <= 47 then
        value = 1
        color =  math.modf(poker % 4)
    elseif poker <= 51 then
        value = 2
        color =  math.modf(poker % 4)
    elseif poker == 52 then--小王
        value = 14
        color = 5
    elseif poker == 53 then-- 大王
        value = 15
        color = 6
    end

    color = self:changeColor(color)

    log("[log_zxh]  value:"..value.."   color:"..color)
    return value , color
end

function m:changeColor( color )
    if color == 0 then
        color = 4
    elseif color == 1 then
        color = 3
    elseif color == 2 then
        color = 2
    elseif color == 3 then
        color = 1
    end

    return color
 end

function m:ScoreEvery(  bombCount ,isJiaoQiang,isChuan)

    if isJiaoQiang then
        self.bomptimes = self.bomptimes * math.pow(2, bombCount)
    else

        if isChuan then
            self.bomptimes = self.bomptimes * math.pow(2, bombCount)
        elseif self.bombNum < self.bombLimit then
            self.bomptimes = self.bomptimes * math.pow(2, bombCount)
            self.bombNum = self.bombNum + bombCount
        end
    end
end


function m:ScoreNum( bombCount,isJiaoQiang,isChuan)
    self:ScoreEvery(bombCount,isJiaoQiang,isChuan)
end


-- start --
--------------------------------
-- @class function
-- @description 播放玩家操作
-- @param 玩家座位号
-- @param 玩家操作
-- @param 玩家操作的牌
-- @return
-- end --
function m:playOperation(seatIdx, optType, card, isPre,curStep,isLast)

    log("m:playOperation-----1",curStep,optType,seatIdx)
    dump(card)
    log("m:playOperation-----2",curStep,optType,seatIdx)


    if isLast then

        for i=1,self.playerFixDispSeat do

            local displayIdx = (i + self.seatOffset ) % self.playerFixDispSeat
            local realSeat = ( displayIdx == 0 and {self.playerFixDispSeat } or {displayIdx} )[1]
                    -- 玩家信息
            local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. realSeat)
            local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")

            scoreLabel:setString(tostring(self.m_lastScore[i]))

        end

    else

        for i=1,self.playerFixDispSeat do

            -- 玩家信息
            local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. i)
            local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")

            scoreLabel:setString("0")

        end

    end



    for i,v in ipairs(self.roomPlayers[seatIdx].outMjTiles) do
        v.mjTileSpr:removeFromParent()
    end

    -- 如果是回退的话，就立马隐藏提示的文字
    if isPre and self.operateTips then
        self.operateTips:setVisible(false)
    end

    self.roomPlayers[seatIdx].outMjTiles = {}

    -- 出牌需要将之前的牌清理掉
    if #self.outCard > 0 then
        for i,v in ipairs(self.outCard) do
            v.mjTileSpr:removeFromParent()
        end
        self.outCard = {}
    end

    local roomPlayer = self.roomPlayers[seatIdx]

    -- 逻辑座位和显示座位偏移量(从0编号开始)
    --local realSeat = (seatIdx - 1 + self.seatOffset) % 3 + 1

    local displayIdx = (seatIdx + self.seatOffset ) % self.playerFixDispSeat
    local realSeat = ( displayIdx == 0 and {self.playerFixDispSeat } or {displayIdx} )[1]

    if optType == m.VIDEOOPER.VIDEO_OPER_NULL then -- 不出
        self:showOperationTips("Node_pass","Image_buyao",nil,realSeat)


    elseif optType == m.VIDEOOPER.VIDEO_OPER_JIAO then--叫地主

        local step = self.bombs[curStep]
        if step then
            self.bomptimes = step
        else
            self:ScoreNum(1,true)

            self.bombs[curStep] = self.bomptimes
        end

        local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
        nd:setString(tostring(self.bomptimes))

        self:playVoice(3,roomPlayer.sex,isPre)

        self:showOperationTips("Node_grab","Image_grab_","Image_nograb_",realSeat)

    elseif optType == m.VIDEOOPER.VIDEO_OPER_BUJIAO then --不叫地主
        self:playVoice(1,roomPlayer.sex,isPre)
        self:showOperationTips("Node_grab","Image_nograb_","Image_grab_",realSeat)

    elseif optType == m.VIDEOOPER.VIDEO_OPER_QIANGDIZHU then -- 抢地主
        self:playVoice(3,roomPlayer.sex,isPre)
        local step = self.bombs[curStep]
        if step then
            self.bomptimes = step
        else
            -- self:ScoreNum(1,true)

            self.bombs[curStep] = self.bomptimes
        end

        local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
        nd:setString(tostring(self.bomptimes))

        local grabNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_grab")
        if grabNode then grabNode:setVisible(true) end

        self:showOperationTips("Node_grab","Image_rob_","Image_norob_",realSeat)

    elseif optType == m.VIDEOOPER.VIDEO_OPER_BUQIANG then -- 不抢
        self:showOperationTips("Node_grab","Image_nograb_","Image_grab_",realSeat)
        self:playVoice(1,roomPlayer.sex,isPre)
        -- 三个玩家都不抢，清理牌桌上的牌，重新发牌
        -- if seatIdx == 3 then
        --  self:cleanMjFormLayer()
        -- end
    elseif optType == m.VIDEOOPER.VIDEO_OPER_DIPAI then -- 地主拿底牌

        roomPlayer.isLandlord = true

        self:showAvatar(roomPlayer,realSeat,isPre,curStep)
        self:showLastHandPoker(card)

        if self.gameType ~= 1 then
            for i,v in ipairs(card) do
                self:addMjTile(roomPlayer,v)
            end

            -- 对玩家手牌重新进行排序
            table.sort(roomPlayer.holdMjTiles,function(a, b)
                return a.mjIndex > b.mjIndex
            end)
            -- 根据花色大小排序并重新放置位置x
            self:sortHoldMjTiles(roomPlayer)

        end
    elseif optType == m.VIDEOOPER.VIDEO_OPER_REDEALCARD then -- 无人抢地主，重新发牌

        for i=1,3 do
            local roomPlayer = self.roomPlayers[i]
            for i,v in ipairs(roomPlayer.holdMjTiles) do
                v.mjTileSpr:removeFromParent()
            end

            roomPlayer.holdMjTiles = {}
        end


        for i,v in ipairs(card) do
            if i <= 17 then
                local roomPlayer = self.roomPlayers[0 + 1]
                self:addMjTile(roomPlayer, v)
                if i == 17 then
                    self:sortHoldMjTiles(roomPlayer)
                end
            elseif i <= 34 then
                local roomPlayer = self.roomPlayers[1 + 1]
                self:addMjTile(roomPlayer, v)
                if i == 34 then
                    self:sortHoldMjTiles(roomPlayer)
                end
            elseif i <= 51 then
                local roomPlayer = self.roomPlayers[2 + 1]
                self:addMjTile(roomPlayer, v)
                if i == 51 then
                    self:sortHoldMjTiles(roomPlayer)
                end
            end
        end

    -- 炸弹
    elseif optType == m.VIDEOOPER.VIDEO_OPER_ROCKET
        or optType == m.VIDEOOPER.VIDEO_OPER_BOMB2
        or optType == m.VIDEOOPER.VIDEO_OPER_BOMB1
        or optType == m.VIDEOOPER.VIDEO_OPER_BOMB3 then

        self:plauOutCard(roomPlayer,seatIdx,card)

        local step = self.bombs[curStep]
        if step then
            self.bomptimes = step
        else
            self:ScoreNum(1)
            self.bombs[curStep] = self.bomptimes
        end

        local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
        nd:setString(tostring(self.bomptimes))
    elseif optType == m.VIDEOOPER.VIDEO_OPER_CHUNTIAN then

        local step = self.bombs[curStep]
        if step then
            self.bomptimes = step
        else
            self:ScoreNum(1,nil,true)
            self.bombs[curStep] = self.bomptimes
        end

        local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
        nd:setString(tostring(self.bomptimes))
    elseif optType == m.VIDEOOPER.VIDEO_OPER_FANCHUN then

        local step = self.bombs[curStep]
        if step then
            self.bomptimes = step
        else
            self:ScoreNum(1,nil,true)

            self.bombs[curStep] = self.bomptimes
        end

        local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
        nd:setString(tostring(self.bomptimes))
    else
        self:plauOutCard(roomPlayer,seatIdx,card)
    end
end

-- 出牌
function m:plauOutCard(roomPlayer,seatIdx,card)

    for i,v in ipairs(card) do
        self:addAlreadyOutMjTiles(seatIdx, v, nil, #card)
        --遍历当前手牌如果有就删掉一个
        for j=1, #roomPlayer.holdMjTiles do
            if roomPlayer.holdMjTiles[j].mjIndex == v then
                --删除
                roomPlayer.holdMjTiles[j].mjTileSpr:removeFromParent()
                table.remove(roomPlayer.holdMjTiles, j)
                -- log("============================")
                break
            end
        end
    end
    -- 根据花色大小排序并重新放置位置x
    self:sortHoldMjTiles(roomPlayer)
    self:sortOutMjTilses(roomPlayer)
end

-- 看牌
function m:showPlayCard(roomPlayer,card)
    if #roomPlayer.uselessTiles > 0 then
        for i,v in ipairs(roomPlayer.uselessTiles) do
            v.mjTileSpr:removeFromParent()
        end
        roomPlayer.uselessTiles = {}
    end

    for _, v in ipairs(card) do
        local value , color = self:changePk(v)
        local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
        local pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
        pkTileSpr:setName(tostring(v))
        pkTileSpr:setPosition(cc.p(-100,-100))
        self.playMjLayer:addChild(pkTileSpr)
        local pkTile = {}
        pkTile.mjTileSpr = pkTileSpr
        pkTile.mjColor = color
        pkTile.mjNumber = value
        pkTile.mjIndex = v
        pkTile.mjIsUp = false
        pkTile.mjIsTouch  = true
        table.insert(roomPlayer.holdMjTiles, pkTile)
    end

    self:sortHoldMjTiles(roomPlayer)
end

-- 显示角色。 地主或者农民哥
-- realSeat  地主的座位编号
function m:showAvatar(roomPlayer,realSeat,isPre,curStep )
    if isPre then
        return
    end

    log("11111_______________________",roomPlayer.seatIdx, realSeat, isPre)

    for i=1,3 do
        local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. i)
        playerInfoNode:setVisible(true)
        local avatarSpr = gComm.UIUtils.seekNodeByName(playerInfoNode,"Spr_head")
        avatarSpr:setVisible(true)

        -- local landLordAvatar = nil
        local spr_dizhu = gComm.UIUtils.seekNodeByName(playerInfoNode , "spr_dizhu")
        spr_dizhu:setVisible(false)

        if realSeat == i then -- 地主
            -- 地主的倍数是翻倍的
            if roomPlayer.isOneself and self.gameType ~= 1 then

                local step = self.bombs[curStep]
                if step then
                    self.bomptimes = step
                else
                    -- self:ScoreNum(1)
                    self.bombs[curStep] = self.bomptimes
                end

                local nd = gComm.UIUtils.seekNodeByName(self.rootNode, "AtlasLabel_bombtimes")
                nd:setString(tostring(self.bomptimes))
            end
            spr_dizhu:setVisible(true)
        else
        end
    end
end

-- 操作的提示
function m:showOperationTips(fstLayer,sndLayer,other,realSeat)

    local Node_pass = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_pass")
    for _,v in pairs(Node_pass:getChildren()) do
        v:setVisible(false)
    end

    local Node_grab = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_grab")
    for _,v in pairs(Node_grab:getChildren()) do
        v:setVisible(false)
    end

    local passNode = gComm.UIUtils.seekNodeByName(self.rootNode, fstLayer)
    passNode:setVisible(true)
    for i = 1,3 do
        if other then
            local otherImage = gComm.UIUtils.seekNodeByName(passNode, other..i)
            otherImage:setVisible(false)
        end

        local passImage = gComm.UIUtils.seekNodeByName(passNode, sndLayer..i)
        if realSeat ~= i then
            passImage:setVisible(false)
        else
            passImage:setVisible(true)
            passImage:stopAllActions()
            local delayTime = cc.DelayTime:create(0.5)
            local callFunc = cc.CallFunc:create(function(sender)
                sender:setVisible(false)
                passNode:setVisible(false)
            end)
            self.operateTips = passImage
            passImage:runAction(cc.Sequence:create(delayTime,callFunc))
        end
    end
end



function m:addAlreadyOutMjTiles(seatIdx, msg, isHide, cardLen)
    local value , color = self:changePk(msg)
    local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)

    -- 添加到已出牌列表zy
    local roomPlayer = self.roomPlayers[seatIdx]

    local mjTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
    local mjTile = {}
    mjTile.mjTileSpr = mjTileSpr
    mjTile.mjColor = mjColor
    mjTile.mjNumber = mjNumber

    table.insert(roomPlayer.outMjTiles, mjTile)

    self.playMjLayer:addChild(mjTileSpr)
end


function m:getPlayerMjTilesReferPos(displayIdx)
    local mjTilesReferPos = {}

    local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
    local mjTilesReferNode = gComm.UIUtils.seekNodeByName(playNode, "Node_playerMjTiles_" .. displayIdx)

    -- 持有牌数据
    local mjTileHoldSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_1")
    local mjTileHoldSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_2")

    mjTilesReferPos.holdStart = cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints()))
    mjTilesReferPos.holdSpace = cc.pSub(cc.p(mjTileHoldSprS:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints())),
        cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints())))

    -- 摸牌偏移
    local drawSpaces = {{x = -16,   y = 0},
                        {x = 0,     y = -16},
                        {x = 16,    y = 0},
                        {x = 32,    y = 0}}
    mjTilesReferPos.drawSpace = drawSpaces[displayIdx]

    local mjTileOutSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_1")
    local mjTileOutSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileShow_2")
    mjTilesReferPos.outStart = cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints()))
    mjTilesReferPos.outSpaceH = cc.pSub(cc.p(mjTileOutSprS:getPosition()), cc.p(mjTileOutSprF:getPosition()))
    return mjTilesReferPos
end

function m:sortOutMjTilses(roomPlayer )

    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.outStart

    local pokerSize = cc.size(155,216)
    local gap = mjTilesReferPos.outSpaceH.x

    log("m:sortOutMjTilses gap = ",gap)
    local scalePara  = 0.5

    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local cardNum = #roomPlayer.outMjTiles

    local mjTilePos = cc.p(mjTilesReferPos.outStart.x,mjTilesReferPos.outStart.y)


    local pokerSize = cc.size(155,216)
    pokerSize.width = pokerSize.width * scalePara


    if roomPlayer.displayIdx == 1 then

        local cardWidth = (cardNum - 1)  * gap

        mjTilePos.x = mjTilePos.x - cardWidth

    elseif roomPlayer.displayIdx == 2 then

    elseif roomPlayer.displayIdx == 3 then

        mjTilePos.x = 640

        local startPos = mjTilePos.x - ( (cardNum - 1) * gap + pokerSize.width)/2 + pokerSize.width / 2

        mjTilePos.x = startPos
    end

    for k, mjTile in ipairs(roomPlayer.outMjTiles) do

        mjTile.mjTileSpr:stopAllActions()


        if roomPlayer.isLandlord then

            local landlordFlag = mjTile.mjTileSpr:getChildByName("pkLandlord")

            if landlordFlag == nil then
                local pkTileName = "Image/GameSub/GameDDZ/play_flag_landlord.png"
                local pkLandlord = cc.Sprite:createWithSpriteFrameName(pkTileName)
                pkLandlord:setAnchorPoint(cc.p(1,1))
                pkLandlord:setPosition(landlordPos)
                pkLandlord:setName("pkLandlord")
                mjTile.mjTileSpr:addChild(pkLandlord)
            end
        end


        mjTile.mjTileSpr:setPosition(mjTilePos.x, mjTilePos.y)

        self.playMjLayer:reorderChild(mjTile.mjTileSpr, mjTilePos.x)

        mjTile.mjTileSpr:setScale(scalePara)

        mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.outSpaceH)
    end

end


-- start --
--------------------------------
-- @class function
-- @description 玩家麻将牌根据花色，编号重新排序
-- end --
function m:sortHoldMjTiles(roomPlayer,isOp)
    local cardArr = roomPlayer.holdMjTiles
    if isOp then
        cardArr = roomPlayer.uselessTiles
    end

    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local cardNum = #cardArr --roomPlayer.holdMjTiles -- 当前剩余牌数量

    local mjTilePos = mjTilesReferPos.holdStart

    local centerPos = 0
    local pokerSize = cc.size(155,216)
    local scalePara
    local rotatePara

    local startPos
    local gap = (mjTilesReferPos.holdSpace.x == 0 and {mjTilesReferPos.holdSpace.y} or {mjTilesReferPos.holdSpace.x})[1]

    scalePara = 0.5

    if roomPlayer.displayIdx == 1 then
        centerPos = display.height/2
        rotatePara = 270
    elseif roomPlayer.displayIdx == 2 then
        centerPos = display.height/2
        rotatePara = 90
    elseif roomPlayer.displayIdx == 3 then
        centerPos = 640
        rotatePara = 0
    end

    pokerSize.width = pokerSize.width * scalePara
    pokerSize.height = pokerSize.height * scalePara
    startPos = centerPos - ((cardNum - 1) * gap + pokerSize.width) / 2 + pokerSize.width / 2

    if roomPlayer.displayIdx == 1 then
        mjTilePos.y = startPos
    elseif roomPlayer.displayIdx == 2 then
        mjTilePos.y = startPos
    elseif roomPlayer.displayIdx == 3 then
        mjTilePos.x = startPos
    end

    for k, mjTile in ipairs(cardArr) do
        mjTile.mjTileSpr:stopAllActions()


        if roomPlayer.isLandlord then

            local landlordFlag = mjTile.mjTileSpr:getChildByName("pkLandlord")

            if landlordFlag == nil then
                local pkTileName = "Image/GameSub/GameDDZ/play_flag_landlord.png"
                local pkLandlord = cc.Sprite:createWithSpriteFrameName(pkTileName)
                pkLandlord:setAnchorPoint(cc.p(1,1))
                pkLandlord:setPosition(landlordPos)
                pkLandlord:setName("pkLandlord")
                mjTile.mjTileSpr:addChild(pkLandlord)
            end
        end


        mjTile.mjTileSpr:setPosition(mjTilePos.x, mjTilePos.y)
        self.playMjLayer:reorderChild(mjTile.mjTileSpr, mjTilePos.x)
        mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)


        mjTile.mjTileSpr:setScale(scalePara)
        mjTile.mjTileSpr:setRotation(rotatePara)

    end

end


function m:playSound(seatIdx, optType, card)
    local roomPlayer = self.roomPlayers[seatIdx]
    local PlayScene = require("app.Game.Scene.SceneDDZSenior")
    local sound
    if optType == m.VIDEOOPER.VIDEO_OPER_NULL then
        local num = math.random(1,4)
        if roomPlayer.sex == 1 then
            sound = "man/buyao" .. num
        else
            sound = "woman/buyao" .. num
        end
    elseif optType == PlayScene.CardType.card_style_double then
        local value , color = self:changePk(card[1])
        if roomPlayer.sex == 1 then
            sound = string.format("man/dui%d", value)
        else
            sound = string.format("woman/dui%d",value)
        end
    elseif optType == PlayScene.CardType.card_style_single then
        local value , color = self:changePk(card[1])
        if roomPlayer.sex == 1 then
            sound = string.format("man/pk_%d", value)
        else
            sound = string.format("woman/pk_%d",value)
        end
    elseif optType == PlayScene.CardType.card_style_three then

        local value , color = self:changePk(card[1])
        if roomPlayer.sex == 1 then
            sound = string.format("man/Man_tuple%d",value)
        else
            sound = string.format("woman/Woman_tuple%d",value)
        end
    elseif optType == PlayScene.CardType.card_style_three_single then

        if roomPlayer.sex == 1 then
            sound = "man/sandaiyi"
        else
            sound = "woman/sandaiyi"
        end
    elseif optType == PlayScene.CardType.card_style_three_double then

        if roomPlayer.sex == 1 then
            sound = "man/sandaiyidui"
        else
            sound = "woman/sandaiyidui"
        end
    elseif optType == PlayScene.CardType.card_style_three_list or optType == PlayScene.CardType.card_style_three_list_single or optType == PlayScene.CardType.card_style_three_list_double then
        if roomPlayer.sex == 1 then
            sound = "man/feiji"
        else
            sound = "woman/feiji"
        end
    elseif optType == PlayScene.CardType.card_style_single_list then

        if roomPlayer.sex == 1 then
            sound = "man/shunzi"
        else
            sound = "woman/shunzi"
        end
    elseif optType == PlayScene.CardType.card_style_double_list then

        if roomPlayer.sex == 1 then
            sound = "man/liandui"
        else
            sound = "woman/liandui"
        end
    elseif optType == PlayScene.CardType.card_style_bomb2 then
        if roomPlayer.sex == 1 then
            sound = "man/zhadan"
        else
            sound = "woman/zhadan"
        end
    elseif optType == PlayScene.CardType.card_style_rocket then
        if roomPlayer.sex == 1 then
            sound = "man/wangzha"
        else
            sound = "woman/wangzha"
        end

    elseif optType == PlayScene.CardType.card_style_four2 then
        if roomPlayer.sex == 1 then
            sound = "man/sidaier"
        else
            sound = "woman/sidaier"
        end
    end
    gComm.SoundEngine:playEffect(sound)
end

function m:playVoice(type,sex,isPre)

    if isPre then
        return
    end

    local sound = "man/Man_NoOrder"
    if type == 1 then
        if sex == 1 then
            sound = "man/Man_NoOrder"
        else
            sound = "woman/Woman_NoOrder"
        end
    elseif type == 2 then
        if sex == 1 then
            sound = "man/Man_NoRob"
        else
            sound = "woman/Woman_NoRob"
        end
    elseif type == 3 then

        if sex == 1 then
            sound = "man/Man_Order"
        else
            sound = "woman/Woman_Order"
        end
    elseif type == 4 then
        if sex == 1 then
            sound = "man/Man_Rob1"
        else
            sound = "woman/Woman_Rob1"
        end

    end

    log("PlayTwoManager:playVoice  : ",sound)

    gComm.SoundEngine:playEffect(sound)

end

-- 显示底牌
function m:showLastHandPoker(pokers)
    self.mLastHandsNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_LastHands")
    for k, v in ipairs(pokers) do

        local pkTileBg = gComm.UIUtils.seekNodeByName(self.mLastHandsNode, "LastHand_"..k)
        pkTileBg:setScale(0.3)

        local pkTileSpr = self.rootNode:getChildByName("HandTile_"..k)
        if pkTileSpr then
            pkTileSpr:removeFromParent()
        end

        local pkValue = pokers[1]
        local value, color = self:changePk(v)
        local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",color, value)
        pkTileSpr = cc.Sprite:createWithSpriteFrameName(pkTileName)
        pkTileSpr:setPosition(cc.p(pkTileBg:convertToWorldSpace(pkTileBg:getAnchorPointInPoints())))
        pkTileSpr:setName("HandTile_"..k)
        pkTileSpr:setScale(0.3)
        self.rootNode:addChild(pkTileSpr)

        local pkShadow = cc.Sprite:createWithSpriteFrameName("Image/GameSub/GameDDZ/play_poker_shadow.png")
        pkShadow:setAnchorPoint(cc.p(0, 1))
        pkShadow:setPosition(cc.p(0,pkTileSpr:getContentSize().height))
        pkShadow:setScale(3.3)
        pkTileSpr:removeAllChildren()
        pkTileSpr:addChild(pkShadow)


        pkTileSpr:setVisible(false)
        self:playTurnCardAction(pkTileBg, pkTileSpr, seatIdx, k)

    end
end

function m:playTurnCardAction(pkTileBg, pkTileSpr, diZhuPos, index)
    --显示底牌翻牌动画
    local kOutAngleZ = 0
    local kOutDeltaZ = -90
    local kInAngleZ = 90
    local kInDeltaZ = -90
    local inDuration = 0.2
    local outDuration = 0.2

    local callFunc = cc.CallFunc:create(function(sender)
            pkTileBg:setVisible(false)
            local inAnimation = cc.Sequence:create(
            cc.Show:create(),

            cc.DelayTime:create(0.8),
            cc.CallFunc:create(function ()
            end))
            if not tolua.isnull(pkTileSpr) then
                pkTileSpr:runAction(inAnimation)
            end
        end)

    local outAnimation = cc.Sequence:create(
        cc.Show:create(),
        cc.DelayTime:create(0.2),
        cc.Hide:create(),
        callFunc)
    pkTileBg:runAction(outAnimation)
end

return m
