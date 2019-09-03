
local gComm = cc.exports.gComm
local netMng = require("app.Common.NetMng.NetLobbyMng")

local csbFile = "Csd/ILobby/Item/ItemVideoPlayDetail.csb"

local n = {}
local m = class("ItemVideoPlayDetail", function()
    return display.newNode()
end)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self.data = data
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    Btn_replay = "Btn_replay",
}
n.nodeMap = {
    imgBG      = "imgBG",
    Label_num  = "Label_num",
    Label_time = "Label_time",
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end
    local size = self.btnMap["imgBG"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    self.btnMap["Label_num"]:setString(self.data.index)
    -- 对战时间
    local timeTbl = os.date("*t", self.data.m_time)
    self.btnMap["Label_time"]:setString(string.format("%d-%d %d:%d", timeTbl.month, timeTbl.day, timeTbl.hour, timeTbl.min))
    for i=1, 5 do
        local scoreLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_score_" .. i)
        scoreLabel:setString("")
    end
    -- 对战分数
    for j, score in ipairs(self.data.m_score) do
        local scoreLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_score_" .. j)
        scoreLabel:setString(score)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    
    if s_name == n.btnMap.Btn_replay then
        netMng.getReplayRecord(self.data.m_videoId)
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")
end

function m:onExit()
    log(self.__TAG,"onExit")
    
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")
    
end


return m