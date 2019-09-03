
local function hex(s)
    s=string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
    -- log("====数值",s)
    return s, string.len(s)
end

-- 读取文件
local function readFile( path )
    local file = io.open( path, "rb" )
    if file then
        local content = file:read( "*all" )
        io.close(file)
        return content
    end

    return nil
end

local function checkDirOK( path )
    local cpath = cc.FileUtils:getInstance():isFileExist(path)
    if cpath then
        return true
    end

    return cc.FileUtils:getInstance():createDirectory( path )
end

-- 比较获取需要下载的文件名字
local function compManifest( oList, newList )
    local oldList = {}
    for k,v in pairs(oList or {}) do
        oldList[k] = v["md5"]
    end

    local list = {}
    for k,v in pairs(newList or {}) do
        if v["md5"] ~= oldList[k] then
            local saveTab = {}
            saveTab.name    = k
            saveTab.md5code = v["md5"]
            table.insert( list, saveTab )
        end
    end
    return list
end

local function checkFile( fileName, cryptoCode )
    if not io.exists(fileName) then -- 测试fileName文件是否存在
        return false -- 如果文件不存在,那么返回false
    end

    local data = readFile(fileName)
    if data == nil then
        return false
    end

    if cryptoCode == nil then
        return true
    end
    local needMd5Str, needLen = hex(data)
    local ms = cc.UtilityExtension:generateMD5( needMd5Str, needLen )
    if ms==cryptoCode then
        return true
    end

    log("md5差异Error:", fileName, cryptoCode, ms)
    return false
end

local function checkCacheDirOK( root_dir, path )
    path = string.gsub( string.trim(path), "\\", "/" )
    local info = io.pathinfo(path)
    if not checkDirOK(root_dir..info.dirname) then
        return false
    end

    return true
end

local function removeFile( path )
    io.writefile(path, "")
    if device.platform == "windows" then
        os.remove(string.gsub(path, '/', '\\'))
    else
        cc.FileUtils:getInstance():removeFile( path )
    end
end

local function renameFile(path, newPath)
    if cc.FileUtils:getInstance():isFileExist(path) then--可以是相对路径，也可以为绝对路径
    	dump(path)
    	
        removeFile(newPath)
        os.rename(path, newPath)
    end
end


local projectmanifest_filename = "project.manifest"
local versionmanifest_filename  = "version.manifest"

local InitText = {
    [1] = "正在加载,请稍候……",
    [2] = "加载中,请稍候……",
    [3] = "正在启动游戏，请稍候……",
    [4] = "触摸屏幕开始",
    [5] = "读取manifest[%s]文件错误",
    [6] = "资源已加载完成",
    [7] = "创建目录失败",
    [8] = "加载文件错误",
    [9] = "正在加载文件",
    [10] = "配置文件格式错误",
    [11] = "加载完成",
    [12] = "正在检查文件",
    [13] = "正在写入文件",
}

local m = class("SceneUpdateBase", function()
    return cc.Scene:create()
end)

function m:ctor()
    self.__TAG_BASE = "[[" .. self.__cname .. "]] --===-- "
    self:enableNodeEvents()
    -- 下载url
    self.updateURL  = nil

    self.writePath = cc.FileUtils:getInstance():getWritablePath()

    self:initProjectManifest()
    self.XMLHttpMng = require("app.Common.Manager.XMLHttpMng")
end

function m:startUpdate()
    --清空更新列表缓存，避免资源混用
    self.completedDownList = {}
    -- 请求版本号
    self:requestVersionFile()
end

function m:compareVersion( versionFir, versionSec )
    local versionFirArr = string.split(versionFir,".")
    local versionSecArr = string.split(versionSec,".")

    dump(versionFirArr,"===versionFirArr=")
    dump(versionSecArr,"===versionSecArr=")

    for i=1,#versionFirArr do
        if tonumber(versionFirArr[i]) > tonumber(versionSecArr[i]) then
            return 1
        elseif tonumber(versionFirArr[i]) < tonumber(versionSecArr[i]) then
            return -1
        end
    end
    return 0
end

function m:initProjectManifest()
    local isExist = cc.FileUtils:getInstance():isFileExist(projectmanifest_filename)
    if isExist then
        log("initProjectManifest===1===",os.date("%M:%S"))
        local fileData = cc.FileUtils:getInstance():getStringFromFile(projectmanifest_filename)
        self.projectManifestList = json.decode(fileData)
        log("initProjectManifest===2===",os.date("%M:%S"))
    end

    -- 未找到project.manifest文件,则重新下载一遍所有的资源
    if not self.projectManifestList then
    	self.projectManifestList = {
            version           = "1.0.0",
            remoteVersionUrl  = "https://anhui-update.yongwuzhijing88.com:443/YwZj_2017/AnHui/version.manifest",
            remoteManifestUrl = "https://anhui-update.yongwuzhijing88.com:443/YwZj_2017/AnHui/project.manifest",
            assets            = {},
            newassets         = {},
        }
    end
end

-- 请求版本号
-- project.manifest文件中已经有version版本号了，为什么还要下载version.manifest读取呢？
-- 为了其他地方需要version版本号时从version.manifest文件读取，而不是从project.manifest文件读取，version.manifest文件下读取的快
function m:requestVersionFile()
    log("self.requestVersionFile======",self.projectManifestList.version,self.projectManifestList.remoteVersionUrl)

    local failFunHandle = handlerEx(self,self.updateProcessTipInfo,false,InitText[8])
    local path = self.writePath .. versionmanifest_filename .. ".upd"
    self.XMLHttpMng.downloadFile(self.projectManifestList.remoteVersionUrl,handler(self,self.reqVersionFileCBHandle),failFunHandle,path)
