import 'dart:async';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

class AlipayResult {
  String result = "";
  String status = "";
  String memo = "";

  AlipayResult(Map<String, String> res) {
    result = res["result"] ?? "";
    status = res["resultStatus"] ?? "";
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

  static Future<dynamic> aliPay(
    String orderInfo, {
    String urlScheme = "",
    bool sandbox = false,
  }) async {
    if (Platform.isIOS) {
      if (urlScheme.isEmpty) {
        throw "请设置url scheme";
      }
    }
    try {
      return _channel.invokeMethod("alipay", {
        "orderInfo": orderInfo,
        "urlScheme": urlScheme,
        "sandbox": sandbox ? "1" : ""
      });
    } catch (err) {
      throw err;
    }
  }

  static Future<dynamic> wxPay(String config) async {
    return _channel.invokeMethod("wxpay", config);
  }
}
