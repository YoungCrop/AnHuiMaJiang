
--玩家打出的牌
local gComm = cc.exports.gComm
local EventCmdID = require("app.Common.Config.EventCmdID")
local DefineTile = require("app.Common.Tiles.DefineTile")
local csbFile = "Csd/IRoom/Tiles/SpriteTileStand.csb"

local n = {}
local m = class("LayerTileOut", function()
    return display.newNode()
    -- return display.newLayer()
    -- return display.newSprite()
end)

----------------top[2]---------------
---------|               |
---------|               |
---------|               |
--left[3]|               |right[1]
---------|               |
---------|               |
---------|               |
---------------bottom[4]--------------
function m:ctor(uiPos,tileColor,tileValue,scale)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.tileColor = tileColor
    self.tileValue = tileValue
    log("==LayerTileOut==",uiPos,tileColor,tileValue)
    self.imgTilePath = DefineTile.getOpenTile(uiPos,tileColor,tileValue)
    self.scale = scale or 1
    self.uiPos = uiPos

    self.isRedState = false
    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

function m:loadCSB()
    self.btnMap["bg"] = cc.Sprite:createWithSpriteFrameName(DefineTile.TILE_BG_OUT_ITEM[self.uiPos][1])
    self.btnMap["bg"]:addTo(self)
    local size = self.btnMap["bg"]:getContentSize()
    self:setContentSize(size)
    self.btnMap["tile"] = cc.Sprite:createWithSpriteFrameName(self.imgTilePath)
    self.btnMap["tile"]:addTo(self.btnMap["bg"])
    self.btnMap["tile"]:setPosition(size.width*0.5,size.height*0.5)
    -- self:setAnchorPoint(0.5, 0.5)
    self:setScale(self.scale)
end

--恢复普通
function m:setColorNormal()
    self:setTileColor(cc.c3b(255,255,255))
end

--设置颜色
function m:setTileColor( c3b )
    self.btnMap["bg"]:setColor(c3b)
    self.btnMap["tile"]:setColor(c3b)
end

function m:setColorRed()
    -- self:setTileColor(cc.RED)
    self:setTileColor(cc.YELLOW)
    self.isRedState = true
end

function m:setBright(eventName,tileColor,tileValue)
    if self.isRedState == false then
        if self.tileColor == tileColor and self.tileValue == tileValue then
            self:setTileColor(cc.YELLOW)
        else
            self:setColorNormal()
        end
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gComm.EventBus.regEventListener(EventCmdID.UI_TOUCH_SAME_MJ_BRIGHT,self,self.setBright)
end

function m:onExit()
    log(self.__TAG,"onExit")
    
    gComm.EventBus.unRegAllEvent(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m