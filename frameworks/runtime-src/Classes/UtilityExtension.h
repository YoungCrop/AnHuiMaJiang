//
//  UtilityExtension.hpp
//  mahjonghn
//
//  Created by Developer on 16/3/7.
//
//

#ifndef UtilityExtension_hpp
#define UtilityExtension_hpp

#include "cocos2d.h"

class UtilityExtension : public cocos2d::Ref {
public:
	UtilityExtension();
	virtual ~UtilityExtension();
	
	static UtilityExtension* getInstance();
	static void destroyInstance();
	
    static void httpDownloadImage(const char* url, int uid);
	static std::string generateMD5(const char* buffer, int bufferLen);
};

#endif /* UtilityExtension_hpp */
