#import "PayboxPlugin.h"
#if __has_include(<paybox/paybox-Swift.h>)
#import <paybox/paybox-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "paybox-Swift.h"
#endif
#import <AlipaySDK/AlipaySDK.h>

@implementation PayboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPayboxPlugin registerWithRegistrar:registrar];
}
@end
