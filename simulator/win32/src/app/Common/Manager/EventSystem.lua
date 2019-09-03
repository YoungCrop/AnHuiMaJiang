--事件系统
----------------------------------
local m = class("EventSystem")
function m:ctor()
    self._eventBus = {}
end

-- _eventBus[eventName][tag] = listener
function m:regEvent(eventName,listener,tag)
    print(eventName,listener,tag)
    if type(eventName) == "string" and type(listener) == "function" then
        if not self._eventBus[eventName] then self._eventBus[eventName] = {} end
        tag = tag .. ''
        self._eventBus[eventName][tag] = listener
        printf("[[通知中心 %s 注册 %s 成功! ]]", eventName, tag)
    else
        printf("[[通知中心 %s 注册 %s 失败! ]]", tostring(eventName),tag .. '')
    end
end


function m:postEvent(eventName,data)
    assert(eventName, "m:postEvent eventName = nil")
    local target = self._eventBus[eventName]
    if not target then printf("[[通知中心 %s 不存在! ]]", eventName) return end

    local event = { eventName = eventName, tag = nil, data = data }
    if target then
        for _tag,v in pairs(target) do
            printf("[[通知中心 向 %s 发送 %s 成功! ]]", _tag, event.eventName)
            event.tag = _tag
            v( event )
        end
    end
end

function m:unRegEvent(eventName,tag)
    if self._eventBus[eventName] then
        tag = tag .. ''
        self._eventBus[eventName][tag] = nil
        printf("[[通知中心 %s 注销 %s 成功! ]]", eventName, tag)
    else
        printf("[[通知中心 %s 注销 %s 失败! ]]", eventName, tag)
    end
end

function m:unRegEventByName(eventName)
    if self._eventBus[eventName] then
        self._eventBus[eventName] = nil
        printf("[[通知中心 %s 注销成功! ]]", eventName)
    else
        printf("[[通知中心 %s 注销失败! ]]", eventName)
    end
end


function m:hasEventListenerByName(eventName)
    local t = self._eventBus[eventName]
    if not t then return false end
    for _,__ in pairs(t) do
        return true
    end
    return false
end

function m:hasEventListener(eventName,tag)
    return (not self._eventBus[eventName][tag .. ''])
end

function m:removeAllEventListeners()
    self._eventBus = {}
end

function m:dumpAllEventListeners()
    print("---- m:dumpAllEventListeners() ----begin")
    for name, listeners in pairs(self._eventBus) do
        printf("-- event: %s", name)
        for tag, listener in pairs(listeners) do
            printf("--     tag: %s, listener: %s", tostring(tag), tostring(listener))
        end
    end
    print("---- m:dumpAllEventListeners() ----end")
end

return m