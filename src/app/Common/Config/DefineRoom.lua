
--DefineRoom


local m = {}

m.DeskClothEnum = {
	GREEN   = 1,--绿
	BLUE    = 2,--蓝
	RED     = 3,--红
	PURPLE  = 4,--紫
}

m.DeskClothImgRes = {
--key--{麻将桌布，斗地主桌布}
	[m.DeskClothEnum.GREEN ] = {"Image/BigImg/game_bg1.png","Image/BigImg/game_bg_ddz1.png"},
	[m.DeskClothEnum.BLUE  ] = {"Image/BigImg/game_bg2.png","Image/BigImg/game_bg_ddz2.png"},
	[m.DeskClothEnum.RED   ] = {"Image/BigImg/game_bg3.png","Image/BigImg/game_bg_ddz3.png"},
	[m.DeskClothEnum.PURPLE] = {"Image/BigImg/game_bg4.png","Image/BigImg/game_bg_ddz4.png"},
}

m.BtnMsgImgRes = {
	[m.DeskClothEnum.BLUE ] = {"Image/IRoom/RoomCenter/BtnMsgGreen.png","",""},
	[m.DeskClothEnum.GREEN  ] = {"Image/IRoom/RoomCenter/BtnMsgBlue.png","",""},
	[m.DeskClothEnum.RED   ] = {"Image/IRoom/RoomCenter/BtnMsgRed.png","",""},
	[m.DeskClothEnum.PURPLE] = {"Image/IRoom/RoomCenter/BtnMsgPurple.png","",""},
}

m.BtnVoiceImgRes = {
	[m.DeskClothEnum.BLUE ] = {"Image/IRoom/RoomCenter/BtnVoiceGreenNormal.png" ,"Image/IRoom/RoomCenter/BtnVoiceGreenDown.png" ,"Image/IRoom/RoomCenter/BtnVoiceGreenDown.png" },
	[m.DeskClothEnum.GREEN  ] = {"Image/IRoom/RoomCenter/BtnVoiceBlueNormal.png"  ,"Image/IRoom/RoomCenter/BtnVoiceBlueDown.png"  ,"Image/IRoom/RoomCenter/BtnVoiceBlueDown.png"  },
	[m.DeskClothEnum.RED   ] = {"Image/IRoom/RoomCenter/BtnVoiceRedNormal.png"   ,"Image/IRoom/RoomCenter/BtnVoiceRedDown.png"   ,"Image/IRoom/RoomCenter/BtnVoiceRedDown.png"   },
	[m.DeskClothEnum.PURPLE] = {"Image/IRoom/RoomCenter/BtnVoicePurpleNormal.png","Image/IRoom/RoomCenter/BtnVoicePurpleDown.png","Image/IRoom/RoomCenter/BtnVoicePurpleDown.png"},
}

m.PlayZOrder = {
	MJTILES_LAYER				= 6,
	OUTMJTILE_SIGN				= 7,
	DECISION_SHOW				= 9,
	HAIDILAOYUE					= 23
}

m.ChatType = {
	FIX_MSG						= 1,
	INPUT_MSG					= 2,
	EMOJI						= 3,
	VOICE_MSG					= 4,
}

 
--服务器端玩家思考类型 ThinkOperate
m.THINK_OPERATE = {
	TO_NULL         = 0,      --无
	TO_OUT          = 1,      --出牌
	TO_HU           = 2,	  --胡
	TO_AGANG        = 3,	  --暗杠
	TO_MGANG        = 4,	  --明杠
	TO_PENG         = 5,	  --碰
	TO_CHI          = 6,	  --吃
	TO_ABU          = 7,	  --暗补
	TO_MBU          = 8,	  --明补 --碰转杠，安庆点炮-补花
	TO_QUIET_TING   = 9,      --只自己听,不通知别人;前端只给听牌者一个小提示:测试 9和11互换
	TO_QU           = 10,	  --取牌, 
	TO_TING         = 11,	  --听

	TO_XUANF        = 14,	  --旋风杠
	TO_XI_GANG      = 15,	  --喜杠
	TO_YAOD         = 16,	  --幺蛋杠
	TO_JIUD         = 17,	  --九蛋杠
	TO_MDDAN        = 18,	  --明大蛋
	TO_ADDAN        = 19,	  --暗大蛋
	TO_SGANG_BU     = 20,	  --补杠
	TO_XUANF_BU     = 21,	  --旋风杠 补杠
	TO_XI_GANG_BU   = 22,	  --喜杠 补杠
	TO_YAOD_BU      = 23,	  --幺蛋杠 补杠
	TO_JIUD_BU      = 24,	  --九蛋杠 补杠
	TO_BAOPAI       = 25,     --宝牌决策
	TO_SPECIAL_GANG = 30,	  --特殊杠
}

-- 游戏牌数麻将牌总共144张，分为6大类，分别为：
-- 1：万牌：1，2，3，4，5，6，7，8，9
-- 2：筒牌：1，2，3，4，5，6，7，8，9
-- 3：索牌：1，2，3，4，5，6，7，8，9
-- 4：风牌：东，南，西，北
-- 5：箭牌：中，发，白
-- 6：花牌：春，夏，秋，冬，梅，兰，竹，菊



return m