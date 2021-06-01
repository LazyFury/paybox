import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,WXApiDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func onResp(_ resp: BaseResp) {
        print(resp)
    }
}
