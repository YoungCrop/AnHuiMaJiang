--[[
消息协议号
]]
--NetCmd

--NetCmdID
local m = {}

--=============大厅============--

m.MSG_CG_LOGIN					= 1
m.MSG_GC_LOGIN					= 2

m.MSG_CG_LOGIN_SERVER			= 11
m.MSG_GC_LOGIN_SERVER			= 12

m.MSG_GC_ROOM_CARD				= 13
m.MSG_GC_MARQUEE				= 14


--心跳
m.MSG_CG_HEARTBEAT				= 15
m.MSG_GC_HEARTBEAT				= 16

--创建房间
m.MSG_CG_CREATE_ROOM			= 20
m.MSG_GC_CREATE_ROOM			= 21

m.MSG_C_2_S_CREATE_QUICK_ROOM   = 33  --玩家请求创建俱乐部快捷房间

--加入房间
m.MSG_CG_JOIN_ROOM				= 22
m.MSG_GC_JOIN_ROOM				= 23

--退出房间
m.MSG_CG_QUIT_ROOM				= 24
m.MSG_GC_QUIT_ROOM				= 25

--解散房间
m.MSG_CG_DISMISS_ROOM			= 26
m.MSG_GC_DISMISS_ROOM			= 27
--申请解散房间
m.MSG_CG_APPLY_DISMISS			= 28

--历史记录
m.MSG_CG_HISTORY_RECORD		    = 90
m.MSG_GC_HISTORY_RECORD		    = 91

--播放历史记录
m.MSG_CG_REPLAY				    = 92
m.MSG_GC_REPLAY				    = 93

--散代开房间
m.MSG_CG_DISMISS_AGENT_ROOM 	= 81
m.MSG_GC_DISMISS_AGENT_ROOM 	= 82
--代开房间
m.MSG_CG_GET_AGENT_ROOM 		= 83
m.MSG_GC_GET_AGENT_ROOM 		= 84

--活动奖励房卡
m.MSG_CG_GET_FANGKA_HUODONG	    = 75
m.MSG_GC_GET_FANGKA_HUODONG	    = 76
--买房卡
m.MSG_CG_BUY_FANGKA			    = 77
m.MSG_GC_BUY_FANGKA			    = 78

--=============大奖赛============--
m.MSG_C_2_S_JOIN_RED_MATCH		= 171	--客户端请求参加红包比赛
m.MSG_S_2_C_JOIN_RED_MATCH	    = 172	--红包比赛的错误码返回

m.MSG_C_2_S_RED_MATCH_INFO		= 173	--请求红包比赛场信息
m.MSG_S_2_C_RED_MATCH_INFO		= 174	--返回红包比赛场信息

m.MSG_C_2_S_TUO_GUAN			= 175	--托管操作
m.MSG_S_2_C_TUO_GUAN			= 176	--告知客户端已经进入托管

m.MSG_S_2_C_ACTIVE_CODE			= 177	--发送客户端红包赛激活码

m.MSG_C_2_S_RED_CODE_LOG		= 178	--客户端请求红包赛激活码记录
m.MSG_S_2_C_RED_CODE_LOG		= 179	--发送客户端红包赛激活码记录



m.MSG_CG_APPLY_DISMISS			= 28
m.MSG_GC_ADD_PLAYER			    = 31
m.MSG_GC_REMOVE_PLAYER			= 32
m.MSG_GC_SYNC_ROOM_STATE		= 35
m.MSG_CG_READY					= 36
m.MSG_GC_READY					= 37
m.MSG_GC_OFF_LINE_STATE		    = 40
m.MSG_GC_ROUND_STATE			= 41
m.MSG_GC_START_GAME			    = 50
m.MSG_GC_TURN_SHOW_MJTILE		= 51
m.MSG_CG_SHOW_MJTILE			= 52 --出牌
m.MSG_GC_SYNC_SHOW_MJTILE		= 53
m.MSG_GC_MAKE_DECISION			= 54
m.MSG_CG_PLAYER_DECISION		= 55
m.MSG_GC_SYNC_MAKE_DECISION	    = 56
m.MSG_CG_CHAT_MSG				= 57
m.MSG_GC_CHAT_MSG				= 58
m.MSG_GC_ROUND_REPORT			= 60
m.MSG_GC_FINAL_REPORT			= 80


m.MSG_GC_IS_ACTIVITIES			= 101 -- 服务器推送是否有活动
m.MSG_GC_BEAT					= 113 -- 服务器广播表情互动
m.MSG_CG_UPDATE                 = 73   -- 玩家请求版本号
m.MSG_GC_UPDATE                 = 74   -- 服务器返回版本号


