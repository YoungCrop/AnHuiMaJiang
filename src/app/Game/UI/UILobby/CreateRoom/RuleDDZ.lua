
local gComm = cc.exports.gComm
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/ILobby/CreateRoom/RuleDDZ.csb"

local n = {}
n.dataMap = {
	--key-----{dataVar,defaultValue,}
	[1] = {"varDDZRoundType",DefineRule.GREnum.SELF_ROUND_NUM_4},--局数
	[2] = {"varDDZPlayType",DefineRule.GREnum.DDZ_JIAO_DIZHU},-- 玩法
	[3] = {"varDDZBombLimit",DefineRule.GREnum.DDZ_BOMB_3},-- 炸弹上限
	[4] = {"varShoupaiShow",DefineRule.GREnum.DDZ_SHOW_SHOUPAI_AMOUNT},-- 手牌显示
	[5] = {"varAlarmStatus",DefineRule.GREnum.DDZ_ALARM_REMAIN_3},--报警展示
    [6] = {"varDaiTi",DefineRule.GREnum.DDZ_JIAO_FEN_DAI_TI},--带踢,复选，非选中为-1
}

n.btnMap = {
---key ----{btnName,dataMapKey,ruleEnum}
	[1] = {"Node_roundType_1",1,DefineRule.GREnum.SELF_ROUND_NUM_4},
	[2] = {"Node_roundType_2",1,DefineRule.GREnum.SELF_ROUND_NUM_8},
	[3] = {"Node_roundType_3",1,DefineRule.GREnum.SELF_ROUND_NUM_12},

	[4] = {"Node_WanFa1",2,DefineRule.GREnum.DDZ_JIAO_DIZHU},
	[5] = {"Node_WanFa2",2,DefineRule.GREnum.DDZ_JIAO_FEN},

	[6] = {"Node_Bomb3",3,DefineRule.GREnum.DDZ_BOMB_3},
	[7] = {"Node_Bomb4",3,DefineRule.GREnum.DDZ_BOMB_4},
	[8] = {"Node_Bomb5",3,DefineRule.GREnum.DDZ_BOMB_5},

	[9]  = {"Node_HandCard1",4,DefineRule.GREnum.DDZ_SHOW_SHOUPAI_AMOUNT},
	[10] = {"Node_HandCard2",4,DefineRule.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT},

	[11] = {"Node_alarm1",5,DefineRule.GREnum.DDZ_ALARM_HIDE},
	[12] = {"Node_alarm2",5,DefineRule.GREnum.DDZ_ALARM_REMAIN_3},
	[13] = {"Node_alarm3",5,DefineRule.GREnum.DDZ_ALARM_REMAIN_5},

    [14]= {"Node_WanFa2_2",6,DefineRule.GREnum.DDZ_JIAO_FEN_DAI_TI},--这个key后面会用到
    -- [15]= {"cbTest",6,12},--这个key后面会用到
    -- [16]= {"txtText",6,102},--这个key后面会用到
}

local m = class("RuleDDZ", function()
    return display.newNode()
end)

function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
	self.oriColor = cc.c4b(96,15,3,255)
	self.selectColor = cc.c4b(179,0,58,255)
	self.nodeSet = {} --控件容器
	self.ruleDataSet = {} --数据容器
	self:getData()
    self:loadCSB()
end

function m:getData()
	for k,v in pairs(n.dataMap) do
		self.ruleDataSet[k] = cc.UserDefault:getInstance():getIntegerForKey(v[1],v[2])
	end
end

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)
	gComm.UIUtils.seekNodeByName(csbNode, "imgBG"):setVisible(false)
    self.nodeAlarmParent = gComm.UIUtils.seekNodeByName(csbNode, "nodeAlarmParent")
    
    for k,v in pairs(n.btnMap) do
    	local parant = gComm.UIUtils.seekNodeByName(csbNode, v[1])
        local btn = parant:getChildByName("txt")
        if v[1] == "Node_WanFa2_2" or v[1] == "txtText" then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onCheckBtnClick))
        else
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        end
        btn:setTag(k)
        self.nodeSet[k] = parant
        local dataMapKey = v[2]
        self:setSelected(self.ruleDataSet[dataMapKey] == v[3],parant)
    end

    local curBtnDataValue = self.ruleDataSet[4]
    if curBtnDataValue == DefineRule.GREnum.DDZ_SHOW_SHOUPAI_AMOUNT then
    	self.nodeAlarmParent:setVisible(false)
    elseif curBtnDataValue == DefineRule.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT then
    	self.nodeAlarmParent:setVisible(true)
    end

    local curBtnDataValue = self.ruleDataSet[2]
    if curBtnDataValue == DefineRule.GREnum.DDZ_JIAO_DIZHU then
        self.nodeSet[14]:setVisible(false)
    elseif curBtnDataValue == DefineRule.GREnum.DDZ_JIAO_FEN then
        self.nodeSet[14]:setVisible(true)
    end
