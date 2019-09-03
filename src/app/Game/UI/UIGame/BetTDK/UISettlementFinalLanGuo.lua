
local gComm = cc.exports.gComm

local csbFile = "Csd/SubGame/BetTDK/UISettlementFinal.csb"
local m = class("UISettlementFinalLanGuo", function()
    return cc.LayerColor:create(cc.c4b(85, 85, 85, 85), display.size.width, display.size.height)
end)

function m:ctor(rptMsgTbl, roomPlayers)
    dump(rptMsgTbl)
    -- 注册节点事件
    self:registerScriptHandler(handler(self, self.onNodeEvent))

    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    self.rootNode = csbNode

    local bg = gComm.UIUtils.seekNodeByName(csbNode, "Image_bg")
    bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

    local Image_end = gComm.UIUtils.seekNodeByName(csbNode, "Image_end")
    Image_end:setVisible(false)

    local Image_1 = gComm.UIUtils.seekNodeByName(csbNode, "Image_1")
    Image_1:setVisible(false)
    
    local Tex_time = gComm.UIUtils.seekNodeByName(csbNode, "Text_time")
    local time = os.date("%x") .. " ".. os.date("%X")
    Tex_time:setString(time)

    local roomNumberLabel = gComm.UIUtils.seekNodeByName(csbNode, "Text_roomid")
    roomNumberLabel:setString(string.format("%d",rptMsgTbl.roomID))
    local roomtypeLabel = gComm.UIUtils.seekNodeByName(csbNode, "Text_playType")
    local m_playTypeDesc = "rule"
    roomtypeLabel:setString(" "..m_playTypeDesc)

    for i=1,5 do
        local playerReportNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_player_" .. i)
        playerReportNode:setVisible(false)
    end

    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()

    local totalPeople = #roomPlayers
        
    local winSeatIdx = 1
    local currentGold = 0
    
    for seatIdx, roomPlayer in ipairs(roomPlayers) do
        local playerReportNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_player_" .. seatIdx)
        playerReportNode:setVisible(true)

        gComm.UIUtils.seekNodeByName(playerReportNode, "spr_win"):setVisible(false)

        if totalPeople == 2 then --重新排位置
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(240*seatIdx, -69)))
        elseif totalPeople == 3 then
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(120*seatIdx,  -69)))
        elseif totalPeople == 4 then
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(60*seatIdx,  -69)))
        end

        -- 玩家信息
        local playerInfoNode = gComm.UIUtils.seekNodeByName(playerReportNode, "Node_info")
        -- 头像
        local spr_head = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
        playerHeadMgr:attach(spr_head, roomPlayer.uid, roomPlayer.headURL)

        -- 昵称
        local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_nickname")
        nicknameLabel:setString(gComm.StringUtils.GetShortName(roomPlayer.nickname))
        -- uid
        local uidLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_uid")
        uidLabel:setString("ID:" .. roomPlayer.uid)

        -- 房主
        local spr_homeOwner = gComm.UIUtils.seekNodeByName(playerReportNode, "Sprite_houseOwner")
        spr_homeOwner:setVisible(false)

        local ownerName = rptMsgTbl.m_roomMasterNike
        if seatIdx == 1 then
            -- 0号位置是房主
            if rptMsgTbl.m_RoomType == 0 then
                spr_homeOwner:setVisible(true)
            end
        end

        local reportListV = gComm.UIUtils.seekNodeByName(playerReportNode, "List_score")

        local vecData = {}
        local languocount = 1
        local languoTotal = 0
        for i=1,30 do
            if rptMsgTbl["m_lanGuoCount"..languocount] then
                languoTotal = languoTotal + 1
            end
        end
        for i=1,30 do
            if rptMsgTbl["m_lanGuoCount"..languocount] then
                vecData = rptMsgTbl["m_lanGuoCount"..languocount]


                local file = "Csd/IRoom/Item/ItemFinalScore.csb"
                local cellNode = cc.CSLoader:createNode(file)

                -- local imgBG = gComm.UIUtils.seekNodeByName(cellNode, "imgBG")
                -- if languocount % 2 == 1 then
                --     imgBG:setVisible(true)
                -- else
                --     imgBG:setVisible(false)
                -- end
                local txtName = gComm.UIUtils.seekNodeByName(cellNode, "txtName")
                if i == languoTotal then
                    txtName:setString("烂锅结束局")
                else
                    txtName:setString("烂锅第" .. str .. "局")
                end
                local txtScore = gComm.UIUtils.seekNodeByName(cellNode, "txtScore")
                txtScore:setString(vecData[roomPlayer.seatIdx])

                local cellSize = cellNode:getContentSize()
                local cellItem = ccui.Widget:create()
                cellItem:setTag(i)
                cellItem:setTouchEnabled(true)
                cellItem:setContentSize(cellSize)
                cellItem:addChild(cellNode)
                reportListV:pushBackCustomItem(cellItem)
                languocount = languocount+1
            else
                break
            end
        end

        -- 总成绩
        local totalScoreLabel = gComm.UIUtils.seekNodeByName(playerReportNode, "Label_totalScore")
        totalScoreLabel:setVisible(false)

        local Label_total = gComm.UIUtils.seekNodeByName(playerReportNode, "Label_total")
        Label_total:setVisible(false)
    end


    -- 返回游戏大厅
    local backBtn = gComm.UIUtils.seekNodeByName(csbNode, "Button_back")
    gComm.BtnUtils.setButtonClick(backBtn, function()
        self:removeFromParent()
    end)

    -- 分享
    local shareBtn = gComm.UIUtils.seekNodeByName(csbNode, "Button_share")
    shareBtn:setVisible(false)


    local btnCopy = gComm.UIUtils.seekNodeByName(csbNode, "btnCopy")
    btnCopy:setVisible(false)
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

return m