
--结算界面亮的着牌
--出了这张牌，胡哪些牌，剩余几张
local gComm = cc.exports.gComm

local n = {}
local m = class("SpriteTile", function()
    return display.newSprite()--与display.newLayer(cc.YELLOW)锚点可能不同
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = param

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.nodeMap = {
    bg   = "bg",
    tile = "tile",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(self.param.csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:addTo(self)

    local size = csbNode:getContentSize()
    self:setContentSize(size)
    csbNode:setPosition(size.width*0.5,size.height*0.5)
    self:setScale(self.param.scale)

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["tile"]:setSpriteFrame(self.param.imgTilePath)
end

function m:setSpriteFrame(spriteFrame)
    self.btnMap["tile"]:setSpriteFrame(spriteFrame)
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