end

function m:onCheckBtnClick( _sender )
    local s_name = _sender:getName()
    local tag = _sender:getTag()
    local dataMapKey = n.btnMap[tag][2]
    local curBtnDataValue = n.btnMap[tag][3]
    local parent = self.nodeSet[tag]
    local cb = parent:getChildByName("checkbox")
    -- gComm.Debug:logUD(cb,"--onCheckBtnClick--_sender--")
    local isSelected = cb:isSelected()
    self:setSelected(not isSelected,parent)

    if isSelected then
        self.ruleDataSet[dataMapKey] = -1
    else
        self.ruleDataSet[dataMapKey] = curBtnDataValue
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    local tag = _sender:getTag()
    local dataMapKey = n.btnMap[tag][2]
    local curBtnDataValue = n.btnMap[tag][3]

    -- local str = ""
    -- str = str .. " tag=" .. tag
    -- str = str .. " dataMapKey=" .. dataMapKey
    -- str = str .. " curBtnDataValue=" .. curBtnDataValue

    -- print("====str=",str)
    -- dump(self.ruleDataSet)

    if self.ruleDataSet[dataMapKey] == curBtnDataValue then--已经选中，则返回
    	return 
    end

    for k,v in pairs(n.btnMap) do
    	if dataMapKey == v[2] then --key相同的话，说明是同一组，要取消选中
        	self:setSelected(false,self.nodeSet[k])
    	end
    end
    self:setSelected(true,self.nodeSet[tag])
    
    self.ruleDataSet[dataMapKey] = curBtnDataValue
    if curBtnDataValue == DefineRule.GREnum.DDZ_SHOW_SHOUPAI_AMOUNT then
    	self.nodeAlarmParent:setVisible(false)
    elseif curBtnDataValue == DefineRule.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT then
    	self.nodeAlarmParent:setVisible(true)
    elseif curBtnDataValue == DefineRule.GREnum.DDZ_JIAO_DIZHU then
        self.nodeSet[14]:setVisible(false)
    elseif curBtnDataValue == DefineRule.GREnum.DDZ_JIAO_FEN then
        self.nodeSet[14]:setVisible(true)
    end
end


function m:setSelected(isSelected,parentNode)
    local ckBox = gComm.UIUtils.seekNodeByName(parentNode,"checkbox")
    local txt = gComm.UIUtils.seekNodeByName(parentNode,"txt")
    if isSelected then
        ckBox:setSelected(true)
        txt:setTextColor(self.selectColor)
    else
        ckBox:setSelected(false)
        txt:setTextColor(self.oriColor)
    end
end

function m:getRuleData()
	local msg = {
        m_gameID = DefineRule.GameID.POKER_DDZ,--游戏类别
        roundType = self.ruleDataSet[1],--局数
		ruleArray = {},--规则
        m_MaxCircle = 8,
        m_playerNum = 3,
	}
    msg.m_MaxCircle = DefineRule.GameRoundNum[self.ruleDataSet[1]]

    msg.ruleArray[#msg.ruleArray + 1] = self.ruleDataSet[2]
    msg.ruleArray[#msg.ruleArray + 1] = self.ruleDataSet[3]
    msg.ruleArray[#msg.ruleArray + 1] = self.ruleDataSet[4]
    if self.ruleDataSet[4] == DefineRule.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT then
        msg.ruleArray[#msg.ruleArray + 1] = self.ruleDataSet[5]
    end
    if self.ruleDataSet[2] == DefineRule.GREnum.DDZ_JIAO_FEN and self.ruleDataSet[6] ~= -1 then
        msg.ruleArray[#msg.ruleArray + 1] = self.ruleDataSet[6]
    end

	return msg
end
function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
	for k,v in pairs(n.dataMap) do
		cc.UserDefault:getInstance():setIntegerForKey(v[1],self.ruleDataSet[k])
	end
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
	
end


return m