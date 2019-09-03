//
//  FilesSystem.cpp
//  
//
//  Created by Mr.Yu on 11/28/12.
//  Copyright (c) ...
//

#include "cocos2d.h"
using namespace cocos2d;
#include "FilesSystem.h"
#include "PLTCRC.h"
#include "PLTFileEx.h"

#include "platform/CCPlatformConfig.h"



using namespace Palantir;

struct CryptoInfo
{
	int flag;			// 标示
	int type;			// 加密类型
	int reserved1;		// 预留
	int reserved2;		// 预留
	enum
	{
		Crypto_Flag = 21 << 16 | 1,			// 标示 版本
		Crypto_Type_AES128	= 2 << 16 | 1,	// 算法 子算法
	};

	CryptoInfo()
		: flag( Crypto_Flag )
		, type( Crypto_Type_AES128 )
		, reserved1(0)
		, reserved2(0)
	{
	}
} cryptoinfoobj;


std::list<std::string> FilesSystem::pathmd5filter;
Palantir::CryptoAes FilesSystem::encypto;

struct GlobalFile
{
    GlobalFile()
    {
		// 设置加密秘钥
        FilesSystem::SetEncryptKey( "ncmj@1235" );
		// 设置读文件的回调

        FileUtils::filepathfun = (FileUtils::FilePathFun*)FilesSystem::FilePath;
      FileUtils::decrpyfun = (FileUtils::DecrpyFun*)FilesSystem::Decrpy;

    }
};

static GlobalFile _globalfile;

std::string FilesSystem::FilePath( const std::string& filepath_ )
{
	// 格式化路径
	char path[MAX_PATH];
	Palantir::FileEx::Verify_Path( path, filepath_.c_str(), MAX_PATH );
	std::string filepath = path;

	// 是否含有过滤字样
	std::list<std::string>::iterator filterit = pathmd5filter.begin();
	std::list<std::string>::iterator filterend = pathmd5filter.end();
	for ( ; filterit != filterend; ++filterit )
	{
		if ( filepath.find( *filterit ) != std::string::npos )
		{
			return filepath;
		}
	}
	static std::string cocosresroot = FileUtils::getInstance()->getDefaultResourceRootPath();
	static std::string resroot;
	if ( resroot.empty() || cocosresroot != FileUtils::getInstance()->getDefaultResourceRootPath() )
	{
		cocosresroot = FileUtils::getInstance()->getDefaultResourceRootPath();
		char out[MAX_PATH];
		Palantir::FileEx::Verify_Path( out, cocosresroot.c_str(), MAX_PATH );
		resroot = out;
	}

	size_t pos = filepath.find(resroot);
	if (pos != std::string::npos)
	{
		std::string filename = filepath.substr( resroot.size() );
		// 过滤 开头为./ 和 /./
		if ( filename.size() >= 2 && filename[0] == '.' && filename[1] == '/' )
		{
			filename = filename.substr( 2 );
		}
		std::string::size_type pos = filename.find( "/./" );
		while ( pos != std::string::npos )
		{
			filename.replace( pos, strlen("/./"), "/", 1 );
			pos = filename.find( "/./", pos + 1 );
		}

		std::string md5filename = Palantir::CRC::GetMD5( filename.data(), (unsigned int)filename.size() );
		//CCLOG( "文件路径MD5平铺 path:%s src:%s tga:%s", resroot.c_str(), filename.c_str(), md5filename.c_str() );
		
        std::string soundPath = "s/";
        
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        
        std::string cryptoresPath = "cryptores/";
        
        if ( filepath_.find( ".mp3" ) != std::string::npos )
        {
            return resroot + cryptoresPath + soundPath + md5filename + ".mp3";
        }

        return resroot + cryptoresPath +  md5filename;
        
#elif  CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        
        if ( filepath_.find( ".mp3" ) != std::string::npos )
        {
            return resroot  + soundPath + md5filename + ".mp3";
        }
        
        return resroot +  md5filename;
#endif
        
        
	}
    //CCLOG( "文件路径没有MD5平铺 %s", filepath.c_str() );
	return filepath_;
}

void FilesSystem::SetEncryptKey( const std::string& key )
{
	encypto.Init( CryptoAes::Type128, key );
}

unsigned int FilesSystem::Decrpy( unsigned char *source, unsigned int sourcelength )
{
	if ( sourcelength < sizeof(CryptoInfo) )
	{
		return sourcelength;
	}
	else
	{
		if( memcmp( &source[sourcelength-sizeof(CryptoInfo)], &cryptoinfoobj, sizeof(CryptoInfo) ) != 0 )
		{
			return sourcelength;
		}
	}

	sourcelength -= sizeof(CryptoInfo);
	encypto.Decrypt( source, sourcelength );
	return sourcelength;
}
