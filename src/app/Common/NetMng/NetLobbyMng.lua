
--NetLobbyMng
local gt = cc.exports.gt
local NetCmd = require("app.Common.NetMng.NetCmd")

local m = {}

function m.send_(_msg)
    dump(_msg,"====NetLobbyMng===")
    gt.socketClient:sendMessage(_msg)
end

function m.getVersionNumber()
    local msg = {
        m_msgId = NetCmd.MSG_CG_UPDATE,
    }
    m.send_(msg)
end

function m.SendCreateRoom(_msg)
    local msg = {
        m_msgId = NetCmd.MSG_CG_CREATE_ROOM,
        m_secret = "123456",
        m_gold = 1,
    }
    msg.m_playtype = _msg.ruleArray   --规则
    msg.m_RoomType = _msg.m_RoomType  --1代开

    msg.m_robotNum = _msg.m_robotNum
    msg.m_clubId   = _msg.clubID or 0
    -- msg.m_cardValue = _msg.m_cardValue
    for i=1,5 do
        msg["m_cardValue"..i] = _msg["m_cardValue"..i]
    end

--后加的
    msg.m_gameID = _msg.m_gameID
    msg.m_MaxCircle = _msg.m_MaxCircle
    msg.m_playerNum = _msg.m_playerNum
    
    m.send_(msg)
end

function m.SendJoinRoom(roomID,robotNum)
    local msg = {
        m_msgId = NetCmd.MSG_CG_JOIN_ROOM,
        m_deskId = roomID,
        m_robotNum = robotNum,
    }
    m.send_(msg)
end

function m.getHistoryRecord(uid)
    local msg = {
        m_msgId = NetCmd.MSG_CG_HISTORY_RECORD,
        m_time = 123456,
        m_userId = uid,
    }
    m.send_(msg)
end

function m.getReplayRecord(videoId)
    local msg = {
        m_msgId = NetCmd.MSG_CG_REPLAY,
        m_videoId = videoId,
    }
    m.send_(msg)
end

function m.getAgentRoom(_type)
    local msg = {
        m_msgId = NetCmd.MSG_CG_GET_AGENT_ROOM,
        m_type = _type,
    }
    m.send_(msg)
end

function m.getDismissAgentRoom(deskId)
    local msg = {
        m_msgId = NetCmd.MSG_CG_DISMISS_AGENT_ROOM,
        m_deskId = deskId,
    }
    m.send_(msg)
end

function m.buyCard(cardNum)
    local msg = {
        m_msgId = NetCmd.MSG_CG_BUY_FANGKA,
        m_CardNums = cardNum,
    }
    m.send_(msg)
end

--75: state = 2（请求领取房卡）,state = 5(是否可以领取) 
--m_state = 6 游戏结算面板 分享 领取房卡 必得一张房卡, 7转盘活动
--76: 0：领取房卡成功 7:可以领取，8:不可领取
function m.getCardByShare()
    local msg = {
        m_msgId = NetCmd.MSG_CG_GET_FANGKA_HUODONG,
        m_state = 6,
    }
    m.send_(msg)
end

function m.canGenCardByShare()
    local msg = {
        m_msgId = NetCmd.MSG_CG_GET_FANGKA_HUODONG,
        m_state = 5
    }
    m.send_(msg)
end


--0.退出比赛 1.红包赛斗地主 2.红包赛安庆点炮 3. 红包赛淮北麻将
function m.joinBigWinMatch(matchType)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_JOIN_RED_MATCH,
        m_matchType = matchType,
    }
    m.send_(msg)
end

function m.getBigWinMatchInfo()
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_RED_MATCH_INFO,
    }
    m.send_(msg)
end

function m.getBigWinRecord()
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_RED_CODE_LOG,
    }
    m.send_(msg)
end

-- // 1入会，2离会,3 代理后台邀请时,前端同意 4 代理后台邀请时,前端不同意
function m.joinAndQuitClub(_type,clubID)
    local msg = {
        m_msgId  = NetCmd.MSG_C_2_S_CLUB_APPLICATION,
        m_clubId = clubID,
        m_type   = _type,
    }
    m.send_(msg)
end

function m.createClub(clubName)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_CLUB_CREATE,
        m_clubName = clubName,
    }
    m.send_(msg)
end

function m.getMyClublist()
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_CLUB_ALL_BASIC_INFO,
    }
    m.send_(msg)
end

function m.getClubBaseInfo(clubID)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_CLUB_TARGET_BASIC_INFO,
        m_clubId = clubID,
    }
    m.send_(msg)
end

function m.getClubDetailInfo(clubID)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_CLUB_DETAIL_INFO,
        m_clubId = clubID,
    }
    m.send_(msg)
end


function m.getClubGameRecord(clubID,time)--time:// 0是全部，非零是某天
    local msg = {
        m_msgId  = NetCmd.MSG_C_2_S_CLUB_VIP_LOG,
        m_clubId = clubID,
        m_time   = time,
    }
    m.send_(msg)
end

function m.getMailList()
    local msg = {
        m_msgId  = NetCmd.MSG_C_2_S_CLUB_MAIL,
    }
    m.send_(msg)
end

-- //0 不同意,1 同意
function m.RespondClub(clubID,isAgree)    
    local msg = {
        m_msgId  = NetCmd.MSG_C_2_S_CLUB_MAIL,
        m_clubId = clubID,
        m_agree  = isAgree and 1 or 0,
    }
    m.send_(msg)
end

function m.SendCreateQuickRoom(clubID)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_CREATE_QUICK_ROOM,
        m_clubId = clubID,
    }
    m.send_(msg)
end

return m
