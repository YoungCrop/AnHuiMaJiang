
local luaNative
if "ios" == device.platform then
    luaNative = require("cocos/cocos2d/luaoc")
elseif "android" == device.platform then
    luaNative = require("cocos/cocos2d/luaj")
end

local m = {} 

m.fbCfg = {
    ocClassName = "AppController",
    ocMethodName = "startFeedBack",

    javaClassName = "org/cocos2dx/lua/AppActivity",
    javaMethodName = "startFeedBack",
    javaMethodSig = "()V",
}
function m:openFeedbackView()
    if "ios" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.fbCfg.ocClassName,self.fbCfg.ocMethodName)
    elseif "android" == device.platform then
        local ok,res = luaNative.callStaticMethod(self.fbCfg.javaClassName,self.fbCfg.javaMethodName,nil,self.fbCfg.javaMethodSig)
    elseif "windows" == device.platform then

    end
end

 


return m