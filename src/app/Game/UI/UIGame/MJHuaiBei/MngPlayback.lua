
local gComm = cc.exports.gComm
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local DefineRoom = require("app.Common.Config.DefineRoom")

local SpriteTileStand = require("app.Common.Tiles.SpriteTileStand")
local LayerTileOut = require("app.Common.Tiles.LayerTileOut")
local SpriteTileOpen = require("app.Common.Tiles.SpriteTileOpen")
local DefineTile = require("app.Common.Tiles.DefineTile")
local SoundMng = require("app.Common.Controller.SoundMng")
local SceneMJHuaiBei = require("app.Game.Scene.SceneMJHuaiBeiEx")


local m = class("MngPlayback")

local n = {}
n.outTileItemScale = 0.6875
-- shuffle洗牌，cut切牌，deal发牌，sort理牌，draw摸牌，play打出，discard弃牌

function m:ctor(rootNode, paramTbl, turnCard)
    self.rootNode = rootNode
    -- 房间号
    self.roomID = paramTbl.roomID

    -- 玩法类型
    self.playType = paramTbl.playType
    self.m_flag = paramTbl.m_flag

    self.playTypeDesc = ""
    for k,v in pairs(self.playType) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            self.playTypeDesc = self.playTypeDesc .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            self.playTypeDesc = self.playTypeDesc .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end
    log("MngPlayback--rule--" .. self.playTypeDesc )

    self.gamePlayerNum = paramTbl.m_playerNum
    for i=1,4 do
        local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. i)
        playerInfoNode:setVisible(false)
    end

    -- 玩家显示固定座位号
    self.playerDisplayIdx = 4
    self.playerSeatIdx = paramTbl.playerSeatIdx

    -- 头像下载管理器
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    self.rootNode:addChild(playerHeadMgr)
    self.playerHeadMgr = playerHeadMgr

    --方向图片切换
    if self.gamePlayerNum == 3 or  self.gamePlayerNum == 2 then
        local Spr_turnPosBg = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_turnPosBg")
        -- Spr_turnPosBg:setSpriteFrame("Image/IRoom/CommomRoom/game_direct2.png")
        gComm.SpriteUtils.setSpriteFrameEx(Spr_turnPosBg,"Image/IRoom/CommomRoom/game_direct2.png","Texture/GComm.plist")
    end


    self.zhuang = paramTbl.m_zhuang + 1
    self:initUI()
end

function m:reInit()
    --只删除牌相关 头像 玩法等不动
    if self.outMjTileAnimation then
        self.outMjTileAnimation:stopAllActions()
        self.outMjTileAnimation:removeFromParent()
        self.outMjTileAnimation = nil
    end
    -- 麻将层
    self.playMjLayer:removeFromParent()
    self.playMjLayer = nil
    --出牌标示
    self.outMjtileSignNode:removeFromParent()
    self.outMjtileSignNode = nil
end

function m:initUI()
    -- 隐藏玩家麻将参考位置
    local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
    playNode:setVisible(false)

    -- 房间号
    local roomIDLabel = gComm.UIUtils.seekNodeByName(self.rootNode, "Label_roomID")
    roomIDLabel:setString(mTxtTipConfig.GetConfigTxt("LTKey_0013", self.roomID))

    -- 玩法描述
    local playTypeLabel = gComm.UIUtils.seekNodeByName(self.rootNode, "Label_playType")
    playTypeLabel:setString(self.playTypeDesc)

    -- 麻将层
    local playMjLayer = cc.Layer:create()
    self.rootNode:addChild(playMjLayer, DefineRoom.PlayZOrder.MJTILES_LAYER)
    self.playMjLayer = playMjLayer

    -- 出的牌标识动画
    local outMjtileSignNode, outMjtileSignAnime = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimOutMjtileSign.csb")
    outMjtileSignAnime:play("run", true)
    outMjtileSignNode:setVisible(false)
    self.rootNode:addChild(outMjtileSignNode, DefineRoom.PlayZOrder.OUTMJTILE_SIGN)
    self.outMjtileSignNode = outMjtileSignNode

    -- 逻辑座位和显示座位偏移量(从0编号开始)
    local seatOffset = self.playerDisplayIdx - self.playerSeatIdx
    self.seatOffset = seatOffset
    -- 旋转座次标识,座次方位和显示对应
    local turnPosBgSpr = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_turnPosBg")
    turnPosBgSpr:setRotation(-seatOffset * 90)
    for _, turnPosSpr in ipairs(turnPosBgSpr:getChildren()) do
        turnPosSpr:setVisible(false)
    end
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
    roomPlayer.displayIdx = (roomPlayer.seatIdx + self.seatOffset - 1) % 4 + 1

    if self.gamePlayerNum == 3 then
        if self.seatOffset == 1 and roomPlayer.seatIdx == 1 then
            roomPlayer.displayIdx = 1
        elseif self.seatOffset == 2 and roomPlayer.seatIdx == 1 then
            roomPlayer.displayIdx = 3
        elseif self.seatOffset == 3 and roomPlayer.seatIdx == 3 then
            roomPlayer.displayIdx = 3
        else
        end 
    end

    if self.gamePlayerNum == 2 then
        if self.seatOffset == 3 and roomPlayer.seatIdx == 2 then
            roomPlayer.displayIdx = 2
        elseif self.seatOffset == 2 and roomPlayer.seatIdx == 1 then
            roomPlayer.displayIdx = 2
        end 
    end

    -- 玩家信息
    local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displayIdx)
    playerInfoNode:setVisible(true)
    -- 头像
    roomPlayer.headURL = roomPlayer.headURL
    local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
    self.playerHeadMgr:attach(headSpr, roomPlayer.uid, roomPlayer.headURL)
    -- 昵称
    local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_nickname")
    nicknameLabel:setString(roomPlayer.nickname)
    -- 积分
    local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_score")
    scoreLabel:setString(tostring(roomPlayer.score))
    roomPlayer.scoreLabel = scoreLabel
    -- 离线标示
    -- local offLineSignSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_offLineSign")
    -- offLineSignSpr:setVisible(false)
    -- 庄家
    local bankerSignSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_bankerSign")
    bankerSignSpr:setVisible(roomPlayer.seatIdx == self.zhuang)

    local Spr_tingSign = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_tingSign")
    Spr_tingSign:setVisible(false)

    local txtZuoLaPao = gComm.UIUtils.seekNodeByName(playerInfoNode, "txtZuoLaPao")
    
    local str = ""
    if roomPlayer.zuoLaPao ~= "" then
        local arr = string.split(roomPlayer.zuoLaPao,",")
        if arr ~= "" then
            if roomPlayer.seatIdx == self.zhuang then
                str = str .. "坐".. arr[1] .. "拉" .. arr[2]
            else
                str = str .. "拉".. arr[1] .. "拉" .. arr[2]
            end
        end
    end
    txtZuoLaPao:setString(str)

    -- 玩家持有牌
    roomPlayer.holdMjTiles = {}
    -- 玩家已出牌
    roomPlayer.outMjTiles = {}
    -- 碰
    roomPlayer.mjTilePungs = {}
    -- 明杠
    roomPlayer.mjTileBrightBars = {}
    -- 暗杠
    roomPlayer.mjTileDarkBars = {}
    --吃
    roomPlayer.mjTileEat = {}
    -- 明补
    roomPlayer.mjTileBrightBu = {}
    -- 暗补
    roomPlayer.mjTileDarkBu = {}
    -- 麻将放置参考点
    roomPlayer.mjTilesReferPos = self:getPlayerMjTilesReferPos(roomPlayer.displayIdx)
    -- 0-旋风杠，1-喜杠，2-幺蛋杠，3-九蛋杠
    roomPlayer.mjTileSpecialBars = {{},{},{},{}}

    -- 添加入缓冲
    if not self.roomPlayers then
        self.roomPlayers = {}
    end
    self.roomPlayers[roomPlayer.seatIdx] = roomPlayer
