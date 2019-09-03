

--DefineSound

local m = {}

m.EffectSound = {
	CardOut = "common/audio_card_out.mp3",
}

m.OpeType = {
	CHI     = 1,
	PENG    = 2,
	GANG    = 3,
	TING    = 4,
	HU      = 5,
	ZIMO    = 6,
}

m.SoundOprEnum = {
--key-{普通话男，普通话女，方言男，方言女，}
	[m.OpeType.CHI ] = {"man/chi.mp3" , "woman/chi.mp3" , },
	[m.OpeType.PENG] = {"man/peng.mp3", "woman/peng.mp3", },
	[m.OpeType.GANG] = {"man/gang.mp3", "woman/gang.mp3", },
	[m.OpeType.TING] = {"man/ting.mp3", "woman/ting.mp3", },
	[m.OpeType.HU  ] = {"man/hu.mp3"  , "woman/hu.mp3"  , },
	[m.OpeType.ZIMO] = {"man/zimo.mp3", "woman/zimo.mp3", },
}

-- 游戏牌数麻将牌总共144张，分为6大类，分别为：
-- 1：万牌：1，2，3，4，5，6，7，8，9
-- 2：筒牌：1，2，3，4，5，6，7，8，9
-- 3：索牌：1，2，3，4，5，6，7，8，9
-- 4：风牌：东，南，西，北
-- 5：箭牌：中，发，白
-- 6：花牌：春，夏，秋，冬，梅，兰，竹，菊

m.TILE_TYPE = {
    BG    = 0,
    WAN   = 1,
    TONG  = 2,
    TIAO  = 3,
    FENG  = 4,
    JIAN  = 5,
    HUA   = 6,
}

m.TILE_SOUND_EFFECT = {
	[m.TILE_TYPE.WAN] = {
		[1] = {"一万", "man/mjt1_1.mp3", "woman/mjt1_1.mp3",  },
		[2] = {"二万", "man/mjt1_2.mp3", "woman/mjt1_2.mp3",  },
		[3] = {"三万", "man/mjt1_3.mp3", "woman/mjt1_3.mp3",  },
		[4] = {"四万", "man/mjt1_4.mp3", "woman/mjt1_4.mp3",  },
		[5] = {"五万", "man/mjt1_5.mp3", "woman/mjt1_5.mp3",  },
		[6] = {"六万", "man/mjt1_6.mp3", "woman/mjt1_6.mp3",  },
		[7] = {"七万", "man/mjt1_7.mp3", "woman/mjt1_7.mp3",  },
		[8] = {"八万", "man/mjt1_8.mp3", "woman/mjt1_8.mp3",  },
		[9] = {"九万", "man/mjt1_9.mp3", "woman/mjt1_9.mp3",  },
	},
	[m.TILE_TYPE.TONG] = {
		[1] = {"一筒", "man/mjt2_1.mp3", "woman/mjt2_1.mp3",  },
		[2] = {"二筒", "man/mjt2_2.mp3", "woman/mjt2_2.mp3",  },
		[3] = {"三筒", "man/mjt2_3.mp3", "woman/mjt2_3.mp3",  },
		[4] = {"四筒", "man/mjt2_4.mp3", "woman/mjt2_4.mp3",  },
		[5] = {"五筒", "man/mjt2_5.mp3", "woman/mjt2_5.mp3",  },
		[6] = {"六筒", "man/mjt2_6.mp3", "woman/mjt2_6.mp3",  },
		[7] = {"七筒", "man/mjt2_7.mp3", "woman/mjt2_7.mp3",  },
		[8] = {"八筒", "man/mjt2_8.mp3", "woman/mjt2_8.mp3",  },
		[9] = {"九筒", "man/mjt2_9.mp3", "woman/mjt2_9.mp3",  },
	},
	[m.TILE_TYPE.TIAO] = {
		[1] = {"一条", "man/mjt3_1.mp3", "woman/mjt3_1.mp3",  },
		[2] = {"二条", "man/mjt3_2.mp3", "woman/mjt3_2.mp3",  },
		[3] = {"三条", "man/mjt3_3.mp3", "woman/mjt3_3.mp3",  },
		[4] = {"四条", "man/mjt3_4.mp3", "woman/mjt3_4.mp3",  },
		[5] = {"五条", "man/mjt3_5.mp3", "woman/mjt3_5.mp3",  },
		[6] = {"六条", "man/mjt3_6.mp3", "woman/mjt3_6.mp3",  },
		[7] = {"七条", "man/mjt3_7.mp3", "woman/mjt3_7.mp3",  },
		[8] = {"八条", "man/mjt3_8.mp3", "woman/mjt3_8.mp3",  },
		[9] = {"九条", "man/mjt3_9.mp3", "woman/mjt3_9.mp3",  },
	},
	[m.TILE_TYPE.FENG] = {
		[1] = {"东风", "man/mjt4_1.mp3", "woman/mjt4_1.mp3",  },
		[2] = {"南风", "man/mjt4_2.mp3", "woman/mjt4_2.mp3",  },
		[3] = {"西风", "man/mjt4_3.mp3", "woman/mjt4_3.mp3",  },
		[4] = {"北风", "man/mjt4_4.mp3", "woman/mjt4_4.mp3",  },
	},
	[m.TILE_TYPE.JIAN] = {
		[1] = { "中",  "man/mjt5_1.mp3", "woman/mjt5_1.mp3",  },
		[2] = { "发",  "man/mjt5_2.mp3", "woman/mjt5_2.mp3",  },
		[3] = { "白",  "man/mjt5_3.mp3", "woman/mjt5_3.mp3",  },
	},
	[m.TILE_TYPE.HUA] = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {},
		[5] = {},
		[6] = {},
		[7] = {},
		[8] = {},
	},
}


return m