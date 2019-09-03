
/*
============================================================================================
	Palantir 文件操作接口

	add 2013.11.21 by yuwf

	Copyright (c), ...

=============================================================================================
*/

#include <stdio.h>
#include <sys/stat.h>
#include <memory.h>
#include <string.h>

#include "PLTFileEx.h"

#if defined(PLT_OS_WIN)
#include <io.h>
#include <windows.h>
#include <shlwapi.h>
#include <io.h>
#include <direct.h>
#pragma comment( lib, "shlwapi.lib" )
#pragma warning(disable:4996)	// 关闭这个字符串格式化不安去警告
#else
#include <dirent.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <sys/mman.h>
#endif


namespace Palantir
{
#if defined(PLT_OS_WIN)
#define ACCESS _access
#else
#define ACCESS access
#endif

	const char* Find_Data::fname() const
	{
#ifdef PLT_OS_WIN
		return wfd.cFileName;
#else
		return dinfo->d_name;
#endif
	}

	/* 取父级路径 */
	const char* Find_Data::parent() const
	{
		return path;
	}

	char* Find_Data::fullpath(char *path, size_t len) const
	{
		size_t pathlen = strlen(parent());
		size_t namelen = strlen(fname());
		if (pathlen + namelen >= len)
			return 0;

		memcpy(path, parent(), pathlen);
		memcpy(path + pathlen, fname(), namelen + 1);
		return path;
	}