end

-- start --
--------------------------------
-- @class function
-- @description 设置座位编号标识
-- @param seatIdx 座位编号
-- end --
function m:setTurnSeatSign(seatIdx)

    if self.gamePlayerNum == 3 then
        if self.seatOffset == 1 and seatIdx == 1 then
            seatIdx = 4
        elseif self.seatOffset == 2 and seatIdx == 1 then
            seatIdx = 1
        elseif self.seatOffset == 3 and seatIdx == 3 then
            seatIdx = 4
        else
        end     
    end
    if self.gamePlayerNum == 2 then
        if self.seatOffset == 3 and seatIdx == 2 then
            seatIdx = 3
        elseif self.seatOffset == 2 and seatIdx == 1 then
            seatIdx = 4
        end 
    end
    -- 显示轮到的玩家座位标识
    local turnPosBgSpr = gComm.UIUtils.seekNodeByName(self.rootNode, "Spr_turnPosBg")
    -- 显示当先座位标识
    local turnPosSpr = gComm.UIUtils.seekNodeByName(turnPosBgSpr, "Spr_turnPos_" .. seatIdx)
    turnPosSpr:setVisible(true)
    if self.preTurnSeatIdx and self.preTurnSeatIdx ~= seatIdx then
        -- 隐藏上次座位标识
        local turnPosSpr = gComm.UIUtils.seekNodeByName(turnPosBgSpr, "Spr_turnPos_" .. self.preTurnSeatIdx)
        turnPosSpr:setVisible(false)
    end
    self.preTurnSeatIdx = seatIdx
end

function m:drawMjTile(seatIdx, mjColor, mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]

    -- 添加牌放在末尾
    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.holdStart
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, #roomPlayer.holdMjTiles))
    mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.drawSpace)
    local mjTile = self:addMjTile(roomPlayer, mjColor, mjNumber)
    mjTile.mjTileSpr:setPosition(mjTilePos)
    self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))
end

-- start --
--------------------------------
-- @class function
-- @description 给玩家添加牌
-- @param seatIdx 座位号
-- @param mjColor 花色
-- @param mjNumber 编号
-- end --
function m:addMjTile(roomPlayer, mjColor, mjNumber)
    -- local roomPlayer = self.roomPlayers[seatIdx]
    local mjTileSpr
    if roomPlayer.isOneself then
        -- 玩家自己
        mjTileSpr = SpriteTileStand:create(mjColor, mjNumber)
    else
        if roomPlayer.isHidden then
            -- 持有牌隐藏
            local mjTileName = DefineTile.getTileBGGang(roomPlayer.displaySeatIdx)
            mjTileSpr = cc.Sprite:createWithSpriteFrameName(mjTileName)
        else
            mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx,mjColor, mjNumber)
        end
    end
    self.playMjLayer:addChild(mjTileSpr)

    local mjTile = {}
    mjTile.mjTileSpr = mjTileSpr
    mjTile.mjColor = mjColor
    mjTile.mjNumber = mjNumber
    table.insert(roomPlayer.holdMjTiles, mjTile)

    return mjTile
