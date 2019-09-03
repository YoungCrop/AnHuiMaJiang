
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local DefineHuPai = require("app.Common.Config.DefineHuPai")
local DefineRule = require("app.Common.Config.DefineRule")
local ItemSettlementFinal = require("app.Game.UI.UIGame.UIGameComm.ItemSettlementFinal")
local EventCmdID = require("app.Common.Config.EventCmdID")
local csbFile = "Csd/IRoom/UISettlementFinal.csb"

local n = {}
local m = class("UISettlementFinal",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.param = {
        curRoomPlayers = args.curRoomPlayers,
        msgTbl         = args.msgTbl,
        playerSeatIdx  = args.playerSeatIdx,
        playmes        = args.playmes,
        roomType       = args.roomType,
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
    imgTitle   = "imgTitle",
    txtWanFa   = "txtWanFa",
    txtRoomID  = "txtRoomID",
    txtTime    = "txtTime",
    txtJuShu   = "txtJuShu",
    lvItem     = "lvItem",
}
n.btnMap = {
    btnExit  = "btnExit",
    btnShare = "btnShare",
    btnCopy  = "btnCopy",
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

    -- self.nodeMap["txtRoomID"]:setString("房号:"..self.param.playmes.roomId)

    local time = os.date("%x") .. " ".. os.date("%X")
    self.nodeMap["txtTime"]:setString(time)

    local str = "房号:"..self.param.playmes.roomId .. "  局数: "
    str = str .. (self.param.msgTbl.m_rCurNum or 1) .. "/"..self.param.msgTbl.m_rnum.."局"
    self.nodeMap["txtRoomID"]:setVisible(false)
    self.nodeMap["txtJuShu"]:setString(str)

    self:handleData()

    self:getCopyString()
    
    if cc.exports.gGameConfig.isiOSAppInReview then
        self.nodeMap["btnShare"]:setVisible(false)
        self.nodeMap["btnCopy"]:setVisible(false)
    end
end

function m:handleData()
    local MaxValue,MinValue = 0,0
    self.scoreList = {}
    local sum = function(arr)
        local s = 0
        for i,v in ipairs(arr) do
            s = s + v
        end
        return s
    end
    for i = 1, #self.param.curRoomPlayers do
        self.scoreList[i] = sum(self.param.msgTbl["m_result" .. i])
    end
    for i,v in ipairs(self.scoreList) do
        if MaxValue < v then
            MaxValue = v
        end
        if MinValue > v then
            MinValue = v
        end
    end
    log(MaxValue,"MaxValue--MinValue",MinValue)
    local sumWidth = 0
    for i = 1, #self.param.curRoomPlayers do
        local roomPlayer = self.param.curRoomPlayers[i]
        local data = {
            nickname = roomPlayer.nickname,
            uid      = roomPlayer.uid,
            isZhuang = false,
            isWinner = false,
            isLastLoser = false,
            scoreList   = self.param.msgTbl["m_result" .. i],
            roomType    = self.param.roomType,
        }
        data.isZhuang = (i == 1)
        if MaxValue ~= MinValue then
            data.isWinner = (self.scoreList[i] == MaxValue)
            data.isLastLoser = (self.scoreList[i] == MinValue)
        end

        local cell = ItemSettlementFinal:create(data)    
        local layout = ccui.Layout:create()
        layout:setTouchEnabled(true)
        layout:setContentSize(cell:getContentSize())
        layout:addChild(cell)
        self.nodeMap["lvItem"]:pushBackCustomItem(layout)
        sumWidth = sumWidth + cell:getContentSize().width
    end
    self.nodeMap["lvItem"]:setTouchEnabled(false)
    -- local spaceX = 13
    -- sumWidth = sumWidth + spaceX * (#self.param.curRoomPlayers)
    -- self.nodeMap["lvItem"]:setItemsMargin(spaceX)
    local size = self.nodeMap["lvItem"]:getContentSize()
    local px,py = self.nodeMap["lvItem"]:getPosition()
    self.nodeMap["lvItem"]:setContentSize(cc.size(sumWidth,size.height))
    local pSize = self.nodeMap["lvItem"]:getParent():getContentSize()
    -- self.nodeMap["lvItem"]:setPositionX((pSize.width-sumWidth)*0.5)
    self.nodeMap["lvItem"]:setPosition(px,py)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnShare then
        _sender:setEnabled(false)
        self:screenshotShareToWX()

    elseif s_name == n.btnMap.btnExit then
        -- 返回游戏大厅
        gComm.EventBus.dispatchEvent(EventCmdID.EventType.BACK_MAIN_SCENE)

    elseif s_name == n.btnMap.btnCopy then
        gCallNativeMng.AppNative:copyText(self.copyStr)
        gComm.UIUtils.floatText("复制成功")
    end
end

function m:getCopyString()
    self.copyStr = "结算：\n"
    for i = 1, #self.param.curRoomPlayers  do
        local roomPlayer = self.param.curRoomPlayers[i]
        self.copyStr = self.copyStr .. roomPlayer.nickname
        self.copyStr = self.copyStr .."(ID:" .. self.param.msgTbl.m_id[i]..")"
        local sumscore = self.scoreList[i]
        if sumscore >= 0 then
            self.copyStr = self.copyStr .. "   " .. math.abs(sumscore) .. "\n"
        else
            self.copyStr = self.copyStr .. "   -" .. math.abs(sumscore) .. "\n"
        end
    end
    log(self.copyStr,"===function m:getCopyString()===")
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

        gComm.CallNativeMng:shareImage(gComm.CallNativeMng.shareType.WeiXin,self.shareImgFilePath,"","",function( )
            -- body
        end)

        -- gCallNativeMng:shareImage(_type,img,"title~~~","desc~~~",handle)
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
