
local gComm = cc.exports.gComm
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Item/ItemChatSpeak.csb"

local n = {}
local m = class("ItemChatSpeak", function()
    -- return display.newLayer()
    return ccui.Widget:create()
    -- return ccui.Button:create()
end)

function m:ctor(args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        index       = args.index,
        speakStr    = args.speakStr,
        clickHandle = args.clickHandle,
    }
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    -- btnChat   = "btnChat",
    btnChat   = "txtChat",
}
n.nodeMap = {
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, v)
        -- gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))

        -- btn:setTouchEnabled(true)
        -- btn:addTouchEventListener(handler(self,self.onTouchHandler))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height + 0)
    self.btnMap["btnChat"]:setString(self.param.speakStr)
    self.btnMap["btnChat"]:setSwallowTouches(false)

    self:setTouchEnabled(true)
    self:addTouchEventListener(handler(self,self.onTouchHandler))
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    local tag = _sender:getTag()
    if s_name == n.btnMap.btnChat then
    end
end

function m:onTouchHandler(sender,_event)
    if _event == ccui.TouchEventType.began then
        self._bPos = sender:getWorldPosition()
        self._dis = 0
    elseif _event == ccui.TouchEventType.moved then
        local _mPos = sender:getWorldPosition()
        local dis = cc.pDistanceSQ(self._bPos, _mPos)
        self._dis = self._dis > dis and self._dis or dis
    elseif _event == ccui.TouchEventType.ended then
        if self._dis <= 20 then
            if self.param.clickHandle then
                self.param.clickHandle(self.param.index)
            end
        end
    elseif _event == ccui.TouchEventType.canceled then

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