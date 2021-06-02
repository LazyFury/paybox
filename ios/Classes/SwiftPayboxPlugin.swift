import Flutter
import UIKit

public class SwiftPayboxPlugin: NSObject, FlutterPlugin {
  static var _channel:FlutterMethodChannel?
    
   public static func channel() -> FlutterMethodChannel? {
        return SwiftPayboxPlugin._channel;
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paybox", binaryMessenger: registrar.messenger())
    let instance = SwiftPayboxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    _channel = channel;
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "alipay"){
//        let sandbox = false //ios不支持sandbox
        guard let config = call.arguments  as? NSDictionary else {
            result("参数错误")
            return
        }
        guard let orderInfo = config.value(forKey: "orderInfo") as? String else {
            result("请输入订单配置参数")
            return
        }
        guard let urlScheme = config.value(forKey: "urlScheme") as? String else {
            result("请输入urlscheme")
            return
        }
        AlipaySDK.defaultService().payOrder(orderInfo, dynamicLaunch: true, fromScheme: urlScheme, callback: {res in
            SwiftPayboxPlugin._channel?.invokeMethod("payResult", arguments: res)
        })
    }
    if(call.method == "wxpay"){
        let req = PayReq()

        req.partnerId = "123132"
        req.nonceStr = "1231"
        req.package = "123132"
        req.prepayId = "123132"
        req.timeStamp = 123
        req.sign = "123132"
        WXApi.send(req) { ok in
            result(ok)
        }

    }
    result("iOS " + UIDevice.current.systemVersion)
  }
}
