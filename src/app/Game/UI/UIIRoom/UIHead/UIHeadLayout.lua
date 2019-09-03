
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local gRoomData = cc.exports.gData.ModleRoom
local gConfig = cc.exports.gGameConfig

local EventCmdID = require("app.Common.Config.EventCmdID")
local NetMngRoom = require("app.Common.NetMng.NetMngRoom")
local NetCmd = require("app.Common.NetMng.NetCmd")
local UIHeadDirection = require("app.Game.UI.UIIRoom.UIHead.UIHeadDirection")
local HeadMng = require("app.Common.Manager.HeadMng")
local DefineRoom = require("app.Common.Config.DefineRoom")
local ConfigTxtTip = require("app.Common.Config.ConfigTxtTip")
local ConfigGameScene = require("app.Common.Config.ConfigGameScene")

local csbFile = "Csd/IRoom/CommHead/UIHeadLayout.csb"

local n = {}
local m = class("UIHeadLayout", function()
    return display.newNode()
end)

function m:ctor(param)
    self.__TAG = "[[" .. self.__cname .. "]] --===-- "

    self.param = {
        gameID    = param.gameID,
        roundMaxCount = param.roundMaxCount,
        csbNode   = param.csbNode,
        roomID    = param.roomID,
        sPos      = param.sPos,
        roomType  = param.roomType,
    }

    self:initUI()
    self:enableNodeEvents()
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

n.btnMap = {
}
n.nodeMap = {
    imgBG            = {"imgBG",           false},
    layoutRoot       = {"layoutRoot",      true},
    [2]              = {"FileNodeTop",     false},
    [3]              = {"FileNodeLeft",    false},
    [1]              = {"FileNodeRight",   false},
    [4]              = {"FileNodeBottom",  false},
    spriteFlagReady1 = {"spriteFlagReady1",false},
    spriteFlagReady2 = {"spriteFlagReady2",false},
    spriteFlagReady3 = {"spriteFlagReady3",false},
    spriteFlagReady4 = {"spriteFlagReady4",false},
}

function m:loadCSB()
    -- local csbNode = cc.CSLoader:createNodeWithVisibleSize(csbFile)
    -- csbNode:setAnchorPoint(0.5, 0.5)
    -- csbNode:setPosition(display.center)
    -- csbNode:addTo(self)

    local csbNode = gComm.UIUtils.seekNodeByName(self.param.csbNode, "FileNodeHeadLayout")
    self.param.csbNode:reorderChild(csbNode, ConfigGameScene.ZOrder.CHAT)

    for k,v in pairs(n.btnMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, k)
        gComm.BtnUtils.setButtonClick(btn,handler(self,self.onBtnClick))
        self.btnMap[k] = btn
    end

    for k,v in pairs(n.nodeMap) do
        local btn = gComm.UIUtils.seekNodeByName(csbNode, v[1])
        btn:setVisible(v[2])
        self.btnMap[k] = btn
    end

    self._UIHeadDirection = {}
    for i=1,4 do
        local args = self.param
        args.csbNode = self.btnMap[i]
        args.uiPos = i
        self._UIHeadDirection[i] = UIHeadDirection:create(args)
        self._UIHeadDirection[i]:addTo(csbNode)
    end
    self._HeadMng = HeadMng:create()
    self._HeadMng:addTo(csbNode)
end

function m:roomAddPlayer(sPos)
    local pInfo = gRoomData:getPlayerInfoBySPos(sPos)
    local uiPos = pInfo.uiPos
    self.btnMap["spriteFlagReady" .. uiPos]:setVisible(pInfo.isReady)--准备标记
    self.btnMap[uiPos]:setVisible(true)
    local args = {
        score = pInfo.score,
        nickname = gComm.StringUtils.GetShortName(pInfo.nickname),
        zuoLaPao = "",
    }
    self._UIHeadDirection[uiPos]:setTxt(args)

    args = {
        fang = pInfo.isFangZhu,
    }
    self._UIHeadDirection[uiPos]:setFlagVisible(args)

    local btn = self._UIHeadDirection[uiPos]:getSpriteHead()
    self._HeadMng:detach(btn)
    self._HeadMng:attach(btn, pInfo.UID, pInfo.headURL)
