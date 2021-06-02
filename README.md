# paybox

A new Flutter plugin.

## 集成

### Android支付宝
1.由于alipay sdk使用的本地依赖，而且近期的gradle版本不推荐将android modules内的本地依赖直接编译到app工程中，所以需要配合修改原生工程

    1.1 打开目录./flutterappxx/android/app/,并创建目录/libs

    1.2 下载 https://github.com/LazyFury/paybox/blob/master/android/libs/alipaysdk-15.8.03.210428205839.aar?raw=true 或在支付宝官方网站下载 alipaysdk-15.8.03.210428205839
    并且拷贝到libs目录

    1.3 在/app/build.gradle中添加如下代码


``` gradle
//替换
android{
    defaultConfig{
        //minSdkVersion 16
        minSdkVersion 19
    }
}


//添加
//表示使用libs中到库
repositories {
    flatDir(
            dirs: "libs"
    )
}
```

### iOS支付宝

1 插件使用cocodspod AlipaySDK-iOS,拷贝静态文件到app项目中，所以需要修改ios/podfile
```ruby
# 注释掉 use_frameworks!
target 'Runner' do
  # use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```
2 这一步不确定是否必须，在原生工程中添加相关依赖
```
在 Build Phases 选项卡的 Link Binary With Libraries 中，增加以下依赖：libc++.tbd、libz.tbd、SystemConfiguration.framework、CoreTelephony.framework、QuartzCore.framework、CoreText.framework、CoreGraphics.framework、UIKit.framework、Foundation.framework、CFNetwork.framework、CoreMotion.framework，最后还需要把AlipaySDK.framework也加入依赖库。


作者：十三太饱
链接：https://juejin.cn/post/6844903999829704717
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```
3.添加app scheme url
![https://tva1.sinaimg.cn/large/008i3skNgy1gr457scihkj31no0q641u.jpg](https://tva1.sinaimg.cn/large/008i3skNgy1gr457scihkj31no0q641u.jpg)
在发起支付的时候需要传入，用户支付宝处理完成逻辑之后返回app

4.添加后台能力(似乎是在唤醒微信的似乎需要，没有测试)
![https://tva1.sinaimg.cn/large/008i3skNgy1gr45c93v72j31900tqade.jpg](https://tva1.sinaimg.cn/large/008i3skNgy1gr45c93v72j31900tqade.jpg)

5. 支付回调

```swift
//Runner-Bridging-Header.h
#include <AlipaySDK/AlipaySDK.h>

//appdelegate.swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // method channel
    var channel:FlutterMethodChannel?


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //注册channel
    channel = FlutterMethodChannel(name: "paybox", binaryMessenger: window.rootViewController as! FlutterViewController as! FlutterBinaryMessenger)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if(url.host == "safepay"){
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { result in

                //使用method channel 通知支付结果
                self.channel?.invokeMethod("payResult", arguments:result)
            }
        }
        return true
    }

}
```
