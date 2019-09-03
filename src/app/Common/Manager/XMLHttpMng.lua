--[[
	XMLHttpMng封装
  ]]

local debug = require("app.Common.Utils.DebugUtils")
local m = {}

--_savaPath:绝对路径
function m.request_(responseType,url,sucCallBackHandle,failCallBackHandle,_savaPath)
    local xhr = cc.XMLHttpRequest:new()
    xhr.timeout = 30 -- 设置超时时间
    xhr.responseType = responseType
    xhr:open("GET", url)
    local function callbackFun()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            if _savaPath then
                local res = io.writefile(_savaPath,xhr.response)
                if res == false then
                    debug:log("xmlHttpReq io.writefile error,req:url=" .. url .. "_savaPath is:" .. _savaPath)
                end
            end
            if responseType == cc.XMLHTTPREQUEST_RESPONSE_STRING then
                sucCallBackHandle(xhr.response,_savaPath)
            elseif responseType == cc.XMLHTTPREQUEST_RESPONSE_JSON then
                sucCallBackHandle(json.decode(xhr.response),_savaPath)
            end
        else
            debug:log("xmlHttpReq error,req:url=" .. url .. "xhr.readyState is:" .. xhr.readyState .. " xhr.status is: " .. xhr.status)
            if failCallBackHandle then
                failCallBackHandle()
            end
        end
        xhr:unregisterScriptHandler()
        xhr = nil
    end
    xhr:registerScriptHandler(callbackFun)
    xhr:send()
    -- debug:logUD(xhr,"request_request_request_request_xhr")
    return xhr
end

function m.reqString(url,sucCallBackHandle,failCallBackHandle)
    return m.request_(cc.XMLHTTPREQUEST_RESPONSE_STRING,url,sucCallBackHandle,failCallBackHandle)
end

function m.reqJSON(url,sucCallBackHandle,failCallBackHandle)
    return m.request_(cc.XMLHTTPREQUEST_RESPONSE_JSON,url,sucCallBackHandle,failCallBackHandle)
end

function m.downloadFile(url,sucCallBackHandle,failCallBackHandle,_savaPath)--_savaPath绝对路径
    return m.request_(cc.XMLHTTPREQUEST_RESPONSE_STRING,url,sucCallBackHandle,failCallBackHandle,_savaPath)
end

return m
