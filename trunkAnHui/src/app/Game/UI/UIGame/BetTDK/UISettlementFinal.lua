
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local EventCmdID = require("app.Common.Config.EventCmdID")

local csbFile = "Csd/SubGame/BetTDK/UISettlementFinal.csb"
local m = class("UISettlementFinal", function()
    return cc.LayerColor:create(cc.c4b(85, 85, 85, 85), display.size.width, display.size.height)
end)

function m:ctor(rptMsgTbl, roomPlayers)
    -- 注册节点事件
    self:registerScriptHandler(handler(self, self.onNodeEvent))

    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    self:addChild(csbNode)
    self.rootNode = csbNode

    local bg = gComm.UIUtils.seekNodeByName(csbNode, "Image_bg")
    bg:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

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
    for i,v in ipairs(rptMsgTbl.m_gold) do
        if v >= currentGold then
            currentGold = v
            winSeatIdx = i
        end
    end
    self.copyStr = "结算：\n"
    for seatIdx, roomPlayer in ipairs(roomPlayers) do
        local playerReportNode = gComm.UIUtils.seekNodeByName(csbNode, "Node_player_" .. seatIdx)
        playerReportNode:setVisible(true)

        if winSeatIdx ~= seatIdx then
            gComm.UIUtils.seekNodeByName(playerReportNode, "spr_win"):setVisible(false)
        end

        if totalPeople == 2 then --重新排位置
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(240*seatIdx, -69)))
        elseif totalPeople == 3 then
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(120*seatIdx, -69)))
        elseif totalPeople == 4 then
            playerReportNode:setPosition(cc.pAdd(cc.p(0, 0), cc.p(50*seatIdx, -69)))
        end

        -- 玩家信息
        local playerInfoNode = gComm.UIUtils.seekNodeByName(playerReportNode, "Node_info")
        -- 头像
        -- local headSpr = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")

        local spr_head = gComm.UIUtils.seekNodeByName(playerInfoNode, "Spr_head")
        playerHeadMgr:attach(spr_head, roomPlayer.uid, roomPlayer.headURL)

        -- 昵称
        local nicknameLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_nickname")
        nicknameLabel:setString(gComm.StringUtils.GetShortName(roomPlayer.nickname))

        self.copyStr = self.copyStr .. roomPlayer.nickname
        -- uid
        local uidLabel = gComm.UIUtils.seekNodeByName(playerInfoNode, "Label_uid")
        uidLabel:setString("ID:" .. roomPlayer.uid)

        self.copyStr = self.copyStr .."(ID:" ..roomPlayer.uid..")"

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
        if seatIdx == 1 then
            vecData = rptMsgTbl.m_result1
        elseif seatIdx == 2 then
            vecData = rptMsgTbl.m_result2
        elseif seatIdx == 3 then
            vecData = rptMsgTbl.m_result3
        elseif  seatIdx == 4 then
            vecData = rptMsgTbl.m_result4
         elseif  seatIdx == 5 then
            vecData = rptMsgTbl.m_result5
        end
        for i, v in ipairs(vecData) do
            local file = "Csd/IRoom/Item/ItemFinalScore.csb"
            local cellNode = cc.CSLoader:createNode(file)

            local tag = i
            -- local imgBG = gComm.UIUtils.seekNodeByName(cellNode, "imgBG")
            -- if tag % 2 == 1 then
            --     imgBG:setVisible(true)
            -- else
            --     imgBG:setVisible(false)
            -- end
            local txtName = gComm.UIUtils.seekNodeByName(cellNode, "txtName")
            txtName:setString("第" .. tag .. "局")

            local txtScore = gComm.UIUtils.seekNodeByName(cellNode, "txtScore")
            txtScore:setString(v)

            local cellSize = cellNode:getContentSize()
            local cellItem = ccui.Widget:create()
            cellItem:setTag(tag)
            cellItem:setTouchEnabled(true)
            cellItem:setContentSize(cellSize)
            cellItem:addChild(cellNode)
            reportListV:pushBackCustomItem(cellItem)
        end

        -- 总成绩
        local totalScoreLabel = gComm.UIUtils.seekNodeByName(playerReportNode, "Label_totalScore")
        totalScoreLabel:setString(tostring(rptMsgTbl.m_gold[seatIdx]))

        self.copyStr = self.copyStr .. "   " ..rptMsgTbl.m_gold[seatIdx].. "\n"
    end


    -- 返回游戏大厅
    local backBtn = gComm.UIUtils.seekNodeByName(csbNode, "Button_back")
    gComm.BtnUtils.setButtonClick(backBtn, function()
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)
    end)

    -- 分享
    local shareBtn = gComm.UIUtils.seekNodeByName(csbNode, "Button_share")
    gComm.BtnUtils.setButtonClick(shareBtn, function()
        shareBtn:setEnabled(false)
        self:screenshotShareToWX()
        shareBtn:setEnabled(true)
    end)

    -- 复制
    local btnCopy = gComm.UIUtils.seekNodeByName(csbNode, "btnCopy")
    gComm.BtnUtils.setButtonClick(btnCopy, function()
        local ok
        if gComm.FunUtils.IsiOSPlatform() then
            local luaoc = require("cocos/cocos2d/luaoc")
            ok = luaoc.callStaticMethod("AppController", "copyText", {copyText = self.copyStr})
        elseif gComm.FunUtils.IsAndroidPlatform() then
            local luaj = require("cocos/cocos2d/luaj")
            ok = luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "copyText", {self.copyStr}, "(Ljava/lang/String;)V")
        end

        if ok then
            gComm.UIUtils.floatText("复制成功")
        end
    end)

    if cc.exports.gGameConfig.isiOSAppInReview then
        shareBtn:setVisible(false)
        backBtn:setPositionX(640)
    else
        shareBtn:setVisible(true)
    end
end

function m:screenshotShareToWX()
    local screenshotFileName = string.format("wx-%s.jpg", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
    gComm.UIUtils.screenshot(screenshotFileName)

    self.shareImgFilePath = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName
    self.scheduleHandler = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 0, false)
end

function m:update()
    if self.shareImgFilePath and cc.FileUtils:getInstance():isFileExist(self.shareImgFilePath) then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleHandler)

        local _type = gCallNativeMng.shareType.WeiXin
        gCallNativeMng:shareImage(_type,self.shareImgFilePath,"title~~~","desc~~~",function()
            -- body
        end)
        self.shareImgFilePath = nil
    end
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