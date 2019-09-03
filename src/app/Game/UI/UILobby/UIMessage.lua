
local gComm = cc.exports.gComm

local ConfigGameExp = require("app.Common.Config.Message.ConfigGameExp")
local ConfigUpdateContent = require("app.Common.Config.Message.ConfigUpdateContent")
local ConfigFCM = require("app.Common.Config.Message.ConfigFCM")
local ConfigJuBao = require("app.Common.Config.Message.ConfigJuBao")


local csbFile = "Csd/ILobby/UIMessage.csb"

local n = {}
local m = class("UIMessage",gComm.UIMaskLayer)

function m:ctor(args)
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    args = args or {}
    local selectIndex = cc.UserDefault:getInstance():getIntegerForKey("UIMessageSelectIndex",1)
    self.param = {
        showIndex = args.showIndex or selectIndex,
    }
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
}
n.picPath = "Image/ILobby/UIMessage/"

n.pic = {
    declare = {"btn_yxsm_normal.png","btn_yxsm_disable.png" ,},
    -- msg     = {"btn_msg_normal.png", "btn_msg_disable.png"  ,},
    fangCM  = {"btn_fcm_normal.png",  "btn_fcm_disable.png"  ,},--防沉迷
    juBao   = {"btn_jubao_normal.png","btn_jubao_disable.png"  ,},--举报
}
n.btnRuleTypeMap = {
    [1] = {"btnType1" ,ConfigGameExp,n.picPath .. n.pic.declare[1],n.picPath .. n.pic.declare[2]},
    -- [2] = {"btnType2" ,ConfigUpdateContent,n.picPath .. n.pic.msg[1],n.picPath .. n.pic.msg[2]},
    [2] = {"btnType2" ,ConfigFCM,n.picPath .. n.pic.fangCM[1],n.picPath .. n.pic.fangCM[2]},
    [3] = {"btnType3" ,ConfigJuBao,n.picPath .. n.pic.juBao[1],n.picPath .. n.pic.juBao[2]},
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
    
    self.selectIndex = self.param.showIndex
    self:onRuleTypeBtnClick(self.btnMap[self.selectIndex])
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
    for k,v in ipairs(n.btnRuleTypeMap) do
        local btn = ccui.Button:create()
        log(v[3],v[4])
        btn:loadTextures(v[3],v[3],v[4],ccui.TextureResType.plistType)--localType,plistType
        -- btn:setScaleX(0.9)
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
    if svSize.height > txtSize.height then
        self.btnMap["txtDescRule"]:setPosition(svSize.width * 0.5, svSize.height)
        self.btnMap["svRuleShow"]:setEnabled(false)
    else
        self.btnMap["txtDescRule"]:setPosition(svSize.width * 0.5, txtSize.height)
        self.btnMap["svRuleShow"]:setEnabled(true)
    end
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
end

function m:onExit()
    log(self.__TAG,"onExit")
    cc.UserDefault:getInstance():setIntegerForKey("UIMessageSelectIndex",self.selectIndex)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
end

return m
