#!/usr/bin/python
# -*- coding: cp936 -*-
import os
import configAssetsUpdate
from ftplib import FTP

_XFER_FILE = 'FILE'
_XFER_DIR = 'DIR'

class Xfer(object):
    '''
    @note: upload local file or dirs recursively to ftp server
    '''
    def __init__(self):
        self.ftp = None
        self.file = None
        self.cacheList = []
        self.newList = []
    
    def __del__(self):
        self.clearEnv()
        if self.file is not None:
            self.file.close()
            self.file = None
        self.cacheList = []
        self.newList = []
        pass
    
    def setFtpParams(self, ip, uname, pwd, port = 21, timeout = 3):        
        self.ip = ip
        self.uname = uname
        self.pwd = pwd
        self.port = port
        self.timeout = timeout

    
    def initEnv(self):
        if self.ftp is None:
            self.ftp = FTP()
            print '### connect ftp server: %s '%self.ip
            self.ftp.set_pasv(0)
            self.ftp.connect(self.ip, self.port, self.timeout)
            self.ftp.login(self.uname, self.pwd)
            
            print self.ftp.getwelcome()

    def clearEnv(self):
        if self.ftp:
            self.ftp.close()
            print '### disconnect ftp server: %s '%self.ip 
            self.ftp = None
    
    def uploadDir(self, localdir='./', remotedir='./'):
        if not os.path.isdir(localdir):  
            return
        #print 'remotedir = ' + remotedir + ', current = ' + self.ftp.pwd()
        self.ftp.cwd(remotedir)
        for file in os.listdir(localdir):
            src = os.path.join(localdir, file)
            if os.path.isfile(src):
                self.uploadFile(src, file)
            elif os.path.isdir(src):
                isExist = False
                for name in self.ftp.nlst():
                    if name == file:
                        isExist = True

                if isExist == False:
                    try:  
                        self.ftp.mkd(file)
                    except:  
                        #sys.stderr.write('the dir is exists %s'%(file))
                        print 'the dir is exists %s'%(file)

                self.uploadDir(src, file)
        self.ftp.cwd('..')
    
    def uploadFile(self, localpath, remotepath='./'):

        if not os.path.isfile(localpath) or os.path.basename(localpath) == ".DS_Store":  
            return
        
        isExist = localpath +'\n' in self.cacheList
        if isExist == False:
            print '%s ===> %s:%s'%(localpath, self.ip, remotepath)
            try:
                self.ftp.storbinary('STOR ' + remotepath, open(localpath, 'rb'))
                self.newList.append(localpath)
                self.cacheList.append(localpath)
            except Exception as e:
                for line in self.newList:
                    self.file.write(line+'\n')
                self.file.flush()
                self.file.close()
                raise e
    
    def __filetype(self, src):
        if os.path.isfile(src):
            index = src.rfind('\\')
            if index == -1:
                index = src.rfind('/')                
            return _XFER_FILE, src[index+1:]
        elif os.path.isdir(src):
            return _XFER_DIR, ''

    def initDirs(self):
        items = configAssetsUpdate.Paths.items()
        sortItems = sorted(items)
        for src, dest in sortItems:
            subPaths = dest[1].split('/')
            subPath = ''
            for v in subPaths:
                if v == '.':
                    subPath = '.'
                else:
                    subPath = subPath + '/' + v
                    try:
                        self.ftp.mkd(subPath)
                    except:
                        #print subPath + ' is exists!'
                        v = v
    
    def upload(self):

        tmpName = 'temp.txt'
        self.file = open(tmpName,'a+')
        self.file.seek(0,0)
        self.cacheList = self.file.readlines()
        for line in self.cacheList:
            print line.strip()

        self.file.seek(0,2)

        items = configAssetsUpdate.Paths.items()
        sortItems = sorted(items)
        for src, dest in sortItems:
            self.initEnv()
            self.initDirs()
            #print 'dest = ' + dest[0]
            filetype, filename = self.__filetype(dest[0])
            self.srcDir = dest[0]
            self.destDir = dest[1]
            #print '===destDir' + self.destDir
            if filetype == _XFER_DIR:
                self.uploadDir(self.srcDir, self.destDir)
            elif filetype == _XFER_FILE:
                self.uploadFile(self.srcDir, self.destDir + '/' + filename)
            self.clearEnv()

        if os.path.exists(tmpName):
                os.remove(tmpName)

