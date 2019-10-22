#import "DoordeckPlugin.h"
#import <doordeck/doordeck-Swift.h>

@implementation DoordeckPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDoordeckPlugin registerWithRegistrar:registrar];
}
@end
