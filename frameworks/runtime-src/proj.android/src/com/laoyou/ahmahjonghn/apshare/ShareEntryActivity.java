package com.laoyou.ahmahjonghn.apshare;

//社交分享应用工具通用事件处理接口
import com.alipay.share.sdk.openapi.IAPAPIEventHandler;
//社交分享应用工具接口类，便于对社交分享开放接口的调用
import com.alipay.share.sdk.openapi.IAPApi;
//社交分享应用工具工厂类，用于创建工具实例
import com.alipay.share.sdk.openapi.APAPIFactory;
//社交分享应用的通用请求对象
import com.alipay.share.sdk.openapi.BaseReq;
//社交分享应用的通用响应对象
import com.alipay.share.sdk.openapi.BaseResp;
import com.alipay.share.sdk.openapi.SendMessageToZFB;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import org.cocos2dx.lua.AppActivity;

public class ShareEntryActivity extends Activity implements IAPAPIEventHandler{
	// IAPApi 是第三方app和支付宝通信的openapi接口
	private static IAPApi zfbApi;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Log.v("ShareEntryActivity", "onCreate");

		// 通过WXAPIFactory工厂，获取IAPApi的实例
		zfbApi = APAPIFactory.createZFBApi(getApplicationContext(), AppActivity.ZFB_APP_ID, false);
		zfbApi.handleIntent(getIntent(), this);
	}

	@Override
	public void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		zfbApi.handleIntent(intent, this);
	}

	// 支付宝发送请求到第三方应用时，会回调到该方法
	@Override
	public void onReq(BaseReq req) {
		switch (req.getType()) {
//		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
//			goToGetMsg();
//			break;
//		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
//			goToShowMsg((ShowMessageFromWX.Req) req);
//			break;
//		default:
//			break;
		}
	}

	// 第三方应用发送到支付宝的请求处理后的响应结果，会回调到该方法
	@Override
	   public void onResp(BaseResp baseResp) {
        switch (baseResp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
            	if(baseResp instanceof SendMessageToZFB.Resp) {
    				String authCode = "success";
    				Log.v("WXEntryActivity", "authCode:" + authCode);
    				String str = String.valueOf(BaseResp.ErrCode.ERR_OK) + "&" + "success";
    				AppActivity.LuaCallBackFun(str);
    			}
    			break;
            case BaseResp.ErrCode.ERR_USER_CANCEL:
				String str = String.valueOf(BaseResp.ErrCode.ERR_USER_CANCEL) + "&" + "用户取消";
				AppActivity.LuaCallBackFun(str);
                break;
            case BaseResp.ErrCode.ERR_AUTH_DENIED:
				String str1 = String.valueOf(BaseResp.ErrCode.ERR_AUTH_DENIED) + "&" + "已拒绝";
				AppActivity.LuaCallBackFun(str1);
                break;
            case BaseResp.ErrCode.ERR_SENT_FAILED:
            	
				String str2 = String.valueOf(BaseResp.ErrCode.ERR_SENT_FAILED) + "&" + "success";
				AppActivity.LuaCallBackFun(str2);
                break;
            default:
                break;
        }
        this.finish();
    }
}