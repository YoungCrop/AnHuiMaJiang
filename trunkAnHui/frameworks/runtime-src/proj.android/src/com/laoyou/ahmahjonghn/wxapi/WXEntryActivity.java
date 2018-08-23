package com.laoyou.ahmahjonghn.wxapi;

import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import org.cocos2dx.lua.AppActivity;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{
	// IWXAPI 是第三方app和微信通信的openapi接口
	private static IWXAPI wxApi;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		Log.v("WXEntryActivity", "onCreate");

		// 通过WXAPIFactory工厂，获取IWXAPI的实例
		wxApi = WXAPIFactory.createWXAPI(this, AppActivity.WX_APP_ID, false);
		wxApi.handleIntent(getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);

		setIntent(intent);
		wxApi.handleIntent(intent, this);
	}

	// 微信发送请求到第三方应用时，会回调到该方法
	@Override
	public void onReq(BaseReq req) {
		
		
		Log.v("onReqWX", " = "+req.getType());
		
		
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			
			break;
		default:
			break;
		}
	}

	// 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
	@Override
	public void onResp(BaseResp resp) {
		Log.v("onRespWX", " = "+resp.errCode);
		
//		  public static final int ERR_OK = 0;
//		  
//		  // Field descriptor #18 I
//		  public static final int ERR_COMM = -1;
//		  
//		  // Field descriptor #18 I
//		  public static final int ERR_USER_CANCEL = -2;
//		  
//		  // Field descriptor #18 I
//		  public static final int ERR_SENT_FAILED = -3;
//		  
//		  // Field descriptor #18 I
//		  public static final int ERR_AUTH_DENIED = -4;
//		  
//		  // Field descriptor #18 I
//		  public static final int ERR_UNSUPPORT = -5;

		String authCode = String.valueOf(resp.errCode);
		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			if (resp instanceof SendAuth.Resp) {
				authCode = ((SendAuth.Resp) resp).code;
				Log.v("WXEntryActivity", "authCode:" + authCode);
			}else if(resp instanceof SendMessageToWX.Resp) {
			}
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			break;
		default:
			break;
		}
		AppActivity.LuaCallBackFun(authCode);
		this.finish();
	}
}