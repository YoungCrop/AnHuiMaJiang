
--自己手中站着的牌
local gComm = cc.exports.gComm

local SpriteTile = require("app.Common.Tiles.SpriteTile")
local DefineTile = require("app.Common.Tiles.DefineTile")

local csbFile = "Csd/IRoom/Tiles/LayerTileStand.csb"

local n = {}
local m = class("SpriteTileStand", SpriteTile)
m.tileWidth = 86
m.tileHeight = 126

function m:ctor(tileColor,tileValue,scale)
    self.__SUB_TAG = "[[" .. self.__cname .. "]] --===-- "

    self.tileColor,self.tileValue = tileColor,tileValue
    local param = {
        csbFile = csbFile,
        imgTilePath = DefineTile.TILE_STAND[DefineTile.Direction.BOTTOM][tileColor][tileValue][1],
        scale = scale or 1,
    }
    m.super.ctor(self,param)

    self:enableNodeEvents()
end

function m:setTile(tileColor,tileValue)
    local imgTilePath = DefineTile.TILE_STAND[DefineTile.Direction.BOTTOM][tileColor][tileValue][1]
    self:setSpriteFrame(imgTilePath)
    self.tileColor,self.tileValue = tileColor,tileValue
    log("==setTile==",self.tileColor,self.tileValue,tileColor,tileValue)
end

--置灰(不可点击时置灰)
function m:setColorGray()
    self:setTileColor(cc.c3b(200,200,200))
end

function m:onEnter()
    log(self.__SUB_TAG,"onEnter")
end

function m:onExit()
    log(self.__SUB_TAG,"onExit")
    
end

function m:onCleanup()
    log(self.__SUB_TAG,"onCleanup")
    
end


return m