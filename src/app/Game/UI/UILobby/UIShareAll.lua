
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
 
local csbFile = "Csd/ILobby/UIShareAll.csb"
local m = class("UIShareAll", gComm.UIMaskLayer)

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
 
    self:initUI()
end

function m:initUI()
    self:loadCSB()
end

m.btnMap = {
    {1,"QQ_Txt","ShareQQ",},
    {2,"QQ_Image","ShareQQ",},
    {3,"QQ_Url","ShareQQ",},
    {4,"QQ_安装","ShareQQ",},
    {5,"QQ_支持","ShareQQ",},

    {1,"QQ空间Txt","ShareZQQ",},--不支持
    {2,"QQ空间Image","ShareZQQ",},--不支持
    {3,"QQ空间Url","ShareZQQ",},

    {1,"微博Txt","ShareWeiBo",},
    {2,"微博Image","ShareWeiBo",},
    {3,"微博Url","ShareWeiBo",},
    {4,"微博安装","ShareWeiBo",},

    {1,"支付宝Txt","ShareZFB",},
    {2,"支付宝Image","ShareZFB",},
    {3,"支付宝Url","ShareZFB",},
    {4,"支付宝安装","ShareZFB",},
    {5,"支付宝支持","ShareZFB",},

    {1,"微信Txt","ShareWX",},--没有接口
    {2,"微信Image","ShareWX",},
    {3,"微信Url","ShareWX",},

    {1,"朋友圈Txt","ShareWXPYG",},
    {2,"朋友圈Image","ShareWXPYG",},
    {3,"朋友圈Url","ShareWXPYG",},


    {0,"电量","AppFun",},
    {1,"信号","AppFun",},
    {2,"剪贴板内容","AppFun",},
    {3,"反馈","AppFun",},

    {1,"高德位置","GaoDeFun",},
    {2,"高德测距","GaoDeFun",},
}

function m:loadCSB()
	local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:addTo(self)
    -- csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)


    local index = 1
    for k,v in pairs(m.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, "Button_" .. index)
        if btn then
            btn:setTitleText(v[2])
            btn:setTag(v[1])
            gComm.BtnUtils.setButtonClick(btn,handler(self,self[v[3]]))
        end
        index = index + 1
    end 
    self.rootNode = csbNode
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == "Voice_Btn" then
	end
end
function m:GaoDeFun(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()
    print("GaoDeFun s_name=",s_name,tag)

    if tag == 1 then
        local res = gCallNativeMng.NativeGaoDe:getLocAddres()
        self:Tip("位置：" .. res)
    elseif tag == 2 then
        local res = gCallNativeMng.NativeGaoDe:getDisByTwoPoint(1,1,1,2)
        self:Tip("距离： " .. res)
    elseif tag == 3 then
    elseif tag == 4 then
    
    end

end

function m:AppFun(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()


    print("AppFun s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.QQ
    local handle = handler(self,self.Tip)
    if tag == 0 then
        local res = gCallNativeMng.AppNative:getDeviceBattery()
        self:Tip("电量：" .. res)
    elseif tag == 1 then
        local res = gCallNativeMng.AppNative:getDeviceSignalLevel()
        self:Tip("信号： " .. res)
    elseif tag == 2 then
        local function cbFun(txt)
            self:Tip("剪贴板内容： " .. txt)
        end
        local r = gCallNativeMng.AppNative:getPastBordContext(handler(self,self.cbFun))
        self:Tip("剪贴板内容： " .. (r or "nil"))
    elseif tag == 3 then
        gCallNativeMng.NativeFanKui:openFeedbackView()
    elseif tag == 4 then
    
    end

end
function m:cbFun(txt)
    self:Tip("剪贴板内容： " .. txt)
end

function m:ShareQQ(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareQQ s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.QQ
    local handle = handler(self,self.Tip)
    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)
    elseif tag == 4 then
        local res = gCallNativeMng:checkIsInstalled(_type)
        self:Tip(1,"是否支持" .. (res and "true" or "false"))
    elseif tag == 5 then
        local res = gCallNativeMng:isSupportApi(_type)
        print("===-res--QQ isSupportApi-",res)
        self:Tip(1,"是否支持" .. (res and "true" or "false"))
    end
end

function m:ShareZQQ(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareZQQ s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.QQZone
    local handle = handler(self,self.Tip)

    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)


    end
end

function m:ShareWeiBo(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareWeiBo s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.WeiBo
    local handle = handler(self,self.Tip)
    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)
    elseif tag == 4 then
        local res = gCallNativeMng:checkIsInstalled(_type)
        self:Tip(1,"是否支持" .. (res and "true" or "false"))
    end
end

function m:ShareZFB(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareZFB s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.Zfb
    local handle = handler(self,self.Tip)
    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)
    elseif tag == 4 then
        local res = gCallNativeMng:checkIsInstalled(_type)
        print("===-res--zfb checkIsInstalled-",res)
        self:Tip(1,"是否支持" .. (res and "true" or "false"))
    elseif tag == 5 then
        local res = gCallNativeMng:isSupportApi(_type)
        print("===-res--zfb isSupportApi-",res)
        self:Tip(1,"是否支持" .. (res and "true" or "false"))
    end
end


function m:ShareWX(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareWX s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.WeiXin
    local handle = handler(self,self.Tip)
    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)
    end
end

function m:ShareWXPYG(_sender)
    local s_name = _sender:getName()
    local tag = _sender:getTag()

    print("ShareWXPYG s_name=",s_name,tag)
    local txt = "尼古拉斯赵四，~~~~"
    local title = "title"
    local url = gCallNativeMng.NativeMeChuang:getMCURL()
    local _type = gCallNativeMng.shareType.WeiXinPYQ
    local handle = handler(self,self.Tip)
    if tag == 1 then
        gCallNativeMng:shareText(_type,txt,handle)
    elseif tag == 2 then
        self:JeiPing(_type,handle)
    elseif tag == 3 then
        gCallNativeMng:shareURL(_type,url,title,txt,handle)
    end
end



function m:JeiPing2(_type,handle)
    local layerSize = cc.size(display.size.width,display.size.height)
    local gl_depth24_stencil8 = 0x88F0
    local eFormat = 2
    local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height, eFormat, gl_depth24_stencil8)

    screenshot:begin()
    self.rootNode:visit()
    screenshot:endToLua()

    local screenshotFileName = string.format("wx_%s.jpg", os.time())--os.date("%Y-%m-%d_%H:%M:%S", os.time()))
    screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_JPEG, false)

    local img = cc.FileUtils:getInstance():getWritablePath() .. screenshotFileName

    local delay = cc.DelayTime:create(1.5)
    local calBackFun = cc.CallFunc:create(function(sender)
        gCallNativeMng:shareImage(_type,img,"title~~~","desc~~~",handle)
    end)
    local seqAction = cc.Sequence:create(delay,calBackFun)
    self.rootNode:runAction(seqAction)
