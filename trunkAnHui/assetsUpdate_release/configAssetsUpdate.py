#!/usr/bin/python
#coding:utf-8
#--------------------------请配置以下信息-----------------------------




#正式服(线上服）1,内网测试服2，外网测试服3
ServerType = 1


if ServerType == 1:
    VersionNumber = "1.0.139" # 版本号
    VersionString = "1000139" # 版本号文件夹
elif ServerType == 2:
    VersionNumber = "1.0.200" # 版本号
    VersionString = "1000200" # 版本号文件夹
else:
    VersionNumber = "1.0.196" # 版本号
    VersionString = "1000196" # 版本号文件夹
    
# 是否上传服务器
IsUpload = False

# 项目名称(需要作为路径使用,不允许使用非法字符)
AssetLocPathTest = "ah_test"
AssetLocPathTestOuter = "ah_test_outer"
AssetLocPathOnLine = "ah"
AssetLocPath = AssetLocPathOnLine

# 是否为旧项目(旧项目为assets,newassets同时出现)
IsOld = False

#是否是打包
IsPackage = True
#打包的情况下不上传热更服务器
if IsPackage == True:
    IsUpload = False

# ftp服务器更新的项目目录名称
FTPProjectName = 'AnHui'

# ftp服务器更新路径
UpdatePath = 'YwZj_2017'

# 发布前资源拷贝路径
ReleasePath = "../"

#测试服更新url 
UpdateResUrlTest = "https://anhui.yongwuzhijing88.com:443"
#线上服更新url 
UpdateResUrlOnLine = "https://anhui-update.yongwuzhijing88.com:443"


UpdateResUrl = UpdateResUrlOnLine

if ServerType == 1:
    UpdateResUrl = UpdateResUrlOnLine
    AssetLocPath  = AssetLocPathOnLine
elif ServerType == 2:
    UpdateResUrl = UpdateResUrlTest
    AssetLocPath  = AssetLocPathTest
else:
    FTPProjectName = 'AnHuiOuterServerTest'
    UpdateResUrl = UpdateResUrlTest
    AssetLocPath  = AssetLocPathTestOuter


UpdateWebsite = "%s/%s/%s" % (UpdateResUrl,UpdatePath,FTPProjectName)

# 更新路径 格式为:   本地相对路径 : 服务器相对路径
Paths = {
	'1'	: ['%s/%s/%s/src_et' % (ReleasePath, AssetLocPath, VersionString), './%s/%s/update/%s/src_et' % (UpdatePath,FTPProjectName, VersionString)],
	'2' : ['%s/%s/%s/res' % (ReleasePath, AssetLocPath, VersionString), './%s/%s/update/%s/res' % (UpdatePath,FTPProjectName, VersionString)],
	'3' : ['%s/%s/%s/project.manifest' % (ReleasePath, AssetLocPath, VersionString), './%s/%s' % (UpdatePath,FTPProjectName)],
	'4' : ['%s/%s/%s/version.manifest' % (ReleasePath, AssetLocPath, VersionString), './%s/%s' % (UpdatePath,FTPProjectName)],
	# '5' : ['%s/%s/%s/project.manifest' % (ReleasePath, AssetLocPath, versionString), './%s' % FTPProjectName_AppStore],
	# '6' : ['%s/%s/%s/version.manifest' % (ReleasePath, AssetLocPath, versionString), './%s' % FTPProjectName_AppStore],
}

#--------------------------配置信息结束-----------------------------

assetsXml = ''
assetsMoreXml = ''

def getVersion(versionNumber, versionString):
	return '{\n\
	"packageUrl" : "%s/update/%s",\n\
	"remoteVersionUrl" : "%s/version.manifest",\n\
	"remoteManifestUrl" : "%s/project.manifest",\n\
	"version" : "%s",\n\
	"engineVersion" : "Cocos2d-x v3.10"\n\
    }' % (UpdateWebsite, versionString, UpdateWebsite, UpdateWebsite, versionNumber)

def getProject(versionNumber, versionString, assets, newassets):
	return '{\n\
    "packageUrl" : "%s/update/%s",\n\
    "remoteVersionUrl" : "%s/version.manifest",\n\
    "remoteManifestUrl" : "%s/project.manifest",\n\
    "version" : "%s",\n\
    "engineVersion" : "Cocos2d-x v3.10",\n\
    "assets" : {\
    %s\n\
    },\n\
    "newassets" : {\
    %s\n\
    },\n\
    "searchPaths" : [\n\
    ]\n}' % (UpdateWebsite, versionString, UpdateWebsite, UpdateWebsite, versionNumber, assets, newassets)