end

-- start --
--------------------------------
-- @class function
-- @description 出牌
-- @param
-- @param
-- @param
-- @return
-- end --
function m:playOutMjTile(seatIdx, mjColor, mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]

    -- 持有牌删除对应麻将
    self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber, 1)

    -- 显示出牌动画
    self:showOutMjTileAnimation(roomPlayer, mjColor, mjNumber, function()
        -- 添加出牌
        self:outMjTile(roomPlayer, mjColor, mjNumber)

        -- 显示出牌标识
        self:showOutMjtileSign(roomPlayer)
    end)

    -- 记录出牌的上家
    self.prePlaySeatIdx = seatIdx

    -- dj revise
    SoundMng.PlayCardSound(roomPlayer.sex, mjColor, mjNumber)
end

-- 快速出牌
function m:playOutMjTileQuick(seatIdx, mjColor, mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]

    -- 持有牌删除对应麻将
    self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber, 1)

    -- 添加出牌
    self:outMjTile(roomPlayer, mjColor, mjNumber)

    -- 显示出牌标识
    self:showOutMjtileSign(roomPlayer)

    -- 记录出牌的上家
    self.prePlaySeatIdx = seatIdx
end


-- start --
--------------------------------
-- @class function
-- @description 添加已出牌
-- @param seatIdx 座位号
-- @param mjColor 花色
-- @param mjNumber 编号
-- end --
function m:outMjTile(roomPlayer, mjColor, mjNumber)
    -- 添加到已出牌
    -- local roomPlayer = self.roomPlayers[seatIdx]
    local mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx,mjColor, mjNumber)

    local mjTile = {}
    mjTile.mjTileSpr = mjTileSpr
    mjTile.mjColor = mjColor
    mjTile.mjNumber = mjNumber
    table.insert(roomPlayer.outMjTiles, mjTile)

    -- 缩小玩家已出牌
    if roomPlayer.isOneself then
        mjTileSpr:setScale(0.4625)
    end

    -- 显示已出牌
    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.outStart
    local lineCount = math.ceil(#roomPlayer.outMjTiles / 10) - 1
    local lineIdx = #roomPlayer.outMjTiles - lineCount * 10 - 1
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, lineCount))
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))
    mjTileSpr:setPosition(mjTilePos)
    self.playMjLayer:addChild(mjTileSpr, (display.size.height - mjTilePos.y))
end

-- start --
--------------------------------
-- @class function
-- @description 碰牌
-- @param seatIdx 座位编号
-- @param mjColor 花色
-- @param mjNumber 编号
-- end --
function m:addMjTilePung(seatIdx, mjColor, mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]

    local pungData = {}
    pungData.mjColor = mjColor
    pungData.mjNumber = mjNumber
    table.insert(roomPlayer.mjTilePungs, pungData)

    pungData.groupNode = self:pungBarReorderMjTiles(roomPlayer, mjColor, mjNumber, false)
end

function m:addMjTileChi(seatIdx,eatGroup)
    -- body
    local roomPlayer = self.roomPlayers[seatIdx]
    -- local chiData = {}
    -- chiData.mjColor = mjColor
    -- chiData.mjNumber = mjNumber
    table.insert(roomPlayer.mjTileEat, eatGroup)
    -- chi.groupNode
end

-- start --
--------------------------------
-- @class function
-- @description 杠牌
-- @param seatIdx 座位编号
-- @param mjColor 花色
-- @param mjNumber 编号
-- @param isBrightBar 明杠或者暗杠
-- end --
function m:addMjTileBar(seatIdx, mjColor, mjNumber, isBrightBar)
    local roomPlayer = self.roomPlayers[seatIdx]

    -- 加入到列表中
    local barData = {}
    barData.mjColor = mjColor
    barData.mjNumber = mjNumber
    if isBrightBar then
        -- 明杠
        table.insert(roomPlayer.mjTileBrightBars, barData)
    else
        -- 暗杠
        table.insert(roomPlayer.mjTileDarkBars, barData)
    end

    barData.groupNode = self:pungBarReorderMjTiles(roomPlayer, mjColor, mjNumber, true, isBrightBar)
end


-- start --
--------------------------------
-- @class function
-- @description 特殊杠牌
-- @param seatIdx 座位编号
-- @param cards 杠牌
-- @param type 杠牌类型 1-旋风杠，2-喜杠 3-幺蛋杠，4-九蛋杠，5-明蛋，6-暗蛋
-- end --
function m:addMjTileSpecialBar(seatIdx, cards, type)
    local roomPlayer = self.roomPlayers[seatIdx]
    -- 加入到列表中
    local barData = {}
    if not roomPlayer.mjTileSpecialBars[type].cards then
        barData.cards = self:copyTab(cards)
        roomPlayer.mjTileSpecialBars[type] = barData
        barData.groupNode = self:pungBarReorderMjTiles(roomPlayer, nil, nil, true, 3, cards,type)
    else
        self:changeSpecialBar(seatIdx,cards, type)
    end
end

