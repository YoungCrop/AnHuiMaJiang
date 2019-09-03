
---SceneManager
--require("app.Game.Scene.SceneManager").goSceneLobby()
--require("app.Game.Scene.SceneManager").goSceneUpdate()
--require("app.Game.Scene.SceneManager").goSceneLogin()

local m = {}

function m.goSceneLobby(args)
	local scene = require("app.Game.Scene.SceneLobby"):create(args)
	cc.Director:getInstance():replaceScene(scene)
end

function m.goSceneUpdate(args)
	local scene = require("app.Game.Scene.SceneUpdateX"):create(args)
 	cc.Director:getInstance():replaceScene(scene)
end

function m.goSceneLogin(args)
	local scene = require("app.Game.Scene.SceneLogin"):create(args)
	cc.Director:getInstance():replaceScene(scene)
end



return m