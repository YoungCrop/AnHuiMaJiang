
local m = class("SceneBase", function()
    return cc.Scene:create()
end)

function m:ctor(args)
    self.__TAG_SCENE_BASE = "[[" .. self.__cname .. "-SceneBase]] --===-- "
    self._SB_Param = {

    }
    self:enableNodeEvents()

    self:regEventSceneBase()
end

function m:onRcvEnterRoomSceneBase(msgTbl)
    dump(msgTbl,"====onRcvEnterRoomSceneBase====")
    gComm.UIUtils.removeLoadingTips()

    gt.socketClient:unRegisterMsgListenerByTarget(self)
    gComm.EventBus.unRegAllEvent(self)

    cc.SpriteFrameCache:getInstance():removeSpriteFrames()
    cc.Director:getInstance():getTextureCache():removeAllTextures()

    local DefineRule = require("app.Common.Config.DefineRule")
    local playScene
    if msgTbl.m_gameID == DefineRule.GameID.POKER_DDZ then
        playScene = require("app.Game.Scene.SceneDDZSenior"):create(msgTbl)
    elseif msgTbl.m_gameID == DefineRule.GameID.AnQinDianPao then
         playScene = require("app.Game.Scene.SceneMJAnQingEx"):create(msgTbl)
    elseif msgTbl.m_gameID == DefineRule.GameID.MJHuaiBei then
         playScene = require("app.Game.Scene.SceneMJHuaiBeiEx"):create(msgTbl)
    else
        gComm.UIUtils.floatText("未知错误State---gameID:" .. msgTbl.m_gameID)
    end

    if playScene then
        cc.Director:getInstance():replaceScene(playScene)
    end
end

function m:onRcvRoomCardSceneBase(msgTbl)
    local playerData = cc.exports.gData.ModleGlobal
    playerData.roomCardsCount = {msgTbl.m_card1, msgTbl.m_card2, msgTbl.m_card3}

    local args = { coinNum = msgTbl.m_coin }
    cc.exports.gData.ModleGlobal:setSelfInfo(args)

    local args = {
        coinNum = msgTbl.m_coin,
        cardNum = msgTbl.m_card2,
    }

    local EventCmdID = require("app.Common.Config.EventCmdID")
    gComm.EventBus.dispatchEvent(EventCmdID.UI_USER_COIN_CHANGE,args)

    self:I_ShowCoinCard(args)
end

--接口，子类要重新
function m:I_ShowCoinCard(args)
    -- local args = {
    --     coinNum = msgTbl.m_coin,
    --     cardNum = msgTbl.m_card2,
    -- }
end

--接口
function m:I_ShowCoinInRoom(args)
    -- local args = {
    --     userId = msgTbl.userId,
    --     changeCoin = msgTbl.num,
    --     finalCoin  = msgTbl.allCo,
    --     reasonType = msgTbl.oper,
    -- }

    if args.reasonType == 9 then
        local str = string.format("系统已扣除%d金币作为本局服务费",math.abs(args.changeCoin))
        gComm.UIUtils.floatText(str)
    end
end

function m:onRcvCoinChangeInRoomSceneBase(msgTbl)
    dump(msgTbl,"m:onRcvCoinChangeInRoomSceneBase======")
    -- Lint m_errorCode;//0是成功,1是失败
    -- Lint userId;//金币变化的玩家
    -- Lint oper;//金币变化类型
    -- Lint num;//金币变化值
    -- Lint allCo;//玩家金币变化后的金币总值
    -- CARDS_OPER_TYPE_COIN_MATCH = 9,     //金币赛扣除金币(门票 )
    -- CARDS_OPER_TYPE_COIN_ADD_END = 10,  //金币场一局结束增加金币
    -- CARDS_OPER_TYPE_COIN_DEL_END = 11,  //金币场一局结束减少金币
    -- CARDS_OPER_TYPE_COIN_LOWER   = 12,  //金币低保领取

    if msgTbl.m_errorCode == 0 then
        local args = {
            userId = msgTbl.userId,
            changeCoin = msgTbl.num,
            finalCoin  = msgTbl.allCo,
            reasonType = msgTbl.oper,
        }
        self:I_ShowCoinInRoom(args)
    end
end

function m:onRcvCoinNextSceneBase(msgTbl)
    dump(msgTbl,"m:onRcvCoinNextSceneBase======")
    local errorList = {
        [1] = "玩家不在金币场 ",
        [2] = "您的金币不足，无法继续游戏",
        [3] = "所在金币场不存在",
        [4] = "重复点击",
        [5] = "游戏服不存在",
    }
    if msgTbl.m_errorCode == 0 then
    elseif msgTbl.m_errorCode == 2 then
        if not self:isShwoCoinTip(msgTbl.maxTimes,msgTbl.curTimes,msgTbl.lower,msgTbl.lowerLimit) then
            gComm.UIUtils.floatText(errorList[2])
        end
    else
        local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:onRcvCoinGetSceneBase(msgTbl)
    dump(msgTbl,"m:onRcvCoinGetSceneBase======")
    -- Lint m_errorCode;   //0为兑换成功;1已超当天次数;2玩家金币充足,未到领取低保金币标准
    -- Lint addCoin;       //低保玩家增加的金币数
    -- Lint getCoinTimes;  //玩家当前天已领次数
    -- Lint coin;          //增加后,玩家当前金币数
    if msgTbl.m_errorCode == 0 then
        local str = "您已成功领取".. msgTbl.addCoin .."金币"
        gComm.UIUtils.floatText(str)
    end
