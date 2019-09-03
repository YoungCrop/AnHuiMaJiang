
--安庆点炮
local gComm = cc.exports.gComm
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/ILobby/CreateRoom/RuleMJAnQin.csb"

local n = {}
n.dataMap = {
	--key-----{dataVar,defaultValue,}
	[1] = {"varAQDP_ROUND"             ,DefineRule.GREnum.SELF_ROUND_NUM_8       },--局数

    [2] = {"varAQDP_DIAN_PAO"          ,DefineRule.GREnum.AQDP_DIAN_PAO          },--可点炮
    [3] = {"varAQDP_YI_PAO_DUO_XIANG"  ,DefineRule.GREnum.AQDP_YI_PAO_DUO_XIANG  },--一炮多响
    [14]= {"varAQDP_QIANG_GANG_HU"     ,DefineRule.GREnum.AQDP_QIANG_GANG_HU     },--抢杠胡
    [4] = {"varAQDP_QING_YI_SE"        ,-1},--DefineRule.GREnum.AQDP_QING_YI_SE        },--清一色
    [5] = {"varAQDP_DAN_DIAO_ZI_MO"    ,DefineRule.GREnum.AQDP_DAN_DIAO_ZI_MO    },--单吊风(必须自摸)
    [6] = {"varAQDP_CHI_PENG_NEXT_GANG",DefineRule.GREnum.AQDP_CHI_PENG_NEXT_GANG},--吃碰后可杠
    [7] = {"varAQDP_AN_HUA_CAN_HU"     ,DefineRule.GREnum.AQDP_AN_HUA_CAN_HU     },--暗花可胡
    [8] = {"varAQDP_SAN_KOU"           ,DefineRule.GREnum.AQDP_SAN_KOU           },--正三口反三口
    [9] = {"varAQDP_YI_TIAO_LONG"      ,-1},--DefineRule.GREnum.AQDP_YI_TIAO_LONG      },--一条龙
    [10]= {"varAQDP_ZI_MO_DI_DOUBLE"   ,DefineRule.GREnum.AQDP_ZI_MO_DI_DOUBLE   },--自摸底翻倍
    [11]= {"varAQDP_AN_GANG_SHOW"      ,-1},--DefineRule.GREnum.AQDP_AN_GANG_SHOW      },--暗杠显示(前端显示:摆出一张或者完全不现实 2种展现方式)

    [12]= {"varAQDP_GANG_OPEN_FOOL"    ,DefineRule.GREnum.AQDP_GANG_OPEN_FOOL_369},--杠上开花  369;每多一个+3分;246;每多一个+2分
    [13]= {"varAQDP_DI_FOOL"           ,DefineRule.GREnum.AQDP_DI_FOOL_1_1       },--1底1花

    [15]= {"varAQDP_REN_SHU"           ,4           },--人数
}

