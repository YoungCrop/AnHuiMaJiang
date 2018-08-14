#!/usr/bin/python
#coding:utf-8

import os
import hashlib
import sys
import shutil
import json
import commands
import configAssetsUpdate
import binascii
from refreshCdn import pushAliCdn
from upload import Xfer

def getFileMd5(filename):
    if not os.path.isfile(filename):
        return
    myhash = hashlib.md5()# create a md5 object
    f = file(filename,'rb')
    while True:
        b = f.read(8096)# get file content.
        if not b :
            break
        myhash.update(b)#encrypt the file
    f.close()
    return myhash.hexdigest()

#获取添加结尾字符的md5
def getMoreFileMd5(filename):
    if not os.path.isfile(filename):
        return
    myhash = hashlib.md5()# create a md5 object
    f = file(filename,'rb')
    a = ''
    while True:
        b = f.read(8096)# get file content.
        if not b :
            break
        a = a + b
    c = binascii.b2a_hex(a)
    myhash.update(c.upper())
    myhash.update("3c6e0b8a9c15224a8228b9a98ca1531d")
    f.close()
    return myhash.hexdigest()

def getAssets(path, prefix):
    fl = os.listdir(path) # get what we have in the dir.
    for f in fl:
        if os.path.isdir(os.path.join(path,f)): # if is a dir.
            if prefix == '':
                getAssets(os.path.join(path,f), f)
            else:
                getAssets(os.path.join(path,f), prefix + '/' + f)
        else:
            if f != '.DS_Store' and f != 'version.manifest' and f != 'project.manifest':
                md5 = getFileMd5(os.path.join(path,f))
                configAssetsUpdate.assetsXml += "\n\t\t\"%s\" : {\n\t\t\t\"md5\" : \"%s\"\n\t\t}, " % (prefix + '/' + f, md5)
    return configAssetsUpdate.assetsXml

def getMoreAssets(path, prefix):
    fl = os.listdir(path) # get what we have in the dir.
    for f in fl:
        if os.path.isdir(os.path.join(path,f)): # if is a dir.
            if prefix == '':
                getMoreAssets(os.path.join(path,f), f)
            else:
                getMoreAssets(os.path.join(path,f), prefix + '/' + f)
        else:
            if f != '.DS_Store' and f != 'version.manifest' and f != 'project.manifest':
                md5 = getMoreFileMd5(os.path.join(path,f))
                configAssetsUpdate.assetsMoreXml += "\n\t\t\"%s\" : {\n\t\t\t\"md5\" : \"%s\"\n\t\t}, " % (prefix + '/' + f, md5)
    return configAssetsUpdate.assetsMoreXml

def getVersionString(version):
    versionList = version.split('.')
    if int(versionList[2]) < 10:
        return '%s0%s' % (versionList[0], versionList[2])
    else:
        return '%s%s' % (versionList[0], versionList[2])

# 拷贝res和src_et到release文件夹
def copySrcEtAndRes(oPath):
    if os.path.exists(oPath):
        shutil.rmtree(oPath)
    shutil.copytree(sys.path[0] + "/../res", oPath + '/res')
    shutil.copytree(sys.path[0] + "/../src_et", oPath + '/src_et')

# 拷贝src到release文件夹
def copySrc(oPath):
    shutil.copytree(sys.path[0] + "/../src", oPath + '/src')

# 创建version.manifest文件
def createVersionFile(oPath, versionNumber, versionString):
    versionXml = configAssetsUpdate.getVersion(versionNumber, versionString)
    f = file(oPath + "/version.manifest", "w+")
    f.write(versionXml)
    f.close()

# 创建project.manifest文件
def createProjectFile(oPath, versionNumber, versionString, assets, newassets):
    projectXml = configAssetsUpdate.getProject(versionNumber, versionString, assets, newassets)
    f = file(oPath + "/project.manifest", "w+")
    f.write(projectXml)
    f.close()

#检查是否在项目路径运行脚本
def checkSafe():
    if not os.path.exists(os.getcwd() + '/res'):
        return False
    elif not os.path.exists(os.getcwd() + '/src'):
        return False
    elif not os.path.exists(os.getcwd() + '/luacompiles.sh'):
        return False
    return True

if __name__ == "__main__":
    if not checkSafe():
        print '安全监测失败,脚本结束!\n运行脚本目录不对\n运行脚本目录不对\n运行脚本目录不对\n重要的事情说三遍 运行脚本目录不对 跳转到 = ' + sys.path[0] + ' 的上一级!'
        sys.exit()

    str = 'yes'
    if str == 'yes' :
        
        # 编译src到src_et
        commandline = 'sh luacompiles.sh'
        print commands.getoutput(commandline)

        # 拷贝src_et和res到release
        versionNumber = configAssetsUpdate.VersionNumber
        versionString = configAssetsUpdate.VersionString
        operationPath = configAssetsUpdate.ReleasePath + '/' + configAssetsUpdate.AssetLocPath + '/' + versionString
        copySrcEtAndRes(operationPath)
        print 'copy src_et and res to release finish!'

        # 生成project和version
        assetsXml = ''
        if configAssetsUpdate.IsOld == True:
            configAssetsUpdate.assetsXml = ''
            assetsXml = getAssets(operationPath, '')
            assetsXml = assetsXml[:-2]

        #新的md5
        configAssetsUpdate.assetsMoreXml = ''
        assetsMoreXml = getMoreAssets(operationPath, '')
        assetsMoreXml = assetsMoreXml[:-2]


        createVersionFile(operationPath, versionNumber, versionString)
        createProjectFile(operationPath, versionNumber, versionString, assetsXml, assetsMoreXml)
        print 'create version and project manifest file finish!'

        # 拷贝src留作备份
        copySrc(operationPath)

        # if configAssetsUpdate.IsUpload == True:


        #     # cliUpdateUrl = '118.31.116.202'
        #     # if configAssetsUpdate.IsOnLine == True:
        #     #      cliUpdateUrl = '47.97.5.174'
                 
        #     # #将文件上传到FTP服务器
        #     # xfer = Xfer()
        #     # xfer.setFtpParams(cliUpdateUrl, 'neimeng', 'bWmB)v454FVZ0i3vLoqi')
        #     # xfer.upload()
        #     # print 'upload file finish!'

        #     # f = pushAliCdn()
        #     # params = {'Action': 'RefreshObjectCaches', 'ObjectPath': 'http://www.yongwuzhijing88.com/client/FTPProjectName/', 'ObjectType': 'Directory'}
        #     # res = f.make_request(params)
        #     # print res
        # print '恭喜你,热更新完成!'

