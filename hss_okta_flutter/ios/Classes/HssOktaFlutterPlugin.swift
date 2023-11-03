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
    
    func startDirectAuthenticationFlow(request: DirectAuthRequest, completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
        
        
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
                            
                           
                            
                        case .mfaRequired(_):
                            completion(.success(AuthenticationResult(result: DirectAuthenticationResult.mfaRequired)))
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
    
    func continueDirectAuthenticationMfaFlow(otp: String, completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
        Task{
            do{
                if let authFlow = flow as? DirectAuthenticationFlow{
                    status = try await authFlow.resume(self.status!, with: .otp(code: otp))
                    if case let .success(token) = status{
                        Credential.default = try Credential.store(token)
                        let userInfo = try await Credential.default?.userInfo()
                        
                        completion(.success(constructAuthenticationResult(resultEnum: DirectAuthenticationResult.success, token: token, userInfo: userInfo)))
                    }else{
                        completion(.failure(HssOktaError.generalError("Failed to resume flow, MFA Failed")))
                    }
                }else{
                        completion(.failure(HssOktaError.configError("Incorrect Flow")))
                }
            }catch let error{
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
        }
    }
    
    func refreshDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void){
        
        
        if let credential = Credential.default{
            Task{
                do{
                    try await credential.refresh()
                }catch let error{
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
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
        
        func getCredential(completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
            Task{
               
                do{
                    if let result = Credential.default{
                        let userInfo = try await result.userInfo()
                        
                        completion(.success(
                            constructAuthenticationResult(
                                resultEnum: nil,
                                token: result.token, userInfo: userInfo)))
                        
                    }else{
                        
                        completion(.failure(HssOktaError.generalError("No default credential found")))
                    }
                }catch let e{
                    completion(.failure(HssOktaError.generalError(e.localizedDescription)))

                }
            }
        }
    
    func startDeviceAuthorizationFlow(completion: @escaping (Result<DeviceAuthorizationSession?, Error>) -> Void) {
        do{
            if (try? OAuth2Client.PropertyListConfiguration()) != nil{
                
                 flow = try DeviceAuthorizationFlow()
                
                Task{
                    do{
                        
                        if let authFlow = flow as? DeviceAuthorizationFlow{
                            
                            deviceAuthorizationFlowContext = try await authFlow.start()

                            completion(.success(DeviceAuthorizationSession(
                                userCode: deviceAuthorizationFlowContext?.userCode,
                                verificationUri: deviceAuthorizationFlowContext?.verificationUri.absoluteString
                            )))
                        }
                        
                        
                    }catch let e{
                        completion(.failure(e))
                    }
                }
            }
        }catch let e{
            completion(.failure(e))
        }
    }
    
    func resumeDeviceAuthorizationFlow(completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
        
        Task{
            do{
                if let authFlow = flow as? DeviceAuthorizationFlow{
                    if let context = deviceAuthorizationFlowContext{
                        
                        let token = try await authFlow.resume(with: context)
                        Credential.default = try Credential.store(token)
                        
                        if let userInfo = try await Credential.default?.userInfo(){
                            completion(.success(constructAuthenticationResult(resultEnum: nil, token: token, userInfo: userInfo)))
                        }
                    }
                }
                
            }catch let e{
                
                completion(.failure(HssOktaError.generalError("Failed to Sign in : \(e.localizedDescription)")))
            }
        }
    }
   
    func startTokenExchangeFlow(deviceSecret: String, idToken: String, completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
        Task{
            do{
                flow = try TokenExchangeFlow()
                
                if let authflow = flow as? TokenExchangeFlow{
                    let token = try await authflow.start(with: [.actor(type: .deviceSecret, value: deviceSecret),.subject(type: .idToken, value: idToken)])
                    
                    Credential.default = try Credential.store(token)
                    
                    if let result = Credential.default{
                        let userInfo = try await result.userInfo()
                        
                        completion(.success(
                            constructAuthenticationResult(
                                resultEnum: nil,
                                token: result.token, userInfo: userInfo)))
                        
                    }
                    
                    completion(.failure(HssOktaError.credentialError("Failed to save credentials")))
                }
            }catch let error{
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
            
        }
    }
    
    
    
    
    //    Helper methods
        
        func constructAuthenticationResult(resultEnum : DirectAuthenticationResult?, token : Token,userInfo : AuthFoundation.UserInfo?) -> AuthenticationResult{
            return AuthenticationResult(
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


