//
//  FilesSystem.h
//  FilesSystem 文件系统 读取保存基本的文件
//
//  Created by Mr.Yu on 11/28/12.
//  Copyright (c) ...
//


#ifndef _FILESSYSTEM_H_
#define _FILESSYSTEM_H_

#include "PLTCryptoAes.h"

class FilesSystem
{
public:

    // 文件的平铺函数
	static std::string FilePath( const std::string& filepath );

    // 设置解密的key
	static void SetEncryptKey( const std::string& key );
	// 解密函数 返回值表示解密后的长度
	static unsigned int Decrpy( unsigned char *source, unsigned int sourcelength );

	static void AddPathMD5Filter( const std::string& filter ) { pathmd5filter.push_back(filter); }
	static void ClearPathMD5Filter() { pathmd5filter.clear(); }

protected:
	static std::list<std::string> pathmd5filter;	// 路径平铺时 过滤掉路径中
	static Palantir::CryptoAes encypto;		// 解密对象
};


#endif
