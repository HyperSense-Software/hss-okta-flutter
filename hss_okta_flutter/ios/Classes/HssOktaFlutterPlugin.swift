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
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "dev.hypersense.software.hss_okta.browser-signin-widget")
        
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
       
        if let config = try? OAuth2Client.PropertyListConfiguration(){
            
            let flow = SessionLogoutFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes, logoutRedirectUri: config.redirectUri)
            
            Task{
                do{
                    let result = try await browserAuth?.signOutFlow?.start(with: flow)

                }catch let error{
                    debugPrint(error)
                    completion(.success(false))
                }
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
            if let result = Credential.default{
                
                let userInfo = Credential.default?.userInfo
                
                completion(.success(constructAuthenticationResult(resultEnum: AuthenticationResult.success, token: result.token, userInfo: userInfo)))
                
            }else{
                
                completion(.success(OktaAuthenticationResult(result:  AuthenticationResult.error,error: "Failed To fetch default Credentail ")))
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

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: self.messenger
        )
    }


    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger) {
        _view = UIView()
        super.init()
       
        let browserAuth = FlutterEventChannel(name: "dev.hss.okta_flutter.browser_signin", binaryMessenger: messenger)
        browserAuth.setStreamHandler(BrowserAuthenticationHandler(view: _view))
        createNativeView(view: _view)
    }

    func view() -> UIView {
        
        return _view
    }


    func createNativeView(view _view: UIView){}
}

class BrowserAuthenticationHandler : NSObject, FlutterStreamHandler{
    private var sink: FlutterEventSink?
    lazy var auth = WebAuthentication.shared
    private var view : UIView
    
    init(view : UIView){
        self.view = view
        super.init()
        
    }
    
    func startAuthenticationFlow() async throws -> Bool {
        do{
            if let token = try await self.auth?.signIn(from: self.view.window){
                try Credential.store(token)
               return true
            }
            
          
            
        }catch let e{
            throw e
        }
        
        return false;
    }
    
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        
        self.sink = eventSink
        Task{@MainActor in
           let result = try await startAuthenticationFlow()
            eventSink(result)
        }
        return nil
        
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
    
    
}
