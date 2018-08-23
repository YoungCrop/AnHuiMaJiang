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

#import "WXApi.h"
//高德sdk
#import<AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

//支付宝分享
#import "APOpenAPI.h"

#import "WeiboSDK.h"

#import <TencentOpenAPI/QQApiInterface.h>
@class RootViewController;
@interface AppController : NSObject <UIApplicationDelegate, WXApiDelegate,QQApiInterfaceDelegate,WeiboSDKDelegate,AMapLocationManagerDelegate >
{
    UIWindow *window;
    RootViewController *viewController;
}

+ (BOOL)isWXAppInstalled;
+ (void)sendAuthRequest:(NSDictionary *)dict;

+ (void)shareImageToWX:(NSDictionary *)dict;
+ (void)shareURLToWX:(NSDictionary *)dict;

+ (NSString *)getOpenUDID;
+ (NSString *)getLocAddres;
+ (NSString *)getVersionName;

+ (NSString *)getDeviceBattery;

//获取信号状态
+ (NSString *)getDeviceSignalStatus;

//获取信号强度
+ (NSString *)getDeviceSignalLevel;


#if !TARGET_IPHONE_SIMULATOR
+ (void)createYayaSDK:(NSDictionary *)sdkContent;
+ (void)loginYayaSDK:(NSDictionary *)loginContent;
+ (void)startVoice:(NSDictionary *)recodePath;
+ (void)stopVoice;
+ (void)cancelVoice;
+ (NSString *)getVoiceUrl;
+ (void)playVoice:(NSDictionary *)url;
#endif

//----------------app iap 内购--------------------------
// 请求商品信息
+ (void) req_iap:(NSDictionary *)dict;

// 购买请求
+ (void) pay_iap:(NSDictionary *)dict;

// 恢复购买
+ (void) restore_iap:(NSDictionary *)dict;

//----------------app iap 内购--------------------------

//----------------app 用户反馈--------------------------
//@property (nonatomic, strong) YWFeedbackKit * feedbackKit;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
+ (void)openFeedbackView ;
+ (void)startFeedBack ;

//----------------app 用户反馈--------------------------

+ (void)copyText:(NSDictionary *)dict;

+ (NSString *)getRoomID;
+ (void)clearRoomID;
@end

