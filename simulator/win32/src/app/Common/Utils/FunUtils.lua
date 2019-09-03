
--FunUtils
local m = {}

m.scheduler = cc.Director:getInstance():getScheduler()

function m.IsiOSPlatform()
    return "ios" == device.platform
end

function m.IsAndroidPlatform()
    return "android" == device.platform
end

function m.clearLoadedFiles()
	--需要加这一行，cc.FileUtils:getInstance():setSearchPaths(resSearchPaths)这行代码中执行了下面的一行代码
	--lua层做了一次缓存，oc中也做了一层缓存
	for k,v in pairs( package.loaded ) do
		if string.sub(k,1,3) == "app" then
			package.loaded[k] = nil
		end
	end
	cc.FileUtils:getInstance():purgeCachedEntries()
	require("app.Init").init()
end

---json是全局变量与string一个级别，可以通过打印 package.loaded 来看到
---不需要再require("json")，require("json")是多余的，require("json")与json地址是相同的
---当全局变量json被赋值时，可以通过require("json")来找回
function m.requireJson()
	if package.preload["cjson"] then
		json = require("cjson")
	end
end
m.requireJson()

function m.getResVersion()
	--需要这样写，若只有version.manifest更新，需要用绝对路径获取最新的，
	--不用绝对路径，杀进程，下次启动会获取到最新的
	local writePath = cc.FileUtils:getInstance():getWritablePath()
	local version_filename = "version.manifest"
	local isExist = cc.FileUtils:getInstance():isFileExist(writePath .. version_filename)
	local version
	if isExist then
		local fileData = cc.FileUtils:getInstance():getStringFromFile(writePath .. version_filename)
        local fileList = json.decode(fileData)
     	version = fileList.version
    else
		isExist = cc.FileUtils:getInstance():isFileExist(version_filename)
		if isExist then
			local fileData = cc.FileUtils:getInstance():getStringFromFile(version_filename)
	        local fileList = json.decode(fileData)
	     	version = fileList.version
		end
	end

	-- local version_filename = "version.manifest"
	-- local version
	-- local isExist = cc.FileUtils:getInstance():isFileExist(version_filename)
	-- if isExist then
	-- 	local fileData = cc.FileUtils:getInstance():getStringFromFile(version_filename)
 --        local fileList = json.decode(fileData)
 --     	version = fileList.version
	-- end
	return (version or "1.0.0")
end

-- start --
--------------------------------
-- @class function
-- @description 获取蒙版剪切精灵
-- @param sprFrameName 需要剪切图片的名称
-- @param isCircle 圆形或者矩形,默认是矩形
-- @return
-- end --
function m.getMaskClipSprite(sprFrameName, frameAdapt)
	local frameSpr = cc.Sprite:createWithSpriteFrameName(sprFrameName)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Texture/GComm.plist")--路径
	--comm_head_icon.png,comm_head_frame.png
	local clipMaskSpr = cc.Sprite:createWithSpriteFrameName("Image/GComm/comm_head_icon.png")
	local maskSize = clipMaskSpr:getContentSize()
	if frameAdapt then
		local frameSize = frameSpr:getContentSize()
		frameSpr:setScale(maskSize.width / frameSize.width)
	end
	frameSpr:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)
	clipMaskSpr:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)
	local renderTexture = cc.RenderTexture:create(maskSize.width, maskSize.height)
	clipMaskSpr:setBlendFunc(cc.blendFunc(gl.ZERO, gl.SRC_ALPHA))
	renderTexture:begin()
	frameSpr:visit()
	clipMaskSpr:visit()
	renderTexture:endToLua()
	local clipSpr = cc.Sprite:createWithTexture(renderTexture:getSprite():getTexture())
	clipSpr:setScaleY(-1)
	return clipSpr
end

-- 设置遮罩图片的混合属性
-- local cirBlend = cc.blendFunc(gl.ONE, gl.ZERO)

-- 设置目标图片的混合属性
-- local sprBlend = cc.blendFunc(gl.DST_ALPHA, gl.ZERO)

-- local s = gComm.FunUtils.getMaskedSprite("Image/GComm/com_avator_man.png")
-- self:addChild(s)
-- s:setPosition(display.cx,display.cy)

