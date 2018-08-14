
local gComm = cc.exports.gComm

local csbFile = "Csd/InterfaceLobby/Common/UIPeiPaiPoker.csb"

local n = {}
n.nodeMap = {
    root_num = "root_num",
    t1 = "t1",
    t2 = "t2",
    t3 = "t3",
    t4 = "t4",
    t5 = "t5",
}

local m = class("UIPeiPaiPoker", function()
    return display.newNode()
end)


function m:ctor()
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
    self:initUI()
    self:enableNodeEvents()
end

function m:initUI()
	self.nodeMap = {}
    self:loadCSB()
end


function m:loadCSB()
    local csbNode = cc.CSLoader:createNode(csbFile)
    csbNode:addTo(self)

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        self.nodeMap[k] = btn
    end

end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
end

function m:getPeiPaiData()
    local msg = {
        m_robotNum = nil,
        m_cardValue = nil,
    }
    msg.m_robotNum = tonumber(self.nodeMap[n.nodeMap.root_num]:getStringValue())

    local cardStr = ""
    for i=1,5 do
        local txt = self.nodeMap["t" .. i]:getStringValue()
        if i < 5 and string.len(txt) ~= 0 then
            cardStr = cardStr..txt..","
        else
            cardStr = cardStr..txt
        end
    end

    local subStrs = string.split(cardStr, ",")
    local senTab = {}
    for i,v in ipairs(subStrs) do
        local carTab = {}
        if string.len(v) ~= 0 then
            if tonumber(v) > 100 then
                carTab[1] = math.floor(tonumber(v)/100)
                carTab[2] = tonumber(v)%100
            else
                carTab[1] = math.floor(tonumber(v)/10)
                carTab[2] = tonumber(v)%10
            end
            senTab[#senTab+1] = carTab
        end
    end
    msg.m_cardValue = senTab
	return msg
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