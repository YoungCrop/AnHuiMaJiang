
local gComm = cc.exports.gComm

local SpriteTileOpen = require("app.Common.Tiles.SpriteTileOpen")
local DefineTile = require("app.Common.Tiles.DefineTile")
local LayerTileItemBottom = require("app.Common.Tiles.LayerTileItemBottom")

local csbFile = "Csd/IRoom/Item/ItemSettlementOneRound.csb"

local n = {}
local m = class("ItemSettlementOneRound", function()
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
    spriteHead  = "spriteHead",
    FlagZhuang  = "FlagZhuang",
    txtID       = "txtID",
    txtNickname = "txtNickname",
    txtHuFlag   = "txtHuFlag",

    txtHuType   = "txtHuType",
    FlagWin     = "FlagWin",
    txtScore    = "txtScore",
    imgShowCards = "imgShowCards",
}
function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
	-- csbNode:setAnchorPoint(0.5, 0.5)
	-- csbNode:setPosition(display.center)
    csbNode:addTo(self)
    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end
    local size = self.nodeMap["imgShowCards"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)
    dump(self:getContentSize(),"===cell:getContentSize()==44444444=")

    local imgPath = cc.FileUtils:getInstance():getWritablePath() .. "head_img_" .. self.dataInfo.uid .. ".png"
    if io.exists(imgPath) then
        self.nodeMap["spriteHead"]:setTexture(imgPath)
    end

    self.nodeMap["FlagZhuang"]:setVisible(self.dataInfo.isZhuang)
    self.nodeMap["txtID"]:setString("ID:" .. self.dataInfo.uid)
    self.nodeMap["txtNickname"]:setString(gComm.StringUtils.GetShortName(self.dataInfo.nickname))
    self.nodeMap["txtHuFlag"]:setString(self.dataInfo.txtHuFlag)

    self.nodeMap["txtHuType"]:setString(self.dataInfo.txtHuType)
    self.nodeMap["FlagWin"]:setVisible(self.dataInfo.isWin)
    if self.dataInfo.score > 0 then
        self.nodeMap["txtScore"]:setString("+" .. self.dataInfo.score)
    else
        self.nodeMap["txtScore"]:setString(self.dataInfo.score)
    end
    self:showMJ()
end

function m:showMJ()
    local tileScale = 0.5
    local tilePosY = SpriteTileOpen.tileHeight * tileScale * 0.52
    local tileWidth = SpriteTileOpen.tileWidth * tileScale
    local itemTilePosY = tilePosY + 1
    local itemTileSpaceX = 10
    local itemTileWidth = LayerTileItemBottom.itemTileWidth * tileScale
    local majong_bg = self.nodeMap["imgShowCards"]
    local width = self.nodeMap["txtHuFlag"]:getPositionX() + 20

    --暗杠
    local m_acards = self.dataInfo.m_acards
    if #m_acards > 0 then
        for j = 1, #m_acards do
            if j % 4 == 0 then
                local tileList = {{tileColor = m_acards[j][1],tileValue = m_acards[j][2]}}
                local mjTileSpr = LayerTileItemBottom:create(DefineTile.OpeType.GANG_AN_SHOW,tileList,tileScale)
                mjTileSpr:setPosition(cc.p(width+itemTileWidth*0.5,itemTilePosY))
                width = width + itemTileWidth + itemTileSpaceX
                majong_bg:addChild(mjTileSpr)
            end
        end
    end

    --明杠
    local m_mcards = self.dataInfo.m_mcards
    if #m_mcards > 0 then
        for j = 1, #m_mcards do
            if j % 4 == 0 then
                local tileList = {{tileColor = m_mcards[j][1],tileValue = m_mcards[j][2]}}
                local mjTileSpr = LayerTileItemBottom:create(DefineTile.OpeType.GANG_MING,tileList,tileScale)
                mjTileSpr:setPosition(cc.p(width+itemTileWidth*0.5,itemTilePosY))
                width = width + itemTileWidth + itemTileSpaceX
                majong_bg:addChild(mjTileSpr)
            end
        end
    end 

    --碰
    local m_pcards = self.dataInfo.m_pcards
    if #m_pcards > 0 then
        for j = 1, #m_pcards do
            if j % 3 == 0 then
                local tileList = {{tileColor = m_pcards[j][1],tileValue = m_pcards[j][2]}}
                local mjTileSpr = LayerTileItemBottom:create(DefineTile.OpeType.PENG,tileList,tileScale)
                mjTileSpr:setPosition(cc.p(width+itemTileWidth*0.5,itemTilePosY))
                width = width + itemTileWidth + itemTileSpaceX
                majong_bg:addChild(mjTileSpr)
            end
        end
    end

    --吃
    local m_ccards = self.dataInfo.m_ccards
    if #m_ccards > 0 then
        for j = 1, #m_ccards do
            if j % 3 == 0 then
                local tileList = {
                    {tileColor = m_ccards[j-2][1],tileValue = m_ccards[j-2][2]},
                    {tileColor = m_ccards[j-1][1],tileValue = m_ccards[j-1][2]},
                    {tileColor = m_ccards[j][1],tileValue = m_ccards[j][2]},
                }
                local mjTileSpr = LayerTileItemBottom:create(DefineTile.OpeType.CHI,tileList,tileScale)
                mjTileSpr:setPosition(cc.p(width+itemTileWidth*0.5,itemTilePosY))
                width = width + itemTileWidth + itemTileSpaceX
                majong_bg:addChild(mjTileSpr)
            end
        end
    end

    --持有牌
    local holdmj = self.dataInfo.m_holdmj
    if #holdmj > 0 then
        for j = 1, #holdmj do
            local mjTileSpr = SpriteTileOpen:create(holdmj[j][1],holdmj[j][2],tileScale)
            mjTileSpr:setPosition(cc.p(width+tileWidth*0.5, tilePosY))
            width = width + tileWidth
            majong_bg:addChild(mjTileSpr)
        end
    end
    width = width + itemTileSpaceX

    --胡牌
    local m_hucards = self.dataInfo.m_hucards
    local m_win = self.dataInfo.m_win
    local index = self.dataInfo.itemIndex
    if #m_hucards > 0  then
        if (m_win[index] == 1  or m_win[index] == 2) 
            and (m_hucards[1][1] ~= 0 and m_hucards[1][2] ~= 0) then
            local mjTileSpr = SpriteTileOpen:create(m_hucards[1][1],m_hucards[1][2],tileScale)
            mjTileSpr:setPosition(cc.p(width+ tileWidth*0.5 + itemTileSpaceX, tilePosY))
            width = width + tileWidth + itemTileSpaceX
            majong_bg:addChild(mjTileSpr)
            mjTileSpr:setColorYellow()
        end
    end
    width = width + itemTileSpaceX

    --花牌
    local huaSpace = 20
    local huaCards = self.dataInfo.m_huaCards
    if #huaCards > 13 then
        tileScale = 0.29
    elseif #huaCards > 10 then
        tileScale = 0.35
    elseif #huaCards > 7 then
        tileScale = 0.4
    end
    if #huaCards > 0 then
        width = width + huaSpace
        for j = 1, #huaCards do
            local mjTileSpr = SpriteTileOpen:create(huaCards[j][1],huaCards[j][2],tileScale)
            local w = SpriteTileOpen.tileWidth * tileScale
            mjTileSpr:setPosition(cc.p(width+w*0.5, SpriteTileOpen.tileHeight * tileScale * 0.52))
            width = width + w
            majong_bg:addChild(mjTileSpr)
        end
    end
    
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