function m.getMaskedSprite(targetImg)
	local sprTarget = cc.Sprite:createWithSpriteFrameName(targetImg)
    -- 设置目标图片的混合属性
    local targetBlend = cc.blendFunc(gl.DST_ALPHA, gl.ZERO)
    sprTarget:setBlendFunc(targetBlend)

	cc.SpriteFrameCache:getInstance():addSpriteFrames("Texture/GComm.plist")--路径
	--comm_head_icon.png,comm_head_frame.png
	local sprMask = cc.Sprite:createWithSpriteFrameName("Image/GComm/comm_head_icon.png")--
    -- 设置遮罩图片的混合属性
    local maskBlend = cc.blendFunc(gl.ONE, gl.ZERO)
    sprMask:setBlendFunc(maskBlend)

	local maskSize = sprMask:getContentSize()
	local targetSize = sprTarget:getContentSize()
	sprTarget:setScale(maskSize.width / targetSize.width)

	sprTarget:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)
	sprMask:setPosition(maskSize.width * 0.5, maskSize.height * 0.5)

	local renderTexture = cc.RenderTexture:create(maskSize.width, maskSize.height)
	renderTexture:begin()
	sprTarget:visit()
	sprMask:visit()
	renderTexture:endToLua()
	local sprMasked = cc.Sprite:createWithTexture(renderTexture:getSprite():getTexture())
	sprMasked:setScaleY(-1)
	return sprMasked
end


-- start --
--------------------------------
-- @class function
-- @description 创建扫光动态效果精灵
-- @param targetSpr 目标精灵
-- @param lightSpr 光柱精灵
-- @return 扫光动态效果精灵
-- end --
function m.createTraverseLightSprite(targetSpr, lightSpr)
	targetSpr:removeFromParent()
	targetSpr:setPosition(0, 0)
	lightSpr:removeFromParent()
	lightSpr:setPosition(0, 0)
	local clippingNode = cc.ClippingNode:create()
	clippingNode:setStencil(targetSpr)
	clippingNode:setAlphaThreshold(0)

	local contentSize = targetSpr:getContentSize()
	clippingNode:addChild(targetSpr:clone())
	lightSpr:setPosition(-contentSize.width * 0.5,0)
	clippingNode:addChild(lightSpr)

	local moveAction = cc.MoveTo:create(1, cc.p(contentSize.width, 0))
	local delayTime = cc.DelayTime:create(1)
	local callFunc = cc.CallFunc:create(function(sender)
		sender:setPosition(-contentSize.width, 0)
	end)
	local sequenceAction = cc.Sequence:create(moveAction, delayTime, callFunc)
	local repeatAction = cc.RepeatForever:create(sequenceAction)
	lightSpr:runAction(repeatAction)

	return clippingNode
end


-- start --
--------------------------------
-- @class function
-- @description 震动节点
-- @param node 震动节点
-- @param time 持续时间
-- @param originPos 节点原始位置,为了防止多次shake后节点位置错位
-- @return
-- end --
function m.shakeNode(node, time, originPos, offset)
	local duration = 0.03
	if not offset then
		offset = 6
	end
	-- 一个震动耗时4个duration左,复位,右,复位
	-- 同时左右和上下震动
	local times = math.floor(time / (duration * 4))
	local moveLeft = cc.MoveBy:create(duration, cc.p(-offset, 0))
	local moveLReset = cc.MoveBy:create(duration, cc.p(offset, 0))
	local moveRight = cc.MoveBy:create(duration, cc.p(offset, 0))
	local moveRReset = cc.MoveBy:create(duration, cc.p(-offset, 0))
	local horSeq = cc.Sequence:create(moveLeft, moveLReset, moveRight, moveRReset)
	local moveUp = cc.MoveBy:create(duration, cc.p(0, offset))
	local moveUReset = cc.MoveBy:create(duration, cc.p(0, -offset))
	local moveDown = cc.MoveBy:create(duration, cc.p(0, -offset))
	local moveDReset = cc.MoveBy:create(duration, cc.p(0, offset))
	local verSeq = cc.Sequence:create(moveUp, moveUReset, moveDown, moveDReset)
	node:runAction(cc.Sequence:create(cc.Repeat:create(cc.Spawn:create(horSeq, verSeq), times), cc.CallFunc:create(function()
		node:setPosition(originPos)
	end)))
end

return m