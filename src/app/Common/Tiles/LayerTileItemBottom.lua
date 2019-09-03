
--结算用的牌堆

local gComm = cc.exports.gComm
local DefineTile = require("app.Common.Tiles.DefineTile")

local csbFile = "Csd/IRoom/Tiles/LayerTileItemBottom.csb"

local selfIsNode = true

local n = {}
local m = class("LayerTileItemBottom", function()
    if selfIsNode then
        return display.newNode()
    else
        return display.newLayer(cc.YELLOW)
    end
end)

m.itemTileWidth = 240
m.itemTileHeight = 120

-- function m:ctor(_oprateType,tileColor,tileValue,scale)
function m:ctor(_oprateType,tileList,scale)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self._oprateType = _oprateType
    self.imgTilePathList = {
        DefineTile.getBottomOpenTile(tileList[1].tileColor,tileList[1].tileValue),
    }
    if _oprateType == DefineTile.OpeType.CHI then
        self.imgTilePathList[2] = DefineTile.getBottomOpenTile(tileList[2].tileColor,tileList[2].tileValue)
        self.imgTilePathList[3] = DefineTile.getBottomOpenTile(tileList[3].tileColor,tileList[3].tileValue)
    end

    self.scale = scale or 1

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.nodeMap = {
    item1 = "item1",
    item2 = "item2",
    item3 = "item3",
    item4 = "item4",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:addTo(self)

    if selfIsNode then
        csbNode:setScale(self.scale)
    else
        local size = csbNode:getContentSize()
        self:setContentSize(size)
        self:setAnchorPoint(0.5, 0.5)
        self:setScale(self.scale)
        csbNode:setPosition(size.width*self.scale,size.height*self.scale)
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    if self._oprateType == DefineTile.OpeType.GANG_AN then
        for i=1,4 do
            self.btnMap["item" .. i]:setSpriteFrame(DefineTile.TILE_BG_GANG[DefineTile.Direction.BOTTOM][1])        
            self.btnMap["item" .. i]:getChildByName("tile"):setVisible(false)
        end
    elseif self._oprateType == DefineTile.OpeType.GANG_AN_SHOW then
        for i=1,3 do
            self.btnMap["item" .. i]:setSpriteFrame(DefineTile.TILE_BG_GANG[DefineTile.Direction.BOTTOM][1])        
            self.btnMap["item" .. i]:getChildByName("tile"):setVisible(false)
        end
        self.btnMap["item4"]:getChildByName("tile"):setSpriteFrame(self.imgTilePathList[1])
    elseif self._oprateType == DefineTile.OpeType.CHI then
        for i=1,3 do
            self.btnMap["item" .. i]:getChildByName("tile"):setSpriteFrame(self.imgTilePathList[i])
        end
    else
        for i=1,4 do
            self.btnMap["item" .. i]:getChildByName("tile"):setSpriteFrame(self.imgTilePathList[1])
        end
    end
    self:setOperateType(self._oprateType)
end

function m:setOperateType(op)
    -- self.btnMap["tile1"]:setVisible(op == DefineTile.OpeType.CHI
    --                         or op == DefineTile.OpeType.PENG
    --                         or op == DefineTile.OpeType.GANG_MING)
    self.btnMap["item1"]:setVisible(true)
    self.btnMap["item2"]:setVisible(true)
    self.btnMap["item3"]:setVisible(true)
    self.btnMap["item4"]:setVisible(op == DefineTile.OpeType.GANG_MING
                            or op == DefineTile.OpeType.GANG_AN
                            or op == DefineTile.OpeType.GANG_AN_SHOW)
end

--置灰(不可点击时置灰)
function m:setColorGray()
    self:setTileColor(cc.c3b(100,100,100))
end

--置绿(查看点击的牌)
function m:setColorGreen()
    self:setTileColor(cc.c3b(124,165,130))
end

--置黄(胡哪张牌)
function m:setColorYellow()
    self:setTileColor(cc.YELLOW)
end

--恢复普通
function m:setColorNormal()
    self:setTileColor(cc.c3b(255,255,255))
end

--设置颜色
function m:setTileColor( c3b )
    -- self.btnMap["bg"]:setColor(c3b)
    -- self.btnMap["tile"]:setColor(c3b)
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