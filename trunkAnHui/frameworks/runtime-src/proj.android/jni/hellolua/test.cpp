/*
 * test.cpp
 *
 *  Created on: 2014-10-29
 *      Author: chen
 */

#include "test.h"
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"
//#include "../../../Classes/JniTest.h"
#include <jni.h>
#include "../../audio/VoiceManager.hpp"

#define CLASS_NAME "org/cocos2dx/cpp/JniTestHelper"
using namespace cocos2d;
extern "C"
{

	void Java_org_cocos2dx_lua_JniTestHelper_startCallBack(JNIEnv* env)
	{
		VoiceManager *manager = VoiceManager::GetInstance();
//    	manager->startRecord();
	}
	
	//开始录音
	void Java_org_cocos2dx_lua_JniTestHelper_startVoice(JNIEnv* env)
	{
		VoiceManager *manager = VoiceManager::GetInstance();
    	//manager->startRecord();
	}

//	//取消录音
	void Java_org_cocos2dx_lua_JniTestHelper_cancelVoice(JNIEnv* env)
	{
		VoiceManager *manager = VoiceManager::GetInstance();
    	//manager->cancelRecord();
	}

//	//获取播放的url
	jstring Java_org_cocos2dx_lua_JniTestHelper_getVoiceUrl()
	{
		 JNIEnv * env = 0;
		 VoiceManager *manager = VoiceManager::GetInstance();

		 if (JniHelper::getJavaVM()->GetEnv((void**)&env, JNI_VERSION_1_4) != JNI_OK || ! env) {
			 return 0;
		 }
		 std::string pszText = manager->getAudioUrl();
		 return env->NewStringUTF(pszText.c_str());
	}


}