end

function m:revCoinJoin(msgTbl)
    dump(msgTbl,"m:revCoinJoin======")
    local errorList = {
        [1] = "纠正已关闭的金币场大玩法为已开启的大玩法 ",
        [2] = "未开启任何金币场 ",
        [3] = "该大玩法不存在该金币场索引m_coinIndex",
        [4] = "玩家已加入金币场,不能重复加入 ",
        [5] = "您的金币不足，无法进入该场次 ",
        [6] = "玩家在别的游戏内 ",
        [7] = "服务器无该赛场",
    }

    -- UINoticeTips:create("你的金币低于xxx,不能进入该场次")
    if msgTbl.m_errorCode == 0 then
    elseif msgTbl.m_errorCode == 5 then
        if not self:isShwoCoinTip(msgTbl.maxTimes,msgTbl.curTimes,msgTbl.lower,msgTbl.lowerLimit) then
            gComm.UIUtils.floatText(errorList[5])
        end
    else
        local str = errorList[msgTbl.m_errorCode] or ("未知错误 ErrorCode："..msgTbl.m_errorCode)
        gComm.UIUtils.floatText(str)
    end
end

function m:isShwoCoinTip(maxTimes,curTimes,coin,lowerLimit)
    if curTimes < maxTimes and
        cc.exports.gData.ModleGlobal:getSelfInfo().coinNum < lowerLimit then
        local str = "您的金币不足，每日可以领取" .. maxTimes .. "次".. coin .."金币的金币补助，是否领取？"
        local UINoticeTips = require("app.Game.UI.UICommon.UINoticeTips")
        UINoticeTips:create(str,function()
                    require("app.Common.NetMng.NetCoinGameMng").getCoin()
                end,function()
                    -- body
                end)
        return true
    else
        return false
    end
end

function m:onRcvMarquee(msgTbl)
    dump(msgTbl,"----onRcvMarquee---")
    cc.exports.gData.ModleGlobal.marqueeStr = msgTbl.m_str
    self:I_ShowMarquee()
end

function m:I_ShowMarquee()
end

function m:regEventSceneBase()
    if gt.socketClient then
        local NetCmd = require("app.Common.NetMng.NetCmd")
        gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ROOM_CARD, self, self.onRcvRoomCardSceneBase)
        gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_NEXT, self, self.onRcvCoinNextSceneBase)
        gt.socketClient:registerMsgListener(NetCmd.MSG_GC_ENTER_ROOM, self, self.onRcvEnterRoomSceneBase)
        gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_GET, self, self.onRcvCoinGetSceneBase)
        gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_CHANGE_INROOM, self, self.onRcvCoinChangeInRoomSceneBase)
        gt.socketClient:registerMsgListener(NetCmd.MSG_S_2_C_COIN_JOIN, self, self.revCoinJoin)
        gt.socketClient:registerMsgListener(NetCmd.MSG_GC_MARQUEE, self, self.onRcvMarquee)
    end
end

function m:unRegEventSceneBase()
    if gt.socketClient then
        local NetCmd = require("app.Common.NetMng.NetCmd")
        gt.socketClient:unregisterMsgListener(NetCmd.MSG_GC_ROOM_CARD)
        gt.socketClient:unregisterMsgListener(NetCmd.MSG_S_2_C_COIN_NEXT)
        gt.socketClient:unregisterMsgListener(NetCmd.MSG_GC_ENTER_ROOM)
        gt.socketClient:unregisterMsgListener(NetCmd.MSG_S_2_C_COIN_GET)
        gt.socketClient:unregisterMsgListener(NetCmd.MSG_S_2_C_COIN_CHANGE_INROOM)
    end
end

function m:onEnter()
    log(self.__TAG_SCENE_BASE,"onEnter")
    -- self:regEventSceneBase()

	local info = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
	log("getCachedTextureInfo==",info)
end

function m:onExit()
    log(self.__TAG_SCENE_BASE,"onExit")
    -- self:unRegEventSceneBase()
    
    -- [Socket] Warning Could not handle Message MsgId
end

function m:onCleanup()
    log(self.__TAG_SCENE_BASE,"onCleanup")

    display.removeUnusedSpriteFrames()
    collectgarbage("collect")
end

return m
