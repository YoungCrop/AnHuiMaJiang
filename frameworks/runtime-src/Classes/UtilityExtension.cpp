//
//  UtilityExtension.cpp
//  mahjonghn
//
//  Created by Developer on 16/3/7.
//
//

#include "UtilityExtension.h"

#include "network/HttpClient.h"
#include "MD5.h"

using namespace cocos2d;
using namespace cocos2d::network;

static UtilityExtension *s_sharedUtilityExtension = nullptr;

UtilityExtension::UtilityExtension()
{}

UtilityExtension::~UtilityExtension()
{}

UtilityExtension* UtilityExtension::getInstance()
{
	if (s_sharedUtilityExtension == nullptr)
	{
		s_sharedUtilityExtension = new (std::nothrow) UtilityExtension();
		if (!s_sharedUtilityExtension)
		{
			CC_SAFE_DELETE(s_sharedUtilityExtension);
		}
	}
	return s_sharedUtilityExtension;
}

void UtilityExtension::destroyInstance()
{
	CC_SAFE_RELEASE_NULL(s_sharedUtilityExtension);
}

void UtilityExtension::httpDownloadImage(const char* imgURL, int uid)
{
    string urlStr(imgURL);
    std::string str = UtilityExtension::generateMD5(urlStr.c_str(), (int)urlStr.size());
    
	HttpRequest* request = new (std::nothrow) HttpRequest();
//    request->setTag(str.c_str());
    char uidString[32];
    sprintf(uidString, "%d", uid);
    request->setTag(uidString);
	CCLOG("httpDownloadImage imgURL:[%s] uidString:[%d]", imgURL, uid);
	request->setUrl(imgURL);
	request->setRequestType(HttpRequest::Type::GET);
	request->setResponseCallback([](HttpClient* client, HttpResponse* response) -> void{
		if (!response) {
			return;
		}

		if (!response->isSucceed()) {
			CCLOG("httpDownloadImage error buffer: %s", response->getErrorBuffer());
			return;
		}
        
        std::vector<char> *buffer = response->getResponseData();
        CCLOG("httpDownloadImage buffer size:[%lu]", buffer->size());

        std::string buff(buffer->begin(),buffer->end());
        const char* tag = response->getHttpRequest()->getTag();
        CCLOG("httpDownloadImage tag:%s", tag);
        std::string fileName  = FileUtils::getInstance()->getWritablePath();
        fileName = fileName + "head_img_" + tag + ".png";
        FILE *fp = fopen(fileName.c_str(),"wb+");
        fwrite(buff.c_str(),1,buffer->size(),fp);
        fclose(fp);
	});
	HttpClient::getInstance()->sendImmediate(request);
	request->release();
}

std::string UtilityExtension::generateMD5(const char* buffer, int bufferLen)
{
	std::string catStr = std::string(buffer, bufferLen);
	catStr = catStr + "3c6e0b8a9c15224a8228b9a98ca1531d";

	auto md5 = new CMD5();
	std::string keyStr = md5->GenerateMD5(catStr.c_str(), (int)catStr.length());
	delete(md5);

	return keyStr;
}


