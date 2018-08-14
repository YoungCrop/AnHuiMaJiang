
--NetMngMJAnQin
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local msgPackLib = require("app.Core.Net.LuaMessagePack")
local NetCmd = require("app.Common.NetMng.NetCmd")

local m = {}

function m.send_(_msg)
    gt.socketClient:sendMessage(_msg)
    -- 等待提示
end

--出牌 [52]
function m.sendOutCard(_type,_think)
    local msg = {
		m_msgId = NetCmd.MSC_CG_OUT_CARD,  --NetCmd.MSG_CG_SHOW_MJTILE
		m_type  = _type,
		m_think = _think,
    }
    m.send_(msg)
end

--玩家决策选择
function m.sendPlayerDecision(_type,_think)
    local msg = {
		m_msgId = NetCmd.MSC_CG_PLAYER_DECISION,  --NetCmd.MSG_CG_PLAYER_DECISION
		m_type  = _type,
		m_think = _think,
    }
    m.send_(msg)
end

function m.sendReady(pos)
    local msg = {
		m_msgId = NetCmd.MSC_CG_READY,  --NetCmd.MSG_CG_READY
		m_pos   = pos,
    }
    m.send_(msg)
end

--语音聊天
function m.sendChatMsg(musicUrl)
    local msg = {
		m_msgId = NetCmd.MSC_CG_CHAT_MSG,  --NetCmd.MSG_CG_CHAT_MSG
		m_type  = 4, -- 语音聊天
		m_musicUrl = musicUrl,
    }
    m.send_(msg)
end

--请求胡牌数据
function m.requestTingInfo()
    local subMsg = {
            m_sub_msgId = NetCmd.MSG_GAME_EXT.MSG_C_2_S_TING_ONE_GROUP,
        }
    local msgPackData = msgPackLib.pack(subMsg)
    local msg = {
	    m_msgId = NetCmd.MSG_C_2_S_GAME_EXT,
        array = msgPackData,
        m_buffLen = string.len(msgPackData),
    }
    m.send_(msg)
end

--玩家请求蹲拉跑,下注翻倍
function m.sendBetMultiple(ma1,ma2)
    local subMsg = {
            m_sub_msgId = NetCmd.MSG_GAME_EXT.MSG_C_2_S_DUNLAPAO,
            m_ma1 = ma1,
            m_ma2 = ma2,
        }
    local msgPackData = msgPackLib.pack(subMsg)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_GAME_EXT,
        array = msgPackData,
        m_buffLen = string.len(msgPackData),
    }
    m.send_(msg)
end

function m.test()
    local msg = {
        m_msgId = 124,
    }
    -- m.send_(msg)
end

return m