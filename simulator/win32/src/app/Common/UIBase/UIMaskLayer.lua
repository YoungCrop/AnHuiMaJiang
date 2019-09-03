
--创建触摸屏蔽层

local m = class("UIMaskLayer", function()
    local layer = display.newLayer(cc.c4b(85, 85, 85,180))
    layer:enableNodeEvents()
    return layer
end)

function m:ctor(param)
	param = checktable(param)
	if param.opacity then
		self:setOpacity(param.opacity)
	end
	if param.color then
		self:setColor(param.color)
	end

	-- 创建一个事件监听器类型为 OneByOne 的单点触摸
	local listener = cc.EventListenerTouchOneByOne:create()
    -- ture 吞并触摸事件,不向下级传递事件;
    -- fasle 不会吞并触摸事件,会向下级传递事件;
    -- 设置是否吞没事件，在 onTouchBegan 方法返回 true 时吞没
    listener:setSwallowTouches(true)
    
    -- 实现 onTouchBegan 事件回调函数
	listener:registerScriptHandler(function(touch, event)
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)


    -- 实现 onTouchEnded 事件回调函数
    listener:registerScriptHandler(function(touch, event)
    	if self._touchEndedHandle then
        	self._touchEndedHandle(touch,event)
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)


    -- 实现 onTouchCancelled 事件回调函数
    listener:registerScriptHandler(function(touch, event)
    end, cc.Handler.EVENT_TOUCH_CANCELLED)
	-- 添加监听器
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	self._touchListener = listener
end

function m:setTouchEndedHandle(_func)
	self._touchEndedHandle = _func
end

--解锁触摸
function m:unlock()
	if self._touchListener then
    	local eventDispatcher = self:getEventDispatcher()
    	eventDispatcher:removeEventListener(self._touchListener)
    	self._touchListener = nil
	end
	self:setOpacity(0)
end

return m