
local gComm = cc.exports.gComm
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")

local csbFile = "Csd/IRoom/RoomComm/UIMJLayout.csb"

local n = {}

local m = class("UIMJLayout",function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "
	dump(param,"===UIRoomInfo===")

	self.csbNode = param.csbNode
    self.param = {
        needPeopleNum = param.needPeopleNum,
        csbNode      = param.csbNode,
    }
	self:initUI()
end

function m:initUI()
--ui位置编号
--   2
--3     1
--   4
--
    self.btnMap = {}
    self:loadCSB()
end
function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNode(csbFile)
    local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.center)
    csbNode:addTo(self)
    csbNode:setVisible(false)
    self.csbNode = csbNode
end

function m:getPlayerMjTilesReferPos(uiSeatIdx)
    local mjTilesReferPos = {}
    -- local playNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "nodeMJLayout")
    local playNode = gComm.UIUtils.seekNodeByName(self.csbNode, "layoutRoot")
    local mjTilesReferNode = gComm.UIUtils.seekNodeByName(playNode, "Node_playerMjTiles_" .. uiSeatIdx)

    -- 持有牌数据
    local mjTileHoldSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_1")
    local mjTileHoldSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileHold_2")

    mjTilesReferPos.holdStart = cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints()))
    mjTilesReferPos.holdSpace = cc.pSub(cc.p(mjTileHoldSprS:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints())),
                                        cc.p(mjTileHoldSprF:convertToWorldSpace(mjTileHoldSprF:getAnchorPointInPoints())))
    

    -- 打出牌数据
    local mjTileOutSprF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_1")
    local mjTileOutSprS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_2")
    local mjTileOutSprT = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_3")
    local mjTileOutSprHua = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileOut_hua")
    mjTilesReferPos.outStart = cc.p(mjTileOutSprF:convertToWorldSpace(mjTileHoldSprS:getAnchorPointInPoints()))
    mjTilesReferPos.outSpaceH = cc.pSub(cc.p(mjTileOutSprS:convertToWorldSpace(mjTileOutSprS:getAnchorPointInPoints())), cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints())))
    mjTilesReferPos.outSpaceV = cc.pSub(cc.p(mjTileOutSprT:convertToWorldSpace(mjTileOutSprT:getAnchorPointInPoints())), cc.p(mjTileOutSprF:convertToWorldSpace(mjTileOutSprF:getAnchorPointInPoints())))
    mjTilesReferPos.outStartHua = cc.p(mjTileOutSprHua:convertToWorldSpace(mjTileOutSprHua:getAnchorPointInPoints()))

    if self.param.needPeopleNum == 2 then
        if uiSeatIdx == 2 then
            mjTilesReferPos.outStart.x = mjTilesReferPos.outStart.x + 52
        elseif uiSeatIdx == 4 then
            mjTilesReferPos.outStart.x = mjTilesReferPos.outStart.x - 72
        end
    end
    -- 碰，杠牌数据
    local mjTileGroupPanel = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Panel_mjTileGroup")
    local groupMjTilesPos = {}
    for _, groupTileSpr in ipairs(mjTileGroupPanel:getChildren()) do
        table.insert(groupMjTilesPos, cc.p(groupTileSpr:getPosition()))
    end
    
    mjTilesReferPos.groupMjTilesPos = groupMjTilesPos
    mjTilesReferPos.groupStartPos = cc.p(mjTileGroupPanel:convertToWorldSpace(mjTileGroupPanel:getAnchorPointInPoints()))
    local groupSize = mjTileGroupPanel:getContentSize()
    

    if uiSeatIdx == 1 or uiSeatIdx == 3 then
        mjTilesReferPos.groupSpace = cc.p(0, groupSize.height + 8)
        if uiSeatIdx == 3 then
            mjTilesReferPos.groupSpace.y = -mjTilesReferPos.groupSpace.y
        end
    else 
        mjTilesReferPos.groupSpace = cc.p(groupSize.width + 8, 0)
        if uiSeatIdx == 2 then
            mjTilesReferPos.groupSpace.x = -mjTilesReferPos.groupSpace.x
        end
    end

    -- 当前出牌展示位置
    local showMjTileNode = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Node_showMjTile")
    mjTilesReferPos.showMjTilePos = cc.p(showMjTileNode:convertToWorldSpace(showMjTileNode:getAnchorPointInPoints()))

    local subDis = 150
    local tempPos = {
        [1] = cc.p(subDis,0),
        [2] = cc.p(0,-subDis),
        [3] = cc.p(-subDis,0),
        [4] = cc.p(0,subDis),
    }
    mjTilesReferPos.showMjHuaAnimPos = cc.pAdd(mjTilesReferPos.showMjTilePos,tempPos[uiSeatIdx])

    local showLastHandF = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileLastHand_1")
    local showLastHandS = gComm.UIUtils.seekNodeByName(mjTilesReferNode, "Spr_mjTileLastHand_2")
    
    mjTilesReferPos.showHandStart = mjTilesReferPos.groupStartPos
    mjTilesReferPos.showHandSpace = cc.pSub(cc.p(showLastHandS:convertToWorldSpace(showLastHandS:getAnchorPointInPoints())),cc.p(showLastHandF:convertToWorldSpace(showLastHandF:getAnchorPointInPoints())))
    if uiSeatIdx == 1 or uiSeatIdx == 3 then
        if uiSeatIdx == 3 then
            mjTilesReferPos.showHandSpace.y = -mjTilesReferPos.showHandSpace.y
        end
    else
        if uiSeatIdx == 2 then
            mjTilesReferPos.showHandSpace.x = -mjTilesReferPos.showHandSpace.x
        end
    end

    -- dump(mjTilesReferPos,"====mjTilesReferPos===" .. uiSeatIdx)
    return mjTilesReferPos
end


return m