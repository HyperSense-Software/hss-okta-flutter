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
        let flow = DirectAuthenticationFlow(issuer: config!.issuer, clientId: config!.clientId, scopes: config!.scopes)
        
        Task{
            do{
                try await startSignInFlow(request : request,flow: flow)
                
            }catch{
                
            }
        }
       
        if let result : Credential = Credential.default {

            completion(.success(HssOktaDirectAuthResult(result: "Success! Here is your token \(result.token.accessToken)")))
        }else{
            completion(.success(HssOktaDirectAuthResult(result: "Failed to login")))
        }
       
    }
    
    func startSignInFlow(request : HssOktaDirectAuthRequest, flow : DirectAuthenticationFlow) async throws {
        let token =  try await flow.start(request.username, with: DirectAuthenticationFlow.PrimaryFactor.password(request.password))
        print(token)
        if case let .success(token) = token {
            Credential.default = try Credential.store(token)
        }
    }}
