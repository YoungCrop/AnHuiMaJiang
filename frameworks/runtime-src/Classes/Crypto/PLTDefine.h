/*
============================================================================================
	定义一些常用宏和变量

	add 2013.11.22 by yuwf

	Copyright (c), ...

=============================================================================================
*/

#ifndef	_PALANTIR_DEFINE_H
#define	_PALANTIR_DEFINE_H

#include "PLTConfig.h"

#ifdef PLT_OS_WIN
// windows下有个变态的包含错误 下面必须先包含winsock2 再包含winsock 或者写预定义WIN32_LEAN_AND_MEAN宏也可以解决问题
#include <WinSock2.h>
#include <winsock.h>
#pragma warning(disable:4996)	// 关闭这个字符串格式化不安去警告
#include <windows.h>
#else
#include <unistd.h>
#include <stdint.h>
#endif

#if defined(PLT_CTR_MEM)
#ifndef _CRTDBG_MAP_ALLOC
#define _CRTDBG_MAP_ALLOC
#endif
#include <stdlib.h>
#include <crtdbg.h>
#define new new( _NORMAL_BLOCK, __FILE__, __LINE__)
#pragma warning(disable:4345)
#endif

namespace Palantir
{

#ifdef PLT_OS_WIN
	//typedef unsigned char		uchar;
	typedef unsigned char		uint8;
	typedef	  signed char		int8;

	typedef unsigned short		uint16;
	typedef	  signed short		int16;

	typedef unsigned int		uint;
	typedef unsigned int		uint32;
	typedef	  signed int		int32;

	typedef unsigned __int64	uint64;
	typedef   signed __int64	int64;

#else
	typedef unsigned char		uchar;
	typedef unsigned char		uint8;
	typedef	  signed char		int8;

	typedef unsigned short		uint16;
	typedef	  signed short		int16;

    typedef unsigned int		uint;
	typedef unsigned int		uint32;
	typedef	  signed int		int32;

	typedef unsigned long long	uint64 __attribute__ ((aligned(8)));
	typedef long long			int64 __attribute__ ((aligned(8)));

	typedef unsigned long       DWORD;
	typedef unsigned char       BYTE;
	typedef unsigned short      WORD;

#endif

	// 取64位变量的低32位和高32位
#define LOUINT64(l) ((uint32)(l))
#define HIUINT64(l) ((uint32)(((uint64)(l)>>32)&0xFFFFFFFF))

	// 将2个32位变量分别作为高低32位合成64位变量
#define UINT32TOUINT64(h, l) (((uint64)(h)<<32)|(l))

#ifndef U32_MAX
#define U64_MAX					(0xFFFFFFFFFFFFFFFFULL)
#define U32_MAX					(0xFFFFFFFF)
#define U16_MAX					(0xFFFF)
#define U8_MAX					(0xFF)
#define I64_MAX					(9223372036854775807)
#define I32_MAX					(2147483647)
#define I16_MAX					(32767)
#define I8_MAX					(127)
#define I64_MIN					(-9223372036854775807 - 1)
#define I32_MIN					(-2147483648)
#define I16_MIN					(-32768)
#define I8_MIN					(-128)
#endif

#ifndef MAX_PATH
#define MAX_PATH				(260)
#endif

#ifndef _MAX_DRIVE
#define _MAX_DRIVE  3   /* max. length of drive component */
#endif

#ifndef _MAX_DIR
#define _MAX_DIR    256 /* max. length of path component */
#endif

#ifndef _MAX_FNAME
#define _MAX_FNAME  256 /* max. length of file name component */
#endif

#ifndef _MAX_EXT
#define _MAX_EXT    256 /* max. length of extension component */
#endif

#define FALSE_RST(x)				{if (!(x)) return false;}

#ifndef MAX
#define MAX(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef MIN
#define MIN(a,b)            (((a) < (b)) ? (a) : (b))
#endif

#define PI       3.14159265358979323846f

	union var
	{
		float			f;
		int				i;
		unsigned int	u;
		char*			s;
		void*			p;
	};

#define SAFE_FREE(x)			{if((x) != 0){ free(x); (x) = 0; }}
#define SAFE_DELETE(x)			{if((x) != 0){ delete (x); (x) = 0; }}
#define SAFE_DELETE_ARRAY(x)	{if((x) != 0){ delete [] (x); (x) = 0; }}
#define SAFE_RELEASE(x)			{if((x) != 0){ (x)->release(); (x) = 0; }}
#define SAFE_ASSIGN(left,right)			{if((left) != 0){ left = right; }}

#define ClassName(classname) #classname
#define BoolDesc(b) (b ? "true": "false")
#define ConditionCall( b, truecommand, falsecommand ) \
	if ( b )	\
	{	\
		truecommand;	\
	}	\
	else	\
	{	\
		falsecommand;	\
	}

#define EPSINON 0.000001f
#define FloatIsEqual( a, b ) ( fabs((a)-(b)) < EPSINON )

}

#endif
