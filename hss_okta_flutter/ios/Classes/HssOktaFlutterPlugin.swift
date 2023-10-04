import Flutter
import OktaDirectAuth
import AuthFoundation
import UIKit

enum HssOktaError: Error {
case configError(String)
case credentialError(String)
}


public class HssOktaFlutterPlugin: NSObject, FlutterPlugin,HssOktaFlutterPluginApi {
    

    var flow : DirectAuthenticationFlow?
    var status : DirectAuthenticationFlow.Status?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : HssOktaFlutterPluginApi & NSObjectProtocol = HssOktaFlutterPlugin.init()
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
