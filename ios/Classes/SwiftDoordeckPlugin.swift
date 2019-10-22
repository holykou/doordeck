import Flutter
import UIKit

public class SwiftDoordeckPlugin: NSObject, FlutterPlugin {
    private var doordeck: Doordeck! = nil
     private var channel: FlutterMethodChannel! = nil
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "doordeck", binaryMessenger: registrar.messenger())
    let instance = SwiftDoordeckPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getPlatformVersion" {
        result("iOS " + UIDevice.current.systemVersion)
    }
    else if call.method == "initDoordeck" {
        if let args = call.arguments as? Array<String>, let token = args.first {
            let authToken = AuthTokenClass(token)
            doordeck = Doordeck(authToken)
            doordeck.delegate = self
            doordeck.Initialize()
        }
        result(false)
    }
    else if call.method == "showUnlock" {
        if (doordeck != nil) {
            doordeck.showUnlockScreen(success: {
              return(true)
            }) {
                self.channel.invokeMethod("unlockFailed", arguments: nil)
              return(false)
            }
          }
        }
  }
}

extension SwiftDoordeckPlugin: DoordeckProtocol {
    public func authenticated() {
        self.channel.invokeMethod("authenticated", arguments: nil)
  }
  
    public func verificationNeeded() {
        self.channel.invokeMethod("verificationNeeded", arguments: nil)
  }

    public func newAuthTokenRequired() -> AuthTokenClass {
        self.channel.invokeMethod("invalidAuthToken", arguments: nil)
      return AuthTokenClass("")
  }

    public func unlockSuccessful() {
        self.channel.invokeMethod("unlockSuccessful", arguments: nil)
  }

}
