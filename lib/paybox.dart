import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

class AlipayResult {
  String result = "";
  String status = "";
  String memo = "";

  AlipayResult(Map<String, String> res) {
    result = res["result"] ?? "";
    status = res["status"] ?? "";
    memo = res["memo"] ?? "";
  }
}

class Paybox {
  static get _channel {
    const channel = MethodChannel('paybox');
    channel.setMethodCallHandler(handler);
    return channel;
  }

  static EventBus eventBus = EventBus();

  static Future handler(MethodCall call) async {
    if (call.method == "payResult") {
      print(call.arguments);
      try {
        var _map = new Map<String, String>.from(call.arguments);
        eventBus.fire(AlipayResult(_map));
      } catch (err) {
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

  static Future<dynamic> aliPay(String config) async {
    return _channel.invokeMethod("alipay", config);
  }

  static Future<dynamic> wxPay(String config) async {
    return _channel.invokeMethod("wxpay", config);
  }
}
