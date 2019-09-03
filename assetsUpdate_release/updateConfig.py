#!/usr/bin/python
#coding:utf-8

import os
import hashlib
import sys
import shutil
import json
import configAssetsUpdate


def copyFile(srcFile,destFile):
    if os.path.exists(srcFile) and os.path.exists(destFile):
        os.remove(destFile)
    if os.path.exists(srcFile):
        shutil.copyfile(srcFile, destFile)

def copyDir(srcPath,destPath):
    if os.path.exists(srcPath) and os.path.exists(destPath):
        shutil.copytree(srcPath, destPath)

def removeFile(destFile):
    if os.path.exists(destFile):
        os.remove(destFile)

def removeDir(destDir):
    if os.path.exists(destDir):
        shutil.rmtree(destDir)

if __name__ == '__main__':

    # srcFile = sys.path[0] + "/../doc/temp/"
    # if not os.path.isdir(srcFile):
    #     os.makedirs(srcFile)

    # srcFile = sys.path[0] + "/../version.manifest"
    # destFile = sys.path[0] + "/../doc/temp/version.manifest"
    # copyFile(srcFile,destFile)

    srcFile = sys.path[0] + "/../../%s/%s/version.manifest"%(configAssetsUpdate.AssetLocPath,configAssetsUpdate.VersionString)
    destFile = sys.path[0] + "/../version.manifest"
    copyFile(srcFile,destFile)


    # srcFile = sys.path[0] + "/../project.manifest"
    # destFile = sys.path[0] + "/../doc/temp/project.manifest"
    # copyFile(srcFile,destFile)

    srcFile = sys.path[0] + "/../../%s/%s/project.manifest"%(configAssetsUpdate.AssetLocPath,configAssetsUpdate.VersionString)
    destFile = sys.path[0] + "/../project.manifest"
    copyFile(srcFile,destFile)


    # srcFile = sys.path[0] + "/../frameworks/runtime-src/Classes/Crypto/FilesSystem.cpp"
    # destFile = sys.path[0] + "/../doc/temp/FilesSystem.cpp"
    # copyFile(srcFile,destFile)

    # srcFile = sys.path[0] + "/../doc/crypto/FilesSystem.cpp"
    # destFile = sys.path[0] + "/../frameworks/runtime-src/Classes/Crypto/FilesSystem.cpp"
    # copyFile(srcFile,destFile)