n.btnMap = {
---key ----{btnName,dataMapKey,ruleEnum}
	[1] = {"txtRoundType1",1,DefineRule.GREnum.SELF_ROUND_NUM_8},
	[2] = {"txtRoundType2",1,DefineRule.GREnum.SELF_ROUND_NUM_16},
    [26]= {"txtRoundType3",1,DefineRule.GREnum.SELF_ROUND_NUM_1},

    [27]= {"txtRen4",15,4},
    [28]= {"txtRen3",15,3},
    [29]= {"txtRen2",15,2},

	[3] = {"txtWF1",2,DefineRule.GREnum.AQDP_DIAN_PAO},         -- AQDP_DIAN_PAO           = 5, --可点炮
	[4] = {"txtWF2",3,DefineRule.GREnum.AQDP_YI_PAO_DUO_XIANG}, -- AQDP_YI_PAO_DUO_XIANG   = 6, --一炮多响
	[5] = {"txtWF3",14,DefineRule.GREnum.AQDP_QIANG_GANG_HU},    -- AQDP_QIANG_GANG_HU      = 7, --抢杠胡
	[6] = {"txtWF4",4,DefineRule.GREnum.AQDP_QING_YI_SE},       -- AQDP_QING_YI_SE         = 8, --清一色
    [7]= {"txtWF10",5,DefineRule.GREnum.AQDP_DAN_DIAO_ZI_MO},   -- AQDP_DAN_DIAO_ZI_MO     = 9,  --单吊风(必须自摸)
	[8] ={"txtWF6",6,DefineRule.GREnum.AQDP_CHI_PENG_NEXT_GANG},-- AQDP_CHI_PENG_NEXT_GANG = 10, --吃碰后可杠
	[9] ={"txtWF7",7,DefineRule.GREnum.AQDP_AN_HUA_CAN_HU},     -- AQDP_AN_HUA_CAN_HU      = 11, --暗花可胡
	[10]= {"txtWF9",8,DefineRule.GREnum.AQDP_SAN_KOU},          -- AQDP_SAN_KOU            = 12, --正三口反三口
    [11]= {"txtWF5",9,DefineRule.GREnum.AQDP_YI_TIAO_LONG},     -- AQDP_YI_TIAO_LONG       = 13, --一条龙
    [12]={"txtWF11",10,DefineRule.GREnum.AQDP_ZI_MO_DI_DOUBLE}, -- AQDP_ZI_MO_DI_DOUBLE    = 14, --自摸底翻倍
    [13]= {"txtWF8",11,DefineRule.GREnum.AQDP_AN_GANG_SHOW},    -- AQDP_AN_GANG_SHOW       = 15, --暗杠显示(前端显示:摆出一张或者完全不现实 2种展现方式)

    [16]= {"txtGangKai369",12,DefineRule.GREnum.AQDP_GANG_OPEN_FOOL_369},-- AQDP_GANG_OPEN_FOOL_369 = 16, --杠上开花  369;每多一个+3分
    [17]= {"txtGangKai246",12,DefineRule.GREnum.AQDP_GANG_OPEN_FOOL_246},-- AQDP_GANG_OPEN_FOOL_246 = 17, --杠上开花  246;每多一个+2分

    [18]= {"txtDiHua1_1",13,DefineRule.GREnum.AQDP_DI_FOOL_1_1},   -- AQDP_DI_FOOL_1_1    = 18,  --1底1花
    [19]= {"txtDiHua2_2",13,DefineRule.GREnum.AQDP_DI_FOOL_2_2},   -- AQDP_DI_FOOL_2_2    = 19,  --2底2花
    [20]= {"txtDiHua5_1",13,DefineRule.GREnum.AQDP_DI_FOOL_5_1},   -- AQDP_DI_FOOL_5_1    = 20,  --5底1花
    [21]= {"txtDiHua5_5",13,DefineRule.GREnum.AQDP_DI_FOOL_5_5},   -- AQDP_DI_FOOL_5_5    = 21,  --5底5花
    [22]= {"txtDiHua10_5", 13,DefineRule.GREnum.AQDP_DI_FOOL_10_5},  -- AQDP_DI_FOOL_10_5   = 22,  --10底5花
    [23]= {"txtDiHua10_10",13,DefineRule.GREnum.AQDP_DI_FOOL_10_10}, -- AQDP_DI_FOOL_10_10  = 23,  --10底10花
    [24]= {"txtDiHua20_10",13,DefineRule.GREnum.AQDP_DI_FOOL_20_10}, -- AQDP_DI_FOOL_20_10  = 24,  --20底10花
    [25]= {"txtDiHua20_20",13,DefineRule.GREnum.AQDP_DI_FOOL_20_20}, -- AQDP_DI_FOOL_20_20  = 25,  --20底20花
}

local m = class("RuleAnQing", function()
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
    if self.ruleDataSet[1] == DefineRule.GREnum.SELF_ROUND_NUM_6 then
        self.ruleDataSet[1] = DefineRule.GREnum.SELF_ROUND_NUM_8
    elseif self.ruleDataSet[1] == DefineRule.GREnum.SELF_ROUND_NUM_12 then
        self.ruleDataSet[1] = DefineRule.GREnum.SELF_ROUND_NUM_16
    end
end

function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)
	gComm.UIUtils.seekNodeByName(csbNode, "imgBG"):setVisible(false)

    for k,v in pairs(n.btnMap) do
    	local btn = gComm.UIUtils.seekNodeByName(csbNode, v[1])
        if string.sub(v[1],1,5) == "txtWF" then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onCheckBtnClick))
        else
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        end
        btn:setTag(k)
        self.nodeSet[k] = btn
        local dataMapKey = v[2]
        self:setSelected(self.ruleDataSet[dataMapKey] == v[3],btn)
    end
    self.nodeSet[26]:setVisible(false)
