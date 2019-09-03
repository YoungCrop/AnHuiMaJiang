
--安庆点炮
local gComm = cc.exports.gComm
local DefineRule = require("app.Common.Config.DefineRule")

local csbFile = "Csd/ILobby/CreateRoom/RuleMJHuaiBei.csb"

--淮北麻将
    -- HBMJ_ZiMoDouble         =204 ,  --自摸翻倍
    -- HBMJ_QiangGangQuanBao   =205 ,  --抢杠全包
    -- HBMJ_GangSuiHu          =201 ,  --杠随胡走
    -- HBMJ_ShiSanYaoDouble    =206 ,  --十三幺翻倍
    -- HBMJ_QiDuiDouble        =207 ,  --七对翻倍
    -- HBMJ_ShiSanBuKaoDouble  =208 ,  --十三不靠翻倍
    -- HBMJ_DunLaPao           =203 ,  --坐拉跑
    -- HBMJ_DuoXiang           =202 ,  --一炮多响
    -- HBMJ_GangHouPaoDouble   =209 ,  --杠后炮翻倍

local n = {}
n.dataMap = {
	--key-----{dataVar,defaultValue,}
	[1] = {"varHBMJ_ROUND"             ,DefineRule.GREnum.SELF_ROUND_NUM_8       },--局数
    [2] = {"varHBMJ_REN_SHU"           ,4                                        },--人数
    [3] = {"varHBMJ_ZiMoDouble"        ,DefineRule.GREnum.HBMJ_ZiMoDouble        },--自摸翻倍
    [4] = {"varHBMJ_QiangGangQuanBao"  ,DefineRule.GREnum.HBMJ_QiangGangQuanBao  },--抢杠全包
    [5] = {"varHBMJ_GangSuiHu"         ,DefineRule.GREnum.HBMJ_GangSuiHu         },--杠随胡走
    [6] = {"varHBMJ_ShiSanYaoDouble"   ,DefineRule.GREnum.HBMJ_ShiSanYaoDouble   },--十三幺翻倍
    [7] = {"varHBMJ_QiDuiDouble"       ,DefineRule.GREnum.HBMJ_QiDuiDouble       },--七对翻倍
    [8] = {"varHBMJ_ShiSanBuKaoDouble" ,DefineRule.GREnum.HBMJ_ShiSanBuKaoDouble },--十三不靠翻倍
    [9] = {"varHBMJ_DunLaPao"          ,DefineRule.GREnum.HBMJ_DunLaPao          },--坐拉跑
    [10]= {"varHBMJ_DuoXiang"          ,DefineRule.GREnum.HBMJ_DuoXiang          },--一炮多响
    [11]= {"varHBMJ_GangHouPaoDouble"  ,DefineRule.GREnum.HBMJ_GangHouPaoDouble  },--杠后炮翻倍
    [12]= {"varHBMJ_DiFenEnum"         ,DefineRule.GREnum.HBMJ_DiFen1            },--底分枚举选项
    --保存的值有：GREnum.HBMJ_DiFen1，GREnum.HBMJ_DiFen2，GREnum.HBMJ_DiFen5，GREnum.HBMJ_DiFenInput，这4个值

    [13]= {"varHBMJ_DiFenVar"          ,1                                        },--底分值,
    --txtDiFenInput控件文本所显示的值
}

n.btnMap = {
---key ----{btnName,dataMapKey,ruleEnum}
	[1]  = {"txtRoundType1",1,DefineRule.GREnum.SELF_ROUND_NUM_8},
	[2]  = {"txtRoundType2",1,DefineRule.GREnum.SELF_ROUND_NUM_16},
    [3]  = {"txtRoundType3",1,DefineRule.GREnum.SELF_ROUND_NUM_1},

    [4]  = {"txtRen4",  2,  4},
    [5]  = {"txtRen3",  2,  3},
    [6]  = {"txtRen2",  2,  2},

	[7]  = {"txtWF1",  3,  DefineRule.GREnum.HBMJ_ZiMoDouble        },--自摸翻倍
	[8]  = {"txtWF2",  4,  DefineRule.GREnum.HBMJ_QiangGangQuanBao  },--抢杠全包
	[9]  = {"txtWF3",  5,  DefineRule.GREnum.HBMJ_GangSuiHu         },--杠随胡走
	[10] = {"txtWF4",  6,  DefineRule.GREnum.HBMJ_ShiSanYaoDouble   },--十三幺翻倍
    [11] = {"txtWF5",  7,  DefineRule.GREnum.HBMJ_QiDuiDouble       },--七对翻倍
	[12] = {"txtWF6",  8,  DefineRule.GREnum.HBMJ_ShiSanBuKaoDouble },--十三不靠翻倍
	[13] = {"txtWF7",  9,  DefineRule.GREnum.HBMJ_DunLaPao          },--坐拉跑
	[14] = {"txtWF8", 10,  DefineRule.GREnum.HBMJ_DuoXiang          },--一炮多响
    [15] = {"txtWF9", 11,  DefineRule.GREnum.HBMJ_GangHouPaoDouble  },--杠后炮翻倍

    [16]= {"txtDiFen5" ,    12,DefineRule.GREnum.HBMJ_DiFen1     },--底分5
    [17]= {"txtDiFen10",    12,DefineRule.GREnum.HBMJ_DiFen2     },--底分10
    [18]= {"txtDiFen20",    12,DefineRule.GREnum.HBMJ_DiFen5     },--底分20
    [19]= {"txtDiFenInput", 12,DefineRule.GREnum.HBMJ_DiFenInput },--底分input
}
n.InputSorceRange = {min = 1,max = 5}

