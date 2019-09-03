
local m = {}

--FacadeService

function m.init()
	-- m.DBMgr = require("app.Common.DB.LocalDBMgr").new()

	package.loaded["app.Common.Utils.DebugUtils"] = nil
	m.Debug = require("app.Common.Utils.DebugUtils")

	package.loaded["app.Common.Utils.StringUtils"] = nil
	m.StringUtils = require("app.Common.Utils.StringUtils")


	package.loaded["app.Common.Utils.BtnUtils"] = nil
	m.BtnUtils = require("app.Common.Utils.BtnUtils")

	package.loaded["app.Common.Utils.UIUtils"] = nil
	m.UIUtils = require("app.Common.Utils.UIUtils")

	package.loaded["app.Common.Utils.LabelUtils"] = nil
	m.LabelUtils = require("app.Common.Utils.LabelUtils")

	package.loaded["app.Common.Utils.AnimUtils"] = nil
	m.AnimUtils = require("app.Common.Utils.AnimUtils")

	package.loaded["app.Common.Utils.SpriteUtils"] = nil
	m.SpriteUtils = require("app.Common.Utils.SpriteUtils")

	package.loaded["app.Common.UIBase.UIMaskLayer"] = nil
	m.UIMaskLayer = require("app.Common.UIBase.UIMaskLayer")

	package.loaded["app.Common.UIBase.SceneBase"] = nil
	m.SceneBase = require("app.Common.UIBase.SceneBase")

	package.loaded["app.Common.Utils.ShaderUtils"] = nil
	m.ShaderUtils = require("app.Common.Utils.ShaderUtils")

	package.loaded["app.Common.Utils.FunUtils"] = nil
	m.FunUtils = require("app.Common.Utils.FunUtils")

	--没使用这个
	-- package.loaded["app.Common.Manager.EventSystem"] = nil
	-- m.EventSys = require("app.Common.EventSystem")

	package.loaded["app.Common.Manager.EventBus"] = nil
	m.EventBus = require("app.Common.Manager.EventBus")

	-- m.HttpMng = require("app.Common.Manager.HttpMng")
	package.loaded["app.Common.Manager.XMLHttpMng"] = nil
	m.XMLHttpMng = require("app.Common.Manager.XMLHttpMng")

	package.loaded["app.Common.Manager.SoundEngine"] = nil
	m.SoundEngine = require("app.Common.Manager.SoundEngine"):create()

	package.loaded["app.Common.SDK.LuaCallNativeMng"] = nil
	m.CallNativeMng = require("app.Common.SDK.LuaCallNativeMng")
	return m
end

return m