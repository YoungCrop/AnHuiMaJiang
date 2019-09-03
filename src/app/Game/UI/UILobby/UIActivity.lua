
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local csbFile = "Csd/ILobby/UIActivity.csb"

local n = {}
local m = class("UIActivity",gComm.UIMaskLayer)

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
    btnExit = "btnExit",
    btnSharePYQ = "btnSharePYQ",
}
n.nodeMap = {
    
}

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnExit then
        self:removeFromParent()
    elseif s_name == n.btnMap.btnSharePYQ then
        local title = "【人人安徽麻将】：咱们自己人的麻将，火爆上线，来人！！！开壳！！！"
        local _type = gCallNativeMng.shareType.WeiXinPYQ
        local url = gCallNativeMng.NativeMeChuang:getMCURL()
        gCallNativeMng:shareURL(_type,url,title,"",handler(self, self.shareHandler))
    end
end

function m:shareHandler()
    self:removeFromParent()
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