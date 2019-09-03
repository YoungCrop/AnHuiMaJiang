
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")

local csbFile = "Csd/ILobby/UIShop.csb"

local n = {}

n.shopCfg = {
--key --{shopID,card,money}
	-- [1] = {"ywzj.com.ahmahjonghn.fangka.level1", 1 ,   6,},
	-- [2] = {"ywzj.com.ahmahjonghn.fangka.level2", 6 ,  30,},
	-- [3] = {"ywzj.com.ahmahjonghn.fangka.level3", 25, 128,},
    [1] = {"com.ywzj.ahmahjong.fangka.level1", 1 ,   6,},
    [2] = {"com.ywzj.ahmahjong.fangka.leve2", 6 ,  30,},
    [3] = {"com.ywzj.ahmahjong.fangka.level3", 25, 128,},
} 

local m = class("UIShop",gComm.UIMaskLayer)

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
    btnClose       = "btnClose",
    btnBuy         = "btnBuy",
    btnCopyWXCode1 = "btnCopyWXCode1",
    btnCopyWXCode2 = "btnCopyWXCode2",
    btnItem1       = "btnItem1",
    btnItem2       = "btnItem2",
    btnItem3       = "btnItem3",
}
n.nodeMap = {
    txtWXCode1  = "txtWXCode1",
    txtWXCode2  = "txtWXCode2",
    txtBuyCard  = "txtBuyCard",
    txtBuyMoney = "txtBuyMoney",
    nodeWeiXin  = "nodeWeiXin",
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

    for k,v in pairs(n.shopCfg) do
    	local parent = self.btnMap["btnItem" .. k]
    	local txtCard = parent:getChildByName("txtCard")
    	txtCard:setString("房卡" .. v[2] .. "张")
    	txtCard = parent:getChildByName("txtCardMoney")
    	txtCard:setString(v[3] .. "元")
		parent:getChildByName("shop_item_select"):setVisible(false)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.btnClose then
		self:removeFromParent()
    elseif s_name == n.btnMap.btnBuy then
		local ok = gCallNativeMng.AppNative:reqIap(n.shopCfg[self.selectedIndex][1],handler(self,self.reqIapCallBackFun))
		if ok then
			gComm.UIUtils.showLoadingTips(mTxtTipConfig.GetConfigTxt("LTKey_0060"))
		end
    elseif s_name == n.btnMap.btnCopyWXCode1 then
    	self:handleCopy(self.btnMap["txtWXCode1"]:getString())
    elseif s_name == n.btnMap.btnCopyWXCode2 then
    	self:handleCopy(self.btnMap["txtWXCode2"]:getString())
    elseif s_name == n.btnMap.btnItem1 then
    	self:handleSeletedItem(1)
    elseif s_name == n.btnMap.btnItem2 then
    	self:handleSeletedItem(2)
    elseif s_name == n.btnMap.btnItem3 then
    	self:handleSeletedItem(3)
    end
end


function m:reqIapCallBackFun(errorCode, product)
	dump(errorCode,"errorCode")
	dump(product or "nil","product")
	if product and errorCode == 1000 then
		gCallNativeMng.AppNative:payIap(1,handler(self, self.payIapCallBackFun))
	else
		gComm.UIUtils.removeLoadingTips()
		gComm.UIUtils.floatText("购买失败")
	end
end

function m:payIapCallBackFun(succeed,identifier,quantity)
	dump(succeed,"succeed")
	dump(identifier,"identifier")
	dump(quantity,"quantity")

	if succeed then
        for k,v in pairs(n.shopCfg) do
            if v[1] == identifier then
                NetLobbyMng.buyCard(n.shopCfg[k][2])
            end
        end
	else
		gComm.UIUtils.floatText("购买失败")
	end
	gComm.UIUtils.removeLoadingTips()
end

function m:handleSeletedItem( index )
	self.btnMap["btnItem" .. self.selectedIndex]:getChildByName("shop_item_select"):setVisible(false)
	self.btnMap["btnItem" .. index]:getChildByName("shop_item_select"):setVisible(true)
	self.btnMap["txtBuyCard"]:setString(n.shopCfg[index][2])
	self.btnMap["txtBuyMoney"]:setString(n.shopCfg[index][3] .. "元")
	self.selectedIndex = index
end

function m:handleCopy( copyStr )
	gCallNativeMng.AppNative:copyText(copyStr)
	gComm.UIUtils.floatText("复制成功")
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    self.selectedIndex = 1
	self:handleSeletedItem(self.selectedIndex)
    
    if cc.exports.gGameConfig.isiOSAppInReview then
        self.btnMap["nodeWeiXin"]:setVisible(false)
    end
end

function m:onExit()
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m