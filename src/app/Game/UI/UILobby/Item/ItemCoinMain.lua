
local gComm = cc.exports.gComm
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Item/ItemCoinMain.csb"

local n = {}
local m = class("ItemCoinMain", function()
    -- return display.newLayer()
    return ccui.Widget:create()
    -- return ccui.Button:create()
end)

function m:ctor(args)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.param = {
        index       = args.index,
        clickHandle = args.clickHandle,
        coinNum     = args.coinNum,
        diFen       = args.diFen,
        menNum      = args.menNum,--在线人数，服务器发送
        Open        = args.Open,--1开，0关
        itemImgBG   = args.itemImgBG,
    }
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
}
n.nodeMap = {
    imgBG        = "imgBG",
    imgBGClosed  = "imgBGClosed",
    nodeDataRoot = "nodeDataRoot",
    txtCoinNum   = "txtCoinNum",
    txtDiFen     = "txtDiFen",
    txtMenNum    = "txtMenNum",
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
    self:setContentSize(size.width,size.height)

    self.btnMap["txtCoinNum"]:setString(self.param.coinNum)
    self.btnMap["txtDiFen"]:setString(self.param.diFen)
    self.btnMap["txtMenNum"]:setString(self.param.menNum)
    if self.param.Open == 1 then----1开，0关
        self.btnMap["imgBG"]:setVisible(true)
        self.btnMap["imgBGClosed"]:setVisible(false)
        self.btnMap["imgBG"]:loadTexture(self.param.itemImgBG,ccui.TextureResType.plistType)
    else
        self.btnMap["imgBG"]:setVisible(false)
        self.btnMap["imgBGClosed"]:setVisible(true)
    end

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
    log("--onTouchHandler-444-")
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
                if self.param.Open == 1 then----1开，0关
                    self.param.clickHandle(self.param.index)
                end
            end
        end
    elseif _event == ccui.TouchEventType.canceled then

    end
end
function m:setCurOnlineManNum(num)
    self.btnMap["txtMenNum"]:setString(num)
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