--------------------------------
-- @class function
-- @description 特殊补杠
-- @param seatIdx
-- @param mjColor
-- @param mjNumber
-- @param type 杠牌类型 20-补杠 21-旋风杠，22-喜杠 23-幺蛋杠，24-九蛋杠
-- end --
function m:changeSpecialBar(seatIdx,cards,type)
    local roomPlayer = self.roomPlayers[seatIdx]
    local removeTable = {}
    for j = 1, #cards do
        table.insert(removeTable, {cards[j][1], cards[j][2]})   
    end
    if #removeTable > 0 then
        for k, v in ipairs(removeTable) do
            for i=#roomPlayer.holdMjTiles, 1,-1 do
                local mjTile = roomPlayer.holdMjTiles[i]
                if mjTile.mjNumber == v[2] 
                    and  mjTile.mjColor == v[1] 
                    and mjTile.mjTileSpr then
                    mjTile.mjTileSpr:removeFromParent()
                    table.remove(roomPlayer.holdMjTiles, i)
                    break
                end
            end
        end 
    end


    -- 合并数据
    local specialBarDate = roomPlayer.mjTileSpecialBars[type]

    local sBarArray = specialBarDate.cards
    local arrayCount = #sBarArray
    local function checkSameType(card)
        for i,v in ipairs(sBarArray) do
            if v[1] == card[1] and v[2] == card[2] then
                return i
            end
        end
        return false
    end
    for i,v in ipairs(cards) do
        local key = checkSameType(v)
        if key then
            sBarArray[key][3] = sBarArray[key][3]+1
        else
            table.insert(v,1)
            table.insert(sBarArray,v)
        end
    end

    self:sortHoldMjTiles(roomPlayer)
    --刷新杠
    for i,v in ipairs(sBarArray) do
        if i<= arrayCount then --刷新数量
            if v[3]>1 then
                local mjSpr = specialBarDate.groupNode:getChildByTag(i)
                local ttf = mjSpr:getChildByTag(10)
                if ttf then
                    ttf:setString("X"..v[3])
                else
                    local barSize = mjSpr:getContentSize()
                    local msgContentLabel = gComm.LabelUtils.createTTFLabel("X"..v[3], 18)
                    if roomPlayer.displayIdx == 1 then
                        msgContentLabel:setPosition(10, barSize.height-10)
                    elseif roomPlayer.displayIdx == 2 then
                        msgContentLabel:setPosition(13,21)
                    elseif roomPlayer.displayIdx == 3 then
                        msgContentLabel:setPosition(barSize.width-10, 24)
                    elseif roomPlayer.displayIdx == 4 then
                        msgContentLabel:setPosition(barSize.width-13, barSize.height-10)
                    end
                    msgContentLabel:setRotation(-90*roomPlayer.displayIdx)
                    mjSpr:addChild(msgContentLabel,10,10)
                end

            end
        else  --加牌
            local mjTilesReferPos = roomPlayer.mjTilesReferPos
            local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos
            local mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx, v[1], v[2])
    
            if i<= 3 then
                mjTileSpr:setPosition(groupMjTilesPos[i])
                specialBarDate.groupNode:addChild(mjTileSpr,0,i)
            else
                mjTileSpr:setPosition(groupMjTilesPos[i+1])
                if roomPlayer.displayIdx == 1 then
                    if i == 4 then
                        specialBarDate.groupNode:addChild(mjTileSpr,-1,i)
                    else
                        specialBarDate.groupNode:addChild(mjTileSpr,-2,i)
                    end
                elseif roomPlayer.displayIdx == 2 then
                    specialBarDate.groupNode:addChild(mjTileSpr,0,i)
                elseif roomPlayer.displayIdx == 3 then
                    specialBarDate.groupNode:addChild(mjTileSpr,0,i)
                elseif roomPlayer.displayIdx == 4 then
                    specialBarDate.groupNode:addChild(mjTileSpr,-1,i)
                end
            end
            
            if v[3]>1 then --特殊杠的数字
                local barSize = mjTileSpr:getContentSize()
                local msgContentLabel = gComm.LabelUtils.createTTFLabel("X"..v[3], 18)
                if roomPlayer.displayIdx == 1 then
                    msgContentLabel:setPosition(10, barSize.height-10)
                elseif roomPlayer.displayIdx == 2 then
                    msgContentLabel:setPosition(13,21)
                elseif roomPlayer.displayIdx == 3 then
                    msgContentLabel:setPosition(barSize.width-10, 24)
                elseif roomPlayer.displayIdx == 4 then
                    msgContentLabel:setPosition(barSize.width-13, barSize.height-10)
                end
                msgContentLabel:setRotation(-90*roomPlayer.displayIdx)
                mjTileSpr:addChild(msgContentLabel,10,10)   
            end
        end
    end
end