	bool Find_Data::isdir() const
	{
#ifdef PLT_OS_WIN
		return (wfd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0;
#else
		char path[MAX_PATH];
		if (!fullpath(path, sizeof(path)))
			return false;

		struct stat s;
		if (stat(path, &s) == -1)
			return false;

		return S_ISDIR(s.st_mode);
#endif
	}

	char* FileEx::Get_CWD(char *dir, size_t len)
	{
#ifdef PLT_OS_WIN
		if (0 == GetCurrentDirectoryA((DWORD)len, dir))
			return 0;
		return dir;
#else
		return getcwd(dir, len);
#endif
	}

	void FileEx::Split_Path(const char *fullpath, char *dir, char *fname, char *ext)
	{
		size_t len = strlen(fullpath);
		size_t i;
		size_t dotpos = len;			// 文件名中的点的位置
		size_t namepos = (size_t)(-1);	// 文件名的起始位置
		for (i = len; ; --i)
		{
			if (fullpath[i] == '.')
			{
				if (namepos == (size_t)(-1) && dotpos == len)
					dotpos = i;
			}
			else if (fullpath[i] == '/' || fullpath[i] == '\\')
			{
				if (namepos == (size_t)(-1))
				{
					namepos = i + 1;
					break;
				}
			}

			if(!i)
			{
				break;
			}
		}

		if (ext)
		{
			if (dotpos != len && len - dotpos < _MAX_EXT)
			{
				memcpy(ext, fullpath + dotpos, len - dotpos);
				ext[len - dotpos] = 0;
			}
			else
			{
				ext[0] = 0;
			}
		}

		if (fname)
		{
			if (namepos != (size_t)(-1) && dotpos - namepos < _MAX_FNAME)
			{
				memcpy(fname, fullpath + namepos, dotpos - namepos);
				fname[dotpos - namepos] = 0;
			}
			else
			{
				fname[0] = 0;
			}
		}

		if (dir)
		{
			if (namepos != 0 && namepos < _MAX_DIR)
			{
				memcpy(dir, fullpath, namepos);
				dir[namepos] = 0;
			}
			else
			{
				dir[0] = 0;
			}
		}
	}

	char* FileEx::Verify_Path(char *out, const char *put, size_t len, bool &last_is_split)
	{
		last_is_split = false;

		if (len < 3)
			return 0;

		size_t inlen = strlen(put) + 1;
		if (inlen > len)
			return 0;

		size_t oi = 0;
		for (size_t i = 0; i < inlen; ++i)
		{
			if (put[i] == 0)
			{
				out[oi++] = 0;
				break;
			}

#ifdef PLT_OS_WIN
			if (isleadbyte(put[i]))
#else
			/* TODO:linux 暂时这样识别汉字，别国语言请相应修改 */
			if (put[i] & 0x80)
#endif
			{
				if (put[i + 1] == 0)
				{
					out[oi++] = 0;
					break;
				}
				out[oi++] = put[i++];
				out[oi++] = put[i];
				last_is_split = false;
			}
			else
			{
				if (put[i] == '\\' || put[i] == '/')
				{
					if (!last_is_split)
					{
						out[oi++] = '/';
						last_is_split = true;
					}
				}
				else
				{
					out[oi++] = put[i];
					last_is_split = false;
				}
			}
		}

		if (oi <= 1)
		{
			out[0] = '.';
			out[1] = '/';
			out[2] = 0;
		}
		return out;
	}

	char* FileEx::Verify_Path(char *out, const char *put, size_t len)
	{
		bool last_is_split;
		return Verify_Path(out, put, len, last_is_split);
	}

	char * FileEx::Verify_Dir(char *out, const char *put, size_t len)
	{
		bool last_is_split = false;
		if (!Verify_Path(out, put, len, last_is_split))
			return 0;

		if (!last_is_split)
		{
			size_t last = strlen(out);
			if (last + 1 >= len)
				return 0;

			out[last] = '/';
			out[last + 1] = 0;
		}
		return out;
	}

	bool FileEx::Append_Path(char *path, const char *more)
	{
		if ( !path || !more )
		{
			return false;
		}
#ifdef PLT_OS_WIN
		return !!::PathAppendA(path, more);
#else
		size_t len = strlen(path);
		if ( len > 0 && ( path[len-1] != '\\' || path[len-1] != '/' )    )
		{
			strcat(path, "/");
		}
		strcat(path, more);
		return true;
#endif
	}

    std::string FileEx::Get_CWD()
	{
        char dir[MAX_PATH];
#ifdef PLT_OS_WIN
		if (0 == GetCurrentDirectoryA((DWORD)MAX_PATH, dir))
			return "";
		return std::string(dir);
#else
		return std::string(getcwd(dir, MAX_PATH));
#endif
	}

	bool FileEx::Append_Path(char *path, const char *more, size_t size)
	{
		if (!Verify_Dir(path, path, size))
			return false;

		size_t alen = strlen(more);
		size_t plen = strlen(path);
		if (plen + alen >= size)
			return false;

		memcpy(path + plen, more, alen + 1);
		return true;
	}


	/* 把相对路径变为绝对路径
	* 如 mydir/subdir/.././a 会变成 mydir/a
	* out				:	结果
	* in				:	源路径
	* len				:	out的最大长度
	* 返回值			:	绝对路径 */
	char * FileEx::Full_Path(char *out, const char *put, size_t len)
	{
		char temp_path[MAX_PATH];
		{
			char temp_in[MAX_PATH];
			if (!Verify_Path(temp_in, put, sizeof(temp_in)))
				return 0;

			size_t inlen = strlen(temp_in);
			if (inlen == 0)
			{
				temp_in[0] = '.';
				temp_in[1] = '/';
				temp_in[2] = 0;
				inlen = 2;
			}

			/* linux 起始目录 || windows 起始目录 */
			if (temp_in[0] == '/' || temp_in[1] == ':')
			{
				memcpy(temp_path, temp_in, inlen + 1);
			}
			else
			{
				if (!Get_CWD(temp_path, sizeof(temp_path)))
					return 0;

				if (!Append_Path(temp_path, temp_in, sizeof(temp_path)))
					return 0;
			}

			if (!Verify_Path(temp_path, temp_path, sizeof(temp_path)))
				return 0;
		}

		int numsplits = 0;
		size_t splitposs[1024];
		splitposs[0] = 0;

		size_t inlen = strlen(temp_path) + 1;
		size_t oi = 0;
		for (size_t i = 0; i < inlen && oi < len; ++i)
		{
			if (temp_path[i] == 0)
			{
				out[oi++] = 0;
				break;
			}

#ifdef PLT_OS_WIN
			if (isleadbyte(temp_path[i]))
#else
			/* TODO:linux 暂时这样识别汉字，别国语言请相应修改 */
			if (temp_path[i] & 0x80)
#endif
			{
				if (temp_path[i + 1] == 0)
				{
					out[oi++] = 0;
					break;
				}
				out[oi++] = temp_path[i++];
				out[oi++] = temp_path[i];
			}
			else
			{
				if(temp_path[i] == '/')
				{
					out[oi] = '/';
					splitposs[numsplits] = oi;

					if(out[oi - 1] == '.' && out[oi - 2] == '/')
					{
						oi = splitposs[numsplits - 1];
						oi++;
					}
					else if(out[oi - 1] == '.' && out[oi - 2] == '.' && out[oi - 3] == '/')
					{
						oi = splitposs[numsplits - 2];
						numsplits--;
						oi++;
					}
					else
					{
						oi++;
						numsplits++;
					}
				}
				else
				{
					out[oi++] = temp_path[i];
				}
			}
		}

		if (oi <= 1)
		{
			out[0] = '.';
			out[1] = '/';
			out[2] = 0;
		}
		return out;
	}

	bool FileEx::Is_Exist( const char* filename )
	{
		if ( ACCESS( filename, 0 ) != 0 )
		{
			return false;
		}
		return true;
	}

	bool FileEx::Is_Read( const char* filename )
	{
		if ( !Is_Exist(filename) )
		{
			return false;
		}
		if ( ACCESS( filename, 4 ) != 0 )
		{
			return false;
		}
		return true;
	}

	bool FileEx::Is_Wtrie( const char* filename )
	{
		if ( !Is_Exist(filename) )
		{
			return false;
		}
		if ( ACCESS( filename, 2 ) != 0 )
		{
			return false;
		}
		return true;
	}

	// 获取文件大小
	unsigned int FileEx::Get_File_Size(const char *filepath)
	{
		if(!filepath || filepath[0] == 0) return 0;

		FILE *file = fopen(filepath, "rb");
		if(!file)
			return 0;

		if(fseek(file, 0, SEEK_END) != 0)
			return 0;

		unsigned int filesize = (unsigned int)ftell(file);
		fclose(file);

		return filesize;
	}

	/* 删除一个文件
	* path	:	文件名 */
	bool FileEx::Delete_File(const char *path)
	{
		if (0 == remove(path))
			return true;

#ifdef PLT_OS_WIN
		if (0 != _chmod(path, _S_IWRITE))
			return false;
#else
		if (0 != chmod(path, S_IWUSR))
			return false;
#endif
		return 0 == remove(path);
	}

	/* 创建文件
	*/
	bool FileEx::Create_File(const char* path)
	{
		if(!path)
			return false;

		FILE *file = fopen(path, "wb");
		if(!file)
			return false;

		fclose(file);
		return true;
	}

	bool FileEx::Find_First_File(const char *dir, Find_Data &ffd)
	{
		if (!Verify_Dir(ffd.path, dir, sizeof(ffd.path)))
			return false;

#ifdef PLT_OS_WIN
		char tmpdir[MAX_PATH];
		if (!strncpy(tmpdir, ffd.path, sizeof(tmpdir))
			|| !strncat(tmpdir, "*", sizeof(tmpdir)))
			return false;

		ffd.fh = FindFirstFileA(tmpdir, &ffd.wfd);
		if (ffd.fh == INVALID_HANDLE_VALUE)
			return false;
#else
		ffd.d = opendir(ffd.path);
		if (!ffd.d || !(ffd.dinfo = readdir(ffd.d)))
			return false;
#endif
		return true;
	}

	bool FileEx::Find_Next_File(Find_Data &ffd)
	{
#ifdef PLT_OS_WIN
		return !!FindNextFileA(ffd.fh, &ffd.wfd);
#else
		return (0 != (ffd.dinfo = readdir(ffd.d)));
#endif
	}

	void FileEx::Find_Close(Find_Data &ffd)
	{
#ifdef PLT_OS_WIN
		FindClose(ffd.fh);
		ffd.fh = 0;
#else
		closedir(ffd.d);
		ffd.d = 0;
#endif
	}

	bool FileEx::Is_Dir_Exist(const char *path)
	{
#ifdef PLT_OS_WIN
		return PathIsDirectoryA(path) ? true : false;
#else
		DIR *d = opendir(path);
		if (d)
		{
			closedir(d);
		}
		return (0 != d);
#endif
	}

	bool FileEx::Create_Dir(const char *path, bool breverse)
	{
		if ( !breverse )
		{
#ifdef PLT_OS_WIN
			if (0 != _mkdir(path))
				return false;
#else
			if (0 != mkdir(path, S_IRWXU|S_IRWXG|S_IRWXO))
				return false;
#endif
		}
		else
		{
			char tdir[MAX_PATH];
			char *longdir = 0;
			size_t len = strlen(path);
			if (len >= MAX_PATH)
			{
				longdir = new char [len + 1];
			}
			char *dirbuf = longdir ? longdir : tdir;
			for (size_t i = 1; i <= len; ++i)	// 1 开始
			{
				if ( !(path[i] == '/' || path[i] == '\\' || i == len) )
					continue;

				memcpy(dirbuf, path, i);
				dirbuf[i] = 0;

				if (Is_Dir_Exist(dirbuf))
					continue;

#ifdef PLT_OS_WIN
				if (0 != _mkdir(dirbuf))
					break;
#else
				if (0 != mkdir(dirbuf, S_IRWXU|S_IRWXG|S_IRWXO))
					break;
#endif
			}
			if (longdir)
			{
				delete [] longdir;
			}
			return Is_Dir_Exist(path);
		}
		return true;
	}

	bool FileEx::Delete_Dir(const char *path, bool force)
	{
		if(force)
		{
			Find_Data ffd;
			if (Find_First_File(path, ffd))
			{
				do
				{
					char fname[MAX_PATH];
					if (!ffd.fullpath(fname, sizeof(fname)))
						continue;

					if (ffd.isdir())
					{
						size_t len = strlen(ffd.fname());
						if ((len == strlen(".") && memcmp(ffd.fname(), ".", len) == 0)
							|| (len == strlen("..") && memcmp(ffd.fname(), "..", len) == 0))
							continue;

						Delete_Dir(fname, force);
					}
					else
					{
						Delete_File(fname);
					}
				}
				while (Find_Next_File(ffd));
				Find_Close(ffd);
			}
		}

#ifdef PLT_OS_WIN
		return (0 == _rmdir(path));
#else
		return (0 == rmdir(path));
#endif
	}

	bool FileEx::Delete_Dir_Reverse(const char* path, bool force)
	{
		if(!path)
			return false;

		char temppath[MAX_PATH + 1];
		if(!Verify_Dir(temppath, path, sizeof(temppath)))
			return false;

		int pathlength = (int)strlen(temppath);
		for(int i = pathlength - 1; i >= 0; i--)
		{
			if(temppath[i] != '/')
				continue;

			temppath[i] = 0;

			if(Delete_Dir(temppath, false))
				continue;

			if(force && !Delete_Dir(temppath, true))
				return false;
			else
				return true;
		}
		return true;
	}
}
