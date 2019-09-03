/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import <UIKit/UIKit.h>

#import "cocos2d.h"

#import "AppController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "platform/ios/CCEAGLView-ios.h"

#include "CCLuaEngine.h"
#include "CCLuaBridge.h"

#import "OpenUDID.h"
#import "SFHFKeychainUtils.h"


#if !TARGET_IPHONE_SIMULATOR
#include "VoiceManager.hpp"
#endif

#include "GamePayment.h"


#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"
#import "MWApi.h"

#import <MAMapKit/MAMapKit.h>
#import <dlfcn.h>

#import <Social/Social.h>
using namespace cocos2d;

//QQ
#import <TencentOpenAPI/TencentOAuth.h>
#define TENCENT_CONNECT_APP_KEY @"1106467561" //--换成自己的appId

//支付宝
#define ZFB_APP_ID @"2017121900990381"
//支付宝分享  在需要处理支付宝应用回调的类内添加对应的Delegate

//高德
#define GaoDe_API_KEY @"8aa2b86c04990e417ade352a9b7858d7"

// weibo share
#define wbAppKey    @"3726064055"
#define wbRedirectURI   @"https://api.weibo.com/oauth2/default.html"

//反馈
#define Feedback_AppKey @"24807910"
#define Feedback_AppSecret @"fb71106699662eba86fb4b05c7f9eede"

//微信
#define WeiXin_AppID @"wx1cfbd0c36d76b153"

//魔窗
#define MC_AppKey @"AFY1P38ZLSLYHZ34708JIGXF470UW0QG"


@interface AppController () <APOpenAPIDelegate>
@end

@implementation AppController

#pragma mark -
#pragma mark Application lifecycle

// cocos2d application instance
static AppDelegate s_sharedApplication;

NSString *_localAddres = @"";
NSString *_locationUser = @"";

NSString *roomID = @"";
NSString *userParam = @"";

AMapLocationManager * locationManager = nil;

int _authCodeScriptHandler = 0;

YWFeedbackKit *mfeedbackKit;

+ (NSString *)getDeviceBattery
{
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
    NSInteger batteryStatus = (NSInteger)round(device.batteryLevel * 100);
    [device setBatteryMonitoringEnabled:NO];
    NSLog(@"the device Battery is %ld",(long)batteryStatus);
    return [NSString stringWithFormat:@"%ld",(long)batteryStatus];
}

+ (NSString *)getDeviceSignalStatus
{
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    
    if (strNetworkType.length == 0) {
        strNetworkType = @"WWAN";
    }
    
    NSLog( @"GetNetWorkType() strNetworkType :  %@", strNetworkType);
    
    return strNetworkType;
}




+ (NSString *)getDeviceSignalLevel
{
//    UIApplication *cation = [UIApplication sharedApplication];
//    NSArray *subviews = [[[cation valueForKey:@"statusBar"]valueForKey:@"foregroundView"] subviews];
//    NSString *dataNetworkItemView = nil;
//    for (id subview in subviews) {
//        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]])
//        {
//            dataNetworkItemView = subview;
//            break;
//        }
//    }
//    NSInteger signalStrength = [[dataNetworkItemView valueForKey:@"signalStrengthRaw"] integerValue];
    
    
//    NSInteger signalNum = 0;
//
//    if (signalStrength > -91)
//    {
//        signalNum = 3;
//    }
//    else if (signalStrength >= -103 && signalStrength <= -91)
//    {
//        signalNum = 2;
//    }
//    else if (signalStrength >= -113 && signalStrength <= -101)
//    {
//        signalNum = 1;
//    }
//    else if (signalStrength < -113)
//    {
//        signalNum = 0;
//    }
    
    //    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"wifi"
    //                                                     message:[NSString stringWithFormat:@"signal %ld",(long)signalNum] delegate:nil
    //                                           cancelButtonTitle:@"ok"
    //                                           otherButtonTitles:nil, nil];
    //    [alert1 show];
    
//    NSLog(@"signal %ld", (long)signalNum);
    
//    return [NSString stringWithFormat:@"%ld",(long)signalNum];
    
//    return [NSString stringWithFormat:@"%ld",(long)signalStrength];
    
    UIApplication *cation = [UIApplication sharedApplication];
    NSArray *subviews = [[[cation valueForKey:@"statusBar"]valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]])
            {
                dataNetworkItemView = subview;
                break;
            }
        }
        NSInteger signalStrength = [[dataNetworkItemView valueForKey:@"signalStrengthRaw"] integerValue];
        return [NSString stringWithFormat:@"%ld",(long)signalStrength];
    } else {
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
            {
                dataNetworkItemView = subview;
                break;
            }
        }
        NSInteger signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] integerValue];
        return [NSString stringWithFormat:@"%ld",(long)signalStrength];
    };
}

