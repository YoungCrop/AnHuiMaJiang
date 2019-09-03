//
//  VoiceManager.cpp
//  MyCppGame
//
//  Created by wangxin on 15/12/1.
//
//



#include "VoiceManager.hpp"

VoiceManager* VoiceManager::m_pInstance = NULL;
VoiceManager* VoiceManager::GetInstance()
{
    if(m_pInstance == NULL)
        m_pInstance = new VoiceManager();
    return m_pInstance;
}

VoiceManager::VoiceManager()
{
    RTChatSDKMain::sharedInstance().initSDK("", "");
    RTChatSDKMain::sharedInstance().registerMsgCallback(std::bind(&VoiceManager::callBack, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3));
#ifdef __APPLE__
    RTChatSDKMain::sharedInstance().setParams("https://www.ixianlai.top/wangpan.php", "");
#else
    RTChatSDKMain::sharedInstance().setParams("https://www.ixianlai.top/wangpan.php", "");
#endif
}

VoiceManager::~VoiceManager()
{
    
}

void VoiceManager::callBack(SdkResponseCmd cmdType, SdkErrorCode error, const std::string& msgStr)
{
    if (error == !OPERATION_OK) {
        return;
    }
    switch (cmdType) {
        case enRequestRec:
            audioUrl = msgStr;
 //           CCLOG("recordurl = %s", msgStr);
            break;
        default:
            break;
    }
}

void VoiceManager::startRecord()
{
    audioUrl = "";
    RTChatSDKMain::sharedInstance().startRecordVoice(1);
    printf("startRecord................++++++++");
}

std::string VoiceManager::getVoiceUrl()
{
    return audioUrl;
}

void VoiceManager::cancelRecord()
{
    audioUrl = "";
    RTChatSDKMain::sharedInstance().cancelRecordedVoice();
}

void VoiceManager::stopRecord()
{
    RTChatSDKMain::sharedInstance().stopRecordVoice();
}

void VoiceManager::startPlay(std::string playerUrl)
{
    RTChatSDKMain::sharedInstance().startPlayLocalVoice(1, playerUrl.c_str());
    
}

