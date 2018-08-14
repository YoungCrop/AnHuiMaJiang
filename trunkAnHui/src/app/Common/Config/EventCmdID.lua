
--EventCmdID
local m = {}

m.UI_UPDATE_DESK_CLOTH    = "UI_UPDATE_DESK_CLOTH"    --更新桌布
m.UI_TOUCH_SAME_MJ_BRIGHT = "UI_TOUCH_SAME_MJ_BRIGHT" --触摸麻将，相同的麻将明亮
m.UI_HAS_NEW_MESSAGE      = "UI_HAS_NEW_MESSAGE"      --大厅有新消息
m.UI_ROOM_BTN_ENABLE      = "UI_ROOM_BTN_ENABLE"      --游戏内按钮状态变化，规则按钮、设置按钮
m.UI_COIN_BTN_SELECTED    = "UI_COIN_BTN_SELECTED"    --金币场，按钮选择
m.UI_USER_COIN_CHANGE     = "UI_USER_COIN_CHANGE"    --金币数、房卡数变化

m.EventType = {
	BACK_MAIN_SCENE				= 2,
	APPLY_DIMISS_ROOM			= 3,
	GM_CHECK_HISTORY			= 4,
	SHOW_FINALREPORT            = 5,
	GETIN_EVENT_JONIN           = 8,
	APP_ENTER_FOREGROUND_EVENT  = 9,
	ZJH_ADD_FINALREPORT         = 10,
	DIRECT_LOGIN                = 11,
	NEXTONEGAME_EVENT           = 12,
}

return m