+ (NSString *)getIOSDeviceType
{
    return [NSString stringWithFormat:@"%ld",(long)[[UIDevice currentDevice] userInterfaceIdiom]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	cocos2d::Application *app = cocos2d::Application::getInstance();
	app->initGLContextAttrs();
	cocos2d::GLViewImpl::convertAttrs();

	// Override point for customization after application launch.

	// Add the view controller's view to the window and display.
	window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
	CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
									 pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
									 depthFormat: cocos2d::GLViewImpl::_depthFormat
							  preserveBackbuffer: NO
									  sharegroup: nil
								   multiSampling: NO
								 numberOfSamples: 0 ];

	[eaglView setMultipleTouchEnabled:NO];

	// Use RootViewController manage CCEAGLView
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	viewController.view = eaglView;

	// Set RootViewController to window
	if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
	{
		// warning: addSubView doesn't work on iOS6
		[window addSubview: viewController.view];
	}
	else
	{
		// use this method on ios6
		[window setRootViewController:viewController];
	}

	[window makeKeyAndVisible];

	[[UIApplication sharedApplication] setStatusBarHidden: YES];
    
    //初始化高德sdk
    [AMapServices sharedServices].apiKey = GaoDe_API_KEY;
    
	// release version
	[WXApi registerApp:WeiXin_AppID];
    
    //魔窗
    //[MWApi setLogEnable:YES];
    [MWApi registerApp:MC_AppKey];
    [self registerMlink];
    
    [[TencentOAuth alloc] initWithAppId:TENCENT_CONNECT_APP_KEY andDelegate:nil];
    
    //支付宝分享
    if (![APOpenAPI registerApp:ZFB_APP_ID]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付宝注册App失败" message:@"请检查scheme配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    //初始化用户反馈
    mfeedbackKit = [self feedbackKit];
    
    //初始化微博分享
    [WeiboSDK enableDebugMode:YES]; //目前使用debug，提交版本修改NO
    [WeiboSDK registerApp:wbAppKey];
    
	// IMPORTANT: Setting the GLView should be done after creating the RootViewController
	cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
	cocos2d::Director::getInstance()->setOpenGLView(glview);

	app->run();
	return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"handleOpenURL: %@", url);

    if ([QQApiInterface handleOpenURL:url delegate:self]) {
        BOOL res = [QQApiInterface handleOpenURL:url delegate:self];
        return res;
    }
    
    if ([APOpenAPI handleOpenURL:url delegate:self])
    {
        return [APOpenAPI handleOpenURL:url delegate:self];
    }
    
    if ([WeiboSDK handleOpenURL:url delegate:self])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([WXApi handleOpenURL:url delegate:self])
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
}

//iOS9 以下
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WeiXin_AppID]]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",wbAppKey]]){
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    //支付宝分享调用
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"ap%@",ZFB_APP_ID]]) {
        return [APOpenAPI handleOpenURL:url delegate:self];
    }
    
    //魔窗配置后台用的是微信appid
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WeiXin_AppID]]) {
        [MWApi routeMLink:url];
        return YES;
    }
    return YES;
}
//iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    //微信
    if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WeiXin_AppID]]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    //支付宝分享调用
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"ap%@",ZFB_APP_ID]]) {
        return [APOpenAPI handleOpenURL:url delegate:self];
    }
    //QQ
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",TENCENT_CONNECT_APP_KEY]]) {
        BOOL res = [QQApiInterface handleOpenURL:url delegate:self];
        //delegate如给参nil，则不会走 函数(void) onResp:(BaseResp*)resp
        return res;
    }
    
    //微博
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",wbAppKey]]){
        //wb871141980://response?id=F10FB99B-89C7-4F05-87A2-475665349BF6&sdkversion=2.5
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    //魔窗配置后台，用的是微信appid
    else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WeiXin_AppID]]) {
        
        [MWApi routeMLink:url];
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSLog(@"continueUserActivity: %@", userActivity);
    NSLog(@"continueUserActivity: %@", restorationHandler);
    return [MWApi continueUserActivity:userActivity];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
	cocos2d::Director::getInstance()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
	cocos2d::Director::getInstance()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	 If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
	 */
	cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	/*
	 Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
	 */
	cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
	/*
	 Called when the application is about to terminate.
	 See also applicationDidEnterBackground:.
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	 */
	 cocos2d::Director::getInstance()->purgeCachedData();
}


