
local gComm = cc.exports.gComm
local gRoomData = cc.exports.gData.ModleRoom
local UIPlayerInfo = require("app.Game.UI.UIIRoom.UIPlayerInfo")
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/IRoom/CommHead/NodeHeadUIBase.csb"

local n = {}
local m = class("UIHeadBase", function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,
        roomType  = param.roomType,
        uiPos     = param.uiPos,
    }

    self:initUI()
    self:enableNodeEvents()
end
function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnHeadFrame     = "btnHeadFrame",
}
n.nodeMap = {
    spriteHead        = {"spriteHead",         true,},      
    txtScore          = {"txtScore",           false,},    
    txtNickname       = {"txtNickname",        false,},       
    txtZuoLaPao       = {"txtZuoLaPao",        false,},       
    spriteFlagFang    = {"spriteFlagFang",     false,},          
    spriteFlagZhuang  = {"spriteFlagZhuang",   false,},            
    spriteFlagOffLine = {"spriteFlagOffLine",  false,},             
    spriteFlagTuoGuan = {"spriteFlagTuoGuan",  false,},        
    imgCoin           = {"imgCoin",            false,},         
}

function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    -- csbNode:addTo(self)

    -- local csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "FileNodeHeadUIBase")
    local csbNode = self.param.csbNode
    
    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        btn:setTag(self.param.uiPos)
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        log("====kkk===",k,v[1],v[2])
        btn:setVisible(v[2])
        self.btnMap[k] = btn
    end

    if self.param.roomType == DefineRule.RoomType.CoinRoom then
        self.btnMap["imgCoin"]:setVisible(true)
    else
        self.btnMap["imgCoin"]:setVisible(false)
        local pos = self.btnMap["txtScore"]:getPositionPercent()
        self.btnMap["txtScore"]:setPositionPercent({x = 0.5,y = 0.1681})
    end
    if self.param.roomType == DefineRule.RoomType.ClubQuickRoom or 
        self.param.roomType == DefineRule.RoomType.Club or
        self.param.roomType == DefineRule.RoomType.ClubQuickRoomPlayer then
        
        self.btnMap["spriteFlagFang"]:setVisible(false)
    end

    -- gComm.BtnUtils.setButtonClick(self.btnMap["spriteHead"],handler(self,self.onBtnClick))
end

--key:score,nickname,zuoLaPao
function m:setTxt(args)
    dump(args,"setTxtsetTxtsetTxt")
    args = args or {}
    for k,v in pairs(args) do
        if k == "score" then
            local str = v
            if v > 10000 then
                str = string.format("%0.1f万",v/10000)
            end
            self.btnMap["txtScore"]:setString(str)
            self.btnMap["txtScore"]:setVisible(true)
        elseif k == "nickname" then
            self.btnMap["txtNickname"]:setString(v)
            self.btnMap["txtNickname"]:setVisible(true)
        elseif k == "zuoLaPao" then
            self.btnMap["txtZuoLaPao"]:setString(v)
            self.btnMap["txtZuoLaPao"]:setVisible(true)
        end
    end
end

--key:fang,zhuang,offline,tuoGuan
function m:setFlagVisible(args)
    dump(args,"setFlagVisiblesetFlagVisible")
    args = args or {} 
    for k,v in pairs(args) do
        if k == "fang" then
            self.btnMap["spriteFlagFang"]:setVisible(v)
            if self.param.roomType == DefineRule.RoomType.ClubQuickRoom or 
                self.param.roomType == DefineRule.RoomType.Club or
                self.param.roomType == DefineRule.RoomType.ClubQuickRoomPlayer then
                
                self.btnMap["spriteFlagFang"]:setVisible(false)
            end
        elseif k == "zhuang" then
            self.btnMap["spriteFlagZhuang"]:setVisible(v)
        elseif k == "offline" then
            self.btnMap["spriteFlagOffLine"]:setVisible(v)
        elseif k == "tuoGuan" then
            self.btnMap["spriteFlagTuoGuan"]:setVisible(v)
        end
    end
end

function m:getSpriteHead()
    return self.btnMap["spriteHead"]
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    local tag = _sender:getTag()
    if s_name == n.btnMap.btnHeadFrame then
        local pInfo = gRoomData.uiPosPlayers[tag]
        local isMySelf = tag == 4
        local args = {
            isMySelf = isMySelf,
            nickname = pInfo.nickname,
            ID       = pInfo.UID,
            IP       = pInfo.IP,
            sPos     = pInfo.sPos,
        }
        local ui = UIPlayerInfo:create(args)
        -- self:addChild(ui, ConfigGameScene.ZOrder.PLAYER_INFO_TIPS)
        cc.Director:getInstance():getRunningScene():addChild(ui)
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
