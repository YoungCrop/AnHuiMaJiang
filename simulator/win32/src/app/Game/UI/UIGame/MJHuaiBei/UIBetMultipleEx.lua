
local gComm = cc.exports.gComm
local NetMngMJAnQin = require("app.Common.NetMng.NetMngMJAnQin")
local csbFile = "Csd/SubGame/MJHuaiBei/UIBetMultipleEx.csb"

local n = {}
local m = class("UIBetMultipleEx", gComm.UIMaskLayer)

function m:ctor(param)
    local args = {
        opacity = 0,
    }
    m.super.ctor(self,args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        isZhuang = param.isZhuang,
        diFen    = param.diFen,
        countDown = param.countDown or 0,
    }
    self:initUI()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnOK     = {"btnOK",    },
    cbZuoBet1 = {"cbZuoBet1",0},
    cbZuoBet2 = {"cbZuoBet2",1},
    cbZuoBet3 = {"cbZuoBet3",2},
    cbPaoBet1 = {"cbPaoBet1",0},
    cbPaoBet2 = {"cbPaoBet2",1},
    cbPaoBet3 = {"cbPaoBet3",2},
}

n.nodeMap = {
    spriteBG     = "spriteBG",
    txtZuo       = "txtZuo",
    txtCountDown = "txtCountDown",
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
        if v[2] then
            btn:getChildByName("txtBet"):setString(self.param.diFen * v[2])
            btn:setSelected(false)
        end
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    self.btnMap["spriteBG"]:setPosition(display.cx,display.cy)

    if self.param.isZhuang then
        self.btnMap["txtZuo"]:setString("坐：")
    else
        self.btnMap["txtZuo"]:setString("拉：")
    end
    self.updateTimeCD = self.param.countDown
    if self.param.countDown == 0 then
        self.btnMap["txtCountDown"]:setVisible(false)
    else
        self:update(0)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnOK[1] then
        local ma1 = n.btnMap["cbZuoBet" .. self.seletedIndexZuoLa][2]*self.param.diFen
        local ma2 = n.btnMap["cbPaoBet" .. self.seletedIndexPao][2]*self.param.diFen
        NetMngMJAnQin.sendBetMultiple(ma1,ma2)
        self:removeFromParent()
    else
        local type_ = string.sub(s_name,1,-2)
        local index = tonumber(string.sub(s_name,-1))
        if type_ == "cbZuoBet" then
            if self.seletedIndexZuoLa ~= index then
                self.btnMap["cbZuoBet" .. self.seletedIndexZuoLa]:setSelected(false)
                _sender:setSelected(true)
                self.seletedIndexZuoLa = index
            end
        else
            if self.seletedIndexPao ~= index then
                self.btnMap["cbPaoBet" .. self.seletedIndexPao]:setSelected(false)
                _sender:setSelected(true)
                self.seletedIndexPao = index
            end
        end
    end
end

function m:update(delta)
    self.updateTimeCD = self.updateTimeCD - delta
    if self.updateTimeCD >= 0 then
        local str = "(" .. self.updateTimeCD .."s)"
        self.btnMap["txtCountDown"]:setString(str)
        if self.updateTimeCD == 0 then
            self:onBtnClick(self.btnMap["btnOK"])
        end
    else
        if self.scheduleCurTime then
            gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleCurTime)
            self.scheduleCurTime = nil
        end
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    self.seletedIndexZuoLa = cc.UserDefault:getInstance():getIntegerForKey("HBMJ_ZUOLA",2)
    self.seletedIndexPao = cc.UserDefault:getInstance():getIntegerForKey("HBMJ_PAO",2)
    self.btnMap["cbZuoBet" .. self.seletedIndexZuoLa]:setSelected(true)
    self.btnMap["cbPaoBet" .. self.seletedIndexPao]:setSelected(true)
    self.scheduleCurTime = gComm.FunUtils.scheduler:scheduleScriptFunc(handler(self, self.update), 1, false)
end

function m:onExit()
    log(self.__TAG,"onExit")
    cc.UserDefault:getInstance():setIntegerForKey("HBMJ_ZUOLA",self.seletedIndexZuoLa)
    cc.UserDefault:getInstance():setIntegerForKey("HBMJ_PAO",self.seletedIndexPao)

    if self.scheduleCurTime then
        gComm.FunUtils.scheduler:unscheduleScriptEntry(self.scheduleCurTime)
        self.scheduleCurTime = nil
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end

return m
