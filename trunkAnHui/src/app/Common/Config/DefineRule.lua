--DefineRule
local m = {}

m.GameID = {
	MJChangChun   = 1,--长春麻将
	GameID_TDK    = 2,--填大坑
    POKER_DDZ     = 4,--斗地主
    AnQinDianPao  = 5,--安庆点炮
    MJHuaiBei     = 6,--淮北麻将
}

m.RoomType = {
	General  = 0,
	Agent    = 1,
	BigMatch = 2,
	Club     = 3,
	ClubQuickRoom = 6,--亲友圈代开房(系统开房)
	CoinRoom = 7,--金币场
	ClubQuickRoomPlayer = 8, --玩家俱乐部(快捷创建)
}

m.GameTypeName = {
	[m.GameID.MJChangChun  ] = "长春麻将",
	[m.GameID.GameID_TDK   ] = "填大坑",
    [m.GameID.POKER_DDZ    ] = "斗地主",
    [m.GameID.AnQinDianPao ] = "安庆麻将",
    [m.GameID.MJHuaiBei    ] = "淮北麻将",
}

--GameRuleEnum游戏规则枚举
m.GREnum = {
--自己定义,后期给删除
	SELF_ROUND_NUM_1  = 1000,
	SELF_ROUND_NUM_2  = 1001,
	SELF_ROUND_NUM_4  = 1002,
	SELF_ROUND_NUM_6  = 1003,
	SELF_ROUND_NUM_8  = 1004,
	SELF_ROUND_NUM_12 = 1005,
	SELF_ROUND_NUM_15 = 1006,
	SELF_ROUND_NUM_16 = 1007,
	SELF_ROUND_NUM_30 = 1008,

--自己定义
	MJ_PEOPLE_NUM_2         = 2,
	MJ_PEOPLE_NUM_3         = 3,
	MJ_PEOPLE_NUM_4         = 4,

--安庆麻将
--一炮多响,抢杠胡,暗花可胡 依赖与可点炮
--可点炮、单吊风(必自摸)至少选中一个
	AQDP_DIAN_PAO			= 5,   --可点炮
	AQDP_YI_PAO_DUO_XIANG	= 6,   --一炮多响
	AQDP_QIANG_GANG_HU		= 7,   --抢杠胡
	AQDP_QING_YI_SE			= 8,   --带清一色
	AQDP_DAN_DIAO_ZI_MO		= 9,   --单吊风(必自摸)
	AQDP_CHI_PENG_NEXT_GANG	= 10,  --吃碰后可杠
	AQDP_AN_HUA_CAN_HU		= 11,  --暗花可胡
	AQDP_SAN_KOU			= 12,  --正三口反三口
	AQDP_YI_TIAO_LONG		= 13,  --带一条龙
	AQDP_ZI_MO_DI_DOUBLE	= 14,  --自摸底翻倍
	AQDP_AN_GANG_SHOW		= 15,  --暗杠显示(前端显示:摆出一张或者完全不现实 2种展现方式)

	AQDP_GANG_OPEN_FOOL_369	= 16,  --杠开369;每多一个+3分，杠上开花
	AQDP_GANG_OPEN_FOOL_246	= 17,  --杠开246;每多一个+2分，杠上开花
	AQDP_DI_FOOL_1_1		= 18,  --1底1花
	AQDP_DI_FOOL_2_2		= 19,  --2底2花
	AQDP_DI_FOOL_5_1		= 20,  --5底1花
	AQDP_DI_FOOL_5_5		= 21,  --5底5花
	AQDP_DI_FOOL_10_5		= 22,  --10底5花
	AQDP_DI_FOOL_10_10		= 23,  --10底10花
	AQDP_DI_FOOL_20_10		= 24,  --20底10花
	AQDP_DI_FOOL_20_20		= 25,  --20底20花

--淮北麻将
	HBMJ_GangSuiHu			=26 ,  --杠了就有,--杠随胡走替换成了杠了就有
	HBMJ_DuoXiang			=27 ,  --一炮多响
	HBMJ_DunLaPao			=28 ,  --坐拉跑
	HBMJ_ZiMoDouble			=29 ,  --自摸翻倍
	HBMJ_QiangGangQuanBao	=30 ,  --抢杠全包
	HBMJ_ShiSanYaoDouble	=31 ,  --十三幺翻倍
	HBMJ_QiDuiDouble		=32 ,  --七对翻倍
	HBMJ_ShiSanBuKaoDouble	=33 ,  --十三不靠翻倍
	HBMJ_GangHouPaoDouble	=34 ,  --杠后炮翻倍
	-- HBMJ_DiFen5         	=35 ,  --底分5
	-- HBMJ_DiFen10         	=36 ,  --底分10
	-- HBMJ_DiFen20        	=37 ,  --底分20
	HBMJ_DiFenInput        	=38 ,  --底分input
	HBMJ_DiFen1         	=39 ,  --底分1
	HBMJ_DiFen2         	=40 ,  --底分2
	HBMJ_DiFen5        	    =41 ,  --底分5
	HBMJ_DiFenName        	=10000 ,  --底分--取值范围[10000,10040]

--斗地主
	DDZ_BOMB_3              = 125,	 --斗地主3炸
	DDZ_BOMB_4              = 126,	 --斗地主4炸
	DDZ_BOMB_5              = 127,	 --斗地主5炸
	DDZ_JIAO_FEN            = 128,   --叫分
	DDZ_JIAO_DIZHU          = 129,   --叫地主
	DDZ_JIAO_FEN_DAI_TI     = 155,   --叫分带踢
	DDZ_SHOW_SHOUPAI_AMOUNT = 188 ,   -- 显示手牌数
	DDZ_HIDE_SHOUPAI_AMOUNT = 189 ,   -- 不显示手牌数
	DDZ_ALARM_HIDE          = 190 ,   -- 不显示报警
	DDZ_ALARM_REMAIN_3      = 191 ,   -- 剩余3张报警
	DDZ_ALARM_REMAIN_5      = 192 ,   -- 剩余5张报警


}
m.GameRoundNum = {
	[m.GREnum.SELF_ROUND_NUM_1  ] = 1,
	[m.GREnum.SELF_ROUND_NUM_2  ] = 2,
	[m.GREnum.SELF_ROUND_NUM_4  ] = 4,
	[m.GREnum.SELF_ROUND_NUM_6  ] = 6,
	[m.GREnum.SELF_ROUND_NUM_8  ] = 8,
	[m.GREnum.SELF_ROUND_NUM_12 ] = 12,
	[m.GREnum.SELF_ROUND_NUM_15 ] = 15,
	[m.GREnum.SELF_ROUND_NUM_16 ] = 16,
	[m.GREnum.SELF_ROUND_NUM_30 ] = 30,
}

