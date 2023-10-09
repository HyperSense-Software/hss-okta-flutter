import Flutter
import OktaDirectAuth
import OktaOAuth2
import AuthFoundation
import UIKit
import WebAuthenticationUI


enum HssOktaError: Error {
case configError(String)
case credentialError(String)
}


public class HssOktaFlutterPlugin: NSObject, FlutterPlugin,HssOktaFlutterPluginApi {
    
    
    let browserAuth = WebAuthentication.shared
    var logoutUri : URL?
    var issuer : String?
    var clientId : String?
    
    func startBrowserAuthenticationFlow(completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        
    }
    
    var flow : DirectAuthenticationFlow?
    var status : DirectAuthenticationFlow.Status?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaFlutterPluginApi & NSObjectProtocol = HssOktaFlutterPlugin.init()
        let signInFactory = WebSignInNativeViewFactory(messenger: registrar.messenger())
        let signOutFactory = WebSignOutNativeViewFactory(messenger: registrar.messenger())
        registrar.register(signInFactory, withId: WebSignInNativeViewFactory.platformViewName)
        registrar.register(signOutFactory, withId: WebSignOutNativeViewFactory.platformViewName)
        
        HssOktaFlutterPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
        
    }
    
    func initializeConfiguration(clientid: String, signInRedirectUrl: String, signOutRedirectUrl: String, issuer: String, scopes: String) throws {
        
        
    }
    
    func startDirectAuthenticationFlow(request: DirectAuthRequest, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        
        
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            
            logoutUri = config.logoutRedirectUri
            
            flow = DirectAuthenticationFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes,supportedGrants: [.password,.otpMFA])
            
            Task{
                do{
                    
                    let status = try await flow!.start(request.username, with: .password(request.password))
                    self.status = status
                    
                    switch status{
                    case .success(let token):
                        Credential.default = try Credential.store(token)
                        let userInfo = try await Credential.default?.userInfo()
                        
                        completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: token, userInfo: userInfo)))
                        
                    case .mfaRequired(_):
                        completion(.success(OktaAuthenticationResult(result: AuthenticationResult.mfaRequired,error: "MFA Required")))
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
    
    func continueDirectAuthenticationMfaFlow(otp: String, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        Task{
            do{
                status = try await flow?.resume(self.status!, with: .otp(code: otp))
                if case let .success(token) = status{
                    Credential.default = try Credential.store(token)
                    let userInfo = try await Credential.default?.userInfo()
                    
                    completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: token, userInfo: userInfo)))
                }else{
                    completion(.success(OktaAuthenticationResult(result: AuthenticationResult.error,error: "MFA Failed")))
                }
            }catch let error{
                completion(.success(OktaAuthenticationResult(result: AuthenticationResult.error,error: "\(error)")))
            }
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
    
    
    func startWebSignoutFlow(completion: @escaping (Result<Bool, Error>) -> Void) {
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
        
        func getCredential(completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
            Task{
               
                if let result = Credential.default{
                    let userInfo = result.userInfo
                    
                    completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: result.token, userInfo: userInfo)))
                    
                }else{
                    
                    completion(.failure(HssOktaError.configError("No default credential found")))
                }
            }
        }
        
        func constructAuthenticationResult(resultEnum : AuthenticationResult, token : Token,userInfo : AuthFoundation.UserInfo?) -> OktaAuthenticationResult{
            return OktaAuthenticationResult(
                result: resultEnum,
                token: OktaToken(
                    id: token.id,
                    token: token.idToken?.rawValue ?? "",
                    issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                    tokenType: token.tokenType,
                    accessToken: token.accessToken,
                    scope: token.scope ?? "",
                    refreshToken: token.refreshToken ?? ""
                ),
                userInfo: UserInfo(userId: "", givenName: userInfo?.givenName ?? "", middleName: userInfo?.middleName ?? "", familyName: userInfo?.familyName ?? "", gender: userInfo?.gender ?? "", email: userInfo?.email ?? "", phoneNumber: userInfo?.phoneNumber ?? "", username: userInfo?.preferredUsername  ?? "")
            )
        }       
}
