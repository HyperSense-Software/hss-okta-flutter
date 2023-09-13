import Flutter
import UIKit
import WebAuthenticationUI

public class HssOktaFlutterPlugin: NSObject, FlutterPlugin {
  
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hss_okta_flutter", binaryMessenger: registrar.messenger())
    let instance = HssOktaFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
   
    
    default:
      result(FlutterMethodNotImplemented)
    }
  }

// func signIn() async {
//     let token = try await WebAuthentication.signIn()
//     let credential = try Credential.store(token)
// }
}
