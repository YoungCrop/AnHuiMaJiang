

--NetMngRoom
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")
local mTxtTipConfig = require("app.Common.Config.ConfigTxtTip")

local m = {}

function m.send_(_msg)
    gt.socketClient:sendMessage(_msg)
    -- 等待提示
    -- gComm.UIUtils.showLoadingTips(mTxtTipConfig.GetConfigTxt("LTKey_0005"))
end

--发送打击表情
function m.sendBeatExp(pos,expID)
    local msg = {
        m_msgId = NetCmd.MSG_CG_BEAT,
        m_pos = pos,
        m_type = expID,
    }
    m.send_(msg)
end

--获取用户地址
function m.getUserAdress(uid)
    local msg = {
        m_msgId = NetCmd.MSG_CG_GET_USER_ADDR,
        m_id = uid,--此变量一废弃，都会返回列表
    }
    m.send_(msg)
end

--上传自己的位置
function m.upLoadLocation()
    local ret = cc.exports.gComm.CallNativeMng.NativeGaoDe:getLocAddres()
    local loc = cc.exports.gComm.CallNativeMng.NativeGaoDe:getLocation()
    if ret ~= nil and loc ~= nil and ret ~= "" and loc ~= "" then
        local msg = {
            m_msgId = NetCmd.MSG_CG_POST_ADDR,
            m_dress = ret,
            m_points = loc,
        }
        m.send_(msg)
    end
end

--通过链接进入房间时，但自己已有房间提示
function m.enterRoomTipByURL()
    local roomID = cc.exports.gComm.CallNativeMng.NativeMeChuang:getUrlRoomID()
    if roomID and roomID ~= "" then
        gComm.UIUtils.floatText(mTxtTipConfig.GetConfigTxt("LTKey_0071"))
        cc.exports.gComm.CallNativeMng.NativeMeChuang:clearUrlRoomID()
    end
end


--退出房间
function m.sendQuitRoom(pos)
    local msg = {
        m_msgId = NetCmd.MSG_CG_QUIT_ROOM, --NetCmd.MSG_CG_QUIT_ROOM
        m_pos = pos,
    }
    m.send_(msg)
end

--解散房间
function m.sendDimissRoom(pos)
    local msg = {
        m_msgId = NetCmd.MSG_CG_DISMISS_ROOM, --NetCmd.MSG_CG_DISMISS_ROOM
        m_pos = pos,
    }
    m.send_(msg)
end

--申请解散房间,--1同意;2拒绝
function m.applyDimissRoom(pos,flag)
    local msg = {
        m_msgId = NetCmd.MSG_CG_APPLY_DISMISS, --NetCmd.MSG_CG_APPLY_DISMISS
        m_pos = pos,
        m_flag = flag,
    }
    m.send_(msg)
end

--语音聊天
function m.sendChat(_type,chatId,msg)
    local msg = {
        m_msgId = NetCmd.MSC_CG_CHAT_MSG,
        m_type = _type,
        m_id = chatId,
        m_msg = msg,
    }
    m.send_(msg)
end

--// 1. 托管  2.取消托管
function m.sendTuoGuan(isTuoGuan)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_TUO_GUAN,
        m_type = isTuoGuan and 1 or 2,
    }
    m.send_(msg)
end


return m