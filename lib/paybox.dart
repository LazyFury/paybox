import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/services.dart';

abstract class PayResult {
  String result = "";
  String status = "";
  String memo = "";

  PayResult.formMap(Map<String, dynamic> res) {
    result = res["result"] ?? "";
    status = res["resultStatus"] ?? "";
    memo = res["memo"] ?? "";
  }
}

class AlipayResult extends PayResult {
  AlipayResult.formMap(Map<String, dynamic> res) : super.formMap(res);
}

class WxPayResult extends PayResult {
  WxPayResult.formMap(Map<String, dynamic> res) : super.formMap(res);
}

class WxPayConfig {
  String appId = "";
  String partnerId = "";
  String prepayId = "";
  String nonceStr = "";
  String timeStamp = "";
  String package = "";
  String sign = "";

  WxPayConfig(
      {required this.appId,
      required this.partnerId,
      required this.prepayId,
      required this.nonceStr,
      required this.timeStamp,
      this.package = "Sign=WXPay",
      required this.sign});

  toMap() {
    var map = HashMap();
    map["appId"] = appId;
    map["partnerId"] = partnerId;
    map["prepayId"] = prepayId;
    map["nonceStr"] = nonceStr;
    if (Platform.isIOS) {
      map["timeStamp"] = int.parse(timeStamp);
    } else {
      map["timeStamp"] = timeStamp;
    }
    map["package"] = package;
    map["sign"] = sign;
    return map;
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
    print(call.method);
    if (call.method == "alipayResult") {
      print(call.arguments);
      try {
        var _map = new Map<String, dynamic>.from(call.arguments);
        eventBus.fire(AlipayResult.formMap(_map));
      } catch (err) {
        print(err);
      }

      return 1;
    }

    if (call.method == "wxpayResult") {
      print(call.arguments);
      try {
        var _map = new Map<String, String>.from(call.arguments);
        eventBus.fire(WxPayResult.formMap(_map));
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
      return _channel.invokeMethod("alipay",
          {"orderInfo": orderInfo, "urlScheme": urlScheme, "sandbox": sandbox});
    } catch (err) {
      throw err;
    }
  }

  static Future<dynamic> wxPay(WxPayConfig config) async {
    return _channel.invokeMethod("wxpay", config.toMap());
  }

  static Future<dynamic> wxpayInit(
    String appid,
  ) async {
    try {
      return _channel.invokeMethod("wxpayInit", {
        "appid": appid,
      });
    } catch (err) {
      throw err;
    }
  }
}
