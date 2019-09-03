
/* 
============================================================================================
	Palantir 文件操作接口

	add 2013.11.21 by yuwf

	Copyright (c), ...	

=============================================================================================
*/

#ifndef _PALANTIR_FILETEST_H
#define _PALANTIR_FILETEST_H


#include <string>
#include "PLTDefine.h"
#ifdef PLT_OS_WIN
#else
#include <dirent.h>
#endif

namespace Palantir
{

	/* 文件夹遍历数据结构 */
	struct Find_Data
	{
#ifdef PLT_OS_WIN
		WIN32_FIND_DATAA wfd;
		HANDLE fh;
#else
		DIR *d;
		dirent *dinfo;
#endif
		char path[MAX_PATH];

		/* 取元素名称 */
		const char *fname() const;

		/* 取父级路径 */
		const char *parent() const;

		/* 取全路径
		* path		:	结果缓冲区
		* len		:	结果缓冲区长度
		* 返回值	:	成功则返回参数path, 否则返回0 */
		char *fullpath(char *path, size_t len) const;

		/* 查询是否为目录
		* parent_dir	:	父级目录 */
		bool isdir() const;
	};

	class FileEx
	{
	public:
		/* 取当前工作目录
		* dir				:	结果
		* len				:	结果最大长度
		* 返回值			:	成功后返回参数dir, 失败为0 */
		static char* Get_CWD(char *dir, size_t len);
        
        static std::string Get_CWD();

		/* 提取路径,文件名,扩展名
		* 例如:fullpath="d:\abcd/1234.vbnm" 那么 dir="d:\abcd/", fname="1234", ext = ".vbnm"
		* fullpath			:	路径全名
		* dir				:	路径,长度为_MAX_DIR,可以为0
		* fname				:	文件名,长度为_MAX_FNAME,可以为0
		* ext				:	文件扩展名,长度为_MAX_EXT,可以为0 */
		static void Split_Path(const char *fullpath, char *dir, char *fname, char *ext);

		/* 校对路径,使之能用于windows与linux两个系统
		* 如 mydir\\//subdir 会变成 mydir/subdir
		* out				:	校验的结果
		* in				:	源路径
		* len				:	out的最大长度
		* 返回值			:	校验后的结果路径 */
		static char* Verify_Path(char *out, const char *put, size_t len, bool &last_is_split);

		/* 校对路径,使之能用于windows与linux两个系统
		* 如 mydir\\//subdir 会变成 mydir/subdir
		* out				:	校验的结果
		* in				:	源路径
		* len				:	out的最大长度
		* 返回值			:	校验后的结果路径 */
		static char* Verify_Path(char *out, const char *put, size_t len);

		/* 校对目录路径,使之能用于windows与linux两个系统
		* 如 mydir/subdir 会变成 mydir/subdir/
		* out				:	校验的结果
		* in				:	源路径
		* len				:	out的最大长度
		* 返回值			:	校验后的结果路径 */
		static char* Verify_Dir(char *out, const char *put, size_t len);

		/*
		类似PathAppend()函数
		*/
		static bool Append_Path(char *path, const char *more);

		static bool Append_Path(char *path, const char *more, size_t size);


		/* 把相对路径变为绝对路径
		* 如 mydir/subdir/.././a 会变成 mydir/a
		* out				:	结果
		* in				:	源路径
		* len				:	out的最大长度
		* 返回值			:	绝对路径 */
		static char* Full_Path(char *out, const char *put, size_t len);

		// 文件是否存在
		static bool Is_Exist( const char* filename );

		// 文件是否可以读取
		static bool Is_Read( const char* filename );

		// 文件是否可以写入 文件若不存在返回false
		static bool Is_Wtrie( const char* filename );

		// 获取文件大小
		static unsigned int Get_File_Size(const char *filepath);

		/* 删除一个文件
		* path	:	文件名 */
		static bool Delete_File(const char *path);

		/* 创建文件
		*/
		static bool Create_File(const char* path);

		/* 开始目录遍历,取得路径下的第一个元素
		* dir				:	路径
		* ffd				:	结果
		* 返回值			:	成功为真(true),否则为失败 */
		static bool Find_First_File(const char *dir, Find_Data &ffd);

		/* 取得相邻的下一个元素
		* ffd				:	参照物&结果
		* 返回值			:	成功为真(true),否则为失败 */
		static bool Find_Next_File(Find_Data &ffd);

		/* 结束目录遍历
		* ffd				:	参照物&结果 */
		static void Find_Close(Find_Data &ffd);

		/* 目录是否存在
		* path	:	目录名 */
		static bool Is_Dir_Exist(const char *path);

		/* 创建目录,此函数会递归创建
		* path	:	目录名 */
		static bool Create_Dir(const char *path, bool breverse = false);

		/* 删除目录
		* path	:	目录名
		* force	:	强制删除,指如果里面有文件也会删除此目录(递归删除) */
		static bool Delete_Dir(const char *path, bool force);

		/*删除目录
		从最底层的目录向上删除
		force : true 时如果目录不为空， 会删除目录内的所有文件，再执行删除
		force : false 时如目录不为空算法结束
		*/
		static bool Delete_Dir_Reverse(const char* path, bool force);
	};
}

#endif
