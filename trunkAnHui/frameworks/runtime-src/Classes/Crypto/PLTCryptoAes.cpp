/*
============================================================================================
	aes加密接口

	add 2013.11.22 by yuwf

	Copyright (c), ...

=============================================================================================
*/

#include "PLTCryptoAes.h"
#include "crypto/AES/aes.h"
#include <memory.h>

namespace Palantir
{
	CryptoAes::CryptoAes()
	{
		encrypt = new char[sizeof(AES_KEY)];
		decrypt = new char[sizeof(AES_KEY)];
	}

	CryptoAes::~CryptoAes()
	{
		delete [] encrypt;
		delete [] decrypt;
		encrypt = nullptr;
		decrypt = nullptr;
	}

	bool CryptoAes::Init( KeyType type, const std::string& key )
	{
		if ( !( type == Type128 || type == Type192 || type == Type256 ) )
		{
			return false;
		}
		int charlen = type/8;
		unsigned char* keybuffer = new unsigned char[charlen];
		memset( keybuffer, 0, charlen );
		if ( key.size() != 0 )
		{
			memcpy( keybuffer, &key[0], (unsigned int)charlen > key.size() ? key.size() : charlen );
		}
		private_AES_set_encrypt_key( keybuffer, type, (AES_KEY*)encrypt );
		private_AES_set_decrypt_key( keybuffer, type, (AES_KEY*)decrypt );
		delete [] keybuffer;
		return true;
	}

	void CryptoAes::Encrypt( unsigned char *source, unsigned char* dest )
	{
		AES_encrypt( source, dest, (const AES_KEY*)encrypt );
	}

	void CryptoAes::Decrypt( unsigned char *source, unsigned char* dest )
	{
		AES_decrypt( source, dest, (const AES_KEY*)decrypt );
	}

	void CryptoAes::Encrypt( unsigned char *source, unsigned int sourcelength )
	{
		unsigned char buffer[AES_BLOCK_SIZE] = {0};
		for(unsigned int i = 0; i + AES_BLOCK_SIZE <= sourcelength; i += AES_BLOCK_SIZE)
		{
			Encrypt( source + i, buffer );
			memcpy( &source[i], buffer, AES_BLOCK_SIZE );
		}
	}

	void CryptoAes::Decrypt( unsigned char *source, unsigned int sourcelength )
	{
		unsigned char buffer[16] = {0};
		for(unsigned int i = 0; i + AES_BLOCK_SIZE <= sourcelength; i += +AES_BLOCK_SIZE)
		{
			Decrypt( source + i, buffer );
			memcpy( &source[i], buffer, AES_BLOCK_SIZE );
		}
	}

	void CryptoAes::Encrypt( unsigned char *source, unsigned char* dest, unsigned int size )
	{
		for(unsigned int i = 0; i + AES_BLOCK_SIZE <= size; i += AES_BLOCK_SIZE)
		{
			Encrypt( source + i, dest + i );
		}
	}

	void CryptoAes::Decrypt( unsigned char *source, unsigned char* dest, unsigned int size )
	{
		for(unsigned int i = 0; i + AES_BLOCK_SIZE <= size; i += +AES_BLOCK_SIZE)
		{
			Decrypt( source + i, dest + i );
		}
	}

}
