package com.aliyun.face.aliyun_face_plugin;

import androidx.annotation.NonNull;
import java.util.Map;
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.Log;

import com.alipay.face.api.ZIMCallback;
import com.alipay.face.api.ZIMFacade;
import com.alipay.face.api.ZIMFacadeBuilder;
import com.alipay.face.api.ZIMResponse;

/** AliyunFacePlugin */
public class AliyunFacePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context mContext;
  private static String TAG = "AliyunFace";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "aliyun_face_plugin");
    channel.setMethodCallHandler(this);
    mContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      if (call.method.equals("getPlatformVersion")) {
          result.success("android " + android.os.Build.VERSION.RELEASE);
      } else if (call.method.equals("init")) {
          Log.d(TAG, "enter init.");
          ZIMFacade.install(mContext);
      } else if (call.method.equals("getMetaInfos")) {
          Log.d(TAG, "enter getMetaInfos.");
          String metaInfo = ZIMFacade.getMetaInfos(mContext);
          result.success(metaInfo);
      } else if (call.method.equals("verify")) {
          Log.d(TAG, "enter verify.");
          Map<String, String> params = call.arguments();
          String certifyId = params.get("certifyId");
          if (certifyId == null || certifyId.isEmpty()) {
              Log.e(TAG, "certifyId is null");
              return;
          }

          ZIMFacade zimFacade = ZIMFacadeBuilder.create(mContext);
          zimFacade.verify(certifyId, false, new ZIMCallback() {
              @Override
              public boolean response(ZIMResponse response) {
                  if (null != response && 1000 == response.code) {
                      Log.d(TAG, "face verify success.");
                  } else {
                      Log.e(TAG, "face verify error.");
                  }

                  result.success(response.code + "," + response.reason);
                  return true;
              }
          });
      } else if (call.method.equals("setCustomUI")) {
		 String jsonConfig = call.arguments();
		 int paramType = ZIMFacade.ZIM_EXT_PARAMS_VAL_ZIM_EXT_PARAMS_CONFIG_FILE_JSON;
          ZIMFacade zimFacade = ZIMFacadeBuilder.create(mContext);
		 String customUIErrMsg = zimFacade.setCustomTxtConfig(paramType, jsonConfig);
      } else {
          result.notImplemented();
      }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
