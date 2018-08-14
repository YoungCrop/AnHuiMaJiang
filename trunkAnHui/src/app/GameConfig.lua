
--GameConfig

local m = {}

--正式服1,审核服2,外网测试服3,内网测试服4,开发服老杜5
m.ServerTypeKey = {
	sDis       = 1,
	sIOSInReview  = 2,
	sAndroidInReview = 3,
	sTestOuter = 4,
	sTestInner = 5,
	sLaoDuDev  = 6,
	sInnerMe   = 7,
}
m.CurServerIndex = m.ServerTypeKey.sDis

m.ServerTypeEnum = {
--key--{index,iOS提审,调试模式,打印,}
	[m.ServerTypeKey.sDis      ] = {index = 1,debugMode = false,isPrintLog = false,upLoadBugly = true,},
	[m.ServerTypeKey.sIOSInReview ] = {index = 2,debugMode = false,isPrintLog = true,upLoadBugly = true,},
	[m.ServerTypeKey.sAndroidInReview ] = {index = 3,debugMode = false,isPrintLog = true, upLoadBugly = true,},
	[m.ServerTypeKey.sTestOuter] = {index = 4,debugMode = false,isPrintLog = true, upLoadBugly = true,},
	[m.ServerTypeKey.sTestInner] = {index = 5,debugMode = true, isPrintLog = true, upLoadBugly = true,},
	[m.ServerTypeKey.sLaoDuDev ] = {index = 6,debugMode = true, isPrintLog = true, upLoadBugly = true,},
	[m.ServerTypeKey.sInnerMe  ] = {index = 7,debugMode = true, isPrintLog = true, upLoadBugly = false,},
}

m.debugServer = {
	[m.ServerTypeKey.sDis      ] = {sName = "正式服", ip = "anhuigame.yongwuzhijing88.com",  port = "5001",
		versionUrl = "https://anhui-update.yongwuzhijing88.com:443/YwZj_2017/AnHui/version.manifest"},
	[m.ServerTypeKey.sIOSInReview ] = {sName = "审核服", ip = "118.31.185.56", port = "5055",versionUrl = nil},
	-- [m.ServerTypeKey.sIOSInReview ] = {sName = "审核服", ip = "app-review-56.laoyou18.com", port = "5055",versionUrl = nil},
	[m.ServerTypeKey.sAndroidInReview ] = {sName = "Android审核服", ip = "118.31.185.56", port = "5055",versionUrl = nil},
	[m.ServerTypeKey.sTestOuter] = {sName = "外网测试服", ip = "47.97.4.16", port = "5555",
		versionUrl = "https://anhui.yongwuzhijing88.com/YwZj_2017/AnHuiOuterServerTest/version.manifest"},
	[m.ServerTypeKey.sTestInner] = {sName = "内网测试服", ip = "10.100.12.14", port = "5055",
		versionUrl = "https://anhui.yongwuzhijing88.com:443/YwZj_2017/AnHui/version.manifest"},
	[m.ServerTypeKey.sLaoDuDev ] = {sName = "开发服老杜", ip = "10.100.1.39",  port = "5055",versionUrl = nil},
	[m.ServerTypeKey.sInnerMe]   = {sName = "内网测试服Me", ip = "10.100.12.14", port = "5055",
		versionUrl = "https://anhui.yongwuzhijing88.com:443/YwZj_2017/AnHui/version.manifest"},

}

function m.SetConfig(serverIndex)
	m.CurServerIndex = serverIndex
	if serverIndex == m.ServerTypeKey.sIOSInReview then
		m.isiOSAppInReview = true --iOS提审时把它设置为true
	else
		m.isiOSAppInReview = false
	end
	m.debugMode = m.ServerTypeEnum[m.CurServerIndex].debugMode  --调试模式
	m.debugNickname = "c-113" --调试昵称
	m.isPrintLog = m.ServerTypeEnum[m.CurServerIndex].isPrintLog
	m.LoginServer = m.debugServer[m.CurServerIndex]--登录服务器
	m.upLoadBugly = m.ServerTypeEnum[m.CurServerIndex].upLoadBugly
	if m.isPrintLog == false then
		print = function( ... )
		end
	end
end

function m.GetServerConfig()
	return (m.debugServer[m.CurServerIndex] or {})
end

m.SetConfig(m.CurServerIndex)


return m