function m:getPlayerMjTilesReferPos(displayIdx)
    local mjTilesReferPos = {}

    local playNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_play")
    local mjTilesReferNode = gComm.UIUtils.seekNodeByName(playNode, "Node_playerMjTiles_" .. displayIdx)

    -- 持有牌数据
    local mjTileHoldSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_1")
    local mjTileHoldSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_2")
    mjTilesReferPos.holdStart = cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints()))
    mjTilesReferPos.holdSpace = cc.pSub(mjTileHoldSprS:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints()), 
        mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints()))

    -- 摸牌偏移
    local drawSpaces = {{x = -16,   y = 0},
                        {x = 0,     y = -16},
                        {x = 16,    y = 0},
                        {x = 32,    y = 0}}
    mjTilesReferPos.drawSpace = drawSpaces[displayIdx]

    -- 打出牌数据
    local mjTileOutSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_1")
    local mjTileOutSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_2")
    local mjTileOutSprT = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_3")
    mjTilesReferPos.outStart = cc.p(mjTileOutSprF:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints()))
    mjTilesReferPos.outSpaceH = cc.pSub(cc.p(mjTileOutSprS:convertToWorldSpace(mjTileOutSprS:getAnchorPointInPoints())), cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints())))
    mjTilesReferPos.outSpaceV = cc.pSub(cc.p(mjTileOutSprT:convertToWorldSpace(mjTileOutSprT:getAnchorPointInPoints())), cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints())))

    if self.gamePlayerNum == 2 then
        if displayIdx == 2 then
            mjTilesReferPos.outStart.x = mjTilesReferPos.outStart.x + 52
        elseif displayIdx == 4 then
            mjTilesReferPos.outStart.x = mjTilesReferPos.outStart.x - 72
        end
    end
    -- 碰，杠牌数据
    local mjTileGroupPanel = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Panel_mjTileGroup")
    local groupMjTilesPos = {}
    for _, groupTileSpr in ipairs(mjTileGroupPanel:getChildren()) do
        table.insert(groupMjTilesPos, cc.p(groupTileSpr:getPosition()))
    end
    mjTilesReferPos.groupMjTilesPos = groupMjTilesPos
    mjTilesReferPos.groupStartPos = cc.p(mjTileGroupPanel:convertToWorldSpace(mjTileGroupPanel:getAnchorPointInPoints()))
    local groupSize = mjTileGroupPanel:getContentSize()
    if displayIdx == 1 or displayIdx == 3 then
        mjTilesReferPos.groupSpace = cc.p(0, groupSize.height + 8)
        if displayIdx == 3 then
            mjTilesReferPos.groupSpace.y = -mjTilesReferPos.groupSpace.y
        end
    else
        mjTilesReferPos.groupSpace = cc.p(groupSize.width + 8, 0)
        if displayIdx == 2 then
            mjTilesReferPos.groupSpace.x = -mjTilesReferPos.groupSpace.x
        end
    end

    -- 当前出牌展示位置
    local showMjTileNode = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Node_showMjTile")
    mjTilesReferPos.showMjTilePos = cc.p(showMjTileNode:convertToWorldSpace(showMjTileNode:getAnchorPointInPoints()))
    return mjTilesReferPos
end

-- start --
--------------------------------
-- @class function
-- @description 玩家麻将牌根据花色，编号重新排序
-- end --
function m:sortHoldMjTiles(roomPlayer)
    -- local roomPlayer = self.roomPlayers[seatIdx]

    -- 玩家持有牌不能看,不用排序
    if not roomPlayer.isHidden then
        -- 按照花色分类
        local colorsMjTiles = {}
        for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
            if not colorsMjTiles[mjTile.mjColor] then
                colorsMjTiles[mjTile.mjColor] = {}
            end
            table.insert(colorsMjTiles[mjTile.mjColor], mjTile)
        end
        -- dump(colorsMjTiles)

        -- 同花色从小到大排序
        local transMjTiles = {}
        for _, sameColorMjTiles in pairs(colorsMjTiles) do
            table.sort(sameColorMjTiles, function(a, b)
                return a.mjNumber < b.mjNumber
            end)
            for _, mjTile in ipairs(sameColorMjTiles) do
                table.insert(transMjTiles, mjTile)
            end
        end
        -- dump(transMjTiles)
        roomPlayer.holdMjTiles = transMjTiles
    end

    -- 更新摆放位置
    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.holdStart
    for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
        mjTile.mjTileSpr:setPosition(mjTilePos)
        self.playMjLayer:reorderChild(mjTile.mjTileSpr, (display.size.height - mjTilePos.y))
        mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.holdSpace)
    end
end

function m:removeHoldMjTiles(roomPlayer, mjColor, mjNumber, mjTilesCount)
    local transMjTiles = {}
    local count = 0
    for _, mjTile in ipairs(roomPlayer.holdMjTiles) do
        if roomPlayer.isHidden then
            if count < mjTilesCount then
                mjTile.mjTileSpr:removeFromParent()
                count = count + 1
            else
                table.insert(transMjTiles, mjTile)
            end
        else
            if count < mjTilesCount and mjTile.mjColor == mjColor and mjTile.mjNumber == mjNumber then
                mjTile.mjTileSpr:removeFromParent()
                count = count + 1
            else
                -- 保存其它牌
                table.insert(transMjTiles, mjTile)
            end
        end
    end
    roomPlayer.holdMjTiles = transMjTiles

    self:sortHoldMjTiles(roomPlayer)
end

