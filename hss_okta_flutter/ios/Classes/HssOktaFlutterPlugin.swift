import Flutter
import OktaDirectAuth
import OktaOAuth2
import AuthFoundation
import UIKit
import WebAuthenticationUI



enum HssOktaError: Error {
case configError(String)
case credentialError(String)
case generalError(String)
}


public class HssOktaFlutterPlugin: NSObject, FlutterPlugin,HssOktaFlutterPluginApi {
     
    
    let browserAuth = WebAuthentication.shared
    var flow : (any AuthenticationFlow)?
    var status : DirectAuthenticationFlow.Status?
    var deviceAuthorizationFlowContext : DeviceAuthorizationFlow.Context?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaFlutterPluginApi & NSObjectProtocol = HssOktaFlutterPlugin.init()
        
        
        let signInFactory = WebSignInNativeViewFactory(messenger: registrar.messenger())
        registrar.register(signInFactory, withId: WebSignInNativeViewFactory.platformViewName)
        
        let signOutFactory = WebSignOutNativeViewFactory(messenger: registrar.messenger())
        registrar.register(signOutFactory, withId: WebSignOutNativeViewFactory.platformViewName)
        
        HssOktaFlutterPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
        
    }
    
    func initializeConfiguration(clientid: String, signInRedirectUrl: String, signOutRedirectUrl: String, issuer: String, scopes: String) throws {
    }
    
    func startDirectAuthenticationFlow(request: DirectAuthRequest, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        
        
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            flow = DirectAuthenticationFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes,supportedGrants: [.password,.otpMFA])
            
            Task{
                do{
                  
                    if let authFlow = flow as? DirectAuthenticationFlow{
                        
                        let status = try await authFlow.start(request.username, with: .password(request.password))
                        self.status = status
                        
                        switch status{
                        case .success(let token):
                            Credential.default = try Credential.store(token)
                            let userInfo = try await Credential.default?.userInfo()
                            
                            completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: token, userInfo: userInfo)))
                            
                        case .mfaRequired(_):
                            completion(.success(OktaAuthenticationResult(result: AuthenticationResult.mfaRequired,error: "MFA Required")))
                        }
                    }else{
                        completion(.failure(HssOktaError.generalError("Incorrect flow")))
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
                if let authFlow = flow as? DirectAuthenticationFlow{
                    status = try await authFlow.resume(self.status!, with: .otp(code: otp))
                    if case let .success(token) = status{
                        Credential.default = try Credential.store(token)
                        let userInfo = try await Credential.default?.userInfo()
                        
                        completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: token, userInfo: userInfo)))
                    }else{
                        completion(.success(OktaAuthenticationResult(result: AuthenticationResult.error,error: "MFA Failed")))
                    }
                }else{
                    completion(.failure(HssOktaError.generalError("Incorrect Flow")))
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
               
                do{
                    if let result = Credential.default{
                        let userInfo = try await result.userInfo()
                        
                        completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: result.token, userInfo: userInfo)))
                        
                    }else{
                        
                        completion(.failure(HssOktaError.generalError("No default credential found")))
                    }
                }catch let e{
                    completion(.failure(HssOktaError.generalError(e.localizedDescription)))

                }
            }
        }
    
    func startDeviceAuthorizationFlow(completion: @escaping (Result<DeviceAuthorizationSession, Error>) -> Void) {
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            let flow = DeviceAuthorizationFlow(
                issuer: config.issuer,
                clientId: config.clientId,
                scopes: config.scopes)
            
            Task{@MainActor in
                do{
                    deviceAuthorizationFlowContext = try await flow.start()

                    completion(.success(DeviceAuthorizationSession(
                        userCode: deviceAuthorizationFlowContext?.userCode,
                        verificationUri: deviceAuthorizationFlowContext?.verificationUri.absoluteString
                    )))
                    
                }catch let e{
                    completion(.failure(e))
                }
            }
        }
    }
    
    func resumeDeviceAuthorizationFlow(completion: @escaping (Result<OktaAuthenticationResult, Error>) -> Void) {
        
        Task{@MainActor in
            
            do{
                if let authFlow = flow as? DeviceAuthorizationFlow{
                    if let context = deviceAuthorizationFlowContext{
                        var token = try await authFlow.resume(with: context)
                        Credential.default = try Credential.store(token)
                    }
                }
            }catch let e{
                completion(.failure(e))
            }
        }
    }
    
    //    Helper methods
        
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


