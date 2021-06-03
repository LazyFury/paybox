import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,WXApiDelegate {
    var channel:FlutterMethodChannel?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    channel = FlutterMethodChannel(name: "paybox", binaryMessenger: window.rootViewController as! FlutterViewController as! FlutterBinaryMessenger)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if(url.host == "safepay"){
//            standbyCallback 为nil是使用默认paybox回调
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback:    nil)
        }
        return true
    }
    
    func onResp(_ resp: BaseResp) {
        let map = NSDictionary();
        var result = ""
        switch resp.type {
        case 0:
            result = "成功"
        case -1:
            result = "一般错误"
        case -2:
            result = "用户取消"
        case -3:
            result = "发送失败"
        case -4:
            result = "认证失败"
        case -5:
            result = "不支持错误"
        case -6:
            result = "被屏蔽所有操作，可能由于签名不正确或无权限"
        default:
            result = "未知错误"
        }
        map.setValue(result, forKey: "result")
        map.setValue(resp.errCode, forKey: "status")
        map.setValue(resp.errStr, forKey: "memo")
        channel?.invokeMethod("wxpayResult", arguments: resp)
    }
    
}