-- start --
--------------------------------
-- @class function
-- @description 碰杠重新排序麻将牌,显示碰杠
-- @param seatIdx
-- @param mjColor
-- @param mjNumber
-- @param isBar
-- @param isBrightBar
-- @param isBrightBar -- 1-明杠,2-暗杠，3-特殊杠
-- @param cards -- 特殊杠-数据
-- @return
-- end --
function m:pungBarReorderMjTiles(roomPlayer, mjColor, mjNumber, isBar, isBrightBar,cards,typeFlag)
    local groupNode = nil
    local isEat = false
    if type(roomPlayer) == "number" then
        roomPlayer = self.roomPlayers[roomPlayer]
        isEat = true
    end

    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    -- 显示碰杠牌
    local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos
    groupNode = cc.Node:create()
    groupNode:setPosition(mjTilesReferPos.groupStartPos)
    self.playMjLayer:addChild(groupNode)
    local mjTilesCount = 3
    if isBar then
        if cards then
            mjTilesCount = #cards
        else
            mjTilesCount = 4
        end 
    end
    if isEat == true then
        for i = 1, mjTilesCount do
            local mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx, mjColor, mjNumber[i][1])
            mjTileSpr:setPosition(groupMjTilesPos[i])
            groupNode:addChild(mjTileSpr)
        end
        mjTilesReferPos.groupStartPos = cc.pAdd(mjTilesReferPos.groupStartPos, mjTilesReferPos.groupSpace)
        mjTilesReferPos.holdStart = cc.pAdd(mjTilesReferPos.holdStart, mjTilesReferPos.groupSpace)

        -- 更新持有牌
        self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber[1][1], 1)
        self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber[3][1], 1)
    else
        for i = 1, mjTilesCount do
            local mjTileSpr
            if cards then --特殊杠
                mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx, cards[i][1], cards[i][2])
            else
                mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx, mjColor, mjNumber)
            end
            if isBar and not isBrightBar and i <= 3 then
                -- 暗杠前三张牌扣着
                local img = DefineTile.getTileBGGang(roomPlayer.displayIdx)
                mjTileSpr = cc.Sprite:createWithSpriteFrameName(img)
            end
            if roomPlayer.displayIdx == 4 then
                mjTileSpr:setScale(n.outTileItemScale)
            end
            if cards and i > 3 then
                mjTileSpr:setPosition(groupMjTilesPos[i+1])
                if roomPlayer.displayIdx == 1 then
                    if i == 4 then
                        groupNode:addChild(mjTileSpr,-1,i)
                    else
                        groupNode:addChild(mjTileSpr,-2,i)
                    end
                elseif roomPlayer.displayIdx == 2 then
                    groupNode:addChild(mjTileSpr,0,i)
                elseif roomPlayer.displayIdx == 3 then
                    groupNode:addChild(mjTileSpr,0,i)
                elseif roomPlayer.displayIdx == 4 then
                    groupNode:addChild(mjTileSpr,-1,i)
                end
            else
                mjTileSpr:setPosition(groupMjTilesPos[i])
                groupNode:addChild(mjTileSpr,0,i)
            end

            if cards and cards[i][3]>1 then --特殊杠的数字
                local barSize = mjTileSpr:getContentSize()
                local msgContentLabel = gComm.LabelUtils.createTTFLabel("X"..cards[i][3], 18)
                if roomPlayer.displayIdx == 1 then
                    msgContentLabel:setPosition(10, barSize.height-10)
                elseif roomPlayer.displayIdx == 2 then
                    msgContentLabel:setPosition(13,21)
                elseif roomPlayer.displayIdx == 3 then
                    msgContentLabel:setPosition(barSize.width-10, 24)
                elseif roomPlayer.displayIdx == 4 then
                    msgContentLabel:setPosition(barSize.width-13, barSize.height-10)
                end
                msgContentLabel:setRotation(-90*roomPlayer.displayIdx)
                mjTileSpr:addChild(msgContentLabel,10,10)
            end
        end
        mjTilesReferPos.groupStartPos = cc.pAdd(mjTilesReferPos.groupStartPos, mjTilesReferPos.groupSpace)
        mjTilesReferPos.holdStart = cc.pAdd(mjTilesReferPos.holdStart, mjTilesReferPos.groupSpace)

        -- 更新持有牌
        -- 碰2张
        local mjTilesCount = 2
        if isBar then
            -- 明杠3张
            mjTilesCount = 3
            -- 暗杠4张
            if not isBrightBar then
                mjTilesCount = 4
            end
        end
        if cards then
            for i,v in ipairs(cards) do
                self:removeHoldMjTiles(roomPlayer, v[1], v[2], v[3])
            end
        else
            self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber, mjTilesCount)
        end 
        
    end
    -- end

    return groupNode
end

-- start --
--------------------------------
-- @class function
-- @description 自摸碰变成明杠
-- @param seatIdx
-- @param mjColor
-- @param mjNumber
-- end --
function m:changePungToBrightBar(seatIdx, mjColor, mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]
    -- 从持有牌中移除
    self:removeHoldMjTiles(roomPlayer, mjColor, mjNumber, 1)

    -- 查找碰牌
    local brightBarData = nil
    for i, pungData in ipairs(roomPlayer.mjTilePungs) do
        if pungData.mjColor == mjColor and pungData.mjNumber == mjNumber then
            -- 从碰牌列表中删除
            brightBarData = pungData
            table.remove(roomPlayer.mjTilePungs, i)
            break
        end
    end

    -- 添加到明杠列表
    if brightBarData then
        -- 加入杠牌第4个牌
        local mjTilesReferPos = roomPlayer.mjTilesReferPos
        local groupMjTilesPos = mjTilesReferPos.groupMjTilesPos
        local mjTileSpr = LayerTileOut:create(roomPlayer.displayIdx, mjColor, mjNumber)
        if 4 == roomPlayer.displayIdx then
            mjTileSpr:setScale(n.outTileItemScale)
        end
        mjTileSpr:setPosition(groupMjTilesPos[4])
        brightBarData.groupNode:addChild(mjTileSpr)
        table.insert(roomPlayer.mjTileBrightBars, brightBarData)
    end
end