--斗地主
m.MSG_GC_ALARM_MSG				= 59
m.MSG_GC_GET_SURPLUS			= 203   --游戏结束剩余牌
m.MSG_GC_SAMEIP				    = 205   --广播相同IP玩家
m.MSG_GC_ASK_DIZHU				= 215   --通知客户端抢地主
m.MSG_CG_QIANG_DIZHU			= 216   --客户端返回抢地主结果
m.MSG_GC_ANS_DIZHU				= 217   --服务器广播客户端操作
m.MSG_GC_WHO_IS_DIZHU			= 218   --服务器广播最终地主位置
m.MSG_MSG_S_2_C_SHOWCARDS 		= 1118	--展示玩家自己的手牌

-- 炸金花
m.MSG_CG_START_GAME			    = 124   --房主开始游戏
m.MSG_CG_PLAYER_DECISION_ZJH	= 125   --1.玩家请求看牌  2.比牌 3.跟注  4. 加注 5. 弃牌
m.MSG_GC_PLAYER_DECISION		= 126   --广播玩家操作
m.MSG_GC_ROUND_ZJH      		= 127   --广播轮数

-- 填大坑
m.MSG_GC_TDK_sendCard     		= 130   --广播发牌

--=============房间内============--BROADCAST

m.MSG_CG_POST_ADDR 			    = 121 -- 客户端上传用户地址
m.MSG_CG_GET_USER_ADDR 		    = 122 -- 客户端请求用户地址
m.MSG_GC_GET_USER_ADDR 		    = 123 -- 服务器返回用户地址

--击打表情
m.MSG_CG_BEAT					    = 114
m.MSG_GC_BEAT					    = 113 --广播


m.MSG_GC_ROOM_CARD                  = 13 --接收房卡信息
m.MSG_GC_ENTER_ROOM                 = 30 --进入房间
m.MSG_GC_ADD_PLAYER                 = 31 --玩家加入房间
m.MSG_GC_REMOVE_PLAYER              = 32 --玩家离开房间
m.MSG_GC_SYNC_ROOM_STATE            = 35 --断线重连
m.MSG_GC_READY                      = 37 --玩家准备手势
m.MSG_GC_SAMEIP                     = 205 --相同IP
m.MSG_GC_OFF_LINE_STATE             = 40 --玩家掉线在线标识
m.MSG_GC_ROUND_STATE                = 41 --当前局数/最大局数
m.MSG_GC_START_GAME                 = 50 --开始游戏
m.MSG_GC_TURN_SHOW_MJTILE           = 51 --通知玩家出牌
m.MSG_GC_SYNC_SHOW_MJTILE           = 53 --显示玩家出牌消息
m.MSG_GC_CHAT_MSG                   = 58 --聊天
m.MSG_GC_LOGIN                      = 2  --断线重连
m.MSG_GC_QUIT_ROOM                  = 25 --返回大厅
m.MSG_GC_DISMISS_ROOM               = 27 --解散房间
m.MSG_GC_ROUND_REPORT               = 60 --单局游戏结束
m.MSG_GC_FINAL_REPORT               = 80 --总结算界面
m.MSG_GC_LOGIN_SERVER               = 12 --登录服务器
m.MSG_GC_ALARM_MSG                  = 59  --通知警报灯消息
m.MSG_GC_GET_SURPLUS                = 203 --最后手中剩余牌消息
m.MSG_GC_ASK_DIZHU                  = 215 --通知客户端抢地主
m.MSG_GC_ANS_DIZHU                  = 217 --服务器广播客户端操作
m.MSG_GC_WHO_IS_DIZHU               = 218 --服务器广播最终地主位置

m.MSG_MSG_S_2_C_SHOWCARDS           = 1118 --结算后显示扑克牌

--=============扑克============--
m.MSG_GC_ALARM_MSG                  = 59 --通知警报灯消息
m.MSG_GC_GET_SURPLUS                = 203 --最后手中剩余牌消息
m.MSG_GC_ASK_DIZHU                  = 215--通知客户端抢地主
m.MSG_GC_ANS_DIZHU                  = 217--服务器广播客户端操作
m.MSG_GC_WHO_IS_DIZHU               = 218--服务器广播最终地主位置
m.MSG_GC_SHOWCARDS                  = 1118--结算后显示扑克牌

--=============麻将============--

--准备
m.MSC_CG_READY					    = 36
m.MSC_GC_READY					    = 37

--服务器发给某玩家一张牌，包含决策选择提示
m.MSC_GC_DISPENSE_CARD              = 51  --NetCmd.MSG_GC_TURN_SHOW_MJTILE

--出牌
m.MSC_CG_OUT_CARD                   = 52  --出牌 NetCmd.MSG_CG_SHOW_MJTILE
m.MSC_BROADCAST_OUT_CARD		    = 53  --NetCmd.MSG_GC_SYNC_SHOW_MJTILE		= 53

--别人出的牌，服务器通知自己的决策选择提示
m.MSC_GC_NOTICE_DECISION            = 54  --NetCmd.MSG_GC_MAKE_DECISION

--玩家决策选择
m.MSC_CG_PLAYER_DECISION            = 55  --玩家决策选择 NetCmd.MSG_CG_PLAYER_DECISION
m.MSC_BROADCAST_DECISION     		= 56  --NetCmd.MSG_GC_SYNC_MAKE_DECISION	= 56

