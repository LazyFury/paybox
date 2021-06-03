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
            SwiftPayboxPlugin._channel?.invokeMethod("alipayResult", arguments: res)
        })
        result("success")
    }
    if(call.method == "wxpayInit"){
        guard let config = call.arguments as? NSDictionary else {
            result("参数错误")
            return
        }
        guard  let appid = config.value(forKey: "appid") as? String else {
            result("请输入appid")
            return
        }
        guard let universalLink = config.value(forKey: "universalLink") as? String else {
            result("请输入universalLink")
            return
        }
        WXApi.registerApp(appid, universalLink: universalLink)
        result("success")
    }
    if(call.method == "wxpay"){
        guard let config = call.arguments as? NSDictionary else {
            result("参数错误")
            return
        }
        let req = PayReq()
        req.partnerId = config.value(forKey: "partnerId") as! String
        req.nonceStr = config.value(forKey: "nonceStr") as! String
        req.package = config.value(forKey: "package") as! String
        req.prepayId = config.value(forKey: "prepayId") as! String
        req.timeStamp = config.value(forKey: "timeStamp") as! UInt32
        req.sign = config.value(forKey: "sign") as! String
        WXApi.send(req) { ok in
//            这一句测试没执行
            result(ok)
        }

    }
    result("iOS " + UIDevice.current.systemVersion)
  }
}
