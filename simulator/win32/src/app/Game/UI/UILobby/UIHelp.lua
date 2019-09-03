
local gComm = cc.exports.gComm

local ConfigRuleAnHui = require("app.Common.Config.ConfigRuleAnHui")
local ConfigRuleAnQing = require("app.Common.Config.ConfigRuleAnQing")
local ConfigRuleHuaiBei = require("app.Common.Config.ConfigRuleHuaiBei")
local ConfigRuleDDZ = require("app.Common.Config.ConfigRuleDDZ")

local csbFile = "Csd/ILobby/UIHelp.csb"

local n = {}
local m = class("UIHelp",gComm.UIMaskLayer)

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
    btnClose = "btnClose",
}
n.nodeMap = {
    lvBtn       = "lvBtn",
    svRuleShow  = "svRuleShow",
    txtDescShow = "txtDescShow",
}
n.picPath = "Image/ILobby/UICreateRoom/"
n.pic = {
    anhui   = {"btn_anhui_down.png"   ,"btn_anhui_up.png",},
    anqing  = {"btn_anqing_down.png"  ,"btn_anqing_up.png",},
    huaibei = {"btn_huaibei_down.png" ,"btn_huaibei_up.png",},
    ddz     = {"btn_ddz_down.png"     ,"btn_ddz_up.png",},
}
n.btnRuleTypeMap = {
    [1] = {"btnType1" ,ConfigRuleAnQing,n.picPath .. n.pic.anqing[1],n.picPath .. n.pic.anqing[2]},
    [2] = {"btnType2" ,ConfigRuleHuaiBei,n.picPath .. n.pic.huaibei[1],n.picPath .. n.pic.huaibei[2]},
    [3] = {"btnType3" ,ConfigRuleDDZ,n.picPath .. n.pic.ddz[1],n.picPath .. n.pic.ddz[2]},
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

    self:handleBtn()
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        self.btnMap[2]:setVisible(false)
        self.btnMap[3]:setVisible(false)
        local img1 = n.picPath .. n.pic.anhui[1]
        local img2 = n.picPath .. n.pic.anhui[2]
        self.btnMap[1]:loadTextures(img1,img1,img2,ccui.TextureResType.plistType)--localType,plistType
        n.btnRuleTypeMap[1][2] = ConfigRuleAnHui
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    end
end

function m:handleBtn()
    self.btnMap["lvBtn"]:removeAllItems()
    for k,v in pairs(n.btnRuleTypeMap) do
        local btn = ccui.Button:create()
        btn:loadTextures(v[3],v[3],v[4],ccui.TextureResType.plistType)--localType,plistType
        btn:setScaleX(0.9)
        -- gComm.Debug:logUD(btn,"======btn=====")
        self.btnMap["lvBtn"]:pushBackCustomItem(btn)
        if btn then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onRuleTypeBtnClick))
            btn:setTag(k)
            self.btnMap[k] = btn
        end
    end
end

function m:onRuleTypeBtnClick( _sender )
    if not _sender then
        return
    end
    local s_name = _sender:getName()
    print("onRuleTypeBtnClick--s_name=",s_name)

    local _tag = _sender:getTag()
    local str = n.btnRuleTypeMap[_tag][2].ruleDesc
    if self.btnMap["txtDescRule"] then
        self.btnMap["txtDescRule"]:setString(str)
    else
        self.btnMap["txtDescRule"] = gComm.LabelUtils.createTTFLabel(str, 28)
        self.btnMap["svRuleShow"]:addChild(self.btnMap["txtDescRule"])
    end
    -- gComm.Debug:logUD(self.btnMap["txtDescShow"],"======txtDescShow=====")
    self.btnMap["txtDescRule"]:setAnchorPoint(0.5, 1)
    self.btnMap["txtDescRule"]:setTextColor(cc.c4b(125,47,0,255))
    self.btnMap["txtDescRule"]:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)

    local svSize = self.btnMap["svRuleShow"]:getContentSize()
    self.btnMap["txtDescRule"]:setWidth(svSize.width-10)
    local txtSize = self.btnMap["txtDescRule"]:getContentSize()
    self.btnMap["txtDescRule"]:setPosition(svSize.width * 0.5, txtSize.height)
    self.btnMap["svRuleShow"]:setInnerContainerSize(txtSize)

    self:setSelectIndex(self.selectIndex,true)
    self.selectIndex = _tag
    self:setSelectIndex(self.selectIndex,false)
end

function m:setSelectIndex(index,isSelected)
    if not self.btnMap[index] then
        return
    end
    self.btnMap[index]:setBright(isSelected)
    self.btnMap[index]:setTouchEnabled(isSelected)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    self.selectIndex = cc.UserDefault:getInstance():getIntegerForKey("UIHelpSelectIndex",1)
    if gGameConfig.CurServerIndex == gGameConfig.ServerTypeKey.sAndroidInReview then
        self.selectIndex = 1
    end
    self:onRuleTypeBtnClick(self.btnMap[self.selectIndex])
end

function m:onExit()
    log(self.__TAG,"onExit")
    cc.UserDefault:getInstance():setIntegerForKey("UIHelpSelectIndex",self.selectIndex)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end

return m
