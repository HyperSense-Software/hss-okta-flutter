import Flutter
import Foundation
import OktaOAuth2
import AuthFoundation
import OktaDirectAuth

enum HssOktaError: Error {
case configError(String)
}


open class HssOktaDirectAuthPlugin :NSObject, FlutterPlugin,HssOktaDirectAuthPluginApi
{
  
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaDirectAuthPluginApi & NSObjectProtocol = HssOktaDirectAuthPlugin.init()
        HssOktaDirectAuthPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
    
   
    func signInWithCredentials(request: HssOktaDirectAuthRequest, completion: @escaping (Result<HssOktaDirectAuthResult, Error>) -> Void) {
        let config = try? OAuth2Client.PropertyListConfiguration()
    Task{
      
              
        let flow = DirectAuthenticationFlow(issuer: config!.issuer, clientId: config!.clientId, scopes: config!.scopes)
           
        let token = try await flow.start(request.username, with: DirectAuthenticationFlow.PrimaryFactor.password(request.password))
        
        
           
           if case let .success(token) = token {
               
               Credential.default = try Credential.store(token)
               return HssOktaDirectAuthResult(result: token.accessToken)
               
           }
        return HssOktaDirectAuthResult(result: "Failure to Sign in")

    }
}
    
   
    
}
