import Flutter
import OktaDirectAuth
import AuthFoundation
import UIKit
import WebAuthenticationUI


enum HssOktaError: Error {
case configError(String)
case credentialError(String)
}


public class HssOktaFlutterPlugin: NSObject, FlutterPlugin,HssOktaFlutterPluginApi {
    
    func startBrowserAuthenticationFlow(completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        
    }
    
    var flow : DirectAuthenticationFlow?
    var status : DirectAuthenticationFlow.Status?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaFlutterPluginApi & NSObjectProtocol = HssOktaFlutterPlugin.init()
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "browser-redirect")
        
        HssOktaFlutterPluginApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
    
    func initializeConfiguration(clientid: String, signInRedirectUrl: String, signOutRedirectUrl: String, issuer: String, scopes: String) throws {
        
        
     }
    
    func startDirectAuthenticationFlow(request: DirectAuthRequest, completion: @escaping (Result<OktaAuthenticationResult?, Error>) -> Void) {
        
        
        if let config = try? OAuth2Client.PropertyListConfiguration(){

            flow = DirectAuthenticationFlow(issuer: config.issuer, clientId: config.clientId, scopes: config.scopes,supportedGrants: [.password,.otpMFA])
            
            Task{
                do{
                    
                    let status = try await flow!.start(request.username, with: .password(request.password))
                    self.status = status
                    
                    switch status{
                    case .success(let token):
                        Credential.default = try Credential.store(token)
                        var userInfo = try await Credential.default?.userInfo()

                        completion(.success(OktaAuthenticationResult(
                            result: AuthenticationResult.success,
                            
                            token: OktaToken(
                                id: token.id,
                                token: token.idToken?.rawValue ?? "",
                                issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                                tokenType: token.tokenType, accessToken: token.accessToken, scope: token.scope ?? "",
                                refreshToken: token.refreshToken ?? ""),
                            
                        userInfo:  UserInfo(userId: "", givenName: userInfo?.givenName ?? "", middleName: userInfo?.middleName ?? "", familyName: userInfo?.familyName ?? "", gender: userInfo?.gender ?? "", email: userInfo?.email ?? "", phoneNumber: userInfo?.phoneNumber ?? "", username: userInfo?.preferredUsername  ?? "")
                        )))
                        
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
                    var userInfo = try await Credential.default?.userInfo()
                    
                    completion(.success(OktaAuthenticationResult(
                        result: AuthenticationResult.success,
                        
                        token: OktaToken(
                            id: token.id,
                            
                            token: token.idToken?.rawValue ?? "",
                            issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                            tokenType: token.tokenType,
                            accessToken: token.accessToken,
                            scope: token.scope ?? "",
                            refreshToken: token.refreshToken ?? ""),
                        
                            userInfo: UserInfo(userId: "", givenName: userInfo?.givenName ?? "", middleName: userInfo?.middleName ?? "", familyName: userInfo?.familyName ?? "", gender: userInfo?.gender ?? "", email: userInfo?.email ?? "", phoneNumber: userInfo?.phoneNumber ?? "", username: userInfo?.preferredUsername  ?? "")
                    )))
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
                
                var resultEnum = AuthenticationResult.success
                var userInfo = try await Credential.default?.userInfo()
                
                completion(.success(OktaAuthenticationResult(
                    result: resultEnum,
                    token: OktaToken(
                        id: result.token.id,
                        token: result.token.idToken?.rawValue ?? "",
                        issuedAt: Int64(((result.token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                        tokenType: result.token.tokenType,
                        accessToken: result.token.accessToken,
                        scope: result.token.scope ?? "",
                        refreshToken: result.token.refreshToken ?? ""
                    ),
                    userInfo: UserInfo(userId: "", givenName: userInfo?.givenName ?? "", middleName: userInfo?.middleName ?? "", familyName: userInfo?.familyName ?? "", gender: userInfo?.gender ?? "", email: userInfo?.email ?? "", phoneNumber: userInfo?.phoneNumber ?? "", username: userInfo?.preferredUsername  ?? "")
                )))
            }else{
                var resultEnum = AuthenticationResult.error
                completion(.success(OktaAuthenticationResult(result: resultEnum,error: "Failed to Login : Server did not provide result")))
            }
        }
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
            binaryMessenger: messenger)
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
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        super.init()
        createNativeView(view: _view)
        let browserAuth = FlutterEventChannel(name: "dev.hss.okta_flutter/browser_signin", binaryMessenger: messenger)
        browserAuth.setStreamHandler(BrowserAuthenticationHandler(view: _view))
        
        
    }

    func view() -> UIView {
        return _view
    }


    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.white
    }
}

class BrowserAuthenticationHandler : NSObject, FlutterStreamHandler{
    private var sink: FlutterEventSink?
    lazy var auth = WebAuthentication.shared
    private var view : UIView
    
    init(view : UIView){
        self.view = view
    }
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
                print("onListen......")
                self.sink = eventSink
                
        Task{
            do{
                let token = try await auth?.signIn(from: self.view.window)
                eventSink("success?")
            }catch let e{
                eventSink(e.localizedDescription)
            }
            eventSink("success after the task?")
        }

        
                return nil
            }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
    
    
}
