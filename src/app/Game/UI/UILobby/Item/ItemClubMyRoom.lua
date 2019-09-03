local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Item/ItemClubMyRoom.csb"

local n = {}
local m = class("ItemClubMyRoom", function()
    return display.newLayer()
end)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    dump(data,self.__TAG .. "ctor")
    
    self.data = data 
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnJoin   = "btnJoin",
}
n.nodeMap = {
    txtGameName = "txtGameName",
    txtRule     = "txtRule",
    imgBG       = "imgBG",
    txtDateTime = "txtDateTime",
    txtRoundNum = "txtRoundNum",
    txtMinisterOpen = "txtMinisterOpen",
}

n.nodeMapIndex = {
    spr_icon_   = "spr_icon_",   
    Txt_ID_     = "Txt_ID_",  
    Txt_name_   = "Txt_name_",    
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

    local size = self.btnMap["imgBG"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    for i=1, 4 do
        self.btnMap[i] = {}
        for k,v in pairs(n.nodeMapIndex) do
            local btn = gComm.UIUtils.seekNodeByName(csbNode, k .. i)
            self.btnMap[i][k] = btn
        end
    end
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    csbNode:addChild(playerHeadMgr)
    local str = ""
    for k,v in ipairs(self.data.ruleList) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            str = str .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            str = str .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end
    self.btnMap["txtRule"]:setString(str)
    self.btnMap["txtGameName"]:setString(DefineRule.GameTypeName[self.data.gameID])
    
    str = os.date("%Y-%m-%d %H:%M:%S",self.data.dateTime)
    self.btnMap["txtDateTime"]:setString(str)
    self.btnMap["txtRoundNum"]:setString(self.data.maxCircle .. "局")

    if self.data.isMinisterOpen == true then
        self.btnMap["txtMinisterOpen"]:setVisible(true)
    else
        self.btnMap["txtMinisterOpen"]:setVisible(false)
    end

    for i=1,4 do
        if i > self.data.playerNum then
            self.btnMap[i]["spr_icon_"]:setVisible(false)
            self.btnMap[i]["Txt_ID_"]:setVisible(false)
            self.btnMap[i]["Txt_name_"]:setVisible(false)
        else
            if self.data.userIDList[i] then
                self.btnMap[i]["Txt_ID_"]:setString("ID:"..self.data.userIDList[i])
                self.btnMap[i]["Txt_name_"]:setString(gComm.StringUtils.GetShortName(self.data.nikeNameList[i]))

                -- self.btnMap[i]["spr_icon_"]:setScale(0.5)
                local headUrl = self.data.headURLList[i] or ""
                if headUrl ~= "" then
                    playerHeadMgr:detachAgentIcon(self.data.userIDList[i])
                    playerHeadMgr:attach(self.btnMap[i]["spr_icon_"], self.data.userIDList[i], headUrl)
                end
            end
        end
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnJoin then
        NetLobbyMng.SendJoinRoom(self.data.deskID)
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