- (void)dealloc {
	[super dealloc];
}

+ (void)openWebURL:(NSDictionary *)url
{
    if (!url)
        return;

    NSString *s_url = [url objectForKey:@"webURL"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s_url]];
}

#pragma mark - WXApiDelegate
- (void) onReq:(BaseReq*)req
{
    NSLog(@" ----req %@",req);
	if([req isKindOfClass:[GetMessageFromWXReq class]])
	{
        
        NSLog(@"APP GetMessageFromWXReq");
        
		// 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
		NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
		NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		alert.tag = 1000;
		[alert show];
		[alert release];
	} else if([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        
         NSLog(@"APP ShowMessageFromWXReq");
        
		ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
		WXMediaMessage *msg = temp.message;

		//显示微信传过来的内容
		WXAppExtendObject *obj = msg.mediaObject;

		NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
		NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%luu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	} else if([req isKindOfClass:[LaunchFromWXReq class]]) {
        
        NSLog(@"APP LaunchFromWXReq");
        
        
		//从微信启动App
		NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
		NSString *strMsg = @"这是从微信启动的消息";

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
    }
}

- (void) onResp:(BaseResp*)resp
{
//    NSLog(@" ----resp,errStr=%@",resp.errStr);
	if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSLog(@"APP SendMessageToWXResp,errCode=[%d],errDesc=[%@]",resp.errCode,resp.errStr);
        
        if(_authCodeScriptHandler) {
            //resp.errCode == 0 //成功
            NSString* res = [[NSString alloc] initWithFormat:@"%d&%@", resp.errCode,resp.errStr];
            
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([res UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
        
	}else if([resp isKindOfClass:[SendAuthResp class]]) {
        
        //  ERR_OK = 0(用户同意)
        //  ERR_AUTH_DENIED = -4（用户拒绝授权）
        //  ERR_USER_CANCEL = -2（用户取消）
        NSLog(@"APP WeiXin auth SendAuthResp,errCode=[%d],errDesc=[%@]",resp.errCode,resp.errStr);
        
        if(_authCodeScriptHandler) {
            NSString* code = [[NSString alloc] initWithFormat:@"%d", resp.errCode];
            if (resp.errCode == 0) {// 用户同意,code获取成功
                code = [[NSString alloc] initWithString:((SendAuthResp*)resp).code];
            }
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([code UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
	}
    
    //QQ分享返回
    else if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp * tmpResp = (SendMessageToQQResp *)resp;
        NSLog(@"APP SendMessageToQQResp,errCode=[%@],errDesc=[%@]",tmpResp.result,tmpResp.errorDescription);
        NSString* res = [[NSString alloc] initWithFormat:@"%@&%@", tmpResp.result, tmpResp.errorDescription];
        if(_authCodeScriptHandler) {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([res UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
    }
    
    //支付宝分享的返回
    else if([resp isKindOfClass:[APSendMessageToAPResp class]]) {
        NSLog(@"APP SendMessageToAlipayResp");
        APSendMessageToAPResp * tmpResp = (APSendMessageToAPResp *)resp;
        NSString* res = [[NSString alloc] initWithFormat:@"%d&%@", tmpResp.errCode, tmpResp.errStr];
        if(_authCodeScriptHandler) {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([res UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
    }
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}


- (void)registerMlink
{
    [MWApi registerMLinkDefaultHandler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        
        //URL和mlinkKey匹配不上，自行处理URL,进行跳转
    }];
    
    [MWApi registerMLinkHandlerWithKey:@"openAnHuiMJApp" handler:^(NSURL * _Nonnull url, NSDictionary * _Nullable params) {
        roomID = [params objectForKey:@"roomID"];
        userParam = [params objectForKey:@"userParam"];
    }];
}

+ (NSString *)getRoomID
{
    NSLog(@"getRoomID:room%@",roomID);
    return roomID;
}

+ (void)clearRoomID
{
    NSLog(@"clearRoomID");
    roomID = @"";
}
+ (NSString *)getUserParam
{
    NSLog(@"getUserParam:userParam%@",userParam);
    return userParam;
}

+ (void)clearUserParam
{
    NSLog(@"clearUserParam");
    userParam = @"";
}

+ (BOOL)isWXAppInstalled
{
    CCLOG("AppController isWXAppInstalled");
    return [WXApi isWXAppInstalled];
}

+ (void)sendAuthRequest:(NSDictionary *)dict
{
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    SendAuthReq* req =[[[SendAuthReq alloc] init] autorelease];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
}

+ (void)shareTextToWX:(NSDictionary *)dict
{
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [dict objectForKey:@"text"];
    req.bText = YES;
    req.scene = [[dict objectForKey:@"disType"] intValue];//0--好友 1--朋友圈
    [WXApi sendReq:req];
}

+ (void)shareImageToWX:(NSDictionary *)dict
{
    NSString *filePath = [dict objectForKey:@"imgFilePath"];
    NSLog(@"filePath:[%@]", filePath);
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *imgObject = [WXImageObject object];
    message.mediaObject = imgObject;
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    imgObject.imageData = UIImageJPEGRepresentation(image,0.5);// UIImagePNGRepresentation(image);
    
    // 分享图片缩小
    CGSize size;
    size.width = 300;
    size.height = int(300 / (double)image.size.width * image.size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [message setThumbImage:newImage];
    
    // 像微信发送分享请求
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [[dict objectForKey:@"disType"] intValue];//0--好友 1--朋友圈
    
    [WXApi sendReq:req];
}

+ (void)shareURLToWX:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"url"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *description = [dict objectForKey:@"description"];
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    UIImage *appIcon = [UIImage imageNamed:@"icon.png"];
    
    [message setThumbImage:appIcon];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [[dict objectForKey:@"disType"] intValue];//0--好友 1--朋友圈
    [WXApi sendReq:req];
}
//QQ分享文本信息
+ (void)shareTextToQQ:(NSDictionary *)dict
{
    NSString *text = [dict objectForKey:@"text"];
    NSString *disType = [dict objectForKey:@"disType"];
    NSLog(@"shareTextToQQ,text:[%@],disType:[%@]", text,disType);
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq,QQ空间
    if (disType.intValue == 1)
    {
        [QQApiInterface sendReq:req];
    }
    else
    {
        //弹出的QQ界面中没有QQ空间,不支持QQ空间分享文本
        [QQApiInterface  SendReqToQZone:req];
    }
}
//QQ分享图片信息
+ (void)shareImageToQQ:(NSDictionary *)dict
{
    NSString *filePath = [dict objectForKey:@"imgFilePath"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *description = [dict objectForKey:@"description"];
    NSString *disType = [dict objectForKey:@"disType"];
    NSLog(@"filePath:[%@],title=%@,description=%@,disType=%@", filePath,title,description,disType);
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    // 分享图片缩小
    CGSize size;
    size.width = 300;
    size.height = int(300 / (double)image.size.width * image.size.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* objectWithData = UIImageJPEGRepresentation(image,1);
    
    //具体数据内容,最大5M字节
    //预览图像，最大1M字节
    int rate = 1024 * 1000 * 5 / objectWithData.length;
    if (rate < 1){
        objectWithData = UIImageJPEGRepresentation(image,rate);
    }
    NSData* previewImageData = UIImageJPEGRepresentation(image,1);
    rate = 1024 * 1000 / previewImageData.length;
    if (rate < 1){
        previewImageData = UIImageJPEGRepresentation(newImage,rate);
    }
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:objectWithData previewImageData:previewImageData title:title description:description];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq,QQ空间
    if (disType.intValue == 1)
    {
        [QQApiInterface sendReq:req];
    }
    else
    {
        //弹出的QQ界面中没有QQ空间,不支持QQ空间分享图片
        [QQApiInterface SendReqToQZone:req];
    }
}
//QQ分享URL信息
+ (void)shareURLToQQ:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"url"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *description = [dict objectForKey:@"description"];
    NSString *disType = [dict objectForKey:@"disType"];
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    UIImage *appIcon = [UIImage imageNamed:@"icon.png"];
    QQApiNewsObject* newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString: url] title:title description:description previewImageData:UIImagePNGRepresentation(appIcon)];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq,QQ空间
    if (disType.intValue == 1)
    {
        [QQApiInterface sendReq:req];
    }
    else
    {
        [QQApiInterface  SendReqToQZone:req];
    }
}

/**
 检测是否已安装QQ
 \return 如果QQ已安装则返回YES，否则返回NO
 */
+ (BOOL)isQQInstalled
{
    return [QQApiInterface isQQInstalled];
}

/**
 检测QQ是否支持API调用
 \return 如果当前安装QQ版本支持API调用则返回YES，否则返回NO
 */
+ (BOOL)isQQSupportApi
{
    return [QQApiInterface isQQInstalled];
}

//支付宝分享文本信息
+ (void)shareTextToZFB:(NSDictionary *)dict
{
    NSString *text = [dict objectForKey:@"text"];
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    //  创建文本类型的消息对象
    APShareTextObject *textObj = [[APShareTextObject alloc] init];
    textObj.text = text;
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = textObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至当前版本，分享入口已合并，scene参数并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题，建议还是照常传入。
    //request.scene = 0;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"shareTextToZFB发送失败");
    }
}
//支付宝分享图片信息
+ (void)shareImageToZFB:(NSDictionary *)dict
{
    NSString *filePath = [dict objectForKey:@"imgFilePath"];
    NSLog(@"filePath:[%@]", filePath);
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    //  创建图片类型的消息对象
    APShareImageObject *imgObj = [[APShareImageObject alloc] init];
    //imgObj.imageUrl = @"此处填充图片的url链接地址";
    //图片也可使用imageData字段分享本地UIImage类型图片，必须填充有效的image NSData类型数据，否则无法正常分享
    //例如 imgObj.imageData = UIImagePNGRepresentation(Your UIImage Obj);
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    imgObj.imageData = UIImageJPEGRepresentation(image,0.5);// UIImagePNGRepresentation(image);
    
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = imgObj;
    
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至当前版本，分享入口已合并，scene参数并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题，建议还是照常传入。
    //request.scene = 0;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"shareImageToZFB发送失败");
    }
}
//支付宝分享网页链接
+ (void)shareURLToZFB:(NSDictionary *)dict
{
    NSString *url = [dict objectForKey:@"url"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *description = [dict objectForKey:@"description"];
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = [[APMediaMessage alloc] init];
    
    message.title = title;
    message.desc = description;
    //  此处填充缩略图data数据,例如 UIImagePNGRepresentation(UIImage对象)
    //  此处必须填充有效的image NSData类型数据，否则无法正常分享
    //    UIImage *appIcon = [UIImage imageNamed:@"icon.png"];
    //    message.thumbUrl = @"https://tfsimg.alipay.com/images/openhome/TB1wH8IXl9m.eJkUuGVwu1RoFXa.png";
    
    UIImage *appIcon = [UIImage imageNamed:@"icon.png"];
    message.thumbData =  UIImagePNGRepresentation(appIcon);
    
    //  创建网页类型的消息对象
    APShareWebObject *webObj = [[APShareWebObject alloc] init];
    webObj.wepageUrl = url;
    //  回填 APMediaMessage 的消息对象
    message.mediaObject = webObj;
    
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至现在版本，分享入口已合并，这个scene并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题、建议还是照常传入
    //request.scene = 0;
    //  发送请求
    BOOL result = [APOpenAPI sendReq:request];
    if (!result) {
        //失败处理
        NSLog(@"shareURLToZFB发送失败");
    }
}











#if !TARGET_IPHONE_SIMULATOR
+ (void)createYayaSDK:(NSDictionary *)sdkContent
{
    if (!sdkContent)
    return;
    
    NSString *str_appid = [sdkContent objectForKey:@"appid"];
    NSString *str_audioPath = [sdkContent objectForKey:@"audioPath"];
    NSString *str_isDebug = [sdkContent objectForKey:@"isDebug"];
    NSString *str_oversea = [sdkContent objectForKey:@"oversea"];
    VoiceManager *manager = VoiceManager::GetInstance();
    NSInteger appid = [str_appid integerValue];
    std::string audioPath = [str_audioPath UTF8String];
    bool isDebug = [str_isDebug boolValue];
    bool oversea = [str_oversea boolValue];
    manager->addListern(appid,audioPath,isDebug,oversea);
    
}

+ (void)loginYayaSDK:(NSDictionary *)loginContent
{
    if (!loginContent)
    return;
    [NSThread detachNewThreadSelector:@selector(loginYaya:) toTarget:self withObject:loginContent];
}

+ (void)loginYaya:(NSDictionary*)loginContent
{
    if (!loginContent)
        return;
    
    NSString *str_username = [loginContent objectForKey:@"username"];
    NSString *str_userid = [NSString stringWithFormat:@"%@", [loginContent objectForKey:@"userid"]];
    VoiceManager *manager = VoiceManager::GetInstance();
    std::string username = [str_username UTF8String];
    std::string userid = [str_userid UTF8String];
    manager->loginYayayun(username,userid);
}



+ (void)startVoice:(NSDictionary *)recodePath
{
    if (!recodePath)
    return;
    
    NSString *s_url = [recodePath objectForKey:@"recodePath"];
    VoiceManager *manager = VoiceManager::GetInstance();
    std::string url = [s_url UTF8String];
    printf("recodePath = %s\n",url.c_str());
    
    manager->startRecord(url);
}

+ (void)stopVoice
{
    VoiceManager *manager = VoiceManager::GetInstance();
    manager->stopRecord();
}

+ (void)cancelVoice
{
    VoiceManager *manager = VoiceManager::GetInstance();
    manager->stopRecord();
}

+ (NSString *)getVoiceUrl
{
    VoiceManager *manager = VoiceManager::GetInstance();
    NSString * url = [NSString stringWithCString:manager->getAudioUrl().c_str()
                                        encoding:NSUTF8StringEncoding];
    return url;
}

+ (void)playVoice:(NSDictionary *)url
{
    NSString *s_url = [url objectForKey:@"voiceUrl"];
    VoiceManager *manager = VoiceManager::GetInstance();
    std::string voiceUrl = [s_url UTF8String];
    manager->playAudio(voiceUrl);
}
#endif

+ (NSString *)getOpenUDID
{
    NSString *pUDIDString = [SFHFKeychainUtils getPasswordForUsername:@"DeviceOpenUDID"
                                                       andServiceName:@"LaoYouMahjonghn" error:nil];
    if (pUDIDString == nil) {
        pUDIDString = [OpenUDID value];
        [SFHFKeychainUtils storeUsername:@"DeviceOpenUDID" andPassword:pUDIDString
                          forServiceName:@"LaoYouMahjonghn" updateExisting:NO error:nil];
    }
    
    return pUDIDString;
}

+ (NSString *)getVersionName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}



+ (void)copyText:(NSDictionary *)dict
{
    NSString *copyText = [dict objectForKey:@"copyText"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString: copyText];
}


//----------------app iap 内购--------------------------

// 请求商品信息
+ (void) req_iap:(NSDictionary *)dict
{
    
    NSString *identifier = [dict objectForKey:@"identifier"];
    
    std::string cidentifier = [identifier UTF8String];
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    
    GamePayment::getInstance()->req_iap(cidentifier, scriptHandler);
}

// 购买请求
+ (void) pay_iap:(NSDictionary *)dict
{
    
    int quantity = [[dict objectForKey:@"quantity"] intValue];
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    
    GamePayment::getInstance()->pay_iap(quantity, scriptHandler);
}

// 恢复购买
+ (void) restore_iap:(NSDictionary *)dict
{
    
    // lua回调函数
    int iapRestoreScriptHandler = [[dict objectForKey:@"iapRestoreScriptHandler"] intValue];
    
    int iapRestoreFinishScriptHandler = [[dict objectForKey:@"iapRestoreFinishScriptHandler"] intValue];
    
    GamePayment::getInstance()->pay_iap(iapRestoreScriptHandler, iapRestoreFinishScriptHandler);
}
//----------------app iap 内购--------------------------

/** 打开用户反馈页面 */
+ (void)openFeedbackView
{
    
}
+ (void)startFeedBack
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [mfeedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if ( viewController != nil ) {
            
            //controller = viewController;
            
            viewController.title = @"反馈界面";
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [window.rootViewController presentViewController:nav animated:YES completion:nil];
            static AppController *sharedMyManager = nil;
            sharedMyManager = [[AppController alloc] init];
            
//            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:sharedMyManager action:@selector(actionQuitFeedback:)];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
        else
        {
            //            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            //            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title description:nil
            //                                                                  type:TWMessageBarMessageTypeError];
        }
    }];
    
}
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:Feedback_AppKey appSecret:Feedback_AppSecret];
    }
    return _feedbackKit;
}

+ (NSString *)getLocAddres{
    
    if ( !locationManager )
    {
        locationManager = [[AMapLocationManager alloc] init];
    }
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //   定位超时时间，最低2s，此处设置为10s
    locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    locationManager.reGeocodeTimeout = 2;
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                _localAddres = @"";
                NSLog(@"_localAddres: %@", _localAddres);
                return;
            }
        }
        
        if (regeocode)
        {
            _localAddres = [[NSString alloc] initWithString:regeocode.formattedAddress ];
            NSLog(@"_localAddres: %@", _localAddres);
        }
        
        if (location)
        {
            
            NSString* loc = [NSString stringWithFormat:@"%f_%f", location.coordinate.latitude, location.coordinate.longitude];
            NSString* loca = [[NSString alloc] initWithString:loc];
            
            [self setLocation:loca];
        }
        
    }];
    
    NSLog(@"_localAddres: %@", _localAddres);
    return _localAddres;
}

