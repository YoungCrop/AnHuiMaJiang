--[[
	http封装,HttpMng
  ]]

local debug = require("app.Common.Utils.DebugUtils")

local m = {}
local db = {}
local cookie = {}--增加cookes

--注册一个http的回调监听
function m.listeners(_tag, _success, _fail, _progress)
	if not db[_tag] then db[_tag] = {} end
	db[_tag].fail       = _fail
	db[_tag].success    = _success
	db[_tag].progress 	= _progress
end

--取消注册
function m.unlisteners(_tag)
	if db[_tag] then
		db[_tag] = nil
	end
end

--请求http
function m.request_(_way, _url, _data, _listenTag, _subTag, _savaPath)
	print("TPHttp.request_", _url)
	local tag = _listenTag
    --请求回调
	local function httpCallback(_event)
		debug:logUD(_event,"httpCallback")
	    local event   = _event
	    local ok      = ( event.name == "completed" )
	    local request = event.request
	    --成功
	    if "completed" == event.name then
	    	local code = request:getResponseStatusCode()
	        if 200==code then --成功
	            local response = request:getResponseData()
		    	print("http success,respose size:",request:getResponseDataLength())
		    	local cookiestr = event.request:getCookieString()
		    	if string.len(cookiestr) >5 then
		    		cookie = network.parseCookie(cookiestr)
		    	end
		    	--保存文件
		        if _savaPath then
				    request:saveResponseData(_savaPath)
				    print("HTTP saveFile ".._savaPath.." done!")
		    	end
		    	--成功回调
		    	if db[tag] and db[tag].success then
		        	db[tag].success(response, _subTag)
		        end
	        else --失败
	            print("http请求失败，返回码: ", code)
	            local res = {}
	            res.response = request:getResponseData()
	            res.code = code.."+"
	            if db[tag] and db[tag].fail then
	            	db[tag].fail(res, _subTag)
	            end
	        end
	    --请求失败，地址错或者网络不通
	    elseif "failed" == event.name then
	    	local res = {}
            res.response = "Not Found"
            res.code = 404
            if request then
            	print("http请求失败: ",request:getErrorCode(), request:getErrorMessage())
        	end
        	-- g_SMG:removeWaitLayer()
            if db[tag] and db[tag].fail then
            	db[tag].fail(res, _subTag)
            end
	    --下载进度
		elseif "progress" == event.name then
			if db[tag] and db[tag].progress then
				db[tag].progress( event.total, event.dltotal, _subTag)
			end
	    --取消请求
	    elseif "cancelled" == event.name then
	    	print("TPHttp.request_ cancelled")
	    --未知情况 unknown
		else
			print("TPHttp.request_ unknown")
		end
	end

    -- if self.xhr == nil then
    --     self.xhr = cc.XMLHttpRequest:new()
    --     self.xhr:retain()
    --     self.xhr.timeout = 30 -- 设置超时时间
    -- end
    -- self.xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- local refreshTokenURL = needurl
    -- self.xhr:open("GET", refreshTokenURL)
    -- self.xhr:registerScriptHandler( handler(self,self.onResp) )
    -- self.xhr:send()

    local request = cc.XMLHttpRequest:new()
    request.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    request.timeout = 30 -- 设置超时时间
    request:registerScriptHandler(httpCallback)
    request:open(_way,_url)
    request:send()


	-- --发送请求
	-- -- print("TPHttp _url", _url)
 --    local request = network.createHTTPRequest(httpCallback, _url, _way)
 --    if _way == "POST" then
 --    	request:setCookieString(network.makeCookieString(cookie))
 --        request:setPOSTData(_data)
 
 --  --       for k, v in pairs(_data) do
	-- 	-- 	request:addPOSTValue(k,v)
	-- 	-- end
 --    end
 --    -- request:setTimeout(10)
 --    request:start()
end

--get
function m.GET(_url, _listenTag, _subTag)
	m.request_("GET", _url, nil, _listenTag, _subTag, nil)
end

--post
function m.POST(_url, _data, _listenTag, _subTag)
	m.request_("POST", _url, json.encode(_data), _listenTag, _subTag, nil)
end

--dowload
function m.Download(_url, _listenTag, _subTag, _savaPath)
	m.request_("GET", _url, nil, _listenTag, _subTag, _savaPath)
end
function m.test()
	m.Download("https://www.baidu.com/img/bd_logo1.png","BaiduIcon",nil,nil)
end

return m
