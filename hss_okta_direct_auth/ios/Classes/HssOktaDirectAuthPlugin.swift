import Flutter
import Foundation
import OktaOAuth2
import AuthFoundation
import OktaDirectAuth

enum HssOktaError: Error {
case configError(String)
case credentialError(String)
}


open class HssOktaDirectAuthPlugin :NSObject, FlutterPlugin,HssOktaDirectAuthPluginApi
{
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaDirectAuthPluginApi & NSObjectProtocol = HssOktaDirectAuthPlugin.init()
        HssOktaDirectAuthPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
    
    
    func signInWithCredentials(request: HssOktaDirectAuthRequest, completion: @escaping (Result<HssOktaDirectAuthResult?, Error>) -> Void)  {
        
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            let flow = DirectAuthenticationFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes)
            
            Task{
                do{
                    try await startSignInFlow(request : request,flow: flow)
                    
                }catch let error{
                    debugPrint(error)
                    completion(.failure(error))
                }
            }
            
            if let result : Credential = Credential.default {

                completion(.success(HssOktaDirectAuthResult(
                    success: true, id: result.token.id, token: result.token.idToken?.rawValue ?? "", issuedAt: Int64(((result.token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()), tokenType: result.token.tokenType, accessToken: result.token.accessToken, scope: result.token.scope ?? "", refreshToken: result.token.refreshToken ?? ""))) }else{
                completion(.success(HssOktaDirectAuthResult(success: false,error: "Failed to Login : Server did not provide result")))
            }

        }else{
            completion(.failure(HssOktaError.configError("Configuration Error, Check okta.plist")))
        }
    }
    
    func refreshDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void){
        if let credential = Credential.default{
            Task{
                do{
                    try await credential.refresh()
                }catch let error{
                    debugPrint(error)
                    completion(.failure(error))
                }
            }
            completion(.success(true))
        }else{
            completion(.success(false))
        }
        
        
    }
    
    func revokeDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void){
        if let credential = Credential.default{
            Task{
                do{
                    try await credential.revoke()
                }catch let error{
                    debugPrint(error)
                    completion(.success(false))
                }
            }
            completion(.success(true))
        }else{
            completion(.success(false))
        }
    }
    
    func getCredential(completion: @escaping (Result<HssOktaDirectAuthResult?, Error>) -> Void){
        if let result = Credential.default{
            completion(.success(HssOktaDirectAuthResult(
                success: true, id: result.token.id, token: result.token.idToken?.rawValue ?? "", issuedAt: Int64(((result.token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()), tokenType: result.token.tokenType, accessToken: result.token.accessToken, scope: result.token.scope ?? "", refreshToken: result.token.refreshToken ?? "")))
        }else{
            completion(.success(HssOktaDirectAuthResult(success: false,error: "Failed to Login : Server did not provide result")))
        }
    }

    
    func startSignInFlow(request : HssOktaDirectAuthRequest, flow : DirectAuthenticationFlow) async throws {
        let token =  try await flow.start(request.username, with: DirectAuthenticationFlow.PrimaryFactor.password(request.password))

        switch try await flow.start(request.username, with: .password(request.password)) {
    case .success(let token):
        Credential.default = try Credential.store(token)
        case .mfaRequired(_):
            debugPrint("Something something")
        }}
}
