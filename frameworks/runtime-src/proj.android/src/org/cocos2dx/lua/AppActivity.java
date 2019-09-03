/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lua;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaRecorder;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.Settings;
import android.telephony.PhoneStateListener;
import android.telephony.SignalStrength;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.WindowManager;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.Toast;
import cn.magicwindow.MLinkAPIFactory;
import cn.magicwindow.MWConfiguration;
import cn.magicwindow.MagicWindowSDK;
import cn.magicwindow.Session;
import cn.magicwindow.mlink.MLinkCallback;
import cn.magicwindow.mlink.YYBCallback;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationClientOption.AMapLocationMode;
import com.amap.api.location.AMapLocationClientOption.AMapLocationProtocol;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps2d.AMapUtils;
import com.amap.api.maps2d.model.LatLng;
import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.WeiboAppManager;
import com.sina.weibo.sdk.api.ImageObject;
import com.sina.weibo.sdk.api.TextObject;
import com.sina.weibo.sdk.api.WebpageObject;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.WbAppInfo;
import com.sina.weibo.sdk.share.WbShareCallback;
import com.sina.weibo.sdk.share.WbShareHandler;
import com.tencent.connect.share.QQShare;
import com.tencent.connect.share.QzoneShare;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXTextObject;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;
import com.laoyou.ahmahjonghn.R;
import com.laoyou.ahmahjonghn.Util;
import com.yunva.im.sdk.lib.core.YunvaImSdk;
import com.yunva.im.sdk.lib.event.MessageEvent;
import com.yunva.im.sdk.lib.event.MessageEventListener;
import com.yunva.im.sdk.lib.event.MessageEventSource;
import com.yunva.im.sdk.lib.event.RespInfo;
import com.yunva.im.sdk.lib.event.msgtype.MessageType;
import com.yunva.im.sdk.lib.model.tool.ImAudioRecordResp;
import com.yunva.im.sdk.lib.model.tool.ImUploadFileResp;
import com.alibaba.sdk.android.feedback.impl.FeedbackAPI;
//-----------------------------支付宝分享-------------------//
//社交分享开放工具接口类，便于对社交分享开放接口的调用
import com.alipay.share.sdk.openapi.IAPApi;
//社交分享开放工具工厂类，用于创建工具实例
import com.alipay.share.sdk.openapi.APAPIFactory;
//普通文本消息内容定义类
import com.alipay.share.sdk.openapi.APTextObject;
//图片消息内容定义类
import com.alipay.share.sdk.openapi.APImageObject;
//网页Card消息内容定义类
import com.alipay.share.sdk.openapi.APWebPageObject;
//分享消息定义类
import com.alipay.share.sdk.openapi.APMediaMessage;
//分享消息请求包装类
import com.alipay.share.sdk.openapi.SendMessageToZFB;
//---------------------------支付宝分享END-------------------//










import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