end

function m:JeiPing(_type,handle)
    -- local size = cc.Director:getInstance():getWinSize()
    -- local screen = cc.RenderTexture:create(size.width,size.height,cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888,gl.DEPTH24_STENCIL8_OES)
    -- local scene = cc.Director:getInstance():getRunningScene()
    -- screen:begin()
    -- scene:visit()
    -- screen:endToLua()
    local name = string.format("wx_%s.jpg", os.time())
    -- screen:saveToFile(name,cc.IMAGE_FORMAT_JPEG,false)

    gComm.UIUtils.screenshot(name)

    local img = cc.FileUtils:getInstance():getWritablePath() .. name
    local delay = cc.DelayTime:create(1.5)
    local calBackFun = cc.CallFunc:create(function(sender)
        gCallNativeMng:shareImage(_type,img,"title~~~","desc~~~",handle)
    end)
    local seqAction = cc.Sequence:create(delay,calBackFun)
    self.rootNode:runAction(seqAction)

    -- local layerSize = self.rootNode:getContentSize()
    -- local layerSize = cc.size(display.size.width,display.size.height)
    -- local gl_depth24_stencil8 = 0x88f0
    -- local eFormat = 2
    -- local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height, eFormat, gl_depth24_stencil8)
    -- screenshot:begin()
    -- self.rootNode:visit()
    -- screenshot:endToLua()

    -- local screenshotFileName = string.format("wx-%s.jpg", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
    -- screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_JPEG, false)

end


function m:Tip(resId,errorDesc)
--[[
微信分享
0：成功
-2（用户取消）

//        public static final int ERR_OK = 0;
//        
//        // Field descriptor #18 I
//        public static final int ERR_COMM = -1;
//        
//        // Field descriptor #18 I
//        public static final int ERR_USER_CANCEL = -2;
//        
//        // Field descriptor #18 I
//        public static final int ERR_SENT_FAILED = -3;
//        
//        // Field descriptor #18 I
//        public static final int ERR_AUTH_DENIED = -4;
//        
//        // Field descriptor #18 I
//        public static final int ERR_UNSUPPORT = -5;

]]


    local arr = string.split(resId,"&")
    -- local str = "resultID:" .. resId
    -- if errorDesc then
    --     str = "resultID:" .. resId .. "  errorInfo: " .. errorDesc
    -- end
    local str = arr[1]
    if arr[2] then
        str = str .. "   " .. arr[2]
    end
    if errorDesc then
        str = str .. "   " .. errorDesc
    end
    log("myTip======" .. str)

    UINoticeTips:create(str)
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function( ... )
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function ( ... )
        self:removeFromParent()
    end, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self.rootNode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function m:onExit()
    log(self.__TAG,"onExit") 
end 
function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end 

return m