+ (NSString*) getLocation
{
    return _locationUser;
}

+ (void) setLocation:(NSString *)location
{
    _locationUser = location;
}

+ (float) getDisByTwoPoint:(NSDictionary *)dict
{
    float location1LA = [[dict objectForKey:@"location1LA"] floatValue];
    float location1LT = [[dict objectForKey:@"location1LT"] floatValue];
    float location2LA = [[dict objectForKey:@"location2LA"] floatValue];
    float location2LT = [[dict objectForKey:@"location2LT"] floatValue];
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location1LA,location1LT));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location2LA,location2LT));
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    return distance;
}

+ (BOOL)isWeiboAppInstalled
{
    CCLOG("AppController isWeiboAppInstalled");
//    return [WeiboSDK isWeiboAppInstalled];
    NSString *url = [NSString stringWithFormat:@"sinaweibo://wb%@",wbAppKey];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];//@"wbxxxxxxxx://"
}

+ (void)shareToWeiBo:(NSDictionary *)dict
{
    NSString *shareType = [dict objectForKey:@"shareType"]; // 1 文本  2 链接  3 图片
    
    // lua回调函数
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    
    WBMessageObject *message = [WBMessageObject message];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = wbRedirectURI;
    authRequest.scope = @"all";
    
    if ([shareType isEqual:@"text"])
    {
        // 文本
        NSString *text = [dict objectForKey:@"title"];
        NSString *desc = [dict objectForKey:@"description"];
        NSString *showText = @"";
        if ([desc isEqual:@""])
        {
            showText = text;
        }
        else
        {
            showText = [NSString stringWithFormat:@"%@\n%@" , text , desc];
        }
        
        message.text = showText;
    }
    else if ([shareType isEqual:@"link"])
    {
        //链接
        NSString *url = [dict objectForKey:@"url"];
        NSString *title = [dict objectForKey:@"title"];
        NSString *desc = [dict objectForKey:@"description"];
        NSString *filePath = [dict objectForKey:@"imgFilePath"];
        
        NSString* showText = @"";
        
        if ([desc isEqual:@""])
        {
            showText = [NSString stringWithFormat:@"%@%@", title ,url];
        }
        else
        {
            showText = [NSString stringWithFormat:@"%@\n%@%@" , title , desc,url];
        }
        
        message.text = showText;
        
        //        WBImageObject *image = [WBImageObject object];
        //        image.imageData = [NSData dataWithContentsOfFile:filePath];
        //        message.imageObject = image;
        
    }
    else if ([shareType isEqual:@"image"])
    {
        //图片
        NSString *filePath = [dict objectForKey:@"imgFilePath"];
        
        WBImageObject *image = [WBImageObject object];
        image.imageData = [NSData dataWithContentsOfFile:filePath];
        message.imageObject = image;
    }
    
    WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}

