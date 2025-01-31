//
//  RTChatSdk.h
//  RTChat
//
//  Created by raymon_wang on 14-7-29.
//  Copyright (c) 2014年 yunwei. All rights reserved.
//

#ifndef RTChat_RTChatSdkAndroidIpml_h
#define RTChat_RTChatSdkAndroidIpml_h

#include "RTChatCommonTypes.h"
#include <strings.h>
#include <string>
#include <jni.h>
#include <functional>

namespace rtchatsdk {

    typedef std::function<void (SdkResponseCmd cmdType, SdkErrorCode error, const std::string& msgStr)> pMsgCallFunc;

    class RTChatSDKMain {
    public:
        static RTChatSDKMain& sharedInstance();
        
        //sdk初始化，只能调用一次(主线程)
        SdkErrorCode initSDK(const std::string& appid, const std::string& key, const char* uniqueid = NULL);
        
        //注册消息回调(主线程)
        void registerMsgCallback(const pMsgCallFunc& func);
        
        //获取SDK当前操作状态，用户发起操作前可以检测一下状态判断可否继续
        SdkOpState getSdkState();

        /// 设置自定义参数
        void setParams(const std::string& voiceUploadUrl, const char* xunfeiAppID);
        
        /// 开始录制麦克风数据(主线程)
        bool startRecordVoice(unsigned int labelid,bool bte=false);
        
        /// 停止录制麦克风数据(主线程)
        bool stopRecordVoice();
        
        /// 开始播放录制数据(主线程)
        bool startPlayLocalVoice(unsigned int labelid, const char* voiceUrl);
        
        /// 停止当前播放录制数据()
        bool stopPlayLocalVoice();

            //设置头像
        bool setAvater(unsigned int uid,int type);

        //获取头像
        bool getAvater(unsigned int uid,int type,const char* imageUrl);

            /// 取消当前录音
        bool cancelRecordedVoice();
        
        ///开始语音识别
        bool startVoiceToText();
        
        ///停止语音识别
        bool stopVoiceToText();
        
        ///开始GPS定位获取地理位置
        bool startQueryGeoInfo();

        public:
        pMsgCallFunc        callbackfunc;          //回调函数
        uint64_t convertJstring2Uint64(jstring longstring);
    private:
        jobject GetEVOEObject();

    };
    
}
#endif
