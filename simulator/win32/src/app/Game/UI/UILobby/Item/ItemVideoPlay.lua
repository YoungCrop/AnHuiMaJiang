
local gComm = cc.exports.gComm

local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local csbFile = "Csd/ILobby/Item/ItemVideoPlay.csb"

local n = {}
local m = class("ItemVideoPlay", function()
    return display.newLayer()
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
    btnPlay    = "btnPlay",
}
n.nodeMap = {
    imgBG        = {"imgBG"      ,},
    Label_num    = {"lvContent"  ,"index",},
    Label_roomID = {"txtEmpty"   ,"m_deskId",},
    Label_time   = {"Label_time" ,"m_time",},
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        btn:setTag(self.data.index)
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
        if v[2] then
            btn:setString(self.data[v[2]])
        end
    end

    local size = self.btnMap["imgBG"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    for i=1, 5 do
        local nicknameLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_nickname_" .. i)
        nicknameLabel:setString("")
        local scoreLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_score_" .. i)
        scoreLabel:setString("")
    end

    -- 对战时间
    local tT = os.date("*t", self.data.m_time)
    self.btnMap["Label_time"]:setString(mTxtTipConfig.GetConfigTxt("LTKey_0040", tT.year, tT.month, tT.day, tT.hour, tT.min, tT.sec))
    
    -- 玩家昵称+分数
    for i, v in ipairs(self.data.m_nike) do
        local nicknameLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_nickname_" .. i)
        nicknameLabel:setString(v)
        local scoreLabel = gComm.UIUtils.seekNodeByName(csbNode, "Label_score_" .. i)
        scoreLabel:setString(self.data.m_score[i])
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    local tag = _sender:getTag()
    if s_name == n.btnMap.btnPlay then
        self.handle(tag)
    end
end

function m:setClickHandle( handle )
    self.handle = handle
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