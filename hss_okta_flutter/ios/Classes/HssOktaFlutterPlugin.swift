import Flutter
import OktaDirectAuth
import OktaOAuth2
import AuthFoundation
import UIKit
import WebAuthenticationUI




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
                            completion(.success(constructAuthenticationResult(resultEnum: DirectAuthenticationResult.success, token: token, userInfo: userInfo)))
                           
                            
                        case .mfaRequired(_):
                            completion(.success(AuthenticationResult(result: DirectAuthenticationResult.mfaRequired)))
                    
                            
                        }
                    }else{
                        completion(.failure(HssOktaFlutterException(
                            code: "Error", message: "Incorrect flow",details: ""
                        )))
                    }
                    
                }catch let error{
                    completion(.failure(HssOktaFlutterException(
                        code: "Error", message: error.localizedDescription,details: ""
                    )))
                }
            }
        }else{
            
            completion(.failure(HssOktaFlutterException(
                code: "No .plist found", message: "Create a .plist containing okta configs",details: ""
            )))
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
                        completion(.failure(HssOktaFlutterException(
                            code: "Error", message:"failed to resume flow MFA failed",details: ""
                        )))
                    }
                }else{
                    completion(.failure(HssOktaFlutterException(
                        code: "Incorrect flow", message: "You have the incorrect flow",details: ""
                    )))
                }
            }catch let error{
                completion(.failure(HssOktaFlutterException(
                    code: "Error", message: error.localizedDescription, details: ""
                )))
            }
        }
    }
    
    func refreshDefaultToken(completion: @escaping (Result<Bool?, Error>) -> Void){
        
        
        if let credential = Credential.default{
            Task{
                do{
                    try await credential.refresh()
                }catch let error{
                    completion(.failure(HssOktaFlutterException(
                        code: "Error", message: error.localizedDescription,details: ""
                    )))
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
                        
                        completion(.failure(HssOktaFlutterException(
                            code: "No Credential found", message: "There is no default credential stored",details: ""
                        )))
                    }
                }catch let error{
                    completion(.failure(HssOktaFlutterException(
                        code: "Error", message: error.localizedDescription,details: ""
                    )))

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
                        
                        
                    }catch let error{
                        completion(.failure(HssOktaFlutterException(
                            code: "Error", message: error.localizedDescription,details: ""
                        )))
                    }
                }
            }
        }catch let error{
            completion(.failure(HssOktaFlutterException(
                code: "Error", message: error.localizedDescription,details: ""
            )))
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
                
            }catch let error{
                
                completion(.failure(HssOktaFlutterException(
                    code: "Error", message: error.localizedDescription,details: ""
                )))
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
                    
                    completion(.failure(HssOktaFlutterException(
                        code: "Error", message: "Failed saving credentails",details: ""
                    )))
                }
            }catch let error{
                completion(.failure(HssOktaFlutterException(
                    code: "Error", message: error.localizedDescription, details: ""
                )))
            }
            
        }
    }
    
    func getAllUserIds(completion: @escaping (Result<[String], Error>) -> Void) {
        Task{
            let ids = Credential.allIDs
            completion(.success(ids))
        }
    }
    
    func getToken(tokenId: String, completion: @escaping (Result<AuthenticationResult?, Error>) -> Void) {
        Task{
            do{
                if let fetchedCredential = try Credential.with(id: tokenId){
                    completion(.success(constructAuthenticationResult(
                        resultEnum: nil, token: fetchedCredential.token, userInfo: fetchedCredential.userInfo)))
                }
               
            }catch let error{
                completion(.failure(HssOktaFlutterException(
                    code: "Error", message: error.localizedDescription,details: ""
                )))
            }
        }
    }
    
   
    
    func removeCredential(tokenId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task{
            Task{
                do{
                    
                    try Credential.with(id:tokenId)?.remove()
                    completion(.success(true))
                    
                }catch let error{
                    completion(.failure(HssOktaFlutterException(
                        code: "Error", message: error.localizedDescription,details: ""
                    )))
                }
            }
        }
    }
    
    func setDefaultToken(tokenId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task{
            do{
               
                try Credential.tokenStorage.setDefaultTokenID(tokenId)
                completion(.success(true))
                
            }catch let error{
                completion(.failure(HssOktaFlutterException(
                    code: "Error", message: error.localizedDescription,details: ""
                )))
            }
        }}

    
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


