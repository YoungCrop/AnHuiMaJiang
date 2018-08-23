//
//  VoiceManager.cpp
//  MyCppGame
//
//  Created by wangxin on 15/12/1.
//
//



#include "VoiceManager.hpp"
#include "cocos2d.h"
using namespace cocos2d;

VoiceManager* VoiceManager::m_pInstance = NULL;
VoiceManager* VoiceManager::GetInstance()
{
    if(m_pInstance == NULL)
        m_pInstance = new VoiceManager();
    return m_pInstance;
}

VoiceManager::VoiceManager()
{
	// CCLOG("==============qqqqqqq");
 //    // RTChatSDKMain::sharedInstance().initSDK("", "");
 //    CCLOG("==============qqqqqqq000");
    RTChatSDKMain::sharedInstance().registerMsgCallback(std::bind(&VoiceManager::callBack, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));
// #ifdef __APPLE__
//    CCLOG("==============qqqqqqq111");
//    // RTChatSDKMain::sharedInstance().setParams("http://sdk.audio.mztgame.com/wangpan.php", "54acafe7");
// #else
//    CCLOG("==============qqqqqqq22");
//    // RTChatSDKMain::sharedInstance().setParams("http://sdk.audio.mztgame.com/wangpan.php", "566503f0");
// #endif
}

VoiceManager::~VoiceManager()
{
    
}

void VoiceManager::callBack(SdkResponseCmd cmdType, SdkErrorCode error, const std::string& msgStr)
{
	CCLOG("recordurl 1111111111111222= %d======%d",error,cmdType);
    if (error == !OPERATION_OK) {
    	CCLOG("recordurl 1111111111111333= %d======%d",error,cmdType);
        return;
    }

    switch (cmdType) {
        case enRequestRec:
            audioUrl = msgStr;
            CCLOG("recordurl 111111111111444= %s", msgStr.c_str());
//            printf("recordurl = %s", msgStr);
            break;
        default:
        	CCLOG("recordurl 111111111111555= %d", cmdType);
            break;
    }
}

void VoiceManager::startRecord()
{
    audioUrl = "";
//    RTChatSDKMain::sharedInstance().startRecordVoice(1);
//    CCLOG("startRecord 222222222= %s","123");
}

std::string VoiceManager::getVoiceUrl()
{
	CCLOG("getVoiceUrl 33333= %s",audioUrl.c_str());
	if(audioUrl.length() == 0 || audioUrl.c_str() == NULL)
	{
		return "";
	}
    return audioUrl;
}

void VoiceManager::cancelRecord()
{
    audioUrl = "";
//    RTChatSDKMain::sharedInstance().cancelRecordedVoice();
}

void VoiceManager::stopRecord()
{
	CCLOG("stopRecord 4444444444= %s","123");
    RTChatSDKMain::sharedInstance().stopRecordVoice();
}

void VoiceManager::startPlay(std::string playerUrl)
{
    RTChatSDKMain::sharedInstance().startPlayLocalVoice(1, playerUrl.c_str());
    
}

