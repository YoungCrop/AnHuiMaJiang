
local gComm = cc.exports.gComm
local netMng = require("app.Common.NetMng.NetLobbyMng")
local DefineRule = require("app.Common.Config.DefineRule")
local UIBigWinMatchRule = require("app.Game.UI.UILobby.BigWinMatch.UIBigWinMatchRule")
local csbFile = "Csd/ILobby/Item/ItemBigWinMatch.csb"

local n = {}
local m = class("ItemBigWinMatch", function()
    return display.newNode()
end)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.data = data
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnSignOut = "btnSignOut",
    btnSignIn  = "btnSignIn",
    btnRule    = "btnRule",
    btnWinningList = "btnWinningList",
}
n.nodeMap = {
    imgBG        = "imgBG",
    txtGameName  = "txtGameName",
    txtManNum    = "txtManNum",
    txtGameState = "txtGameState",
    txtRule      = "txtRule",
    remainTime   = "remainTime",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
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
    -- local size = self.btnMap["imgBG"]:getContentSize()
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    self.btnMap["txtGameName"]:setString(DefineRule.GameTypeName[self.data.gameID])
    self.btnMap["txtManNum"]:setString(self.data.playerNum .. "/" .. self.data.needNum)
    -- self.btnMap["txtGameState"]:setString(self.data.index)
    local description = ""
    for i,v in ipairs(self.data.ruleList) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            description = description .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            description = description .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end

    local txt = gComm.LabelUtils.createTTFLabel(description, 28)
    txt:setAnchorPoint(0, 1)
    txt:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    txt:setWidth(1030)
    -- txt:setColor(self.btnMap["txtRule"]:getColor())
    txt:setColor(cc.c3b(79,55,37))
    txt:setPosition(self.btnMap["txtRule"]:getPosition())
    csbNode:addChild(txt)
    
    self.btnMap["txtRule"]:setVisible(false)

    self.btnMap["remainTime"]:setString("剩余" .. self.data.remainTime .."次")

    if self.data.remainTime == 0 then
        self.btnMap["btnSignOut"]:setVisible(false)
        self.btnMap["btnSignIn"]:setVisible(true)
        self.btnMap["btnSignIn"]:setEnabled(false)
    else
        if self.data.curInMatchType == self.data.matchID then
            self.btnMap["btnSignOut"]:setVisible(true)
            self.btnMap["btnSignIn"]:setVisible(false)
        else
            self.btnMap["btnSignOut"]:setVisible(false)
            self.btnMap["btnSignIn"]:setVisible(true)
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnSignOut then
        netMng.joinBigWinMatch(0)
    elseif s_name == n.btnMap.btnSignIn then
        netMng.joinBigWinMatch(self.data.matchID)
    elseif s_name == n.btnMap.btnRule then
        local layer = UIBigWinMatchRule:create()
        self.data.parentNode:addChild(layer)
    end
end

function m:ChangeItemState(isSignOutSuccess,playerNum)
    self.btnMap["btnSignOut"]:setVisible(not isSignOutSuccess)
    self.btnMap["btnSignIn"]:setVisible(isSignOutSuccess)
    self.btnMap["txtManNum"]:setString((playerNum or 1) .. "/" .. self.data.needNum)
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