end

--self.UIPlayer:setTxt(uiPos,args)
--key:score,nickname,zuoLaPao,chatMsg
function m:setTxt(uiPos,args)
    args = args or {}
    self._UIHeadDirection[uiPos]:setTxt(args)
end

--self.UIPlayer:setFlagVisible(uiPos,args)
--key:fang,zhuang,offline,tuoGuan,chatMsgBG,nodeVoice,nodeEmoji,isReady
function m:setFlagVisible(uiPos,args)
    args = args or {}
    self._UIHeadDirection[uiPos]:setFlagVisible(args)
    for k,v in pairs(args) do
        if k == "isReady" then
            self.btnMap["spriteFlagReady" .. uiPos]:setVisible(v)
        end
    end
end

function m:removePlayerByUIPos(uiPos)
    local btn = self._UIHeadDirection[uiPos]:getSpriteHead()
    self._HeadMng:detach(btn)
    self.btnMap[uiPos]:setVisible(false)
    gRoomData:removePlayerByUIPos(uiPos)
end

function m:removePlayer(sPos)
    local pInfo = gRoomData:getPlayerInfoBySPos(sPos)
    if not pInfo then
        log("removePlayer===",sPos)
        return
    end
    local i = pInfo.uiPos
    local btn = self._UIHeadDirection[i]:getSpriteHead()
    self._HeadMng:detach(btn)

    self.btnMap[i]:setVisible(false)
    gRoomData:removePlayer(pInfo)
end

function m:setZuoLaPaoTxt(sPos,txtStr)
    local uiPos = 1
    local pInfo = gRoomData:getPlayerInfoBySPos(sPos)
    if not pInfo then
        log("setZuoLaPaoTxt===",sPos,txtStr)
        return
    end
    local i = pInfo.uiPos
    local args = {
        zuoLaPao = txtStr,
    }
    log(sPos,"---setZuoLaPaoTxt--uipos--",i,txtStr)
    self._UIHeadDirection[i]:setTxt(args)
end

function m:setTuoGuanFlag(sPos,isShow)
    local pInfo = gRoomData:getPlayerInfoBySPos(sPos)
    if not pInfo then
        log("setTuoGuanFlag===",sPos)
        return
    end
    local i = pInfo.uiPos
    local args = {
        tuoGuan = isShow,
    }
    self._UIHeadDirection[i]:setFlagVisible(args)
end

