
local gComm = cc.exports.gComm

local csbFile = "Csd/ICommon/ServerDebug.csb"
local n = {}
local m = class("UIServerDebug",gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self._saveData = {}
    self:initUI()
end


function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnClose = "btnClose",
    btnSend  = "btnSend",
}
n.nodeMap = {
    tfSendMsgNo    = "tfSendMsgNo",
    tfBackMsgNo    = "tfBackMsgNo",
    tfSendMsgParam = "tfSendMsgParam",
    svBackMsg      = "svBackMsg",
    txtBackMsg     = "txtBackMsg",
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
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnClose then
        self:removeFromParent()
    elseif s_name == n.btnMap.btnSend then
        local sendMsgNo = tonumber(self.btnMap["tfSendMsgNo"]:getString())
        if sendMsgNo then
            local backMsgNo = tonumber(self.btnMap["tfBackMsgNo"]:getString())
            if backMsgNo then
                gt.socketClient:registerMsgListener(backMsgNo, self,self.revData)
            end
            local sendMsgParam = self.btnMap["tfSendMsgParam"]:getString()
            local data = self:handleParam(sendMsgParam)
            self:send(data,sendMsgNo)
            self._saveData = {
                _debug_sendMsgNo = sendMsgNo,
                _debug_backMsgNo = backMsgNo or "",
                _debug_sendMsgParam = sendMsgParam,
            }

        end
    end
end

function m:handleParam(data)
    local msg = {}
    local dataArr = string.split(data,",")
    for k,v in pairs(dataArr) do
        local s = string.split(v,"=")
        msg[string.trim(s[1])] = string.trim(s[2])
    end
    return msg
end

function m:send(msgMapData,msgID)
    msgMapData.m_msgId = msgID
    dump(msgMapData,"====send=msg==")
    cc.exports.gt.socketClient:sendMessage(msgMapData)
end

function m:revData(msg)
    local data = json.encode(msg)
    self.btnMap["txtBackMsg"]:setString(data)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    local d = cc.UserDefault:getInstance():getStringForKey("_debug_sendMsgNo","316")
    self.btnMap["tfSendMsgNo"]:setString(d)
    d = cc.UserDefault:getInstance():getStringForKey("_debug_backMsgNo","317")
    self.btnMap["tfBackMsgNo"]:setString(d)
    d = cc.UserDefault:getInstance():getStringForKey("_debug_sendMsgParam","m_clubName = mytest")
    self.btnMap["tfSendMsgParam"]:setString(d)
end

function m:onExit()
    log(self.__TAG,"onExit")
    gt.socketClient:unRegisterMsgListenerByTarget(self)
    
    for k,v in pairs(self._saveData) do
        cc.UserDefault:getInstance():setStringForKey(k,v)
    end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m