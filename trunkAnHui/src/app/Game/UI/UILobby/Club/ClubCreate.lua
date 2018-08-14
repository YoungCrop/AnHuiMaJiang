
local gComm = cc.exports.gComm

local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local DefineShieldWord = require("app.Common.Config.DefineShieldWord")

local csbFile = "Csd/ILobby/Club/ClubCreate.csb"

local n = {}
local m = class("ClubCreate",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose  = "btnClose",
    btnCreate = "btnCreate",
}

n.nodeMap = {
    txtFieldName = "txtFieldName",
    txtName      = "txtName",
    txtID        = "txtID",
    spriteHead   = "spriteHead",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    local selfPlayerInfo = cc.exports.gData.ModleGlobal:getSelfInfo()
    self.btnMap["txtName"]:setString(gComm.StringUtils.GetShortName(selfPlayerInfo.nikeName,6))
    self.btnMap["txtID"]:setString(selfPlayerInfo.userID)
    local imgFileName = string.format("head_img_%s.png", selfPlayerInfo.userID .. "")
    imgFileName = cc.FileUtils:getInstance():getWritablePath() .. imgFileName
    if io.exists(imgFileName) then
        self.btnMap["spriteHead"]:setTexture(imgFileName)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnCreate then
        local inputString = string.trim(self.btnMap["txtFieldName"]:getString())
        print(inputString)
        if string.len(inputString) > 0 then
            if DefineShieldWord.CheckShieldWord(inputString) then
                gComm.UIUtils.floatText("您输入的词语含有敏感词,请重新输入!")
            else
                if string.utf8len(inputString) > 7 then
                    gComm.UIUtils.floatText("请输入少于7个字符的文字")
                else
                    NetLobbyMng.createClub(inputString)
                end
            end
        end
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