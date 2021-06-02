import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
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
            
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { result in
                self.channel?.invokeMethod("payResult", arguments:result)
            }
        }
        return true
    }
    
}
