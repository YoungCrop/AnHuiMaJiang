
local gComm = cc.exports.gComm
local UICreateRoom = require("app.Game.UI.UILobby.CreateRoom.UICreateRoom")
local UIPeiPai = require("app.Game.UI.UICommon.UIPeiPai")
local m = class("UICreateRoomPoker", UICreateRoom)

function m:ctor(data)
    m.super.ctor(self,data)
    self.__TAG_SUB = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end
m.n = {}
m.n.picPath = "Image/ILobby/UICreateRoom/"
m.n.pic = {
    anqing  = {"btn_anqing_down.png" ,"btn_anqing_up.png" ,},
    ddz     = {"btn_ddz_down.png"    ,"btn_ddz_up.png"    ,},
    huaibei = {"btn_huaibei_down.png","btn_huaibei_up.png",},
}

function m:initUI()
    m.super.btnRuleTypeMap = {
        [1] = {"btnType1" ,"app.Game.UI.UILobby.CreateRoom.RuleDDZ",   m.n.picPath .. m.n.pic.ddz[1]   ,m.n.picPath .. m.n.pic.ddz[2]},
        -- [1] = {"btnType2" ,"app.Game.UI.UILobby.CreateRoom.RuleAnQing",m.n.picPath .. m.n.pic.anqing[1],m.n.picPath .. m.n.pic.anqing[2]},
    }
    m.super.peiPaiType = UIPeiPai.TYPE.Poker
    m.super.initUI(self)
    self:loadCSBSub()
end

function m:loadCSBSub()
end

function m:onEnter()
    log(self.__TAG_SUB,"onEnter")
    m.super.onEnter(self)
    local index = cc.UserDefault:getInstance():getIntegerForKey("UICreatePokerRuleType",1)
    self:onRuleTypeBtnClick(self.nodeSet[index])
end

function m:onExit()
    log(self.__TAG_SUB,"onExit")
    m.super.onExit(self)
	cc.UserDefault:getInstance():setIntegerForKey("UICreatePokerRuleType",self.lastActivityIndex or 1)
end

function m:onCleanup()
    log(self.__TAG_SUB,"onCleanup")
    m.super.onCleanup(self)
end


return m
