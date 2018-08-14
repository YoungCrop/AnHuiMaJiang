
--NetLoginMng
local gt = cc.exports.gt
local gComm = cc.exports.gComm
local NetCmd = require("app.Common.NetMng.NetCmd")

local m = {}

function m.send_(_msg)
    gt.socketClient:sendMessage(_msg)
    -- 等待提示
end

function m.xmlRequest(url, cbFun)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    xhr:open("GET", url)
    local function onResp()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            cbFun(xhr.response)
            -- local response = xhr.response
            -- response = string.gsub(response,"\\","")
            -- response = self:godNick(response)
            
            -- local respJson = json.decode(response)
            -- if respJson.errcode then
            --                     -- 申请失败
            --     cc.UserDefault:getInstance():setStringForKey("WX_Access_Token", "")
            --     cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token", "")
            --     cc.UserDefault:getInstance():setStringForKey("WX_Access_Token_Time", "")
            --     cc.UserDefault:getInstance():setStringForKey("WX_Refresh_Token_Time", "")
            --     cc.UserDefault:getInstance():setStringForKey("WX_OpenId", "")

            --     self.autoLoginRet = false
            --     if cc.exports.gGameConfig.isiOSAppInReview then
            --     else
            --         -- require("app/tools/Tips"):create(mTxtTipConfig.GetConfigTxt("LTKey_0007"), mTxtTipConfig.GetConfigTxt("LTKey_0030"))
            --     end

            --     gComm.UIUtils.removeLoadingTips()

            --     log("requestUserInfo respJson.errcode = "..respJson.errcode)
            -- else
            --     local sex           = respJson.sex
            --     local nickname      = respJson.nickname
            --     local headimgurl    = respJson.headimgurl
            --     local unionid       = respJson.unionid
            --     -- 登录
            --     self:sendRealLogin( accessToken, refreshToken, openid, sex, nickname, headimgurl, unionid)
            --     log("requestUserInfo sendRealLogin ")
            -- end
        elseif xhr.readyState == 1 and xhr.status == 0 then
            -- self.autoLoginRet = false
            -- log("requestUserInfo xhr.readyState =  "..xhr.readyState)
            -- gComm.UIUtils.removeLoadingTips()
            cbFun() --失败
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onResp)
    xhr:send()
end


function m:getLoginInfo()
    -- local xhr = cc.XMLHttpRequest:new()
    -- xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- local LoginServerUrl = "https://test.gongyang58.com:81/YwZj_2016/jx/LoginServer"
    -- xhr:open("GET", LoginServerUrl)
    -- local function onResp()
    --  if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
    --      local response = xhr.response
    --      local respJson = json.decode(response)
    --      self:onGetLoginHandle(respJson)
    --  elseif xhr.readyState == 1 and xhr.status == 0 then
    --      log("getRemoteServer Failure")
    --  end

    --  xhr:unregisterScriptHandler()
    -- end

    -- xhr:registerScriptHandler(onResp)
    -- xhr:send()
end

function m:onGetLoginHandle( data )
    dump(data,self.__TAG .. "onGetLoginHandle")

    if not data or not ( type(data)  == "table" ) then 
        log("onGetLoginHandle Error")
        return 
    end
end


return m