function m:onRcvChatMsg(msgTbl)
    dump(msgTbl,"=====headonRcvChatMsg==")
    local pInfo = gRoomData:getPlayerInfoBySPos(msgTbl.m_pos)
    if not pInfo then
        log("===---onRcvChatMsg===",sPos)
        return
    end
    local uiPos = pInfo.uiPos
    local btn = self._UIHeadDirection[uiPos]:getBtn()
    -- ImgBGChatMsg = self.btnMap["ImgBGChatMsg"],
    -- txtChatMsg   = self.btnMap["txtChatMsg"],
    -- nodeVoice    = self.btnMap["nodeVoice"],
    -- nodeEmoji    = self.btnMap["nodeEmoji"],

    if msgTbl.m_type == DefineRoom.ChatType.VOICE_MSG then
        --语音
        gComm.SoundEngine:pauseAllSound()

        local num1,num2 = string.find(msgTbl.m_musicUrl, "\\")
        local curUrl = string.sub(msgTbl.m_musicUrl,1,num2-1)
        local videoTime = string.sub(msgTbl.m_musicUrl,num2+1)
        log("the play voide url is .." .. curUrl)
        log("the play voide videoTime is .." .. videoTime)

        videoTime = tonumber(videoTime)
        gComm.CallNativeMng.NativeYaya:playVoice(curUrl)
        log("the play voide end ")

        for i = 1, 4 do
            if self.voiceGroup and self.voiceGroup[i] then
                self.voiceGroup[i][2]:setVisible(false)
                self.voiceGroup[i][1]:pause()
            end
        end
        local voiceNode = self.voiceGroup[uiPos][2]
        local voiceAni = self.voiceGroup[uiPos][1]
        voiceNode:setVisible(true)
        voiceAni:gotoFrameAndPlay(0, true)

        local yuyinChatNode = btn.nodeVoice
        yuyinChatNode:stopAllActions()
        local delayTime = cc.DelayTime:create(videoTime+0.3)
        local callFunc = cc.CallFunc:create(function(sender)
            voiceNode:setVisible(false)
            voiceAni:pause()
            gComm.SoundEngine:resumeAllSound()
        end)
        yuyinChatNode:runAction(cc.Sequence:create(delayTime, callFunc))
    else
        local chatBgImg = btn.ImgBGChatMsg
        chatBgImg:setVisible(true)

        local msgLabel = btn.txtChatMsg
        local emojiSpr = btn.nodeEmoji

        emojiSpr:stopAllActions()
        emojiSpr:removeAllChildren()
        emojiSpr:setVisible(true)

        local isTextMsg = false
        if msgTbl.m_type == DefineRoom.ChatType.FIX_MSG then
            msgLabel:setString(ConfigTxtTip.GetConfigTxt("LTKey_0028_" .. msgTbl.m_id))
            isTextMsg = true
            local soundEffect = gComm.SoundEngine:getSoundEffectVolume()
            if soundEffect > 1 then
                if pInfo.sex == 1 then
                    -- 男性
                    gComm.SoundEngine:playEffect("man/fix_msg_" .. msgTbl.m_id)
                else
                    -- 女性
                    gComm.SoundEngine:playEffect("woman/fix_msg_" .. msgTbl.m_id)
                end
            end
        elseif msgTbl.m_type == DefineRoom.ChatType.INPUT_MSG then
            msgLabel:setString(msgTbl.m_msg)
            isTextMsg = true

        elseif msgTbl.m_type == DefineRoom.ChatType.EMOJI then
            chatBgImg:setVisible(false)
            local picStr = string.sub(msgTbl.m_msg,1,10)

            local animationStr = "Csd/Animation/Expression/".. picStr .. ".csb"
            local animationNode, animationAction = gComm.UIUtils.createCSAnimation(animationStr)
            animationAction:gotoFrameAndPlay(0, true)
            animationNode:setPosition(cc.p(0,0))
            emojiSpr:addChild(animationNode)

            local chatBgNode_delayTime = cc.DelayTime:create(3)
            local chatBgNode_callFunc = cc.CallFunc:create(function(sender)
                sender:stopAllActions()
                sender:removeAllChildren()
                sender:setVisible(false)
                display.removeSpriteFrames("Texture/Animation/AnimExpression.plist","Texture/Animation/AnimExpression/biaoqing.png")
            end)
            local seq = cc.Sequence:create(chatBgNode_delayTime,chatBgNode_callFunc)
            emojiSpr:runAction(seq)
            isTextMsg = false
        end

        if msgTbl.m_type == DefineRoom.ChatType.FIX_MSG or
            msgTbl.m_type == DefineRoom.ChatType.INPUT_MSG then

            chatBgImg:setVisible(true)
            local chatBgSize = chatBgImg:getContentSize()
            local bgWidth = chatBgSize.width

            if isTextMsg then
                local labelSize = msgLabel:getContentSize()
                bgWidth = labelSize.width + 30
                msgLabel:setPositionX(bgWidth * 0.5)
            end
            chatBgImg:setContentSize(cc.size(bgWidth, chatBgSize.height))

            chatBgImg:stopAllActions()
            local fadeInAction = cc.FadeIn:create(0.5)
            local delayTime = cc.DelayTime:create(1)
            local fadeOutAction = cc.FadeOut:create(0.5)
            local callFunc = cc.CallFunc:create(function(sender)
                chatBgImg:setVisible(false)
            end)
            chatBgImg:runAction(cc.Sequence:create(fadeInAction, delayTime, fadeOutAction, callFunc))
        end
    end
