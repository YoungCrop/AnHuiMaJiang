

local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
local SceneUpdateBase = require("app.Common.Manager.SceneUpdateBase")
local resCsb = "Csd/Scene/SceneUpdate.csb"

local m = class("SceneUpdateX", SceneUpdateBase)
local n = {}

n.nodeMap = {
    bg = "bg",
    Label_progress= "Label_progress",
    Slider_update = "Slider_update",
}

function m:ctor()
    m.super.ctor(self)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    if cc.exports.gt.socketClient then
        cc.exports.gt.socketClient:close()
    end
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

function m:loadCSB()
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(resCsb)
    self:addChild(csbNode)

    for k,v in pairs(n.nodeMap) do
        local btn = cc.exports.gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    self.btnMap["bg"]:setScale(math.max(1,display.height/CC_DESIGN_RESOLUTION.height))

    -- 显示更新状态
    self.btnMap["Label_progress"]:setString(ConfigTxtTip.GetConfigTxt("LTKey_0033"))
    local fadeOut = cc.FadeOut:create(1)
    local fadeIn = cc.FadeIn:create(1)
    local seqAction = cc.Sequence:create(fadeOut, fadeIn)
    self.btnMap["Label_progress"]:runAction(cc.RepeatForever:create(seqAction))

    -- 更新进度条
    if cc.exports.gGameConfig.isiOSAppInReview then
        self.btnMap["Label_progress"]:setVisible(false)
    else
        self.btnMap["Label_progress"]:setVisible(true)
    end
    self.btnMap["Slider_update"]:setVisible( true )
    self.btnMap["Slider_update"]:setPercent(0)
end

function m:updateProgressTip( percent )
    log("updateProgressTip==",percent)
    self.btnMap["Label_progress"]:setString( "正在更新游戏资源".." "..math.floor(percent).."%")
    self.btnMap["Slider_update"]:setPercent( percent )
end

function m:updateCompleted()
    log("==updateCompleted==")
    m.super.updateCompleted(self)
    require("app.Game.Scene.SceneManager").goSceneLogin()

    -- package.loaded["main"] = nil
    -- require("main")

    -- if package.loaded["src_et/main"] then
    --     package.loaded["src_et/main"] = nil
    --     require("src_et/main")
    -- elseif package.loaded["src/main"] then
    --     package.loaded["src/main"] = nil
    --     require("src/main")
    -- end
end

function m:updateProcessTipInfo( isUpdateSuccess,endInfo)
    if endInfo then
        log("更新结束,原因: "..endInfo,isUpdateSuccess)
    end

    if isUpdateSuccess == false then
        UINoticeTips:create("加载失败,请检查您的网络连接", handler(self,self.startUpdate))
        return
    end
    self:updateCompleted()
end

function m:onEnter()
    log(self.__TAG,"onEnter")
    m.super.onEnter(self)
    
    self:startUpdate()
end

function m:onExit()
    log(self.__TAG,"onExit")
    m.super.onExit(self)
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    m.super.onCleanup(self)
end

return m