n.moreBtnMap = {
---key -- {btnType,btnName}
    btnReduce = {"btn", "btnReduce",},
    btnPlus   = {"btn", "btnPlus",  },
    txtScore  = {"node","txtScore", },
}

local m = class("RuleHuaiBei", function()
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
    dump(n.dataMap,"===m:getData()==")
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
        log(k,v[1])
        btn:setTag(k)
        self.nodeSet[k] = btn
        local dataMapKey = v[2]
        self:setSelected(self.ruleDataSet[dataMapKey] == v[3],btn)
    end

    for k,v in pairs(n.moreBtnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeSet[k] = btn
        if v[1] == "btn" then
            gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnScoreClick))
        end
    end

    if self.ruleDataSet[13] > n.InputSorceRange.max or
         (self.ruleDataSet[12] ~= DefineRule.GREnum.HBMJ_DiFen1 and
            self.ruleDataSet[12] ~= DefineRule.GREnum.HBMJ_DiFen2 and
            self.ruleDataSet[12] ~= DefineRule.GREnum.HBMJ_DiFen5 and
            self.ruleDataSet[12] ~= DefineRule.GREnum.HBMJ_DiFenHBMJ_DiFenInput) then
        self.ruleDataSet[13] = n.InputSorceRange.max
        self.ruleDataSet[12] = DefineRule.GREnum.HBMJ_DiFenInput
        self:setSelected(false,self.nodeSet[16])
        self:setSelected(false,self.nodeSet[17])
        self:setSelected(false,self.nodeSet[18])
        self:setSelected(true,self.nodeSet[19])
    end
    self.nodeSet["txtScore"]:setString(self.ruleDataSet[13])
    self.nodeSet[3]:setVisible(false)
end

function m:onBtnScoreClick( _sender )
    local s_name = _sender:getName()
    if s_name == "btnReduce" then
        self:scoreHandle(false)
    elseif s_name == "btnPlus" then
        self:scoreHandle(true)
    end
end
function m:scoreHandle( isPlus )
    local k = 13
    if isPlus then
        self.ruleDataSet[k] = self.ruleDataSet[k] + 1
        if self.ruleDataSet[k] > n.InputSorceRange.max then
            self.ruleDataSet[k] = n.InputSorceRange.max
        end
    else
        self.ruleDataSet[k] = self.ruleDataSet[k] - 1
        if self.ruleDataSet[k] < 1 then
            self.ruleDataSet[k] = 1
        end
    end
    self.nodeSet["txtScore"]:setString(self.ruleDataSet[k])

    if self.ruleDataSet[12] ~= DefineRule.GREnum.HBMJ_DiFenInput then
        for k,v in pairs(n.btnMap) do
            if v[3] == self.ruleDataSet[12] then
                self:setSelected(false,self.nodeSet[k])
            end
        end
        self:setSelected(true,self.nodeSet[19])
        self.ruleDataSet[12] = DefineRule.GREnum.HBMJ_DiFenInput
    end
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
        m_gameID = DefineRule.GameID.MJHuaiBei,--游戏类别
        roundType = self.ruleDataSet[1],--局数
		ruleArray = {},--规则
        m_MaxCircle = DefineRule.GameRoundNum[self.ruleDataSet[1]],
        m_playerNum = self.ruleDataSet[2],
	}
	for i,v in ipairs(self.ruleDataSet) do
        if v ~= -1 and i ~= 1 and i ~= 2 and i ~= 12 and i ~= 13 then
            msg.ruleArray[#msg.ruleArray + 1] = v
        end
	end
    --底分:10000+?
    local diFen = {
        [DefineRule.GREnum.HBMJ_DiFen1   ] = 1,
        [DefineRule.GREnum.HBMJ_DiFen2   ] = 2,
        [DefineRule.GREnum.HBMJ_DiFen5   ] = 5,
        [DefineRule.GREnum.HBMJ_DiFenInput] = self.ruleDataSet[13],
    }
    log("==huaibei=getRuleData===",diFen[self.ruleDataSet[12]])
    msg.ruleArray[#msg.ruleArray + 1] = 10000 + diFen[self.ruleDataSet[12]]

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
