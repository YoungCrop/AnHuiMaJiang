
local gComm = cc.exports.gComm
local gCallNativeMng = cc.exports.gComm.CallNativeMng

local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")
local DefineRule = require("app.Common.Config.DefineRule")
local NetLobbyMng = require("app.Common.NetMng.NetLobbyMng")
local csbFile = "Csd/ILobby/Item/ItemAgentRoom.csb"

local n = {}
local m = class("ItemAgentRoom", function()
    return display.newLayer()
end)

function m:ctor(data)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    dump(data,self.__TAG .. "ctor")
    
    self.data = data 
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
    self.btnMap = {}
    self:loadCSB()
end

n.btnMap = {
    btnCopyRoomID    = "btnCopyRoomID",
    btnInvite        = "btnInvite",
    btnDismiss       = "btnDismiss",
    btnJoin          = "btnJoin",
}
n.nodeMap = {
    txtRoomID  = "txtRoomID",
    txtYmd     = "txtYmd",
    txtTime    = "txtTime",
    txtState   = "txtState",
    txtRule    = "txtRule",
    imgBG      = "imgBG",
}

n.nodeMapIndex = {
    spr_icon_   = "spr_icon_",    
    Txt_score_  = "Txt_score_",     
    Txt_ID_     = "Txt_ID_",  
    Txt_name_   = "Txt_name_",    
}

function m:loadCSB()
 	local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.btnMap[k] = btn
    end

    local size = self.btnMap["imgBG"]:getContentSize()
    self:setContentSize(size.width,size.height + 10)

    for i=1, 5 do
        self.btnMap[i] = {}
        for k,v in pairs(n.nodeMapIndex) do
            local btn = gComm.UIUtils.seekNodeByName(csbNode, k .. i)
            self.btnMap[i][k] = btn
            -- btn:setVisible(false)
        end
    end
    local playerHeadMgr = require("app.Common.Manager.HeadMng"):create()
    csbNode:addChild(playerHeadMgr)

    -- 房间号
    self.btnMap["txtRoomID"]:setString(string.format("房间号: %d" , self.data.m_deskId))

    -- 时间
    local timeTbl = os.date("*t", self.data.m_CreatTime)
    local ymdStr = string.format("%d-%d-%d" , timeTbl.year , timeTbl.month, timeTbl.day)
    local timeStr = string.format("%d:%d:%d" , timeTbl.hour, timeTbl.min, timeTbl.sec)
    self.btnMap["txtYmd"]:setString(ymdStr)
    self.btnMap["txtTime"]:setString(timeStr)

    -- 状态
    if self.data.m_isInUse then
        -- 已开始
        self.btnMap["txtState"]:setColor(cc.c3b(4, 243, 47))
        self.btnMap["txtState"]:setString("状态: 已开始")
    else
        -- 未开始
        self.btnMap["txtState"]:setColor(cc.c3b(255, 0, 0))
        self.btnMap["txtState"]:setString("状态: 未开始")
    end

    if self.data.showOperate then
        if self.data.m_isInUse then
            self.btnMap["btnDismiss"]:setVisible(false)
        end
    else
        self.btnMap["txtState"]:setColor(cc.c3b(4, 243, 47))
        self.btnMap["txtState"]:setString("状态: 已完成")
        self.btnMap["btnCopyRoomID"]:setVisible(false)
        self.btnMap["btnInvite"]:setVisible(false)
        self.btnMap["btnDismiss"]:setVisible(false)
        self.btnMap["btnJoin"]:setVisible(false)
    end

    local str = ""
    for k,v in ipairs(self.data.m_playtype) do
        if v > DefineRule.GREnum.HBMJ_DiFenName then
            str = str .. (DefineRule.GRNameStr[DefineRule.GREnum.HBMJ_DiFenName] ..(v - DefineRule.GREnum.HBMJ_DiFenName)) .. " "
        else
            str = str .. (DefineRule.GRNameStr[v] or "") .. " "
        end
    end
    self.btnMap["txtRule"]:setString(str)

    for i=1,5 do
        if i > self.data.m_playerNum then
            self.btnMap[i]["spr_icon_"]:setVisible(false)
            self.btnMap[i]["Txt_score_"]:setVisible(false)
            self.btnMap[i]["Txt_ID_"]:setVisible(false)
            self.btnMap[i]["Txt_name_"]:setVisible(false)
        else
            self.btnMap[i]["Txt_ID_"]:setString("ID:"..self.data.m_RoomUserId[i])
            self.btnMap[i]["Txt_name_"]:setString(gComm.StringUtils.GetShortName(self.data.m_RoomUserNike[i]))

            if self.data.m_score then
                local score = self.data.m_score[i] or 0
                self.btnMap[i]["Txt_score_"]:setString(score)
                if tonumber(score) >=0 then
                    self.btnMap[i]["Txt_score_"]:setTextColor(cc.c4b(74,90,66,255))
                else
                    self.btnMap[i]["Txt_score_"]:setTextColor(cc.c4b(220,40,40,255))
                end
            else
                self.btnMap[i]["Txt_score_"]:setVisible(false)
            end

            self.btnMap[i]["spr_icon_"]:setScale(0.5)
            local headUrl = self.data.m_headImageUrl[i] or ""
            if headUrl ~= "" then
                playerHeadMgr:detachAgentIcon(self.data.m_RoomUserId[i])
                playerHeadMgr:attach(self.btnMap[i]["spr_icon_"], self.data.m_RoomUserId[i], headUrl)
            end
        end
    end

end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)

    if s_name == n.btnMap.btnCopyRoomID then
        local titleLocal,description = self:inviteFriendUrl()
        local copyStr = titleLocal .. "\n" ..description
        copyStr = copyStr .."\n".. gCallNativeMng.NativeMeChuang:getMCURL()

        gCallNativeMng.AppNative:copyText(copyStr)
        gComm.UIUtils.floatText("复制成功")
    elseif s_name == n.btnMap.btnInvite then
        local title,txt = self:inviteFriendUrl()
        local _type = gCallNativeMng.shareType.WeiXin
        local url = gCallNativeMng.NativeMeChuang:getMCURL()
        gCallNativeMng:shareURL(_type,url,title,txt,function()
            -- body
        end)

    elseif s_name == n.btnMap.btnDismiss then
        NetLobbyMng.getDismissAgentRoom(self.data.m_deskId)
    elseif s_name == n.btnMap.btnJoin then
        NetLobbyMng.SendJoinRoom(self.data.m_deskId)
    end
end

function m:inviteFriendUrl()
    local description = ""
    for _,v in pairs(self.data.m_playtype) do
        description = description .. (DefineRule.GRNameStr[v] or "") .. " "
    end
    description = description.."!"
    local titleLocal = "人人安徽麻将: 房号:[%d] %d局 %d缺%d"
    local curPlayerAmount = 1
    titleLocal = string.format(titleLocal,self.data.m_deskId,self.data.m_playerNum,curPlayerAmount,self.data.m_playerNum-curPlayerAmount)
    
    return titleLocal,description
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