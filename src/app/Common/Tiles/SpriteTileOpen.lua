
--结算界面亮的着牌
--出了这张牌，胡哪些牌，剩余几张
local gComm = cc.exports.gComm
local SpriteTile = require("app.Common.Tiles.SpriteTile")
local DefineTile = require("app.Common.Tiles.DefineTile")
local csbFile = "Csd/IRoom/Tiles/LayerTileOpen.csb"
local n = {}
local m = class("SpriteTileOpen", SpriteTile)

m.tileWidth = 80
m.tileHeight = 120

function m:ctor(tileColor,tileValue,scale)
    self.__SUB_TAG = "[[" .. self.__cname .. "]] --===-- "
    log(self.__SUB_TAG,tileColor,tileValue,scale)
    local imgPath = DefineTile.TILE_OUT[DefineTile.Direction.BOTTOM][0][0][1]

    --对非法数据进行异常判断
    if DefineTile.TILE_OUT[DefineTile.Direction.BOTTOM][tileColor] and 
        DefineTile.TILE_OUT[DefineTile.Direction.BOTTOM][tileColor][tileValue] then
        imgPath = DefineTile.TILE_OUT[DefineTile.Direction.BOTTOM][tileColor][tileValue][1]
    end
    local param = {
        csbFile = csbFile,
        imgTilePath = imgPath,
        scale = scale or 1,
    }
    m.super.ctor(self,param)

    self:enableNodeEvents()
end

--置灰(不可点击时置灰)
function m:setColorGray()
    self:setTileColor(cc.c3b(100,100,100))
end

--置黄(胡哪张牌)
function m:setColorYellow()
    self:setTileColor(cc.YELLOW)
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