local gt = cc.exports.gt
local gComm = cc.exports.gComm

local NetCmd = require("app.Common.NetMng.NetCmd")
local UISettlementFinalLanGuo = require("app.Game.UI.UIGame.BetTDK.UISettlementFinalLanGuo")
local EventCmdID = require("app.Common.Config.EventCmdID")
local m = class("UISettlementOneRound", function()
    return cc.Layer:create()
end)

function m:ctor( msgData, roomPlayers, playerSeatIdx )

    self.msgData = msgData
    self.roomPlayers = roomPlayers
    self.playerSeatIdx = playerSeatIdx
    -- 注册节点事件
    self:registerScriptHandler(handler(self, self.onNodeEvent))

    self:initVariables(msgData, roomPlayers, playerSeatIdx)

    self.m_end = 0
    if msgData.m_end then
        self.m_end = msgData.m_end
    end
    self:initUIWidget()
end

function m:initVariables( data, roomPlayers, playerSeatIdx )
    self.playerSeatIdx = playerSeatIdx
    self.data = data
    self.roomPlayers = roomPlayers
end

function m:initUIWidget(  )
    self:initRootNode()

    self:initPlayTypeLabel()

    self:initRoomId()

    self:initTimeLabel()

    self:initPlayerInfo()

    self:initNextBtn()
    
    self:initLanguoBtn()
end

local csbFile = "Csd/SubGame/BetTDK/UISettlementOneRound.csb"

function m:initRootNode(  )
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self.rootNode = csbNode
    self:addChild(csbNode)

    local bg = gComm.UIUtils.seekNodeByName(csbNode, "Image_bg")
    bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))
end

function m:initPlayTypeLabel()
    local playDesc = "rule"
    local label = gComm.UIUtils.seekNodeByName(self.rootNode, "Text_playPara")
    label:setString(" "..playDesc)
end

function m:initRoomId(  )
    local label = gComm.UIUtils.seekNodeByName(self.rootNode, "Text_roomid")
    label:setString(self.data.roomID)
end

function m:initTimeLabel(  )
    local label = gComm.UIUtils.seekNodeByName(self.rootNode, "Text_time")
    local time = os.date("%x") .. " ".. os.date("%X")
    label:setString(time)
end

