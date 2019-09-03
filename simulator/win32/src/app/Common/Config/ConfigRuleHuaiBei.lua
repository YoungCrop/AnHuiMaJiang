--ConfigRuleHuaiBei
local m = {}

-- 淮北麻将规则
m.ruleDesc = "\
一. 简介 \
淮北麻将使用136张麻将。 每人手里抓13张牌。在游戏中对和牌没有要求，和牌者胜，被和牌者负，荒庄时计和局。\
坐拉跑是安庆麻将最大的特色，即庄闲之间可以互相额外加分，庄家坐分，闲家拉分，所有人可以设置跑分。\
\
二. 牌数\
共计136张。数牌（1~9万、1~9筒、1~9条），风牌（东、南、西、北），三元牌（也称箭牌，包括中、发、白）。其中风牌和三元牌统称为字牌。\
1) 字牌（合计28张）\
A) 风牌：东、南、西、北，各4张，共16张。\
B) 箭牌：中、发、白，各4张，共12张。\
2) 序数牌（合计108张）\
A) 万子牌：从一万至九万，各4张，共36张。\
B) 筒子牌：从一筒至九筒，各4张，共36张。也有的地方称为饼，从一饼到九饼。\
C) 束子牌：从一束至九束，各4张，共36张。也有的地方称为条，从一条到九条。\
\
三. 玩法介绍\
1)	庄：庄家可摸14张，不胡则轮庄，逆时针轮，胡牌后继续坐庄。庄家需要翻倍。\
庄家胡则坐庄，流局算连庄。其他人胡则轮庄。\
2) 荒庄：牌墙摸完没有人胡，则流局荒庄。荒庄荒杠。杠分只有胡牌了才有效。\
3) 杠随胡：选项，只计算胡牌人的杠分。或者只有有人胡就所有杠都计算。\
4) 一炮多响：点炮玩家打出一张牌，可多人胡牌。则每个人单独和点炮玩家结算分。\
5) 一炮单响：点炮玩家打出一张牌，可多人胡牌时，按点炮玩家起算，逆时针优先转到的胡牌方胡牌。其他胡牌玩家被此玩家截胡，不结算。（此4,5两个玩法作为玩法选项）\
6) 吃碰杠：不可吃，可以碰杠。所有的杠都是3家付。明杠为底分，暗杠2倍底分。\
6）自摸：自摸需要翻倍。\
7）杠上开花：开杠之后摸牌胡牌。\
8）抢杠胡：即被抢杠的人算点炮胡，且1人需要付3家钱。\
9）杠上炮：开杠之后，摸牌出牌即点炮。\
10）过手胡：同一圈当中如果点炮未胡，则本圈无法接炮胡，必须过牌后才可以接炮胡或者自摸。\
\
四．胡牌牌型说明\
1）平胡：1倍底分。即正常可以胡的小胡牌。\
2）十三幺：19万19桶19条东南西北中发白+其中任意一张。1倍底分\
3）十三不靠：147,258,369+东南西北中发白。这其中任意13张胡另外3张。\
4）明杠：1倍底分。别人打出来第四张，选择杠牌。或者自己碰完补杠。\
5）暗杠：2倍底分。自己摸了4张一样牌，选择暗杠。可累计。\
6）底分：额外加的分数，由玩家在面板上操作。\
\
"




return m