-- start --
--------------------------------
-- @class function
-- @description 移除上家被下家，杠打出的牌
-- end --
function m:removePrePlayerOutMjTile()

    dump("m:removePrePlayerOutMjTile")
    
    -- 移除上家打出的牌
    if self.prePlaySeatIdx then
        local roomPlayer = self.roomPlayers[self.prePlaySeatIdx]
        local endIdx = #roomPlayer.outMjTiles
        local outMjTile = roomPlayer.outMjTiles[endIdx]
        outMjTile.mjTileSpr:removeFromParent()
        table.remove(roomPlayer.outMjTiles, endIdx)

        -- 隐藏出牌标识箭头
        self.outMjtileSignNode:setVisible(false)
    end
end

-- start --
--------------------------------
-- @class function
-- @description 显示玩家接炮胡，自摸胡，明杠，暗杠，碰动画显示
-- @param seatIdx 座位索引
-- @param decisionType 决策类型
-- end --
function m:showDecisionAnimation(seatIdx, decisionType)
        log("出牌类型是：")
        log(decisionType)
        -- 接炮胡，自摸胡，明杠，暗杠，碰文件后缀
        local decisionSuffixs = {1, 4, 2, 2, 3, 5, 6, 6, 10}
        local decisionSfx = {"hu", "zimo", "gang", "gang", "peng" ,"chi", "bu", "bu","guo","ting" }
        -- 显示决策标识
        local roomPlayer = self.roomPlayers[seatIdx]
        local deciName = "Image/IRoom/DecisionBtn/dec_"..decisionSfx[decisionType] ..".png"
        local decisionSignSpr = cc.Sprite:createWithSpriteFrameName(deciName)
        decisionSignSpr:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
        self.rootNode:addChild(decisionSignSpr, DefineRoom.PlayZOrder.DECISION_SHOW)
        -- 标识显示动画
        decisionSignSpr:setScale(0)
        local scaleToAction = cc.ScaleTo:create(0.2, 1)
        local easeBackAction = cc.EaseBackOut:create(scaleToAction)
        local fadeOutAction = cc.FadeOut:create(0.5)
        local callFunc = cc.CallFunc:create(function(sender)
            -- 播放完后移除
            sender:removeFromParent()
        end)
        local seqAction = cc.Sequence:create(easeBackAction, fadeOutAction, callFunc)
        decisionSignSpr:runAction(seqAction)

        local index = SceneMJHuaiBei.SoundDecisionType[decisionType]
        if index then
            SoundMng.playEffect(index,roomPlayer.sex)
        end
end

-- start --
--------------------------------
-- @class function
-- @description 展示杠两张牌
-- end --
function m:showBarTwoCardAnimation(seatIdx,cardList)
    local roomPlayer = self.roomPlayers[seatIdx]

    local mjTileSpr = SpriteTileOpen:create(2, 2)
    local width_oneMJ = mjTileSpr:getContentSize().width
    local width = 30+mjTileSpr:getContentSize().width*(#cardList)
    local height = 24+mjTileSpr:getContentSize().height
    -- 添加半透明底
    local image_bg = ccui.ImageView:create()
    image_bg:loadTexture("")
    image_bg:setScale9Enabled(true)
    image_bg:setCapInsets(cc.rect(10,10,1,1))
    image_bg:setContentSize(cc.size(width,height))
    image_bg:setAnchorPoint(cc.p(0.5,0.5))
    self.rootNode:addChild(image_bg,DefineRoom.PlayZOrder.HAIDILAOYUE)
    image_bg:setScale(0)
    -- 设置坐标位置
    local  m_curPos_x = 1
    local  m_curPos_y = 1
    if roomPlayer.displayIdx == 1 or roomPlayer.displayIdx == 3 then
        m_curPos_x = roomPlayer.mjTilesReferPos.holdStart.x
        m_curPos_y = roomPlayer.mjTilesReferPos.showMjTilePos.y
    elseif roomPlayer.displayIdx == 2 or roomPlayer.displayIdx == 4 then
        m_curPos_x = roomPlayer.mjTilesReferPos.showMjTilePos.x
        m_curPos_y = roomPlayer.mjTilesReferPos.showMjTilePos.y
    end

    -- image_bg:setPosition(roomPlayer.mjTilesReferPos.showMjTilePos)
    image_bg:setPosition(cc.p(m_curPos_x,m_curPos_y))

    local tileBG = DefineTile.getBottomOpenTile(0, 0)
    -- 添加两个麻将
    log("添加两个麻将")
    dump(cardList)
    for _,v in pairs(cardList) do
        local image_mj = ccui.Button:create()
        image_mj:loadTextures(tileBG,tileBG,"",ccui.TextureResType.plistType)
        image_mj:setAnchorPoint(cc.p(0,0))
        image_mj:setPosition(cc.p(15+width_oneMJ*(_-1), 10))
        image_bg:addChild(image_mj)
        
        local mjSprName = DefineTile.getBottomOpenTile(mjColor, mjNumber)
        local spr = cc.Sprite:createWithSpriteFrameName(mjSprName)
        image_mj:addChild(spr)
        local size = image_mj:getContentSize()
        spr:setPosition(size.width*0.5,size.height*0.5)
    end

    -- 播放动画
    local scaleToAction = cc.ScaleTo:create(0.2, 1)
    local easeBackAction = cc.EaseBackOut:create(scaleToAction)
    local present_delayTime = cc.DelayTime:create(1.5)
    local fadeOutAction = cc.FadeOut:create(0.5)
    local callFunc_dontPresent = cc.CallFunc:create(function(sender)
        -- 播放完后隐藏
        sender:setVisible(false)
    end)
    local callFunc_present_first = cc.CallFunc:create(function(sender)
        -- 打出第一张牌
        log("打出第一张牌")
        for idx,data in pairs(cardList) do
            if 1 == idx then
                self:discardsOneCard(seatIdx,data[1], data[2])
                break
            end
        end
    end)
    local delayTime_f_s = cc.DelayTime:create(0.7)
    local callFunc_present_second = cc.CallFunc:create(function(sender)
        -- 打出第二张牌
        log("打出第二张牌")
        for idx,data in pairs(cardList) do
            if 2 == idx then
                self:discardsOneCard(seatIdx,data[1], data[2])
                break
            end
        end
    end)
    local callFunc_remove = cc.CallFunc:create(function(sender)
        -- 播放完后移除
        sender:removeFromParent()
    end)
    local seqAction = cc.Sequence:create(easeBackAction, present_delayTime, fadeOutAction, callFunc_dontPresent,
        callFunc_present_first, delayTime_f_s, callFunc_present_second,callFunc_remove)
    image_bg:runAction(seqAction)

end

function m:discardsOneCard(seatIdx,mjColor,mjNumber)
    log("先出一张牌")
    -- log(seatIdx)
    -- log(mjColor)
    -- log(mjNumber)
    local roomPlayer = self.roomPlayers[seatIdx]
    -- log("roomPlayer")
    -- dump(roomPlayer)
    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    -- log("mjTilesReferPos")
    -- dump(mjTilesReferPos)
    local mjTilePos = mjTilesReferPos.holdStart
    -- log("mjTilePos")
    -- dump(mjTilePos)
    -- print(mjTilesReferPos.holdSpace)
    -- print(roomPlayer.mjTilesRemainCount)
    -- local realpos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, roomPlayer.mjTilesRemainCount))

    -- log("realpos")
    -- dump(realpos)
    -- 显示出的牌
    self:outMjTile(roomPlayer, mjColor, mjNumber)
    -- 显示出的牌箭头标识
    self:showOutMjtileSign(roomPlayer)

    -- 记录出牌的上家
    self.preShowSeatIdx = seatIdx

    -- dj revise
    SoundMng.PlayCardSound(roomPlayer.sex, mjColor, mjNumber)
