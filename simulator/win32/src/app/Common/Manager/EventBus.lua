--事件系统
----------------------------------


-- _eventBus[eventName] = {target, method}
local _eventBus = {}

local m = class("EventBus")

-- start --
--------------------------------
-- @class function regEventListener
-- @description 注册事件回调
-- @param eventName 事件名称
-- @param target 实例
-- @param method 方法
-- @return
-- regEventListener(2, self, self.eventLis)
-- end --
function m.regEventListener(eventName, target, method)
    if not eventName or not target or not method then
        return
    end

    local listeners = _eventBus[eventName]
    if not listeners then
        -- 首次添加eventType类型事件，新建消息存储列表
        listeners = {}
        _eventBus[eventName] = listeners
    else
        -- 检查重复添加
        for _, listener in ipairs(listeners) do
            if listener[1] == target and listener[2] == method then
                return
            end
        end
    end

    -- 加入到事件列表中
    local listener = {target, method}
    table.insert(listeners, listener)
end

function m.dispatchEvent(eventName, ...)
    if not eventName then
        return
    end
    local listeners = _eventBus[eventName] or {}
    for _, listener in ipairs(listeners) do
        -- 调用注册函数
        listener[2](listener[1], eventName, ...)
    end
end

function m.unRegEventByName(target, eventName)
    if not target or not eventName then
        return
    end
    -- 移除target的注册的eventName类型事件
    local listeners = _eventBus[eventName] or {}
    for i, listener in ipairs(listeners) do
        if listener[1] == target then
            table.remove(listeners, i)
        end
    end
end

function m.unRegAllEvent(target)
    if not target then
        return
    end
    -- 移除target注册的全部事件
    for eventName, listeners in pairs(_eventBus) do
        for i=#listeners, 1, -1 do          
            local v = listeners[i]
            if v[1] == target then 
                table.remove(listeners, i)
            end
        end
        if #listeners == 0 then
            _eventBus[eventName] = nil 
        end
    end
end

function m.removeAllEvent()
    _eventBus = {}
end

function m:dumpAllEventListeners()
    print("---- m:dumpAllEventListeners() ----begin")
    for name, listeners in pairs(_eventBus) do
        printf("-- event: %s", name)
        for tag, listener in pairs(listeners) do
            printf("--     tag: %s, self: %s,method: %s", tostring(tag), tostring(listener[1]),tostring(listener[2]))
        end
    end
    print("---- m:dumpAllEventListeners() ----end")
end

return m