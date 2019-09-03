
--NetCoinGameMng
--require("app.Common.NetMng.NetCoinGameMng").coinReturn()
local gt = cc.exports.gt
local NetCmd = require("app.Common.NetMng.NetCmd")

local m = {}

function m.send_(_msg)
    dump(_msg,"====NetCoinGameMng===")
    gt.socketClient:sendMessage(_msg)
end


function m.getCoin()
    local msg = {
        m_msgId   = NetCmd.MSG_C_2_S_COIN_GET,
    }
    m.send_(msg)
end

function m.coinReturn()
    local msg = {
        m_msgId   = NetCmd.MSG_C_2_S_COIN_RETURN,
    }
    m.send_(msg)
end

function m.levelCoinGameHall()
    local msg = {
        m_msgId   = NetCmd.MSG_C_2_S_COIN_LEAVE_HALL,
    }
    m.send_(msg)
end

function m.joinCoinGameNext()
    local msg = {
        m_msgId   = NetCmd.MSG_C_2_S_COIN_NEXT,
    }
    m.send_(msg)
end

function m.GameCoinMainInfo(gameID)
    local msg = {
        m_msgId   = NetCmd.MSG_C_2_S_COIN_REFRESH_HALL,
        m_bigPlay = gameID,
    }
    m.send_(msg)
end

function m.ConvertCoin(cIndex,cardCost)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_COIN_CONVERT,
        m_index = cIndex,
        m_cardCost = cardCost,
    }
    m.send_(msg)
end


function m.JoinCoinGame(coinIndex)
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_COIN_JOIN,
        m_coinIndex = coinIndex,
    }
    m.send_(msg)
end

function m.JoinFastCoinGame()
    local msg = {
        m_msgId = NetCmd.MSG_C_2_S_COIN_FAST_START,
    }
    m.send_(msg)
end


return m