--GameRuleEnum游戏规则枚举对应的名字
m.GRNameStr = {
	[m.GREnum.DDZ_BOMB_3] = "3炸",
	[m.GREnum.DDZ_BOMB_4] = "4炸",
	[m.GREnum.DDZ_BOMB_5] = "5炸",

	[m.GREnum.DDZ_JIAO_FEN]   = "叫分(1分,2分,3分)",
	[m.GREnum.DDZ_JIAO_DIZHU] = "叫地主",
	[m.GREnum.DDZ_JIAO_FEN_DAI_TI] = "带踢",

	[m.GREnum.DDZ_SHOW_SHOUPAI_AMOUNT] = "显示手牌数",
	[m.GREnum.DDZ_HIDE_SHOUPAI_AMOUNT] = "不显示手牌数",
	[m.GREnum.DDZ_ALARM_HIDE]          = "不报警",
	[m.GREnum.DDZ_ALARM_REMAIN_3]      = "剩余3张报警",
	[m.GREnum.DDZ_ALARM_REMAIN_5]      = "剩余5张报警",

	[m.GREnum.AQDP_DIAN_PAO			  ]  = "可点炮",
	[m.GREnum.AQDP_YI_PAO_DUO_XIANG	  ]  = "一炮多响",
	[m.GREnum.AQDP_QIANG_GANG_HU	  ]  = "抢杠胡",
	[m.GREnum.AQDP_QING_YI_SE		  ]  = "带清一色",
	[m.GREnum.AQDP_DAN_DIAO_ZI_MO	  ]  = "单吊风(必自摸)",
	[m.GREnum.AQDP_CHI_PENG_NEXT_GANG ]  = "吃碰后可杠",
	[m.GREnum.AQDP_AN_HUA_CAN_HU	  ]  = "暗花可胡",
	[m.GREnum.AQDP_SAN_KOU			  ]  = "正三口反三口",
	[m.GREnum.AQDP_YI_TIAO_LONG		  ]  = "带一条龙",
	[m.GREnum.AQDP_ZI_MO_DI_DOUBLE	  ]  = "自摸底翻倍",
	[m.GREnum.AQDP_AN_GANG_SHOW		  ]  = "暗杠显示",
	[m.GREnum.AQDP_GANG_OPEN_FOOL_369 ]  = "杠开369",
	[m.GREnum.AQDP_GANG_OPEN_FOOL_246 ]  = "杠开246",
	[m.GREnum.AQDP_DI_FOOL_1_1		  ]  = "1底1花",
	[m.GREnum.AQDP_DI_FOOL_2_2		  ]  = "2底2花",
	[m.GREnum.AQDP_DI_FOOL_5_1		  ]  = "5底1花",
	[m.GREnum.AQDP_DI_FOOL_5_5		  ]  = "5底5花",
	[m.GREnum.AQDP_DI_FOOL_10_5		  ]  = "10底5花",
	[m.GREnum.AQDP_DI_FOOL_10_10	  ]  = "10底10花",
	[m.GREnum.AQDP_DI_FOOL_20_10	  ]  = "20底10花",
	[m.GREnum.AQDP_DI_FOOL_20_20	  ]  = "20底20花",

	[m.GREnum.HBMJ_GangSuiHu		 ]  = "杠了就有",
	[m.GREnum.HBMJ_DuoXiang			 ]  = "一炮多响",
	[m.GREnum.HBMJ_DunLaPao			 ]  = "坐拉跑",
	[m.GREnum.HBMJ_ZiMoDouble		 ]  = "自摸翻倍",
	[m.GREnum.HBMJ_QiangGangQuanBao	 ]  = "抢杠全包",
	[m.GREnum.HBMJ_ShiSanYaoDouble	 ]  = "十三幺翻倍",
	[m.GREnum.HBMJ_QiDuiDouble		 ]  = "七对翻倍",
	[m.GREnum.HBMJ_ShiSanBuKaoDouble ]  = "十三不靠翻倍",
	[m.GREnum.HBMJ_GangHouPaoDouble	 ]  = "杠后炮翻倍",
	[m.GREnum.HBMJ_DiFenName	     ]  = "底分",
}

m.GRDiHua = {
	[m.GREnum.AQDP_DI_FOOL_1_1		  ]  = {diFen = 1, huaShu = 1,},
	[m.GREnum.AQDP_DI_FOOL_2_2		  ]  = {diFen = 2, huaShu = 2,},
	[m.GREnum.AQDP_DI_FOOL_5_1		  ]  = {diFen = 5, huaShu = 1,},
	[m.GREnum.AQDP_DI_FOOL_5_5		  ]  = {diFen = 5, huaShu = 5,},
	[m.GREnum.AQDP_DI_FOOL_10_5		  ]  = {diFen = 10, huaShu = 5,},
	[m.GREnum.AQDP_DI_FOOL_10_10	  ]  = {diFen = 10, huaShu = 10,},
	[m.GREnum.AQDP_DI_FOOL_20_10	  ]  = {diFen = 20, huaShu = 10,},
	[m.GREnum.AQDP_DI_FOOL_20_20	  ]  = {diFen = 20, huaShu = 20,},
}

return m
