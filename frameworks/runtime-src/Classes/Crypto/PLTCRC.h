/* 
============================================================================================
	crc算法接口

	add 2015.7.30 by yuwf

	Copyright (c), ...	

=============================================================================================
*/

#ifndef	_PALANTIR_CRC_H
#define	_PALANTIR_CRC_H

#include <string>

namespace Palantir
{
	class CRC
	{
	public:
		static unsigned char CRC8( const void* buf, unsigned int len );

		static unsigned short CRC16( const void* buf, unsigned int len );

		static unsigned int CRC32( const void* buf, unsigned int len );

		static std::string GetMD5( const void* buf, unsigned int len );

		static std::string GetMD5( const std::string& filepath );
	};

}

#endif