end

function m:onCheckBtnClick( _sender )
    local s_name = _sender:getName()
    local tag = _sender:getTag()
    local dataMapKey = n.btnMap[tag][2]
    local curBtnDataValue = n.btnMap[tag][3]
    local parent = self.nodeSet[tag]

    local ckBox = _sender:getChildByName("cb")
    local isSelected = ckBox:isSelected()
    self:setCheckBoxSelected(not isSelected,_sender)

    if isSelected then
        self.ruleDataSet[dataMapKey] = -1
    else
        self.ruleDataSet[dataMapKey] = curBtnDataValue
    end
--一炮多响,抢杠胡,暗花可胡 依赖与可点炮
--可点炮、单吊风(必自摸)至少选中一个
    if s_name == "txtWF2" or s_name == "txtWF3" or s_name == "txtWF7" then
        if self.ruleDataSet[2] == -1 then
            self.ruleDataSet[2] = DefineRule.GREnum.AQDP_DIAN_PAO
            self:setCheckBoxSelected(true,self.nodeSet[3])
        end
    elseif s_name == "txtWF1" then
        if self.ruleDataSet[dataMapKey] == -1 and self.ruleDataSet[5] == -1 then
            self.ruleDataSet[5] = DefineRule.GREnum.AQDP_DAN_DIAO_ZI_MO
            self:setCheckBoxSelected(true,self.nodeSet[7])
        end
        if self.ruleDataSet[dataMapKey] == -1 then
            self.ruleDataSet[3] = -1
            self.ruleDataSet[14] = -1
            self.ruleDataSet[7] = -1
            self:setCheckBoxSelected(false,self.nodeSet[4])
            self:setCheckBoxSelected(false,self.nodeSet[5])
            self:setCheckBoxSelected(false,self.nodeSet[9])
        end
    elseif s_name == "txtWF10" then
        if self.ruleDataSet[dataMapKey] == -1 and self.ruleDataSet[2] == -1 then
            self.ruleDataSet[2] = DefineRule.GREnum.AQDP_DIAN_PAO
            self:setCheckBoxSelected(true,self.nodeSet[3])
        end
    end
end

function m:setCheckBoxSelected(isSelected,parentNode)
    local ckBox = parentNode:getChildByName("cb")
    if isSelected then
        ckBox:setSelected(true)
        parentNode:setTextColor(self.selectColor)
    else
        ckBox:setSelected(false)
        parentNode:setTextColor(self.oriColor)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    local tag = _sender:getTag()
    local dataMapKey = n.btnMap[tag][2]
    local curBtnDataValue = n.btnMap[tag][3]

    local str = ""
    str = str .. " tag=" .. tag
    str = str .. " dataMapKey=" .. dataMapKey
    str = str .. " curBtnDataValue=" .. curBtnDataValue
    print("====str=",str)
    dump(self.ruleDataSet)

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
end

function m:setSelected(isSelected,parentNode)
    local ckBox = gComm.UIUtils.seekNodeByName(parentNode,"cb")
    if isSelected then
        ckBox:setSelected(true)
        parentNode:setTextColor(self.selectColor)
    else
        ckBox:setSelected(false)
        parentNode:setTextColor(self.oriColor)
    end
end

function m:getRuleData()
	local msg = {
        m_gameID = DefineRule.GameID.AnQinDianPao,--游戏类别
        roundType = self.ruleDataSet[1],--局数
		ruleArray = {},--规则
        m_MaxCircle = DefineRule.GameRoundNum[self.ruleDataSet[1]],
        m_playerNum = self.ruleDataSet[15],
	}
	for i,v in ipairs(self.ruleDataSet) do
        if v ~= -1 and i ~= 1 and i ~= 15 then
            msg.ruleArray[#msg.ruleArray + 1] = v
        end
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