public class AppActivity extends Cocos2dxActivity implements
		OnCheckedChangeListener, MessageEventListener, AMapLocationListener,
		WbShareCallback {

	public static AppActivity appThis = null;
	private static Activity mActivity = null;

	public static final String WX_APP_ID = "wx1cfbd0c36d76b153";
	private static IWXAPI wxApi;
	private static int authCodeScriptHandler = 0;
	private static int roomIDScriptHandler = 0;
	private static final int THUMB_SIZE = 150;

	private static boolean isInitYun = false;

	private static MediaRecorder mRecorder = null;

	private Context mContext;
	private static Context myContext;
	private final String mPageName = "AppActivity";

	TelephonyManager Tel;// TelephonyManager类的对象

	MyPhoneStateListener MyListener;// MyPhoneStateListener类的对象，即设置一个监听器对象

	private WifiInfo wifiInfo = null; // 获得的Wifi信息
	private WifiManager wifiManager = null; // Wifi管理器
	private Handler handler;
	private int wifilevel; // 信号强度值

	// 信号强度
	private static int signalLevel;
	private static int noWifiSignalLevel;

	static String hostIPAdress = "0.0.0.0";

	// 定位
	static String locAddres = "";
	static double lati = 0f;
	static double logi = 0f;
	static String location = "";
	private AMapLocationClient locationClient = null;
	private AMapLocationClientOption locationOption = new AMapLocationClientOption();

	//阿里云反馈
	private static String Feedback_AppKey = "24770639";
	private static String Feedback_AppSecret = "4b66446ab3f0d0a737b54e0879852c99";
	
	// 魔窗
	public static String roomID = "";
	public static String userParam = "";

	// QQ
	public static final String QQ_APP_ID = "1106467561";// 其前面没有tencent
	private static Tencent mTencent;
	private static ShareListener mShareListener;// 回调监听
	private static int callBackScriptHandler = 0;// 回调handler

	// 支付宝分享
	public static final String ZFB_APP_ID = "2017121900990381";
	private static IAPApi zfbApi;

	// WeiBo分享
	public static final String WeiBo_APP_KEY = "3726064055";
	public static final String WeiBo_REDIRECT_URL = "http://www.sina.com";// 应用的回调页
	public static final String WeiBo_SCOPE = // 应用申请的高级权限
	"email,direct_messages_read,direct_messages_write,"
			+ "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
			+ "follow_app_official_microblog," + "invitation_write";

	public static WbShareHandler wbShareHandler;

	@SuppressLint("HandlerLeak")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		appThis = this;
		mContext = this;
		myContext = this;

		if (nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}

		// 第一步：初始化获得imsdk 实例 ,一定要先调用init()
		YunvaImSdk.getInstance().init(this, "1001018", getVoiceFolder(), false,
				false);
		YunvaImSdk.getInstance().setAppVesion(getAppVersionName());
		com.yunva.im.sdk.lib.YvLoginInit.context = this.getApplication();
		com.yunva.im.sdk.lib.YvLoginInit.initApplicationOnCreate(
				this.getApplication(), "1001018");

		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_LOGIN_RESP, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_THIRD_LOGIN_RESP, this);

		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_RECONNECTION_NOTIFY, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_RECORD_STOP_RESP, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_RECORD_FINISHPLAY_RESP, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_SPEECH_STOP_RESP, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_NET_STATE_NOTIFY, this);
		MessageEventSource.getSingleton().addLinstener(
				MessageType.IM_UPLOAD_FILE_RESP, this);

		mActivity = this;
		// 2.Set the format of window
		registerAppToWX();

		initLocation();

		// 注册电量的广播监听
		IntentFilter intentFilter = new IntentFilter(
				Intent.ACTION_BATTERY_CHANGED);
		BatteryReceiver batteryReceiver = new BatteryReceiver();
		registerReceiver(batteryReceiver, intentFilter);

		@SuppressWarnings("unused")
		String type = getCurrentNetworkType();
		// Toast.makeText(getApplicationContext(),
		// "当前手机的网络是 = "
		// + type,
		// Toast.LENGTH_SHORT).show();

		MyListener = new MyPhoneStateListener();// 初始化对象
		Tel = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);// Return
																				// the
																				// handle
																				// to
																				// a
																				// system-level
																				// service
																				// by
																				// name.通过名字获得一个系统级服务
		Tel.listen(MyListener, PhoneStateListener.LISTEN_SIGNAL_STRENGTHS);// Registers
																			// a
																			// listener
																			// object
																			// to
																			// receive
																			// notification
																			// of
																			// changes
																			// in
																			// specified
																			// telephony
																			// states.设置监听器监听特定事件的状态

		// 获得WifiManager
		wifiManager = (WifiManager) getSystemService(WIFI_SERVICE);

		// 使用定时器,每隔5秒获得一次信号强度值
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			@Override
			public void run() {
				wifiInfo = wifiManager.getConnectionInfo();
				// 获得信号强度值
				wifilevel = wifiInfo.getRssi();
				// 根据获得的信号强度发送信息
				if (wifilevel <= 0 && wifilevel >= -50) {
					Message msg = new Message();
					msg.what = 1;
					handler.sendMessage(msg);
				} else if (wifilevel < -50 && wifilevel >= -70) {
					Message msg = new Message();
					msg.what = 2;
					handler.sendMessage(msg);
				} else if (wifilevel < -70 && wifilevel >= -80) {
					Message msg = new Message();
					msg.what = 3;
					handler.sendMessage(msg);
				} else if (wifilevel < -80 && wifilevel >= -100) {
					Message msg = new Message();
					msg.what = 4;
					handler.sendMessage(msg);
				} else {
					Message msg = new Message();
					msg.what = 5;
					handler.sendMessage(msg);
				}

			}

		}, 1000, 1000);
		// 使用Handler实现UI线程与Timer线程之间的信息传递,每5秒告诉UI线程获得wifiInto
		handler = new Handler() {

			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				// 如果收到正确的消息就获取WifiInfo，改变图片并显示信号强度
				case 1:
					// Toast.makeText(getApplicationContext(),
					// "信号强度：" + wifilevel + " 信号最好", Toast.LENGTH_SHORT)
					// .show();
					signalLevel = 3;
					break;
				case 2:
					// Toast.makeText(getApplicationContext(),
					// "信号强度：" + wifilevel + " 信号较好", Toast.LENGTH_SHORT)
					// .show();
					signalLevel = 2;
					break;
				case 3:
					// Toast.makeText(getApplicationContext(),
					// "信号强度：" + wifilevel + " 信号一般", Toast.LENGTH_SHORT)
					// .show();
					signalLevel = 2;
					break;
				case 4:
					// Toast.makeText(getApplicationContext(),
					// "信号强度：" + wifilevel + " 信号较差", Toast.LENGTH_SHORT)
					// .show();
					signalLevel = 1;
					break;
				case 5:
					// Toast.makeText(getApplicationContext(),
					// "信号强度：" + wifilevel + " 无信号", Toast.LENGTH_SHORT)
					// .show();
					signalLevel = 0;
					break;
				default:
					// 以防万一
					signalLevel = 0;
					// Toast.makeText(getApplicationContext(), "无信号",
					// Toast.LENGTH_SHORT).show();
				}
			}

		};

		// Check the wifi is opened when the native is debug.
		if (nativeIsDebug()) {
			getWindow().setFlags(
					WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
					WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
			if (!isNetworkConnected()) {
				AlertDialog.Builder builder = new AlertDialog.Builder(this);
				builder.setTitle("Warning");
				builder.setMessage("Please open WIFI for debuging...");
				builder.setPositiveButton("OK",
						new DialogInterface.OnClickListener() {

							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								startActivity(new Intent(
										Settings.ACTION_WIFI_SETTINGS));
								finish();
								Session.onKillProcess();
								System.exit(0);
							}
						});

				builder.setNegativeButton("Cancel", null);
				builder.setCancelable(true);
				builder.show();
			}
			hostIPAdress = getHostIpAddress();
		}

		initMW();
		if (getIntent().getData() != null) {
			MLinkAPIFactory.createAPI(this).router(this, getIntent().getData());
		} else {
			MLinkAPIFactory.createAPI(this).checkYYB(mContext,
					new YYBCallback() {
						@Override
						public void onFailed(Context mContext) {

						}

						@Override
						public void onSuccess() {
							// finish();
						}
					});
		}
		mTencent = Tencent.createInstance(QQ_APP_ID,
				this.getApplicationContext());
		mShareListener = new ShareListener();

		// 支付宝分享
		zfbApi = APAPIFactory.createZFBApi(getApplicationContext(), ZFB_APP_ID,
				true);
		FeedbackAPI.init(this.getApplication(), Feedback_AppKey,Feedback_AppSecret);

		// mWeiboShareAPI = WeiboShareSDK.createWeiboAPI(this, WeiBo_APP_ID);
		// WbShareHandle weiBoShareHandler = new WbShareHandle(this);

		WbSdk.install(this, new AuthInfo(this, WeiBo_APP_KEY,
				WeiBo_REDIRECT_URL, WeiBo_SCOPE));
		wbShareHandler = new WbShareHandler(this);
		wbShareHandler.registerApp();
	}

	public void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		wbShareHandler.doResultIntent(intent, this);
		this.setIntent(intent);
		Uri mLink = intent.getData();
		if (mLink != null) {
			MLinkAPIFactory.createAPI(this).router(mLink);
		} else {
			MLinkAPIFactory.createAPI(this).checkYYB(mContext,
					new YYBCallback() {
						@Override
						public void onFailed(Context mContext) {

						}

						@Override
						public void onSuccess() {
							// finish();
						}
					});
		}
	}

	private static void register(Context context) {
		MLinkAPIFactory.createAPI(context).registerDefault(new MLinkCallback() {
			@Override
			public void execute(Map<String, String> map, Uri uri,
					Context context) {
				if (map != null) {
					roomID = map.get("roomID");
					userParam = map.get("userParam");
				} else if (uri != null) {
					roomID = uri.getQueryParameter("roomID");
					userParam = uri.getQueryParameter("userParam");
				}
			}

			// mLinkKey: mLink 的 key, mLink的唯一标识
		});
		MLinkAPIFactory.createAPI(context).register("openAnHuiMJApp",
				new MLinkCallback() {
					public void execute(Map<String, String> map, Uri uri,
							Context context) {
						if (map != null) {
							roomID = map.get("roomID");
							userParam = map.get("userParam");
						} else if (uri != null) {
							roomID = uri.getQueryParameter("roomID");
							userParam = uri.getQueryParameter("userParam");
						}
					}
				});
	}

	private void initMW() {
		MWConfiguration config = new MWConfiguration(this);
		// config.setLogEnable(true)
		config.setDebugModel(true).setPageTrackWithFragment(true)
				.setWebViewBroadcastOpen(true)
				.setSharePlatform(MWConfiguration.ORIGINAL);
		MagicWindowSDK.initSDK(config);
		register(this);
	}

	@Override
	public void onResume() {
		Session.onResume(this);
		super.onResume();

		Tel.listen(MyListener, PhoneStateListener.LISTEN_SIGNAL_STRENGTHS);

	}

	@Override
	public void onPause() {
		Session.onPause(this);
		super.onPause();

		Tel.listen(MyListener, PhoneStateListener.LISTEN_NONE);
	}

	@Override
	protected void onStart() {
		super.onStart();
		Uri mLink = getIntent().getData();
		if (mLink != null) {
			MLinkAPIFactory.createAPI(this).router(mLink);
		} else {
			MLinkAPIFactory.createAPI(this).checkYYB(mContext,
					new YYBCallback() {
						@Override
						public void onFailed(Context mContext) {

						}

						@Override
						public void onSuccess() {
							// finish();
						}
					});
		}
	}

	private class MyPhoneStateListener extends PhoneStateListener {
		// 监听器类
		/* 得到信号的强度由每个tiome供应商,有更新 */

		@Override
		public void onSignalStrengthsChanged(SignalStrength signalStrength) {

			super.onSignalStrengthsChanged(signalStrength);// 调用超类的该方法，在网络信号变化时得到回答信号

			@SuppressWarnings("unused")
			String str;

			if (!signalStrength.isGsm()) {

				int dBm = signalStrength.getCdmaDbm();

				if (dBm >= -75) {
					str = "信号强大";
					noWifiSignalLevel = 3;
				} else if (dBm >= -85) {
					str = "信号好";
					noWifiSignalLevel = 2;
				} else if (dBm >= -95) {
					str = "信号适中";
					noWifiSignalLevel = 2;
				} else if (dBm >= -100) {
					str = "信号差";
					noWifiSignalLevel = 1;
				} else {
					str = "没有信号或者未知信号";
					noWifiSignalLevel = 0;
				}

				// Toast.makeText(getApplicationContext(),
				// "DBM ="+String.valueOf(dBm), Toast.LENGTH_SHORT).show();

			} else {

				int asu = signalStrength.getGsmSignalStrength();

				if (asu <= 2 || asu == 99) {
					str = "没有信号或者未知信号";
					noWifiSignalLevel = 0;
				} else if (asu >= 12) {
					str = "信号强大";
					noWifiSignalLevel = 3;
				} else if (asu >= 8) {
					str = "信号好";
					noWifiSignalLevel = 2;
				} else if (asu >= 5) {
					str = "信号适中";
					noWifiSignalLevel = 2;
				} else {
					str = "信号差";
					noWifiSignalLevel = 1;
				}

				// Toast.makeText(getApplicationContext(),
				// "ASU ="+String.valueOf(asu), Toast.LENGTH_SHORT).show();
			}
		}
	}

	private boolean isNetworkConnected() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm != null) {
			NetworkInfo networkInfo = cm.getActiveNetworkInfo();

			ArrayList<Integer> networkTypes = new ArrayList<Integer>();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField(
						"TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			} catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null
					&& networkTypes.contains(networkInfo.getType())) {
				return true;
			}
		}
		return false;
	}

	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "."
				+ ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}

	public static String getLocalIpAddress() {
		return hostIPAdress;
	}

	private static native boolean nativeIsLandScape();

	private static native boolean nativeIsDebug();

	public boolean dispatchKeyEvent(KeyEvent event) {
		return super.dispatchKeyEvent(event);
	}

	private DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
		public void onClick(DialogInterface dialog, int which) {
			switch (which) {
			case AlertDialog.BUTTON_POSITIVE: {
				AppActivity.this.finish();
			}
				break;
			default:
				break;
			}
		}
	};

	private void registerAppToWX() {
		wxApi = WXAPIFactory.createWXAPI(this, WX_APP_ID, true);
		wxApi.registerApp(WX_APP_ID);
	}

	private static String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis())
				: type + System.currentTimeMillis();
	}

	public static boolean isWXAppInstalled() {
		Log.v("AppActivity", "isWXAppInstalled");
		return wxApi.isWXAppInstalled();
	}

	public static void sendAuthRequest(int handler) {
		Log.v("AppActivity", "sendAuthRequest");

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;
		
		final SendAuth.Req req = new SendAuth.Req();
		req.scope = "snsapi_userinfo";
		req.state = "wechat_sdk_demo_test";
		wxApi.sendReq(req);
	}

	private static int mBatteryLevel;

	class BatteryReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context arg0, Intent arg1) {
			// TODO Auto-generated method stub
			arg0.unregisterReceiver(this);
			int rawlevel = arg1.getIntExtra("level", -1);// 获得当前电量
			int scale = arg1.getIntExtra("scale", -1); // 获得总电量
			int level = -1;
			if (rawlevel >= 0 && scale > 0) {
				level = (rawlevel * 100) / scale;
			}
			mBatteryLevel = level;
			// Toast.makeText(getApplicationContext(),
			// "当前电池的电量是 = "
			// + String.valueOf(mBatteryLevel),
			// Toast.LENGTH_SHORT).show();
		}

	}

	// 网络类型

	private static final int NETWORK_TYPE_UNAVAILABLE = -1;
	private static final int NETWORK_TYPE_WIFI = -101;

	private static final int NETWORK_CLASS_WIFI = -101;
	private static final int NETWORK_CLASS_UNAVAILABLE = -1;
	/** Unknown network class. */
	private static final int NETWORK_CLASS_UNKNOWN = 0;
	/** Class of broadly defined "2G" networks. */
	private static final int NETWORK_CLASS_2_G = 1;
	/** Class of broadly defined "3G" networks. */
	private static final int NETWORK_CLASS_3_G = 2;
	/** Class of broadly defined "4G" networks. */
	private static final int NETWORK_CLASS_4_G = 3;

	private static String networkType;

	public static String getCurrentNetworkType() {
		int networkClass = getNetworkClass();
		String type = "未知";
		switch (networkClass) {
		case NETWORK_CLASS_UNAVAILABLE:
			type = "无";
			break;
		case NETWORK_CLASS_WIFI:
			type = "WIFI";
			break;
		case NETWORK_CLASS_2_G:
			type = "2G";
			break;
		case NETWORK_CLASS_3_G:
			type = "3G";
			break;
		case NETWORK_CLASS_4_G:
			type = "4G";
			break;
		case NETWORK_CLASS_UNKNOWN:
			type = "未知";
			break;
		}
		networkType = type;
		return type;
	}

	// 适配低版本手机
	/** Network type is unknown */
	public static final int NETWORK_TYPE_UNKNOWN = 0;
	/** Current network is GPRS */
	public static final int NETWORK_TYPE_GPRS = 1;
	/** Current network is EDGE */
	public static final int NETWORK_TYPE_EDGE = 2;
	/** Current network is UMTS */
	public static final int NETWORK_TYPE_UMTS = 3;
	/** Current network is CDMA: Either IS95A or IS95B */
	public static final int NETWORK_TYPE_CDMA = 4;
	/** Current network is EVDO revision 0 */
	public static final int NETWORK_TYPE_EVDO_0 = 5;
	/** Current network is EVDO revision A */
	public static final int NETWORK_TYPE_EVDO_A = 6;
	/** Current network is 1xRTT */
	public static final int NETWORK_TYPE_1xRTT = 7;
	/** Current network is HSDPA */
	public static final int NETWORK_TYPE_HSDPA = 8;
	/** Current network is HSUPA */
	public static final int NETWORK_TYPE_HSUPA = 9;
	/** Current network is HSPA */
	public static final int NETWORK_TYPE_HSPA = 10;
	/** Current network is iDen */
	public static final int NETWORK_TYPE_IDEN = 11;
	/** Current network is EVDO revision B */
	public static final int NETWORK_TYPE_EVDO_B = 12;
	/** Current network is LTE */
	public static final int NETWORK_TYPE_LTE = 13;
	/** Current network is eHRPD */
	public static final int NETWORK_TYPE_EHRPD = 14;
	/** Current network is HSPA+ */
	public static final int NETWORK_TYPE_HSPAP = 15;

	private static int getNetworkClass() {
		int networkType = NETWORK_TYPE_UNKNOWN;

		ConnectivityManager connectMgr = (ConnectivityManager) myContext
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo network = connectMgr.getActiveNetworkInfo();
		if (network == null) {
			return NETWORK_CLASS_UNAVAILABLE;
		}
		int type = network.getType();
		if (type == ConnectivityManager.TYPE_WIFI) {
			networkType = NETWORK_TYPE_WIFI;
		} else if (type == ConnectivityManager.TYPE_MOBILE) {
			TelephonyManager telephonyManager = (TelephonyManager) myContext
					.getSystemService(Context.TELEPHONY_SERVICE);
			networkType = telephonyManager.getNetworkType();
		}

		return getNetworkClassByType(networkType);

	}

	private static int getNetworkClassByType(int networkType) {
		switch (networkType) {
		case NETWORK_TYPE_UNAVAILABLE:
			return NETWORK_CLASS_UNAVAILABLE;
		case NETWORK_TYPE_WIFI:
			return NETWORK_CLASS_WIFI;
		case NETWORK_TYPE_GPRS:
		case NETWORK_TYPE_EDGE:
		case NETWORK_TYPE_CDMA:
		case NETWORK_TYPE_1xRTT:
		case NETWORK_TYPE_IDEN:
			return NETWORK_CLASS_2_G;
		case NETWORK_TYPE_UMTS:
		case NETWORK_TYPE_EVDO_0:
		case NETWORK_TYPE_EVDO_A:
		case NETWORK_TYPE_HSDPA:
		case NETWORK_TYPE_HSUPA:
		case NETWORK_TYPE_HSPA:
		case NETWORK_TYPE_EVDO_B:
		case NETWORK_TYPE_EHRPD:
		case NETWORK_TYPE_HSPAP:
			return NETWORK_CLASS_3_G;
		case NETWORK_TYPE_LTE:
			return NETWORK_CLASS_4_G;
		default:
			return NETWORK_CLASS_UNKNOWN;
		}
	}

	// 电量
	public static String getDeviceBattery() {

		return String.valueOf(mBatteryLevel);
	}

	// wifi信号强度
	public static String getDeviceSignalLevel() {

		return String.valueOf(signalLevel);
	}

	// 非wifi信号强度
	public static String getDeviceNoWifiLevel() {

		return String.valueOf(noWifiSignalLevel);
	}

	// 网络类型
	public static String getDeviceSignalStatus() {

		return networkType;
	}

	public static String getDeviceSignal() {
		if ("WIFI" == networkType) {
			return String.valueOf(signalLevel);
		} else {
			return String.valueOf(noWifiSignalLevel);
		}
	}

	public static void shareImageToWX(final int wxScene, final String filePath,final int handler) {
		Log.v("AppActivity", "filePath:" + filePath);

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;
		Bitmap bmp = BitmapFactory.decodeFile(filePath);
		WXImageObject imgObj = new WXImageObject(bmp);

		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = imgObj;

		Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
				(int) (THUMB_SIZE / (double) bmp.getWidth() * bmp.getHeight()),
				true);
		bmp.recycle();
		msg.thumbData = Util.bmpToByteArray(thumbBmp, true);

		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("img");
		req.message = msg;

		// public static final int WXSceneSession = 0;
		// public static final int WXSceneTimeline = 1;
		req.scene = wxScene;
		wxApi.sendReq(req);
	}

	public static void shareTextToWX(final int wxScene, final String txt,final int handler) {
		Log.v("AppActivity", "shareTextToWX txt:" + txt);

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;
		
		WXTextObject textObject = new WXTextObject();// 初始化一个WXTextObject对象
		textObject.text = txt;

		WXMediaMessage msg = new WXMediaMessage();// 用WXTextObject对象初始化一个WXMediaMessage
		msg.mediaObject = textObject;
		msg.description = txt;

		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("text");
		req.message = msg;

		// public static final int WXSceneSession = 0;
		// public static final int WXSceneTimeline = 1;

		req.scene = wxScene;
		wxApi.sendReq(req);
	}

	public static void shareURLToWX(final int wxScene, final String url,
			final String title, final String description,final int handler) {
		Log.v("AppActivity", "url:" + url + " title:" + title + " description:"
				+ description);

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = url;

		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = title;
		msg.description = description;
		int WX_THUMB_SIZE = 120;
		Bitmap thumb = BitmapFactory.decodeResource(mActivity.getResources(),
				R.drawable.icon);
		Bitmap thumbBmp = Bitmap.createScaledBitmap(thumb, WX_THUMB_SIZE,
				WX_THUMB_SIZE, true);
		thumb.recycle();
		msg.thumbData = Util.bmpToByteArray(thumbBmp, true);

		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("url");
		req.message = msg;
		

		// public static final int WXSceneSession = 0;
		// public static final int WXSceneTimeline = 1;//朋友圈
		
		req.scene = wxScene;
		wxApi.sendReq(req);
	}

	public static void startVoiceRecord(final String filePath) {
		mRecorder = new MediaRecorder();
		mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
		mRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
		mRecorder.setOutputFile(filePath);
		mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		try {
			mRecorder.prepare();
		} catch (IOException e) {
			// Log.e(LOG_TAG, "prepare() failed");
		}
		mRecorder.start();
	}

	public static String getAppVersionName() {
		String versionName = "";
		try {
			// ---get the package info---
			PackageManager pm = myContext.getPackageManager();
			PackageInfo pi = pm.getPackageInfo(myContext.getPackageName(), 0);
			versionName = pi.versionName;
			if (versionName == null || versionName.length() <= 0) {
				return "";
			}
		} catch (Exception e) {
			Log.e("VersionInfo", "Exception", e);
		}
		return versionName;
	}

	public static void stopVoiceRecord() {
		mRecorder.stop();
		mRecorder.release();
		mRecorder = null;
	}

	public static void openWebURL(String url) {
		Log.v("AppActivity", "openWebURL+++++++++++++:" + url);
		Intent mIntent = new Intent(Intent.ACTION_VIEW);
		mIntent.setData(Uri.parse(url));
		mActivity.startActivity(mIntent);
	}

	public static boolean startVoice() {

		Log.v("AppActivity", "开始录制语音============================>");

		YunvaImSdk.getInstance().stopPlayAudio();
		YunvaImSdk.getInstance().stopAudioRecord();

		voiceUrl = "";
		musicTime = 0;

		boolean start = YunvaImSdk.getInstance().startAudioRecord(
				getVoiceFolder() + "/laoyouAnHuiMJ.amr", "android", (byte) 2);
		// boolean start = YunvaImSdk.getInstance().startAudioRecognizeUrl("",
		// "");
		if (!start) {
			Toast.makeText(mActivity, "请开启系统录音权限！", Toast.LENGTH_SHORT).show();
		}

		return true;
	}

	public static boolean stopVoice() {
		Log.v("AppActivity", "停止录制语音============================>");
		YunvaImSdk.getInstance().stopAudioRecord();
		return true;
	}

	public static boolean cancelVoice() {
		Log.v("AppActivity", "取消录制语音============================>");
		YunvaImSdk.getInstance().stopAudioRecord();
		return true;
	}

	public static String getVoiceUrl() {
		Log.v("AppActivity", "获取语音URL============================>" + voiceUrl);
		return voiceUrl;
	}

	public static void playVoice(String url) {
		Log.v("AppActivity", "播放录制语音============================>" + url);
		YunvaImSdk.getInstance().playAudio(url, "", "");
	}

	public static boolean hasSdcard() {
		String status = Environment.getExternalStorageState();
		if (status.equals(Environment.MEDIA_MOUNTED)) {
			return true;
		} else {
			return false;
		}
	}

	public static final String path = Environment.getExternalStorageDirectory()
			.toString() + "/yunva_sdk_lite";

	public static final String voice_path = path + "/voice";

	public static String getVoiceFolder() {
		if (hasSdcard()) {
			return voice_path;
		} else {
			return getContext().getFilesDir().getAbsolutePath()
					+ File.separator + "voice" + File.separator;
		}
	}

	static String voiceUrl = "";
	static int musicTime = 0;
	@SuppressLint("HandlerLeak")
	private Handler myHandler = new Handler() {
		public void handleMessage(Message msg) {
			getLooper();
			@SuppressWarnings("unused")
			int code = msg.arg1;

			Log.v("AppActivity", "语音what============================>"
					+ msg.what);
			switch (msg.what) {
			case MessageType.IM_NET_STATE_NOTIFY:
				break;
			case MessageType.IM_RECORD_STOP_RESP:
				// 语音录制完成，恢复背景音

				 ImAudioRecordResp imAudioRecordResp = (ImAudioRecordResp)
				 msg.obj;
				 musicTime = imAudioRecordResp.getTime()/1000;
				 YunvaImSdk.getInstance().uploadFile(imAudioRecordResp.getStrfilepath(),
				 "upload");
				
				 Log.v("AppActivity",
				 "imAudioRecordResp.getStrfilepath()============================>"
				 + imAudioRecordResp.getStrfilepath());
				break;
			case MessageType.IM_SPEECH_STOP_RESP:
				// 停止语音识别返回
				break;
			case MessageType.IM_UPLOAD_FILE_RESP:
				ImUploadFileResp imUploadFileResp = (ImUploadFileResp) msg.obj;
				voiceUrl = imUploadFileResp.getFileUrl();
				voiceUrl = voiceUrl + "\\" + musicTime;
				Log.v("AppActivity",
						"ImUploadFileResp ============================> voiceUrl = "
								+ voiceUrl);
				// YunvaImSdk.getInstance().playAudio(voiceUrl, "", "");
				break;
			}
		}
	};

	@Override
	public void handleMessageEvent(MessageEvent event) {
		RespInfo msg = event.getMessage();
		Message chatmsg = new Message();
		Log.v("AppActivity",
				"语音chatmsg============================>" + event.getbCode());
		switch (event.getbCode()) {
		case MessageType.IM_RECORD_STOP_RESP:
			chatmsg.what = event.getbCode();
			chatmsg.obj = msg.getResultBody();
			chatmsg.arg1 = msg.getResultCode();
			myHandler.sendMessage(chatmsg);
			break;
		case MessageType.IM_SPEECH_STOP_RESP:
			chatmsg.what = event.getbCode();
			chatmsg.obj = msg.getResultBody();
			chatmsg.arg1 = msg.getResultCode();
			myHandler.sendMessage(chatmsg);
			break;
		case MessageType.IM_NET_STATE_NOTIFY:
			chatmsg.what = event.getbCode();
			chatmsg.obj = msg.getResultBody();
			chatmsg.arg1 = msg.getResultCode();
			myHandler.sendMessage(chatmsg);
			break;
		case MessageType.IM_UPLOAD_FILE_RESP:
			chatmsg.what = event.getbCode();
			chatmsg.obj = msg.getResultBody();
			chatmsg.arg1 = msg.getResultCode();
			myHandler.sendMessage(chatmsg);
			break;
		default:
			break;
		}

	}

	@Override
	public void onCheckedChanged(CompoundButton arg0, boolean arg1) {
		// TODO Auto-generated method stub
		Log.v("AppActivity", "语音onCheckedChanged============================>");
	}

	/**
	 * 初始化定位
	 * 
	 * @since 2.8.0
	 * @author hongming.wang
	 *
	 */
	private void initLocation() {
		// 初始化client
		locationClient = new AMapLocationClient(mContext);
		// 设置定位参数
		locationClient.setLocationOption(getDefaultOption());
		// 设置定位监听
		locationClient.setLocationListener(this);

		locationClient.startLocation();
	}

	/**
	 * 默认的定位参数
	 * 
	 * @since 2.8.0
	 * @author hongming.wang
	 *
	 */
	private AMapLocationClientOption getDefaultOption() {
		AMapLocationClientOption mOption = new AMapLocationClientOption();
		mOption.setLocationMode(AMapLocationMode.Hight_Accuracy);// 可选，设置定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
		mOption.setGpsFirst(false);// 可选，设置是否gps优先，只在高精度模式下有效。默认关闭
		mOption.setHttpTimeOut(30000);// 可选，设置网络请求超时时间。默认为30秒。在仅设备模式下无效
		mOption.setInterval(2000);// 可选，设置定位间隔。默认为2秒
		mOption.setNeedAddress(true);// 可选，设置是否返回逆地理地址信息。默认是true
		mOption.setOnceLocation(false);// 可选，设置是否单次定位。默认是false
		mOption.setOnceLocationLatest(false);// 可选，设置是否等待wifi刷新，默认为false.如果设置为true,会自动变为单次定位，持续定位时不要使用
		AMapLocationClientOption
				.setLocationProtocol(AMapLocationProtocol.HTTPS);// 可选，
																	// 设置网络请求的协议。可选HTTP或者HTTPS。默认为HTTP
		mOption.setSensorEnable(false);// 可选，设置是否使用传感器。默认是false
		mOption.setWifiScan(true); // 可选，设置是否开启wifi扫描。默认为true，如果设置为false会同时停止主动刷新，停止以后完全依赖于系统刷新，定位位置可能存在误差
		mOption.setLocationCacheEnable(true); // 可选，设置是否使用缓存定位，默认为true
		return mOption;
	}

	public static String getLocAddres() {
		return locAddres;
	}

	/**
	 * 定位监听
	 */

	@Override
	public void onLocationChanged(AMapLocation loc) {
		if (null != loc) {
			// 解析定位结果
			locAddres = loc.getAddress();
			lati = loc.getLatitude();
			logi = loc.getLongitude();
			Log.d("解析定位结果 OK = ", loc.getAddress());
		} else {
			Log.d("解析定位结果 ", "Error");
		}
	}

	public static String getLocation() {
		if (lati != 0 && logi != 0) {
			location = new StringBuilder().append(lati).append("_")
					.append(logi).toString();
		}
		return location;
	}

	public static float getDisByTwoPoint(float location1LA, float location1LT,
			float location2LA, float location2LT) {
		LatLng latLng1 = new LatLng(location1LA, location1LT);
		LatLng latLng2 = new LatLng(location2LA, location2LT);
		float distance = AMapUtils.calculateLineDistance(latLng1, latLng2);
		return distance;
	}

	public static String getRoomID() {
		if (roomID == null){
			return "";
		}
		return roomID;
	}

	public static void clearRoomID() {
		roomID = "";
	}

	public static String getUserParam() {
		if(userParam == null){
			return "";
		}
		return userParam;
	}

	public static void clearUserparam() {
		userParam = "";
	}

	@SuppressLint("NewApi")
	public static void copyText(final String text) {

		mActivity.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				ClipboardManager clipboardManager = (ClipboardManager) mActivity
						.getSystemService(Context.CLIPBOARD_SERVICE);
				clipboardManager.setPrimaryClip(ClipData.newPlainText(null,
						text));
				if (clipboardManager.hasPrimaryClip()) {
					clipboardManager.getPrimaryClip().getItemAt(0).getText();
				}
			}
		});
	}

	public static void shareTextToQQ(final int type, final String txt,
			final int handler) {
		System.out.println("AppActivity shareTextToQQ type" + type + " txt:"
				+ txt);
		final Bundle params = new Bundle();
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		// if (type == 2) {
		// params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE,QzoneShare.SHARE_TO_QZONE_TYPE_APP);
		// params.putString(QzoneShare.SHARE_TO_QQ_TITLE, txt);
		// params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY, " ");//
		// 自己不给空，腾讯给其他默认文字
		// // params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL,
		// // "http://www.baidu.com");
		//
		// ArrayList<String> path_arr = new ArrayList<String>();
		// path_arr.add("https://tfsimg.alipay.com/images/openhome/TB1wH8IXl9m.eJkUuGVwu1RoFXa.png");//
		// 自己不给值，腾讯给其他默认图片
		// params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL,path_arr);//
		// new
		// //
		// ArrayList<String>());//SHARE_TO_QZONE_TYPE_APP下需要有SHARE_TO_QQ_IMAGE_URL属性
		// params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN);
		// mTencent.shareToQzone(mActivity, params, mShareListener);
		//
		// } else {
		// params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE,QQShare.SHARE_TO_QQ_TYPE_APP);
		// params.putString(QQShare.SHARE_TO_QQ_TITLE, txt);
		// params.putString(QQShare.SHARE_TO_QQ_SUMMARY, txt);
		// // ArrayList<String> path_arr = new ArrayList<String>() ;
		// //
		// path_arr.add("https://tfsimg.alipay.com/images/openhome/TB1wH8IXl9m.eJkUuGVwu1RoFXa.png");//自己不给值，腾讯给其他默认图片
		// // params.putStringArrayList(QQShare.SHARE_TO_QQ_IMAGE_URL,path_arr);
		// //
		// params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);
		// mTencent.shareToQQ(mActivity, params, mShareListener);
		// }

		// 不支持在QQ空间分享纯文本
		Intent sendIntent = new Intent();
		sendIntent.setAction(Intent.ACTION_SEND);
		sendIntent.putExtra(Intent.EXTRA_TEXT, txt);
		sendIntent.setType("text/plain");
		try {
			sendIntent.setClassName("com.tencent.mobileqq",
					"com.tencent.mobileqq.activity.JumpActivity");
			Intent chooserIntent = Intent.createChooser(sendIntent, "选择分享途径");
			if (chooserIntent == null) {
				return;
			}
			myContext.startActivity(chooserIntent);
		} catch (Exception e) {
			myContext.startActivity(sendIntent);
		}
	}

	public static void shareImageToQQ(final int type, final String imgPath,
			final String title, final String description, final int handler) {
		System.out.println("AppActivity shareURLToQQ，type" + type + " url:"
				+ imgPath + " title:" + title + " description:" + description);
		final Bundle params = new Bundle();
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE,
				QQShare.SHARE_TO_QQ_TYPE_IMAGE);
		params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
		params.putString(QQShare.SHARE_TO_QQ_SUMMARY, description);
		params.putString(QQShare.SHARE_TO_QQ_IMAGE_LOCAL_URL, imgPath);
		File file1 = new File(imgPath);
		file1.setReadable(true, false);
		file1.setWritable(true, false);
		// params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);
		mTencent.shareToQQ(mActivity, params, mShareListener);
	}

	public static void shareURLToQQ(final int type, final String url,
			final String title, final String description, final int handler) {
		System.out.println("AppActivity shareURLToQQ type" + type + " url:"
				+ url + " title:" + title + " description:" + description);

		final Bundle params = new Bundle();
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;
		if (type == 2) {
			params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE,
					QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT);
			params.putString(QzoneShare.SHARE_TO_QQ_TITLE, title);
			params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY, description);
			params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, url);
			ArrayList<String> path_arr = new ArrayList<String>();
			path_arr.add("https://anhui-update.yongwuzhijing88.com/YwZj_2017/AnHui/shareIcon.png");// 自己不给空，腾讯给其他默认图片
			params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL,
					path_arr);// wiki上写着选填，但不填会出错

			params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,
					QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN);
			mTencent.shareToQzone(mActivity, params, mShareListener);
		} else {
			params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE,
					QQShare.SHARE_TO_QQ_TYPE_APP);
			params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
			params.putString(QQShare.SHARE_TO_QQ_SUMMARY, description);
			params.putString(QQShare.SHARE_TO_QQ_TARGET_URL, url);

			params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,
					QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);
			mTencent.shareToQQ(mActivity, params, mShareListener);
		}
	}

	public static boolean isQQInstalled() {
		final PackageManager packageManager = myContext.getPackageManager();
		List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
		if (pinfo != null) {
			for (int i = 0; i < pinfo.size(); i++) {
				String pn = pinfo.get(i).packageName;
				if (pn.equalsIgnoreCase("com.tencent.qqlite")
						|| pn.equalsIgnoreCase("com.tencent.mobileqq")) {
					return true;
				}
			}
		}
		return false;
	}

	public static boolean isQQSupportApi() {
		return true;
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (mTencent != null) {
			mTencent.onActivityResultData(requestCode, resultCode, data,
					mShareListener);
		}
	}

	private static class ShareListener implements IUiListener {
		@Override
		public void onCancel() {
			System.out.println("ShareListener 分享取消");
			String str = "-4&分享取消";// 与ios一致
			AppActivity.LuaCallBackFun(str);
		}

		@Override
		public void onComplete(Object arg0) {
			System.out.println("ShareListener 分享成功");
			String str = "0&分享成功";// 与ios一致
			AppActivity.LuaCallBackFun(str);
		}

		@Override
		public void onError(UiError uiError) {
			Log.v("AppActivity shareListener onError", uiError.errorMessage
					+ "--" + uiError.errorCode + "---" + uiError.errorDetail);
			String str = uiError.errorCode + "&" + uiError.errorMessage
					+ uiError.errorDetail;
			AppActivity.LuaCallBackFun(str);
		}
	}

	// 支付宝分享文本
	public static void shareTextToZFB(final String description,
			final int handler) {
		Log.v("AppActivity", "description:" + description);

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		// 初始化APTextObject，组装文本消息内容对象
		APTextObject textObject = new APTextObject();
		textObject.text = description;

		// 初始化APMediaMessage ，组装分享消息对象
		APMediaMessage mediaMessage = new APMediaMessage();
		mediaMessage.mediaObject = textObject;

		// 将分享消息对象包装成请求对象
		SendMessageToZFB.Req req = new SendMessageToZFB.Req();
		req.message = mediaMessage;

		// 发送请求
		zfbApi.sendReq(req);
	}

	// 支付宝分享图片
	public static void shareImageToZFB(final String filePath, final int handler) {
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		Bitmap bmp = BitmapFactory.decodeFile(filePath);
		APImageObject imageObject = new APImageObject(bmp);

		// 初始化一个APMediaMessage对象 ，组装分享消息对象
		APMediaMessage mediaMessage = new APMediaMessage();
		mediaMessage.mediaObject = imageObject;

		// 将分享消息对象包装成请求对象
		SendMessageToZFB.Req req = new SendMessageToZFB.Req();
		req.message = mediaMessage;
		req.transaction = "ImageShare"
				+ String.valueOf(System.currentTimeMillis());
		bmp.recycle();

		// 发送请求
		zfbApi.sendReq(req);
	}

	// 支付宝分享网页链接
	public static void shareURLToZFB(final String url, final String title,
			final String description, final int handler) {

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		APWebPageObject webPageObject = new APWebPageObject();
		webPageObject.webpageUrl = url;
		APMediaMessage webMessage = new APMediaMessage();
		webMessage.title = title;
		webMessage.description = description;
		webMessage.mediaObject = webPageObject;
		webMessage.thumbUrl = "https://anhui-update.yongwuzhijing88.com/YwZj_2017/AnHui/shareIcon.png";
		SendMessageToZFB.Req webReq = new SendMessageToZFB.Req();
		webReq.message = webMessage;
		webReq.transaction = buildTransaction("webpage");
		// 修改请求消息对象的scene场景值为ZFBSceneTimeLine
		// 9.9.5版本之后的支付宝不需要传此参数，用户会在跳转进支付宝后选择分享场景（好友、动态等）
		webReq.scene = SendMessageToZFB.Req.ZFBSceneTimeLine;

		// 发送请求
		zfbApi.sendReq(webReq);
	}

	public static boolean isZFBAppInstalled() {
		return zfbApi.isZFBAppInstalled();
	}

	public static boolean isZFBSupportAPI() {
		return zfbApi.isZFBSupportAPI();
	}

	public static void startFeedBack() {

		Log.v("AppActivity", "用户反馈===========================>");
		FeedbackAPI.openFeedbackActivity();
		// FeedbackAPI.openFeedbackActivity(final Callable success, final
		// Callable fail)
		Log.v("AppActivity", "用户反馈===========================>");
	}

	public static boolean isWeiboAppInstalled() {
		final PackageManager packageManager = myContext.getPackageManager();
		List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
		if (pinfo != null) {
			for (int i = 0; i < pinfo.size(); i++) {
				String pn = pinfo.get(i).packageName;
				if (pn.equalsIgnoreCase("com.sina.weibo")) {
					return true;
				}
			}
		}
		return false;
	}

	public static void LuaCallBackFun(final String resStr) {
		appThis.runOnGLThread(new Runnable() {
			@Override
			public void run() {
				if (callBackScriptHandler != 0) {
					Cocos2dxLuaJavaBridge.callLuaFunctionWithString(
							callBackScriptHandler, resStr);
					Cocos2dxLuaJavaBridge
							.releaseLuaFunction(callBackScriptHandler);
					callBackScriptHandler = 0;
				}
			}
		});
	}

	@SuppressWarnings("deprecation")
	@SuppressLint("NewApi")
	public static String getPastBordContext(final int handler) {
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				ClipboardManager clipboardManager = (ClipboardManager) mActivity
						.getSystemService(Context.CLIPBOARD_SERVICE);
				String temp = "";
				if (clipboardManager.getText() != null) {
					temp = clipboardManager.getText().toString();
				}
				AppActivity.LuaCallBackFun(temp);
			}
		});
		return "";
	}

	@Override
	public void onWbShareCancel() {
		// TODO Auto-generated method stub
		String str = "-4&分享取消";// 与ios一致
		AppActivity.LuaCallBackFun(str);
	}

	@Override
	public void onWbShareFail() {
		// TODO Auto-generated method stub
		String str = "110&分享失败";// 与ios一致
		AppActivity.LuaCallBackFun(str);
	}

	@Override
	public void onWbShareSuccess() {
		// TODO Auto-generated method stub
		String str = "0&分享成功";// 与ios一致
		AppActivity.LuaCallBackFun(str);
	}

	// weibo分享文本
	public static void shareTextToWeiBo(final String description,
			final int handler) {
		Log.v("AppActivity", "description:" + description);
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		WeiboMultiMessage multmess = new WeiboMultiMessage();
		TextObject textobj = new TextObject();
		textobj.text = description;
		multmess.textObject = textobj;
		wbShareHandler.shareMessage(multmess, false);
	}

	// weibo分享图片
	public static void shareImageToWeiBo(final String filePath,
			final int handler) {
		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		WeiboMultiMessage weiboMessage = new WeiboMultiMessage();
		ImageObject imageObject = new ImageObject();
		Bitmap bmp = BitmapFactory.decodeFile(filePath);
		Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, bmp.getWidth(),
				bmp.getHeight(), true);
		imageObject.setImageObject(thumbBmp);

		weiboMessage.imageObject = imageObject;
		wbShareHandler.shareMessage(weiboMessage, false);
	}

	// weibo分享网页链接
	public static void shareURLToWeiBo(final String url, final String title,
			final String description, final int handler) {

		if (callBackScriptHandler != 0) {
			Cocos2dxLuaJavaBridge.releaseLuaFunction(callBackScriptHandler);
		}
		callBackScriptHandler = handler;

		WeiboMultiMessage weiboMessage = new WeiboMultiMessage();
		WebpageObject mediaObject = new WebpageObject();
		mediaObject.identify = "lynm";
		mediaObject.title = title;
		mediaObject.description = description;

		Bitmap bmp = BitmapFactory.decodeResource(mActivity.getResources(),
				R.drawable.icon);
		Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
				(int) (THUMB_SIZE / (double) bmp.getWidth() * bmp.getHeight()),
				true);
		mediaObject.setThumbImage(thumbBmp);

		mediaObject.actionUrl = url;
		mediaObject.defaultText = "";

		weiboMessage.mediaObject = mediaObject;
		wbShareHandler.shareMessage(weiboMessage, false);

	}

	public static boolean isWbAppInstalled() {
		WbAppInfo wbAppInfo = WeiboAppManager.getInstance(myContext)
				.getWbAppInfo();
		return wbAppInfo != null && wbAppInfo.isLegal();
	}

	static List<String> channelList;
	public static void loginYayaSDK(final String nick, final String uid){
		channelList = new ArrayList<String>();
		String tt="{\"uid\":\""+uid+"\",\"nickname\":\""+nick+"\"}";
		YunvaImSdk.getInstance().Binding(tt, "1", channelList);
	}
	
	//分享
	private static Uri shareUri;
	public static void shareToWXPYQNativeImage(final int platform,final String text, final String filePath){
		Bitmap bmp = BitmapFactory.decodeFile(filePath);
    	shareUri =  Uri.parse(MediaStore.Images.Media.insertImage(mActivity.getContentResolver(), bmp, null,null));
		bmp.recycle();
		
		String packageName = "";
		String className = "";
		
		if(platform == 1){//微信朋友圈
			packageName = "com.tencent.mm";
			className = "com.tencent.mm.ui.tools.ShareToTimeLineUI";
		}else if (platform == 2){//微信好友
			packageName = "com.tencent.mm";
			className = "com.tencent.mm.ui.tools.ShareImgUI";
//		}else if (platform == 3){//QQ好友
//			packageName = "com.tencent.connect.common";
//			className = "com.tencent.connect.common.AssistActivity";
//		}else if (platform == 4){//QQ空间
//			packageName = "com.qzone";
//			className = "com.qzonex.module.operation.ui.QZonePublishMoodActivity";
//		}else if (platform == 5){//微博
//			packageName = "com.sina.weibo";
//			className = "com.sina.weibo.composerinde.ComposerDispatchActivity";
//		}else if (platform == 6){//支付宝
//			packageName = "com.alipay.share.sdk";
//			className = "com.alipay.share.sdk.ComposerDispatchActivity";
		}
		
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_STREAM, shareUri);
        sendIntent.setType("image/*");
        
        sendIntent.putExtra("Kdescription", text);
        try {
            sendIntent.setClassName(packageName, className);
            Intent chooserIntent = Intent.createChooser(sendIntent, "选择分享途径");
            if (chooserIntent == null) {
                return;
            }
            myContext.startActivity(chooserIntent);
        } catch (Exception e) {
            myContext.startActivity(sendIntent);
//            Toast.makeText(appThis, "分享失败", Toast.LENGTH_SHORT).show();
//            e.printStackTrace();
        }
	}
		
		public static void removeShareUri(){
			mActivity.getContentResolver().delete(shareUri, null, null);
		}
		
		public static boolean isExistMethod(String method) {
//			Field[] fields= AppActivity.getClass().getFields();
			
			return true;
		}
		
		public static String getOpenUDID() {  
			String udid = "";
			udid = udid + "imie-" + getIMIEStatus(myContext);
			udid = udid + "-mac-" + getLocalMac(myContext);
			udid = udid + "-" + getAndroidId(myContext);
			return udid;
		}
	     private static String getIMIEStatus(Context context) {  
	         TelephonyManager tm = (TelephonyManager) context  
	                 .getSystemService(Context.TELEPHONY_SERVICE);  
	         String deviceId = tm.getDeviceId();  
	         return deviceId;  
	     }  
	   
	     // Mac地址  
	     private static String getLocalMac(Context context) {  
	         WifiManager wifi = (WifiManager) context  
	                 .getSystemService(Context.WIFI_SERVICE);  
	         WifiInfo info = wifi.getConnectionInfo();  
	         return info.getMacAddress();
	     }  
	   
	     // Android Id  
	     private static String getAndroidId(Context context) {  
	         String androidId = Settings.Secure.getString(  
	                 context.getContentResolver(), Settings.Secure.ANDROID_ID);  
	         return androidId;  
	     } 
	      

}