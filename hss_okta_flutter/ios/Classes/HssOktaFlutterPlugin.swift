import Flutter
import UIKit
import OktaOAuth2
//import WebAuthenticationUI
import AuthFoundation
import OktaDirectAuth

public class HssOktaFlutterPlugin: NSObject, FlutterPlugin {
    let config = try? OAuth2Client.PropertyListConfiguration()


  
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
    
    public func signInWithCredentials  (username : String,password : String) async throws{
        
        if config == nil{
            throw HssOktaError.configError("Config Error")
        }
        
        if config!.issuer.absoluteString.isEmpty {
            throw HssOktaError.configError("Issuer Error")
        }
    
        
        let flow = DirectAuthenticationFlow(issuer: config!.issuer, clientId: config!.clientId, scopes: config!.scopes)
        
        let token = try await flow.start(username, with: DirectAuthenticationFlow.PrimaryFactor.password(password))
        
        if case let .success(token) = token {
            Credential.default = try Credential.store(token)
            print("Success")
        }
            
        }
    }



enum HssOktaError: Error {
    case configError(String)
}
