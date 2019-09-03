
local gComm = cc.exports.gComm
local DefineRule = require("app.Common.Config.DefineRule")
local csbFile = "Csd/IRoom/Item/ItemSettlementFinal.csb"

local n = {}
local m = class("ItemSettlementFinal", function()
    return display.newNode()
end)

function m:ctor(dataInfo)
    self.dataInfo = dataInfo

    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.nodeMap = {}
    self:loadCSB()
end

n.nodeMap = {
    imgBG          = "imgBG",
    imgHead        = "imgHead",
    imgFangFlag    = "imgFangFlag",
    txtID          = "txtID",
    txtName        = "txtName",
    imgWinnerFlag  = "imgWinnerFlag",
    imgLoseFlag    = "imgLoseFlag",

    lvFinalScore   = "lvFinalScore",
    imgSubFlag     = "imgSubFlag",
    txtTotalScore  = "txtTotalScore",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)
    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height)

    local imgPath = cc.FileUtils:getInstance():getWritablePath() .. "head_img_" .. self.dataInfo.uid .. ".png"
    if io.exists(imgPath) then
        self.nodeMap["imgHead"]:setTexture(imgPath)
    end

    self.nodeMap["imgFangFlag"]:setVisible(self.dataInfo.isZhuang)
    self.nodeMap["txtID"]:setString("ID:" .. self.dataInfo.uid)
    self.nodeMap["txtName"]:setString(gComm.StringUtils.GetShortName(self.dataInfo.nickname))

    self.nodeMap["imgWinnerFlag"]:setVisible(self.dataInfo.isWinner)
    self.nodeMap["imgLoseFlag"]:setVisible(self.dataInfo.isLastLoser)

    local sumScore = 0
    for k,v in pairs(self.dataInfo.scoreList) do
        local cell = self:createItem(k,v)
        self.nodeMap["lvFinalScore"]:pushBackCustomItem(cell)
        sumScore = sumScore + v
    end

    if #self.dataInfo.scoreList <= 6 then
        self.nodeMap["lvFinalScore"]:setTouchEnabled(false)
    end

    self.nodeMap["txtTotalScore"]:setString(math.abs(sumScore))
    if sumScore >= 0 then
        self.nodeMap["imgSubFlag"]:setVisible(false)
    else
        local x = self.nodeMap["txtTotalScore"]:getPositionX()
        local size = self.nodeMap["txtTotalScore"]:getContentSize()
        self.nodeMap["imgSubFlag"]:setVisible(true)
        self.nodeMap["imgSubFlag"]:setPositionX(x - size.width*0.4)
    end
    
    if self.dataInfo.roomType == DefineRule.RoomType.ClubQuickRoom or 
        self.dataInfo.roomType == DefineRule.RoomType.Club or
        self.dataInfo.roomType == DefineRule.RoomType.ClubQuickRoomPlayer then
        
        self.nodeMap["imgFangFlag"]:setVisible(false)
    end
end

function  m:createItem(tag, score)
    local file = "Csd/IRoom/Item/ItemFinalScore.csb"
    local cellNode = cc.CSLoader:createNode(file)

    -- local imgBG = gComm.UIUtils.seekNodeByName(cellNode, "imgBG")
    -- if tag % 2 == 1 then
    --     imgBG:setVisible(true)
    -- else
    --     imgBG:setVisible(false)
    -- end
    local txtName = gComm.UIUtils.seekNodeByName(cellNode, "txtName")
    txtName:setString("第" .. tag .. "局")

    local txtScore = gComm.UIUtils.seekNodeByName(cellNode, "txtScore")
    txtScore:setString(tostring(score))

    local cellSize = cellNode:getContentSize()
    local cellItem = ccui.Widget:create()
    cellItem:setTag(tag)
    cellItem:setTouchEnabled(true)
    cellItem:setContentSize(cellSize)
    cellItem:addChild(cellNode)

    return cellItem
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnSetting then
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