function m:initPlayerInfo(  )
    for i=1,5 do
        local playerInfo = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_player_"..i)
        playerInfo:setVisible(false)
    end
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()

    dump(self.roomPlayers , "[log_zxh] roomPlayers 111")

    -- 交换赢家位置
    dump(self.data.m_isOver , "[log_zxh] m_isOver")
    dump(self.data.score , "[log_zxh] m_score")
    dump(self.data.m_win , "[log_zxh] m_win")
    dump(self.data , "[log_zxh] data")

    -- 0 win   1 giveup   2 lose  3 平局

    local isPing = false
    local winPos = 0
    -- 判断是否是平局
    if self.data.m_winList and #self.data.m_winList ~= 1 then
        isPing = true
    end

    for seatId,roomPlayer in ipairs(self.roomPlayers) do
        if isPing then
            roomPlayer.winStatus = 4
            if #self.data.m_winList > 0 then
                for i=1,#self.data.m_winList do
                    if self.data.m_winList[i] + 1 == seatId then
                        roomPlayer.winStatus = 3
                    end
                end
            end
        else
            if #self.data.m_winList == 1 then
                -- 有赢家  有输
                if self.data.m_winList[1] + 1 == seatId then
                    -- 赢家
                    roomPlayer.winStatus = 0
                else
                    roomPlayer.winStatus = 2
                    -- 输家
                    if self.data.m_isOver[seatId] == 1 then
                        roomPlayer.winStatus = 1
                    end
                end
            end
        end
        roomPlayer.score = self.data.m_score[seatId]
        roomPlayer.cardType = self.data.m_win[seatId]
        roomPlayer.data = self.data["array"..(seatId-1)]
        roomPlayer.cardType = self.data.m_win[seatId]
        roomPlayer.cardPoint = self.data.m_rewardScore[seatId]
    end

    table.sort(self.roomPlayers , function (a , b)
        return a.winStatus < b.winStatus
    end)
    -- 判断是否带豹子
    local isDaiBaozi = false
    for k,v in pairs(self.data.m_playPara) do
        if v == 111 then
            isDaiBaozi = true
        end
    end

    -- 各个玩家具体情况
    for seatId,roomPlayer in ipairs(self.roomPlayers) do
        local realPos = seatId
        local playerInfo = gComm.UIUtils.seekNodeByName(self.rootNode, "Node_player_"..realPos)
        playerInfo:setVisible(true)
        -- 房主
        local Sprite_houseOwner = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_houseOwner")
        Sprite_houseOwner:setVisible(false)
        -- 昵称
        local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfo, "Text_name")
        nicknameLabel:setString(gComm.StringUtils.GetShortName(roomPlayer.nickname))
        --积分
        local scoreLabel = gComm.UIUtils.seekNodeByName(playerInfo, "BitmapFontLabel_score")
        scoreLabel:setString(roomPlayer.score)

        local idLabel = gComm.UIUtils.seekNodeByName(playerInfo, "Text_id")
        idLabel:setString("ID: "..roomPlayer.uid)

        -- 显示牌型和点数
        local Sprite_cardType = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_cardType")
        local Sprite_cardType_0 = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_cardType_0")

        
        local BitmapFontLabel_point = gComm.UIUtils.seekNodeByName(playerInfo, "BitmapFontLabel_point")
        BitmapFontLabel_point:setVisible(false)
        Sprite_cardType:setVisible(false)
        Sprite_cardType_0:setVisible(false)

        if BitmapFontLabel_point then
            BitmapFontLabel_point:setVisible(true)
            BitmapFontLabel_point:setString(roomPlayer.cardPoint)
        end
        
        -- 显示牌型
        if Sprite_cardType and roomPlayer.cardType < 5 then
            Sprite_cardType:setVisible(true)
            Sprite_cardType:setSpriteFrame(self:getCardType(roomPlayer.cardType))
        end
        if roomPlayer.cardType == 6 then -- 双王  豹子
            Sprite_cardType:setVisible(true)
            Sprite_cardType:setSpriteFrame(self:getCardType(3))
            Sprite_cardType_0:setVisible(true)
        end

        --[[local cardTypeSpr = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_cardType")
        local path = self:getCardType(roomPlayer.cardType)
        if path then
            cardTypeSpr:setSpriteFrame(self:getCardType(roomPlayer.cardType))
        else
            cardTypeSpr:setVisible(false)
        end--]]

        -- 对展示的牌进行排序
        -- [1] = "Image/GameSub/GameZJH/sanpai.png", --2 3 5
        -- [2] = "Image/GameSub/GameZJH/sanpai.png", --散牌
        -- [3] = "Image/GameSub/GameZJH/duizi.png", --对子
        -- [4] = "Image/GameSub/GameZJH/shunzi.png", --顺子
        -- [5] = "Image/GameSub/GameZJH/jinhua.png", --金花
        -- [6] = "Image/GameSub/GameZJH/shunjin.png", --顺金
        -- [7] = "Image/GameSub/GameZJH/baozi.png" --豹子

        local array   = roomPlayer.data
        --[[local cardType = roomPlayer.cardType
        if cardType == 1 or cardType == 2 or cardType == 5 then
            -- 散牌  金花
            self:sortSanPai(array)
        elseif cardType == 4 or cardType == 6 then
            -- 顺子  顺金
            self:sortShunZi(array)
        elseif cardType == 3 then
            -- 对子
            self:sortDuiZi(array)
        elseif cardType == 7 then
            self:sortBaoZi(array)
        end--]]

        -- 隐藏所有的扑克
        for i=1,5 do
            local cardSpr = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_card"..i)
            cardSpr:setVisible(false)
        end


        for i=1,#array do
            local cardSpr = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_card"..i)
            cardSpr:setVisible(true)
            local pkTileName = string.format("Image/CardsPoker/p%d_%d.png",array[i][1], array[i][2])
            cardSpr:setSpriteFrame(pkTileName)
            cardSpr:setScale(0.6)
        end

        local winSpr = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_win")
        if roomPlayer.winStatus == 0 then --win
            winSpr:setSpriteFrame("Image/GameSub/GameZJH/winSettle.png")
        elseif roomPlayer.winStatus == 1 then --giveup
            winSpr:setSpriteFrame("Image/GameSub/GameZJH/giveupSettle.png")
        elseif roomPlayer.winStatus == 2 then --lose
            winSpr:setSpriteFrame("Image/GameSub/GameZJH/loseSettle.png")
        elseif roomPlayer.winStatus == 3 then  -- 平局
            winSpr:setSpriteFrame("Image/GameSub/GameZJH/pingSettle.png")
        elseif roomPlayer.winStatus == 4 then
            winSpr:setVisible(false)
        end
        
        -- 头像
        local headSpr = gComm.UIUtils.seekNodeByName(playerInfo, "Sprite_head")
        
        playerHeadMgr:attach(headSpr, roomPlayer.uid, roomPlayer.headURL)

        -- 显示房主标签
        if roomPlayer.seatIdx == 1 then
            if self.data.m_RoomType == 0 then
                Sprite_houseOwner:setVisible(true)
            end
        end
    end