--语音、聊天
m.MSC_CG_CHAT_MSG				    = 57
m.MSC_GC_CHAT_MSG				    = 58

m.MSG_GC_DEL_CARD                   = 131 --删牌

--=============麻将============--

m.MSG_S_2_C_GAME_EXT		        = 165  --服务器 游戏逻辑扩展
m.MSG_C_2_S_GAME_EXT		        = 166  --客户端 游戏逻辑扩展
m.MSG_GAME_EXT = {
	MSG_C_2_S_TING_ONE_GROUP        = 1,--查看听牌按钮调用
	MSG_S_2_C_TING_ONE_GROUP        = 2,--查看听牌按钮调用
	MSG_S_2_C_TO_SAN_KOU	        = 3,--达成顺三口反三口

	MSG_C_2_S_DUNLAPAO			    = 4,--玩家请求蹲拉跑
	MSG_S_2_C_DUNLAPAO			    = 5,--服务器广播蹲拉跑
}

-- // 亲友圈相关 begin
m.MSG_C_2_S_CLUB_DETAIL_INFO		 = 306   --指定亲友圈的详细信息
m.MSG_S_2_C_CLUB_DETAIL_INFO		 = 307   --指定亲友圈的详细信息
m.MSG_C_2_S_CLUB_ALL_BASIC_INFO	     = 308   --我的所有亲友圈基本信息列表
m.MSG_S_2_C_CLUB_ALL_BASIC_INFO	     = 309   --我的所有亲友圈基本信息列表
m.MSG_C_2_S_CLUB_VIP_LOG			 = 310   --指定亲友圈的战绩信息
m.MSG_S_2_C_CLUB_VIP_LOG			 = 311   --指定亲友圈的战绩信息
m.MSG_C_2_S_CLUB_APPLICATION		 = 312   --离会/入会申请
m.MSG_S_2_C_CLUB_APPLICATION		 = 313   --离会/入会申请
m.MSG_C_2_S_CLUB_TARGET_BASIC_INFO   = 314   --指定某个亲友圈的基本信息
m.MSG_S_2_C_CLUB_TARGET_BASIC_INFO   = 315   --指定某个亲友圈的基本信息
m.MSG_C_2_S_CLUB_CREATE			     = 316   --创建亲友圈
m.MSG_S_2_C_CLUB_CREATE			     = 317   --创建亲友圈,返回结果
m.MSG_C_2_S_CLUB_MAIL				 = 318   --请求亲友圈邮件
m.MSG_S_2_C_CLUB_MAIL				 = 319   --亲友圈邮件,
m.MSG_S_2_C_INVITE_ADD_CLUB		     = 320   --后台发来邀请玩家加入亲友圈
-- m.MSG_C_2_S_AGREE_ADD_CLUB		     = 321   --后台发来邀请玩家加入亲友圈,不用了
m.MSG_S_2_C_CLUB_ERROR			     = 322   --通用亲友圈错误码
m.MSG_S_2_C_CLUB_KICK				 = 323   --亲友圈踢人


m.MSG_C_2_S_COIN_CONVERT			 = 401   --房卡转换金币
m.MSG_S_2_C_COIN_CONVERT			 = 402   --房卡转换金币
m.MSG_C_2_S_COIN_REFRESH_HALL		 = 403   --客户端进入金币场大厅;和选场都走这个;返回金币大厅
m.MSG_S_2_C_COIN_REFRESH_HALL		 = 404   --进入金币场和选场,返回数据
m.MSG_C_2_S_COIN_LEAVE_HALL			 = 405   --离开金币大厅
m.MSG_S_2_C_COIN_LEAVE_HALL			 = 406   --离开金币大厅
m.MSG_C_2_S_COIN_JOIN				 = 407   --加入指定index的场
m.MSG_S_2_C_COIN_JOIN				 = 408   --加入指定index的场
m.MSG_C_2_S_COIN_FAST_START			 = 409   --金币场快速开始
m.MSG_S_2_C_COIN_FAST_START			 = 410   --金币场快速开始
m.MSG_C_2_S_COIN_NEXT				 = 411   --金币场下一局
m.MSG_S_2_C_COIN_NEXT				 = 412   --金币场下一局
m.MSG_C_2_S_COIN_GET				 = 413   --领取低保金币
m.MSG_S_2_C_COIN_GET                 = 414   --领取低保金币,策划要求自动领取
m.MSG_C_2_S_COIN_RETURN				 = 415	 --一局结束界面中的返回金币大厅按钮发送消息:这时,玩家可能在牌桌也可能不在牌桌
m.MSG_S_2_C_COIN_RETURN				 = 416	 --一局结束界面中的返回金币大厅按钮发送消息:这时,玩家可能在牌桌也可能不在牌桌

m.MSG_S_2_C_COIN_CHANGE_INROOM       = 417   --金币变化

return m
