
--ConfigCoinLimit
local m = {}

m.data = {
	[1] = {Index = 1  ,Desc =	"淮北麻将初级场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_chuji.png"  ,RuleType =	1,Pos =1,MinCoin =	1000    ,Score = 20 	,Cost =	20     ,Open =	1,},
	[2] = {Index = 2  ,Desc =	"淮北麻将中级场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_zhongji.png",RuleType =	1,Pos =2,MinCoin =	5000    ,Score = 100 	,Cost =	100    ,Open =	1,},
	[3] = {Index = 3  ,Desc =	"淮北麻将高级场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_gaoji.png"  ,RuleType =	1,Pos =3,MinCoin =	50000   ,Score = 500 	,Cost =	500   ,Open =	1,},
	[4] = {Index = 4  ,Desc =	"淮北麻将尊贵场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	1,Pos =4,MinCoin =	200000  ,Score = 2000 	,Cost =	4000   ,Open =	0,},
	[5] = {Index = 5  ,Desc =	"淮北麻将传奇场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	1,Pos =5,MinCoin =	500000  ,Score = 5000 	,Cost =	10000  ,Open =	0,},
	[6] = {Index = 6  ,Desc =	"淮北麻将至尊场" ,GameType = 6, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	1,Pos =6,MinCoin =	1000000 ,Score = 10000 	,Cost =	20000  ,Open =	0,},
	[7] = {Index = 7  ,Desc =	"安庆麻将初级场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_chuji.png"  ,RuleType =	2,Pos =1,MinCoin =	1000    ,Score = 20 	,Cost =	20     ,Open =	1,},
	[8] = {Index = 8  ,Desc =	"安庆麻将中级场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_zhongji.png",RuleType =	2,Pos =2,MinCoin =	5000    ,Score = 100 	,Cost =	100    ,Open =	1,},
	[9] = {Index = 9  ,Desc =	"安庆麻将高级场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_gaoji.png"  ,RuleType =	2,Pos =3,MinCoin =	50000   ,Score = 500 	,Cost =	500   ,Open =	1,},
	[10]= {Index = 10  ,Desc =	"安庆麻将尊贵场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	2,Pos =4,MinCoin =	200000  ,Score = 2000 	,Cost =	4000   ,Open =	0,},
	[11]= {Index = 11  ,Desc =	"安庆麻将传奇场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	2,Pos =5,MinCoin =	500000  ,Score = 5000 	,Cost =	10000  ,Open =	0,},
	[12]= {Index = 12  ,Desc =	"安庆麻将至尊场" ,GameType = 5, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType =	2,Pos =6,MinCoin =	1000000 ,Score = 10000 	,Cost =	20000  ,Open =	0,},
	[13]= {Index = 13  ,Desc =	"斗地主初级场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_chuji.png"  ,RuleType = 3,Pos =1,MinCoin =	1000    ,Score = 20 	,Cost =	10     ,Open =	1,},
	[14]= {Index = 14  ,Desc =	"斗地主中级场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_zhongji.png",RuleType = 3,Pos =2,MinCoin =	5000    ,Score = 100 	,Cost =	50    ,Open =	1,},
	[15]= {Index = 15  ,Desc =	"斗地主高级场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_gaoji.png"  ,RuleType = 3,Pos =3,MinCoin =	50000   ,Score = 500 	,Cost =	250   ,Open =	1,},
	[16]= {Index = 16  ,Desc =	"斗地主尊贵场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType = 3,Pos =4,MinCoin =	200000  ,Score = 2000 	,Cost =	4000   ,Open =	0,},
	[17]= {Index = 17  ,Desc =	"斗地主传奇场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType = 3,Pos =5,MinCoin =	500000  ,Score = 5000 	,Cost =	10000  ,Open =	0,},
	[18]= {Index = 18  ,Desc =	"斗地主至尊场"   ,GameType = 4, DrawPicture = "Image/ILobby/UICoin/Coin_enter_wait.png"   ,RuleType = 3,Pos =6,MinCoin =	1000000 ,Score = 10000 	,Cost =	20000  ,Open =	0,},
}

return m