end

function m:onShowBeatOthers(msgTbl)
    local srcInfo = gRoomData:getPlayerInfoBySPos(msgTbl.m_srcPos)
    if not srcInfo then
        log("===---onShowBeatOthers===srcInfo")
        return
    end

    local destInfo = gRoomData:getPlayerInfoBySPos(msgTbl.m_destPos)
    if not destInfo then
        log("===---onShowBeatOthers===destInfo")
        return
    end
    local src =  srcInfo.uiPos
    local dest = destInfo.uiPos
    log("onShowBeatOthersonShowBeatOthersonShowBeatOthers",src,dest)

    local movetime = 0.8

    if src == 1 and dest == 2 then
        movetime = 0.1
    elseif src == 1 and dest == 3 then
        movetime = 0.7
    elseif src == 1 and dest == 4 then
        movetime = 0.8
    end

    if src == 2 and dest == 1 then
        movetime = 0.1
    elseif src == 2 and dest == 3 then
        movetime = 0.1
    elseif src == 2 and dest == 4 then
        movetime = 0.7
    end

    if src == 3 and dest == 1 then
        movetime = 0.7
    elseif src == 3 and dest == 2 then
        movetime = 0.6
    elseif src == 3 and dest == 4 then
        movetime = 0.1
    end

    if src == 4 and dest == 1 then
        movetime = 0.8
    elseif src == 4 and dest == 2 then
        movetime = 0.7
    elseif src == 4 and dest == 3 then
        movetime = 0.1
    end

    local Ypos1 = 50
    local Ypos = 50
    local playerNode1 = self.btnMap[src]
    local playerNode2 = self.btnMap[dest]
    local rootNode = self.param.csbNode:getParent()
    if msgTbl.m_type == 1 then
        local   delayttt1 = 0.4
        local   stoptime = 0.1
        local   delayttt2 = 0.70

        local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion1_1.csb")
        -- local playerNode1 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. src)
        node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion1_2.csb")
        -- local playerNode2 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. dest)

        local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion1_duration1.png")
        rootNode:addChild(toolsSpr,ConfigGameScene.ZOrder.DECISION_SHOW)
        toolsSpr:setVisible(false)
        toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local callFunc1 = cc.CallFunc:create(function(sender)
            rootNode:addChild(node1,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation1:gotoFrameAndPlay(0, false)
        end)
        local destP = cc.p(playerNode2:getPosition())
        if dest == 2 then
            -- destP = cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(328,-200))
        end
        local callFunc2 = cc.CallFunc:create(function(sender)
            sender:setVisible(false)
            node2:setPosition(cc.pAdd(destP,cc.p(0,Ypos)))
            rootNode:addChild(node2,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation2:gotoFrameAndPlay(0, false)
            gComm.SoundEngine:playEffect("beat/prop_flower")
        end)
        local callFunc3 = cc.CallFunc:create(function(sender)
            node1:setVisible(false)
            sender:setVisible(true)
        end)
        local callFunc4 = cc.CallFunc:create(function(sender)
            node1:removeFromParent()
            node2:removeFromParent()
            sender:removeFromParent()
        end)
        local seqAction = cc.Sequence:create(
                callFunc1,
                cc.DelayTime:create(delayttt1),
                callFunc3,cc.DelayTime:create(stoptime),
                cc.MoveTo:create(movetime,cc.pAdd(destP,cc.p(0,Ypos))),
                callFunc2,
                cc.DelayTime:create(delayttt2),
                callFunc4
            )
        toolsSpr:runAction(seqAction)
    elseif msgTbl.m_type == 2 then
        local   delayttt1 = 0.4
        local   stoptime = 0.1
        local   delayttt2 = 0.58
        local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion2_1.csb")
        -- local playerNode1 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. src)
        node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion2_2.csb")
        -- local playerNode2 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. dest)

        local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion2_duration1.png")
        rootNode:addChild(toolsSpr,ConfigGameScene.ZOrder.DECISION_SHOW)
        toolsSpr:setVisible(false)
        toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))
        local destP = cc.p(playerNode2:getPosition())
        if dest == 2 then
            -- destP = cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(328,-200))
        end
        local callFunc1 = cc.CallFunc:create(function(sender)
            rootNode:addChild(node1,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation1:gotoFrameAndPlay(0, false)
        end)

        local callFunc2 = cc.CallFunc:create(function(sender)
            toolsSpr:setVisible(false)
            node2:setPosition(cc.pAdd(destP,cc.p(0,Ypos)))
            rootNode:addChild(node2,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation2:gotoFrameAndPlay(0, false)
            gComm.SoundEngine:playEffect("beat/prop_zan")
        end)

        local callFunc3 = cc.CallFunc:create(function(sender)
            node1:setVisible(false)
            toolsSpr:setVisible(true)
        end)

        local callFunc4 = cc.CallFunc:create(function(sender)
            node1:removeFromParent()
            node2:removeFromParent()
            toolsSpr:removeFromParent()
        end)

        local seqAction = cc.Sequence:create(
                callFunc1,
                cc.DelayTime:create(delayttt1),
                callFunc3,cc.DelayTime:create(stoptime),
                cc.MoveTo:create(movetime,cc.pAdd(cc.p(destP),cc.p(0,Ypos))),
                callFunc2,
                cc.DelayTime:create(delayttt2),
                callFunc4
            )
        toolsSpr:runAction(seqAction)

    elseif msgTbl.m_type == 3 then
        local   delayttt1 = 0.4
        local   stoptime = 0.1
        local   delayttt2 = 0.58
        local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion3_1.csb")
        -- local playerNode1 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. src)
        node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))
        rootNode:addChild(node1,ConfigGameScene.ZOrder.DECISION_SHOW)

        local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion3_2.csb")
        -- local playerNode2 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. dest)

        local destP = cc.p(playerNode2:getPosition())
        if dest == 2 then
            -- destP = cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(328,-200))
        end

        local callFunc1 = cc.CallFunc:create(function(sender)
            animation1:gotoFrameAndPlay(0, false)
        end)

        local callFunc2 = cc.CallFunc:create(function(sender)
            node2:setPosition(cc.pAdd(destP,cc.p(0,Ypos)))
            rootNode:addChild(node2,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation2:gotoFrameAndPlay(0, false)
            gComm.SoundEngine:playEffect("beat/prop_bomb")
        end)

        local callFunc4 = cc.CallFunc:create(function(sender)
            node1:removeFromParent()
            node2:removeFromParent()
        end)

        local seqAction = cc.Sequence:create(
                callFunc1,
                cc.DelayTime:create(delayttt1),
                cc.MoveTo:create(movetime,cc.pAdd(destP,cc.p(0,Ypos))),
                callFunc2,
                cc.DelayTime:create(delayttt2),
                callFunc4
            )
        node1:runAction(seqAction)

    elseif msgTbl.m_type == 4 then
        local   delayttt1 = 0.4
        local   stoptime = 0.1
        local   delayttt2 = 0.5
        local node1, animation1 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion4_1.csb")
        -- local playerNode1 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. src)
        node1:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion4_2.csb")
        -- local playerNode2 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. dest)

        local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion4_duration1.png")
        rootNode:addChild(toolsSpr,ConfigGameScene.ZOrder.DECISION_SHOW)
        toolsSpr:setVisible(false)
        toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local destP = cc.p(playerNode2:getPosition())
        if dest == 2 then
            -- destP = cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(328,-200))
        end

        local callFunc1 = cc.CallFunc:create(function(sender)
            rootNode:addChild(node1,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation1:gotoFrameAndPlay(0, false)
        end)

        local callFunc2 = cc.CallFunc:create(function(sender)
            toolsSpr:setVisible(false)
            node2:setPosition(cc.pAdd(destP,cc.p(0,Ypos)))
            rootNode:addChild(node2,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation2:gotoFrameAndPlay(0, false)
            gComm.SoundEngine:playEffect("beat/prop_shoess")
        end)

        local callFunc3 = cc.CallFunc:create(function(sender)
            node1:setVisible(false)
            toolsSpr:setVisible(true)
        end)

        local callFunc4 = cc.CallFunc:create(function(sender)
            node1:removeFromParent()
            node2:removeFromParent()
            toolsSpr:removeFromParent()
        end)

        local seqAction = cc.Sequence:create(
                callFunc1,
                cc.DelayTime:create(delayttt1),
                callFunc3,cc.DelayTime:create(stoptime),
                cc.MoveTo:create(movetime,cc.pAdd(destP,cc.p(0,Ypos))),
                callFunc2,
                cc.DelayTime:create(delayttt2),
                callFunc4
            )
        toolsSpr:runAction(seqAction)

    elseif msgTbl.m_type == 5 then
        local   delayttt1 = 0.4
        local   stoptime = 0.1
        local   delayttt2 = 0.92
        -- local playerNode1 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. src)

        local node2, animation2 = gComm.UIUtils.createCSAnimation("Csd/Animation/Emotions/AnimEmotion5_1.csb")
        -- local playerNode2 = gComm.UIUtils.seekNodeByName(self.param.csbNode, "Node_playerInfo_" .. dest)

        local toolsSpr = cc.Sprite:createWithSpriteFrameName("Image/Animation/Emotions/Emotion5_duration1.png")
        rootNode:addChild(toolsSpr,ConfigGameScene.ZOrder.DECISION_SHOW)
        toolsSpr:setVisible(true)
        toolsSpr:setPosition(cc.pAdd(cc.p(playerNode1:getPosition()),cc.p(0,Ypos1)))

        local destP = cc.p(playerNode2:getPosition())
        if dest == 2 then
            -- destP = cc.pAdd(cc.p(playerNode2:getPosition()),cc.p(328,-200))
        end

        local callFunc2 = cc.CallFunc:create(function(sender)
            toolsSpr:setVisible(false)
            node2:setPosition(cc.pAdd(destP,cc.p(0,Ypos)))
            rootNode:addChild(node2,ConfigGameScene.ZOrder.DECISION_SHOW)
            animation2:gotoFrameAndPlay(0, false)

            gComm.SoundEngine:playEffect("beat/prop_egg")
        end)

        local callFunc4 = cc.CallFunc:create(function(sender)
            node2:removeFromParent()
            toolsSpr:removeFromParent()
        end)

        local seqAction = cc.Sequence:create(
                cc.DelayTime:create(stoptime),
                cc.MoveTo:create(movetime,cc.pAdd(destP,cc.p(0,Ypos))),
                callFunc2,
                cc.DelayTime:create(delayttt2),
                callFunc4
            )
        toolsSpr:runAction(seqAction)
    end
end

function m:onBtnClick( _sender )
    local s_name = _sender:getName()
    print("s_name=",s_name)
    if s_name == n.btnMap.btnHeadFrame then
    end
end

function m:onEnter()
    log(self.__TAG,"onEnter")

    self.voiceGroup = {}
    for i= 1,4 do
        local voicePlayNode, voicePlayAni = gComm.UIUtils.createCSAnimation("Csd/Animation/AnimVoicePlay.csb")
        voicePlayAni:gotoFrameAndPlay(0, true)
        voicePlayAni:pause()
        voicePlayNode:setVisible(false)
        table.insert(self.voiceGroup,{voicePlayAni,voicePlayNode})
        self._UIHeadDirection[i]:getBtn().nodeVoice:addChild(voicePlayNode)
    end
end

function m:onExit()
    log(self.__TAG,"onExit")
end

function m:onCleanup()
    log(self.__TAG,"onCleanup")

end

return m
