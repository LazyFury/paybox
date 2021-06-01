import Flutter
import UIKit

public class SwiftPayboxPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paybox", binaryMessenger: registrar.messenger())
    let instance = SwiftPayboxPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "alipay"){
        AlipaySDK.defaultService().payOrder("orderId=1", fromScheme: "suke1demo", callback: { res in
                result(res)
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
