
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local netMng = require("app.Common.NetMng.NetLobbyMng")

local csbFile = "Csd/ILobby/Item/ItemBigWinRecord.csb"

local n = {}
local m = class("ItemBigWinRecord", function()
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
    btnCopy = "btnCopy",
}
n.nodeMap = {
    imgBG          = "imgBG",
    txtDateTime    = "txtDateTime",
    txtDesc        = "txtDesc",
    txtWinningCode = "txtWinningCode",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    local size = csbNode:getContentSize()
    self:setContentSize(size.width,size.height)

    -- self.btnMap["txtDesc"]:setString(self.data.WinningDesc)
    self.btnMap["txtWinningCode"]:setString(self.data.winningCode)
    local str = os.date("%Y-%m-%d %H:%M:%S",self.data.dateTime)
    self.btnMap["txtDateTime"]:setString(str)
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnCopy then
        gCallNativeMng.AppNative:copyText(self.data.winningCode)
        gComm.UIUtils.floatText("复制成功")
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