end

function m:getCardType( cardType )
    local tt = {
        [1] = "Image/GameSub/GameZJH/font_baozi.png", --豹子
        [2] = "Image/GameSub/GameZJH/font_sitiao.png", --四条
        [3] = "Image/GameSub/GameZJH/font_shuangwang.png" , --双王
        [4] = "Image/GameSub/GameZJH/font_wangzhongpao.png", --王中炮 
    }

    return tt[cardType] or nil
end

function m:initNextBtn(  )
    local nextBtn = gComm.UIUtils.seekNodeByName(self.rootNode, "Button_next")
    if self.m_end == 1 then
        -- 结束
        local mjTileName = "Image/GameSub/GameZJH/btn_end.png"
        nextBtn:loadTextures(mjTileName,mjTileName,mjTileName,ccui.TextureResType.plistType)
    end

    gComm.BtnUtils.setButtonClick(nextBtn, function()
        if self.m_end and self.m_end ~= 1 then
            local msgToSend = {}
            msgToSend.m_msgId = NetCmd.MSG_CG_READY
            msgToSend.m_pos = self.playerSeatIdx
            gt.socketClient:sendMessage(msgToSend)
        else
            gComm.EventBus.dispatchEvent(EventCmdID.EventType.ZJH_ADD_FINALREPORT)
        end
        self:removeFromParent()
    end)
end

function m:initLanguoBtn()
    local Button_languo = gComm.UIUtils.seekNodeByName(self.rootNode, "Button_languo")

    Button_languo:setVisible(self.msgData.m_lanGuoCount1 and #self.msgData.m_lanGuoCount1 > 0)
    gComm.BtnUtils.setButtonClick(Button_languo, function()
        local languoReport = UISettlementFinalLanGuo:create(self.msgData, 
            self.roomPlayers, self.playerSeatIdx)
        self:addChild(languoReport, 69)
    end)
end

function m:onNodeEvent(eventName)
    if "enter" == eventName then
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    elseif "exit" == eventName then
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:removeEventListenersForTarget(self)
    end
end

function m:onTouchBegan(touch, event)
    return true
end

function m:sortDuiZi(cardList)
    -- array[i][1]
    local sameCard = 1
    local card1Amount = 0
    local defaultCard = cardList[1][2]
    -- local card2Amount = 1
    for i,v in ipairs(cardList) do
        if v[2] == defaultCard then
            card1Amount = card1Amount + 1
        end
    end

    if card1Amount == 2 then
        sameCard = defaultCard
    else
        sameCard = cardList[2][2]
    end

    for i,v in ipairs(cardList) do
        if v[2] == sameCard then
            v.sameCard = 2
        else
            v.sameCard = 1
        end
        v.cardColor = v[1]
    end

    table.sort(cardList, function(a, b)
        if a.sameCard ~= b.sameCard then
            return a.sameCard > b.sameCard
        elseif a.sameCard == b.sameCard then
            return a.cardColor < b.cardColor
        end
    end)
end

function m:sortShunZi(cardList)
    table.sort(cardList, function(a, b)
        return a[2] < b[2]
    end)
end

function m:sortSanPai( cardList)
    for i,v in ipairs(cardList) do
        if v[2] == 1 then
            v.cardNum = v[2] + 13
        else
            v.cardNum =  v[2]
        end
    end
    table.sort(cardList, function(a, b)
        return a.cardNum > b.cardNum
    end)
end

function m:sortBaoZi( cardList )
    table.sort(cardList, function(a, b)
        return a[1] < b[1]
    end)
end

return m