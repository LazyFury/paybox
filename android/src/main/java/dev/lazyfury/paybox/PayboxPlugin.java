package dev.lazyfury.paybox;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** PayboxPlugin */
public class PayboxPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {



  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  public static MethodChannel channel;
  private FlutterActivity flutterView;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "paybox");
    channel.setMethodCallHandler(this);
  }

  AliPay aliPay;
  WxPay wxPay;
  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding){
    flutterView =  (FlutterActivity) binding.getActivity();
    aliPay = new AliPay(flutterView,channel);
    wxPay = new WxPay(flutterView,channel);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {
    flutterView = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      return;
    }
    if (call.method.equals("alipay")){
      aliPay.Pay(call,result);
      return;
    }
    if (call.method.equals("wxpayInit")){
      wxPay.register(call,result);
      return;
    }
    if (call.method.equals("wxpay")){
      wxPay.Pay(call,result);
      return;
    }
    result.notImplemented();
  }



  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    wxPay.unregisterReceiver();
  }

}