end

function m:reqVersionFileCBHandle(strVersionData,savePath)
    local jsonData = json.decode(strVersionData)
    if not jsonData then
    	self:updateProcessTipInfo(false,string.format(InitText[5], savePath))
    	return
    end
    log(jsonData.version,"reqVersionFileCBHandle")
    local versionRet = self:compareVersion(jsonData.version, self.projectManifestList.version)
    if versionRet == 1 then
        self:requestProjectManifest(jsonData.remoteManifestUrl)
    else
        --versoin版本号要变化
        local versionData = readFile( self.writePath..versionmanifest_filename..".upd" ) 
        local res  = io.writefile( self.writePath..versionmanifest_filename, versionData )
        self:updateProcessTipInfo(true,InitText[6])
    end
end

-- 如果请求的版本和本地的版本不同的话,需要请求目录
function m:requestProjectManifest(url)
    local failFunHandle = handlerEx(self,self.updateProcessTipInfo,false,InitText[8])
    local path = self.writePath .. projectmanifest_filename..".upd"
    self.XMLHttpMng.downloadFile(url,handler(self,self.reqProjectManifestCBHandle),failFunHandle,path)
end

function m:reqProjectManifestCBHandle( strData,savePath )
    local jsonData = json.decode(strData)
    if not jsonData then
    	self:updateProcessTipInfo(false,string.format(InitText[5], savePath))
    	return
    end

    -- 通过比较获得需要更新的文件
    self.needUpdateList = compManifest( self.projectManifestList.newassets, jsonData.newassets )
    
    -- 打印一下需要更新的文件的名字
    for i,v in ipairs(self.needUpdateList) do
        log("getDownloadFile----==-", v.name, v.md5code )
    end

    -- 记录从服务器下载的url地址(更新地址)
    self.updateURL = jsonData.packageUrl
    self.numFileCheck = 0
    self:reqNextFile()
end

function m:reqNextFile()
    self.numFileCheck = self.numFileCheck + 1
    local curStageFile = self.needUpdateList[self.numFileCheck]

    if curStageFile then
        -- 进度条
        local percent = (self.numFileCheck-1)/(#self.needUpdateList) * 100
        self:updateProgressTip(percent)

        -- 如果文件已经存在了(例如MainScene.luac文件),检查此文件是否是已经下载过的文件(比较md5值)
        local fn = self.writePath..curStageFile.name
        if checkFile( fn, curStageFile.md5code ) then
            self:reqNextFile()
            return
        end

        -- 查看是否有已经存在的.udp文件(如果存在并且md5值相同,说明是上次已经更新过的,但是由于某些原因并未完全更新成功)
        fn = fn..".upd"
        if checkFile( fn, curStageFile.md5code ) then -- 如果文件存在
            table.insert(self.completedDownList, fn)
            self:reqNextFile()
            return
        end


	    --检查并创建多级目录(存储下载文件的目录),为了下面下载文件创建路径
	    if not checkCacheDirOK( self.writePath, curStageFile.name ) then
	        self:updateProcessTipInfo(false,InitText[7] ) -- InitText[7] = "创建目录失败"
	        return
	    end
        -- 向服务器发送消息请求curStageFile.name文件
        local url = self.updateURL .. "/" .. curStageFile.name
	    local failFunHandle = handlerEx(self,self.updateProcessTipInfo,false,InitText[8])
		local path = self.writePath..curStageFile.name..".upd"
	    self.XMLHttpMng.downloadFile(url,handlerEx(self,self.reqFileCBHandle,curStageFile),failFunHandle,path)
        return
    end

    --下载完成
    self:renameFiles()
end

function m:reqFileCBHandle(curStageFile,downloadData)
	local fn = self.writePath..curStageFile.name..".upd"
    if checkFile( fn, curStageFile.md5code ) then -- 下载正确,那么继续下载下一个文件
        table.insert(self.completedDownList, fn) -- 下载正确的话,就存到self.completedDownList表中.
        self:reqNextFile()
    else
        --错误
        self:updateProcessTipInfo(false,InitText[8]) -- InitText[8] = "下载文件错误"
    end
end

-- 下载完毕之后,需要修改后缀名等操作
function m:renameFiles()
    log("renameFilesrenameFilesrenameFiles")
    local versionData = readFile( self.writePath..versionmanifest_filename..".upd" ) 
    local res  = io.writefile( self.writePath..versionmanifest_filename, versionData )

    local data = readFile( self.writePath..projectmanifest_filename..".upd" ) -- 从服务器得到的更新目录文件project.manifest.upd
    local ret  = io.writefile( self.writePath..projectmanifest_filename, data ) -- project.manifest文件中去

    removeFile( self.writePath..versionmanifest_filename..".upd" )-- 删除version.manifest.upd文件
    removeFile( self.writePath..projectmanifest_filename..".upd" )-- 删除project.manifest.upd文件

    -- 修改资源中.upd名字
    for i,v in ipairs(self.completedDownList) do
        local fn = string.sub(v, 1, -5)--去掉.upd
        log("rename===",v,fn)
        -- 重新命名
        renameFile(v, fn)
    end
    self:updateProcessTipInfo(true,InitText[11])
end

function m:updateProgressTip(percent)
end

function m:updateProcessTipInfo(isUpdateSuccess,endInfo)
end

function m:updateCompleted()
    log("=base=updateCompleted==")
    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeAllTextures()
    gComm.FunUtils.clearLoadedFiles()
end

function m:onEnter()
    log(self.__TAG_BASE,"onEnter")
end

function m:onExit()
    log(self.__TAG_BASE,"onExit")
end

function m:onCleanup()
    log(self.__TAG_BASE,"onCleanup")
end

return m