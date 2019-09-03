#!/usr/bin/python
#coding:utf-8

import os
import sys
import shutil
import time
import configAssetsUpdate
from xml.dom import minidom

if __name__ == '__main__':

    path = os.getcwd()
    print path
    
    dom = minidom.parse(path + '/frameworks/runtime-src/proj.android/AndroidManifest.xml')

    manifest = dom.documentElement
    version = manifest.getAttribute('android:versionName')
    sType = "dis_server"
#正式服(线上服）1,内网测试服2，外网测试服3
    if configAssetsUpdate.ServerType == 3:
        sType = "outer_server"
    elif configAssetsUpdate.ServerType == 2:
        sType = "inner_server"

    sType = sType + "-v" + version + "-" + configAssetsUpdate.VersionString

    apkName = "publish/android/AnHui-%s.apk" % (sType)
    
    print manifest.getAttribute('package')
    
    print apkName
    

    os.rename("publish/android/AnHuiMJ-release-signed.apk", apkName)


    