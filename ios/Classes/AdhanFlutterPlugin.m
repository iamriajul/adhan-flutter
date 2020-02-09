#import "AdhanFlutterPlugin.h"
#if __has_include(<adhan_flutter/adhan_flutter-Swift.h>)
#import <adhan_flutter/adhan_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "adhan_flutter-Swift.h"
#endif

@implementation AdhanFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdhanFlutterPlugin registerWithRegistrar:registrar];
}
@end
