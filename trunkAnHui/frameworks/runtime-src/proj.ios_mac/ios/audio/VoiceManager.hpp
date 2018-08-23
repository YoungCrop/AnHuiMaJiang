//
//  VoiceManager.hpp
//  MyCppGame
//
//  Created by wangxin on 15/12/1.
//
//

#ifndef VoiceManager_hpp
#define VoiceManager_hpp

#include <stdio.h>
#include <string>
#include <sstream>
#include <iostream>

#include "RTChatSdk.h"

using namespace rtchatsdk;

class VoiceManager {
    
private:
    std::string audioUrl;
    static VoiceManager *m_pInstance;
public:
    VoiceManager();
    virtual ~VoiceManager();
    
    void callBack(SdkResponseCmd cmdType, SdkErrorCode error, const std::string& msgStr);
    
    void startRecord();
    
    void stopRecord();
    
    void cancelRecord();
    
    void startPlay(std::string playerUrl);
    
    std::string getVoiceUrl();
    

public:
    static VoiceManager * GetInstance();
    
};

#endif /* VoiceManager_hpp */
