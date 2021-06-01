
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

class alipayResult{
   String result = "";
  String status = "";
  String memo = "";

  alipayResult(Map<String,String> res){
    result=res["result"]??"";
    status=res["status"]??"";
    memo=res["memo"]??"";
  }
}

class Paybox {
  static  get  _channel{
    const channel = MethodChannel('paybox');
    channel.setMethodCallHandler(handler);
    return channel;
  }

  static EventBus eventBus = EventBus();


  static Future handler(MethodCall call)async{
    if(call.method=="payResult"){
      print(call.arguments);
      try{
        var str = call.arguments.toString();
        var _map = new Map<String,String>.from(jsonDecode(str));
        eventBus.fire(alipayResult(_map));
      }catch(err){
        print(err);
      }

      return 1;
    }
    return "";
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> AliPay(String config) async {
    return _channel.invokeMethod("alipay",config);
  }

  static Future<dynamic> WxPay(String config) async {
    return _channel.invokeMethod("wxpay",config);
  }
}
