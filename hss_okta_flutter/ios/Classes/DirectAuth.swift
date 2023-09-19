import Flutter
import Foundation
import OktaOAuth2
//import WebAuthenticationUI
import AuthFoundation
import OktaDirectAuth

enum HssOktaError: Error {
case configError(String)
}


class DirectAuth{
    
    func signIn (username : String,password : String) async throws -> String {
           
           let config = try? OAuth2Client.PropertyListConfiguration()
           
           let flow = DirectAuthenticationFlow(issuer: config!.issuer, clientId: config!.clientId, scopes: config!.scopes)
           
           let token = try await flow.start(username, with: DirectAuthenticationFlow.PrimaryFactor.password(password))
           
           if case let .success(token) = token {
               Credential.default = try Credential.store(token)
               return("Success")
           }
           return("Fail")
       }
}

class HSSOktaDirectAuthAPI :NSObject, FlutterPlugin, DirectAuthAPI
{
    static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : DirectAuthAPI & NSObjectProtocol = HSSOktaDirectAuthAPI.init()
        DirectAuthAPISetup.setUp(binaryMessenger: messenger, api: api)
    }
    
   
  
    func signInWithCredentials(request: HSSOktaNativeAuthRequest, completion: @escaping (Result<HSSOktaNativeAuthResult, Error>) -> Void) {
    
    Task{
        let auth = DirectAuth()
        let res = try await auth.signIn(username: request.username, password: request.password)
    }
}
    
   
    
}