//----------------新浪微博分享--------------------------
#pragma mark -
#pragma mark WeiBo

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        //statusCode  0 成功  1 取消发送
        
        if(_authCodeScriptHandler) {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([[NSString stringWithFormat:@"%i",(int)response.statusCode] UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
        
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //statusCode  0 成功  1 取消发送
        
        if(_authCodeScriptHandler) {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([[NSString stringWithFormat:@"%i",(int)response.statusCode] UTF8String]);
            stack->executeFunction(1);
            
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
        
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

/*! @brief 检查支付宝是否已被用户安装
 *
 * @return 支付宝已安装返回YES，未安装返回NO。
 */
+(BOOL) isAPAppInstalled
{
    return [APOpenAPI isAPAppInstalled];
}



/*! @brief 判断当前支付宝的版本是否支持OpenApi
 *
 * @return 支持返回YES，不支持返回NO。
 */
+(BOOL) isAPAppSupportOpenApi
{
    return [APOpenAPI isAPAppSupportOpenApi];
}


/*! @brief 判断当前支付宝的版本是否支持分享到生活圈
 *
 * @return 支持返回YES，不支持返回NO。
 */
+(BOOL) isAPAppSupportShareTimeLine
{
    return [APOpenAPI isAPAppSupportShareTimeLine];
}

+ (NSString*)getPastBordContext{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    return pasteboard.string;
}

#pragma mark NativeShare
+ (void)openNativeShare:(NSDictionary*)dict
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;
    
    NSString *url = [dict objectForKey:@"url"];
    NSURL *urlToShare = [NSURL URLWithString:url];
    
    NSString *textToShare = [dict objectForKey:@"description"];
    
    UIImage *imageToShare = [UIImage imageNamed:@"icon.png"];
    NSData *compressData = UIImageJPEGRepresentation(imageToShare, 0.5);
    UIImage *image = [UIImage imageWithData:compressData];
    NSArray *activityItems= @[textToShare,urlToShare,image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToVimeo ];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化Block回调方法,此回调方法是在iOS8之后出的，代替了之前的方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            // 0 成功 1 取消
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
                cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
                cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
                stack->pushString([activityType UTF8String]);
                stack->executeFunction(1);
                
                cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
                _authCodeScriptHandler = 0;
            }
            else
            {
                cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
                cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
                stack->pushString([@"cancel" UTF8String]);
                stack->executeFunction(1);
                
                cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
                _authCodeScriptHandler = 0;
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        //此Block回调方法在iOS8.0之后就弃用了，被上面的所取代
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
                cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
                stack->pushString([activityType UTF8String]);
                stack->executeFunction(1);
                
                cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
                _authCodeScriptHandler = 0;
            }
            else
            {
                cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
                cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
                stack->pushString([@"cancel" UTF8String]);
                stack->executeFunction(1);
                
                cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
                _authCodeScriptHandler = 0;
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    }
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        pop.popoverContentSize = CGSizeMake(320, 480);
        [pop presentPopoverFromRect:CGRectMake(0, 0, 0, 720) inView:window.rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else
    {
        [window.rootViewController presentViewController:activityVC animated:YES completion:nil];
    }
    
}

//没有中间页（只能分享图片）
+ (void)openNativeShareImageToWX:(NSDictionary*)dict
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    int scriptHandler = [[dict objectForKey:@"scriptHandler"] intValue];
    if (_authCodeScriptHandler)
    {
        cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
    }
    _authCodeScriptHandler = scriptHandler;

    NSString *imgFilePath = [dict objectForKey:@"imgFilePath"];
    UIImage *imageToShare = [UIImage imageNamed:imgFilePath];

    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:@"com.tencent.xin.sharetimeline"];
    if (nil == composeVC){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装软件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        [self shareImageToWX:dict];
        return;
    }
    // 添加要分享的图片
    [composeVC addImage:(UIImage *)imageToShare];
    // 弹出分享控制器
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([@"0" UTF8String]);
            stack->executeFunction(1);

            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;

        }
        else if (result == SLComposeViewControllerResultCancelled)
        {
            cocos2d::LuaBridge::pushLuaFunctionById(_authCodeScriptHandler);
            cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
            stack->pushString([@"cancel" UTF8String]);
            stack->executeFunction(1);
            cocos2d::LuaBridge::releaseLuaFunctionById(_authCodeScriptHandler);
            _authCodeScriptHandler = 0;
        }
    };
    [window.rootViewController presentViewController:composeVC animated:YES completion:nil];
}


//(NSDictionary *)url
//+(BOOL)isExistMethod:(NSString*)methodName
+(BOOL)isExistMethod:(NSDictionary*)methodName
{
    NSString *str = [methodName objectForKey:@"methodName"];
    SEL selector = NSSelectorFromString(str);
    if([self respondsToSelector:selector])
    {
        return YES;
    }
    else{
        return NO;
    }
}

@end

