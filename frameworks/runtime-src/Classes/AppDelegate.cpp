#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "lua_module_register.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_LINUX)
#include "ide-support/CodeIDESupport.h"
#endif

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
#include "runtime/Runtime.h"
#include "ide-support/RuntimeLuaImpl.h"
#endif

// 导入头文件 CrashReport.h 和 BuglyLuaAgent.h
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "bugly/CrashReport.h"
#include "bugly/lua/BuglyLuaAgent.h"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "CrashReport.h"
#include "BuglyLuaAgent.h"
#endif


#include "lua_UtilityExtension_auto.hpp"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "YunVaSDK/YVTool.h"
using namespace YVSDK;
#endif

#define BuglyKeyiOS "00c58f1091"
#define BuglyKeyAndroid "fa2bc0c572"

using namespace CocosDenshion;

USING_NS_CC;
using namespace std;

class DispatchMsgNode : public cocos2d::Node
{
public:
    bool init()
    {
        isschedule = false;
        return  Node::init();
    }
    CREATE_FUNC(DispatchMsgNode);
    void startDispatch()
    {
        if (isschedule) return;
        isschedule = true;
        Director::getInstance()->getScheduler()->scheduleUpdate(this, 0, false);
    }
    void stopDispatch()
    {
        if (!isschedule) return;
        isschedule = false;
        Director::getInstance()->getScheduler()->unscheduleUpdate(this);
    }
    void update(float dt)
    {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        YVTool::getInstance()->dispatchMsg(dt);
#endif
    }
private:
    bool isschedule;
    
};

AppDelegate::AppDelegate()
{
    m_dispathMsgNode = NULL;
}

AppDelegate::~AppDelegate()
{
    if (m_dispathMsgNode != NULL)
    {
        m_dispathMsgNode->stopDispatch();
        m_dispathMsgNode->release();
        m_dispathMsgNode = NULL;
    }

    
	SimpleAudioEngine::end();

#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
	// NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
	RuntimeEngine::getInstance()->end();
#endif

}

//if you want a different context,just modify the value of glContextAttrs
//it will takes effect on all platforms
void AppDelegate::initGLContextAttrs()
{
	//set OpenGL context attributions,now can only set six attributions:
	//red,green,blue,alpha,depth,stencil
	GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};

	GLView::setGLContextAttrs(glContextAttrs);
}

// If you want to use packages manager to install more packages,
// don't modify or remove this function
static int register_all_packages(lua_State* L)
{
	register_all_UtilityExtension(L);
	return 0; //flag for packages manager
}

bool AppDelegate::applicationDidFinishLaunching()
{
	// set default FPS
	Director::getInstance()->setAnimationInterval(1.0 / 60.0f);

	Image::setPVRImagesHavePremultipliedAlpha(true);

	// register lua module
	auto engine = LuaEngine::getInstance();
    
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CrashReport::initCrashReport(BuglyKeyAndroid, false);
    // register lua exception handler with lua engine
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CrashReport::initCrashReport(BuglyKeyiOS, false);
    // register lua exception handler with lua engine
    BuglyLuaAgent::registerLuaExceptionHandler(engine);
#endif
    
    
    
	ScriptEngineManager::getInstance()->setScriptEngine(engine);
	lua_State* L = engine->getLuaStack()->getLuaState();
	lua_module_register(L);

	register_all_packages(L);

	LuaStack* stack = engine->getLuaStack();

	stack->setXXTEAKeyAndSign("gLYWZJANHUI", strlen("gLYWZJANHUI"), "talYWZJANHUI", strlen("talYWZJANHUI"));

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    if (m_dispathMsgNode == NULL)
    {
        m_dispathMsgNode = DispatchMsgNode::create();
        m_dispathMsgNode->retain();
        m_dispathMsgNode->startDispatch();
    }
#endif
    
    
#if (COCOS2D_DEBUG > 0) && (CC_CODE_IDE_DEBUG_SUPPORT > 0)
	// NOTE:Please don't remove this call if you want to debug with Cocos Code IDE
	auto runtimeEngine = RuntimeEngine::getInstance();
	runtimeEngine->addRuntime(RuntimeLuaImpl::create(), kRuntimeEngineLua);
	runtimeEngine->start();
#else


    #if COCOS2D_DEBUG
        FileUtils::filepathfun = nullptr;
        FileUtils::decrpyfun = nullptr;
        if (engine->executeString("require('src/main')"))
    #else
        if (engine->executeString("require('src_et/main')"))
    #endif
        {
            return false;
        }
#endif

	return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
	Director::getInstance()->stopAnimation();

	Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_BACKGROUND_EVENT");
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
	Director::getInstance()->startAnimation();

	Director::getInstance()->getEventDispatcher()->dispatchCustomEvent("APP_ENTER_FOREGROUND_EVENT");
}