end

-- start --
--------------------------------
-- @class function
-- @description 显示指示出牌标识箭头动画
-- @param seatIdx 座次
-- end --
function m:showOutMjtileSign(roomPlayer)
    -- local roomPlayer = self.roomPlayers[seatIdx]
    local endIdx = #roomPlayer.outMjTiles
    local outMjTile = roomPlayer.outMjTiles[endIdx]
    self.outMjtileSignNode:setVisible(true)
    self.outMjtileSignNode:setPosition(outMjTile.mjTileSpr:getPosition())
end

-- start --
--------------------------------
-- @class function
-- @description 显示出牌动画
-- @param seatIdx 座次
-- end --
function m:showOutMjTileAnimation(roomPlayer, mjColor, mjNumber, cbFunc)
    local rotateAngle = {-90, 180, 90, 0}
    
    local mjTileSpr = SpriteTileOpen:create(mjColor, mjNumber)
    self.rootNode:addChild(mjTileSpr, 98)

    -- 出牌位置
    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.holdStart
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.holdSpace, #roomPlayer.holdMjTiles))
    mjTilePos = cc.pAdd(mjTilePos, mjTilesReferPos.drawSpace)
    mjTileSpr:setPosition(mjTilePos)
    mjTileSpr:setRotation(rotateAngle[roomPlayer.displayIdx])
    local moveToAc_1 = cc.MoveTo:create(0.3, roomPlayer.mjTilesReferPos.showMjTilePos)
    local rotateToAc_1 = cc.RotateTo:create(0.15, 0)

    local delayTime = cc.DelayTime:create(0.3)

    local mjTilesReferPos = roomPlayer.mjTilesReferPos
    local mjTilePos = mjTilesReferPos.outStart
    local mjTilesCount = #roomPlayer.outMjTiles + 1

    local lineTotlaCount = 10
    if self.gamePlayerNum == 2 then
        lineTotlaCount = 14
    end
    local lineCount = math.ceil(mjTilesCount / lineTotlaCount) - 1
    local lineIdx = mjTilesCount - lineCount * lineTotlaCount - 1
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceV, lineCount))
    mjTilePos = cc.pAdd(mjTilePos, cc.pMul(mjTilesReferPos.outSpaceH, lineIdx))

    local moveToAc_2 = cc.MoveTo:create(0.3, mjTilePos)
    local rotateToAc_2 = cc.RotateTo:create(0.15, rotateAngle[roomPlayer.displayIdx])
    local callFunc = cc.CallFunc:create(function(sender)
        sender:removeFromParent()

        cbFunc()
    end)
    mjTileSpr:runAction(cc.Sequence:create(cc.Spawn:create(moveToAc_1, rotateToAc_1),
                                        delayTime,
                                        cc.Spawn:create(moveToAc_2, rotateToAc_2),
                                        callFunc));
end

-- start --
--------------------------------
-- @class function
-- @description 显示听牌标志
-- @param seatIdx 座次
-- end --
function m:showtTingSign(seatIdx)
    -- local roomPlayer = self.roomPlayers[seatIdx]
    -- local playerInfoNode = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_playerInfo_" .. roomPlayer.displayIdx)
    -- local Spr_tingSign = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_tingSign")
    -- Spr_tingSign:setVisible(true)
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