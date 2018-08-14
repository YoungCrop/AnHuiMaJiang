

local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gConfig = cc.exports.gGameConfig

local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local NetCmd = require("app.Common.NetMng.NetCmd")

local csbFile = "Csd/IRoom/UIDistance.csb"

local n = {}
local m = class("UIDistance", gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.btnMap = {}
    self:initUI()

end

n.btnMap = {
    btnOK = "btnOK",
}
n.nodeMap = {
    fream1  = {"fream1", },
    fream2  = {"fream2", },
    fream3  = {"fream3", },
    fream4  = {"fream4", },
    line1_2 = {"line1_2",1,2},
    line1_3 = {"line1_3",1,3},
    line1_4 = {"line1_4",1,4},
    line2_3 = {"line2_3",2,3},
    line2_4 = {"line2_4",2,4},
    line3_4 = {"line3_4",3,4},
}

function m:initUI()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)
    self.rootNode = csbNode

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        if string.sub(k,1,4) == "line" then
            btn:getChildByName("iconWarning"):setVisible(false)
            btn:setVisible(false)
        end
        self.btnMap[k] = btn
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnOK then
        self:removeFromParent()
    end
end

function m:onRcvAddress(msgTbl)
    dump(msgTbl,"===onRcvAddress===")
    local plist = {}
    for i,v in ipairs(msgTbl.m_POS) do
        self:setHeadIcon(i,v.m_id)
        plist[i] = string.split(v.m_points, "_")
    end
    
    dump(plist,"===onRcvAddress===plist")
    for k,v in pairs(n.nodeMap) do
        if v[2] and v[3] and plist[v[2]] and plist[v[3]] then
            local d1 = plist[v[2]]
            local d2 = plist[v[3]]
            self.btnMap[k]:setVisible(true)
            
            if d2[1] and d2[2] and d1[1] and d1[2] then
                local distance = gComm.CallNativeMng.NativeGaoDe:getDisByTwoPoint(d1[1], d1[2],d2[1],d2[2] or 0)
                
                if distance then
                    if distance < 200 then
                        self.btnMap[k]:getChildByName("iconWarning"):setVisible(true)
                        distance = string.format("%0.1f", distance) .. "米"
                    elseif distance < 1000 then
                        distance = string.format("%0.1f", distance) .. "米"
                    else
                        distance = distance / 1000
                        distance = string.format("%0.1f", distance) .. "千米"
                    end
                    self.btnMap[k]:getChildByName("txtDist"):setString(distance)
                else
                    self.btnMap[k]:getChildByName("txtDist"):setString("测距中")
                end
            else
                self.btnMap[k]:getChildByName("txtDist"):setString("测距中")
            end
        end
    end
end

function m:setHeadIcon(index,uid)
    local imgPath = cc.FileUtils:getInstance():getWritablePath() .. "head_img_" .. uid .. ".png"
    if io.exists(imgPath) then
        self.btnMap["fream" .. index]:setTexture(imgPath)
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    gt.socketClient:registerMsgListener(NetCmd.MSG_GC_GET_USER_ADDR, self, self.onRcvAddress)
    NetMngRoom.getUserAdress()
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unregisterMsgListener(NetCmd.MSG_GC_GET_USER_ADDR)

end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end

return m