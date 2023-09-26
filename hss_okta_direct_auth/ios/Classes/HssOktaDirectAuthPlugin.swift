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
    
    
    var flow : DirectAuthenticationFlow?
    var status : DirectAuthenticationFlow.Status?
    
    
    func mfaOtpSignInWithCredentials(otp: String, completion: @escaping (Result<HssOktaDirectAuthResult?, Error>) -> Void) {
        Task{
            do{
             status = try await flow?.resume(self.status!, with: .otp(code: otp))
                if case let .success(token) = status{
                    Credential.default = try Credential.store(token)
                    completion(.success(HssOktaDirectAuthResult(
                        result: DirectAuthResult.success, id: token.id, token: token.idToken?.rawValue ?? "", issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()), tokenType: token.tokenType, accessToken: token.accessToken, scope: token.scope ?? "", refreshToken: token.refreshToken ?? "")))
                }else{
                    completion(.success(HssOktaDirectAuthResult(result: DirectAuthResult.error,error: "MFA Failed")))
                }
            }catch let error{
                completion(.success(HssOktaDirectAuthResult(result: DirectAuthResult.error,error: "\(error)")))
            }
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaDirectAuthPluginApi & NSObjectProtocol = HssOktaDirectAuthPlugin.init()
        HssOktaDirectAuthPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
    
    
    func signInWithCredentials(request: HssOktaDirectAuthRequest, completion: @escaping (Result<HssOktaDirectAuthResult?, Error>) -> Void)  {
        
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            flow = DirectAuthenticationFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes)
            
            Task{
                do{
                    
                    let status = try await flow!.start(request.username, with: .password(request.password))
                    self.status = status
                    
                    switch status{
                    case .success(let token):
                        Credential.default = try Credential.store(token)
                        
                        completion(.success(HssOktaDirectAuthResult(
                            result: DirectAuthResult.success, id: token.id, token: token.idToken?.rawValue ?? "", issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()), tokenType: token.tokenType, accessToken: token.accessToken, scope: token.scope ?? "", refreshToken: token.refreshToken ?? ""))) 
                        
                    case .mfaRequired(_):
                        completion(.success(HssOktaDirectAuthResult(result: DirectAuthResult.mfaRequired,error: "MFA Required")))
                    }
                    
                }catch let error{
                    debugPrint(error)
                    completion(.failure(error))
                }
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
            
            var resultEnum = DirectAuthResult.success
            completion(.success(HssOktaDirectAuthResult(
                result: resultEnum, id: result.token.id, token: result.token.idToken?.rawValue ?? "", issuedAt: Int64(((result.token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()), tokenType: result.token.tokenType, accessToken: result.token.accessToken, scope: result.token.scope ?? "", refreshToken: result.token.refreshToken ?? "")))
        }else{
            var resultEnum = DirectAuthResult.error
            completion(.success(HssOktaDirectAuthResult(result: resultEnum,error: "Failed to Login : Server did not provide result")))
        }
    }
    
   
    
    
  
    
}
