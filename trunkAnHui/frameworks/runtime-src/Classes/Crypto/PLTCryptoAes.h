/* 
============================================================================================
	aes加密接口

	add 2013.11.22 by yuwf

	Copyright (c), ...	

=============================================================================================
*/

#ifndef	_PALANTIR_CRYPTOAES_H
#define	_PALANTIR_CRYPTOAES_H

#include <string>

namespace Palantir
{
	struct CryptoAes
	{
		enum KeyType
		{
			Type128 = 128,
			Type192 = 192,
			Type256 = 256,
		};

		CryptoAes();
		~CryptoAes();

		bool Init( KeyType type, const std::string& key );

		//************************************
		// Method:									AES 加密和解密
		// Access:    public static 
		// Returns:   void
		// Qualifier:
		// Parameter: unsigned char * source		计算对象		长度必须为16个字节 AES_BLOCK_SIZE
		// Parameter: unsigned char * dest			存储对象		长度必须为16个字节 AES_BLOCK_SIZE
		// Parameter: const AesKey&	key				秘钥
		//************************************
		void Encrypt( unsigned char *source, unsigned char* dest );

		void Decrypt( unsigned char *source, unsigned char* dest );

		//************************************
		// Method:									AES 对在数据buffer上进行加密解密
		// Access:    public static 
		// Returns:   void
		// Qualifier:
		// Parameter: unsigned char * buffer		操作的buffer
		// Parameter: unsigned int buffersize		buffer的长度
		// Parameter: const AesKey&	key				秘钥
		//************************************
		void Encrypt( unsigned char *buffer, unsigned int buffersize );

		void Decrypt( unsigned char *buffer, unsigned int buffersize );

		//************************************
		// Method:									AES 加密和解密
		// Access:    public static 
		// Returns:   void
		// Qualifier:
		// Parameter: unsigned char * source		计算对象
		// Parameter: unsigned char * dest			存储对象 它的大小不能小于source的大小
		// Parameter: unsigned int  size			buffer的长度
		// Parameter: const AesKey&	key				秘钥
		//************************************
		void Encrypt( unsigned char *source, unsigned char* dest, unsigned int size );

		void Decrypt( unsigned char *source, unsigned char* dest, unsigned int size );

	private:
		// 禁止拷贝构造和拷贝
		CryptoAes( const CryptoAes& ) {};
		CryptoAes& operator = ( const CryptoAes& ) { return *this; };

		char* encrypt;
		char* decrypt;
	};

}

#endif