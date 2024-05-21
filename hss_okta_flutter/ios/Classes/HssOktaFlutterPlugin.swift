import Flutter
import OktaDirectAuth
import OktaOAuth2
import AuthFoundation
import UIKit
import WebAuthenticationUI
import OktaIdx



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
    var idxFlow : InteractionCodeFlow?
    
    
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
                        default:
                            break
                            
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
                completion(.failure(error))
            }
        }
    }
    
    func removeCredential(tokenId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        Task{
            do{
                
                try Credential.with(id:tokenId)?.remove()
                completion(.success(true))
                
            }catch let error{
                completion(.failure(error))
            }
        }
        
    }
    
    func setDefaultToken(tokenId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task{
            do{
                
                try Credential.tokenStorage.setDefaultTokenID(tokenId)
                completion(.success(true))
                
            }catch let error{
                completion(.failure(error))
            }
        }}
    
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
    
    // IDX METHODS
    func startEmailAuthenticationFlow(email: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
        Task{
            do{
                print("STARTING INTERACTION CODE FLOW")
                idxFlow = try InteractionCodeFlow();
                
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow!.start()
                    
                    guard let remediation = response.remediations[.identify],
                          let username = remediation["identifier"]
                    else{
                        return completion(.failure(HssOktaError.generalError("Failed indentifying remidiation, check available remidiation fields")))
                    }
                    
                    var remediations = [String]()
                    
                    response.remediations.forEach{ r in
                        remediations.append(r.name)
                    }
                    
                    username.value = email
                    response = try await remediation.proceed()
                    
                    var nextRemediations = [String:String]()
                    
                    
                    response.remediations.forEach{ r in
                        let remidiationFields = r.form.fields.map{ f1 in
                            f1.form?.fields.map{ f2 in
                                "\(f1.name ?? "").\(f2.name ?? "")"
                            }.joined() ?? ""
                        }.joined()
                        
                        nextRemediations[r.name] = remidiationFields
                    }

                    completion(.success(self.mapResponeToIdxResponse(response: response)))
                } else {
                    completion(.failure(HssOktaError.generalError("This method is Only Avaialable to iOS 15.0 or newer")))
                }
                
            }catch let error{
                completion(.failure(error))
            }
        }
    }
    
    func continueWithPassword(password: String, completion: @escaping (Result<OktaToken?, Error>) -> Void) {
        do{
            
            if idxFlow != nil {
                idxFlow?.resume{ responseResult in
                    Task{
                        if #available(iOS 15.0, *) {
                            var response = try responseResult.get()
                            
                            guard let remidiation = response.remediations[.challengeAuthenticator],
                                  let passwordField = remidiation["credentials.passcode"]
                            else{
                                completion(.failure(HssOktaError.generalError("Failed to satisfy remidation")))
                                return
                            }
                            
                            passwordField.value = password
                            response = try await remidiation.proceed()
                            
                            guard response.isLoginSuccessful
                            else{
                                completion(.failure(HssOktaError.generalError("Login Failed, Check your Input")))
                                return
                            }
                            
                            let tokenResult =  try await response.exchangeCode()
                            
                            completion(.success(OktaToken(
                                id: tokenResult.id,
                                token: tokenResult.idToken?.rawValue, issuedAt: Int64(((tokenResult.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                                tokenType: tokenResult.tokenType, accessToken: tokenResult.accessToken,
                                scope: tokenResult.scope, refreshToken:tokenResult.refreshToken
                            )))
                            
                        } else {
                            completion(.failure(HssOktaError.generalError("Only available for iOS 15.0 or newer")))
                        }
                    }
                    
                    
                }
            }
            
            throw HssOktaError.generalError("Create a flow first")
            
        }catch let error{
            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
        }
    }
    
    func startSMSPhoneEnrollment(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task{
            if(idxFlow == nil){
                completion(.failure(HssOktaError.generalError("Start a flow first")))
            }
            
               idxFlow!.resume(
                    completion: {res in
                        switch(res){
                        case .success(let response):
             
                                
                                guard let remediation = response.remediations[.selectAuthenticatorEnroll],
                                      let authenticatorField = remediation["authenticator"],
                                      let phoneOption = authenticatorField.options?.first(where: { option in
                                          option.label == "Phone"
                                      }),
                                      let phoneNumberField = phoneOption["phoneNumber"],
                                      let methodTypeField = phoneOption["methodType"],
                                      let smsMethod = methodTypeField.options?.first(where: { option in
                                          option.label == "SMS"
                                      }) else
                                {
                                    completion(.failure(HssOktaError.generalError("Failed to enroll SMS")))
                                    return
                                }
                                
                                authenticatorField.selectedOption = phoneOption
                                methodTypeField.selectedOption = smsMethod
                                phoneNumberField.value = phoneNumber
                                
                            remediation.proceed{ proceedResults in
                                completion(.success(true))
                            }

                            break
                        case .failure(let error):
                            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                        }
                    })
        }
    }
    
    
    
    func continueSMSPhoneEnrollment(passcode: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if(idxFlow == nil){
            completion(.failure(HssOktaError.generalError("Start a flow first")))
        }
        idxFlow!.resume(completion: { result in
            
                switch(result){
                case .success(let response):
                    
                    guard let remidiation = response.remediations[.challengeAuthenticator],
                          let passcodeField = remidiation["credentials.passcode"]
                            
                            
                            
                    else {
                        completion(.failure(HssOktaError.generalError("Failed to contunue flow")))
                        return}

                     passcodeField.value = passcode
                    
                    remidiation.proceed(completion: {remidiationResult in
                        switch(remidiationResult){
                        case .success(_):
                            completion(.success(true))
                            break;
                        case .failure(let error):
                            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                        }
                    })
                    
                    break
                case .failure(let error):
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                }
            }
        )
        
    }
    
    func startUserEnrollmentFlow(firstName: String, lastName: String, email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        do{
            if(idxFlow == nil){
                idxFlow = try InteractionCodeFlow()
            }
            
            Task{
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow!.start()
                    guard let remediation = response.remediations[.selectEnrollProfile] else {
                        completion(.failure(HssOktaError.generalError("The organization doesn't have enrollProfile enabled")))
                        return
                    }
                    
                    response = try await remediation.proceed()
                    guard let remediation = response.remediations[.enrollProfile],
                          let firstNameField = remediation["userProfile.firstName"],
                          let lastNameField = remediation["userProfile.lastName"],
                          let emailField = remediation["userProfile.email"]
                    else {
                        let error = response.messages.first?.message
                        completion(.failure(HssOktaError.generalError("Failed with remidation : \(error ?? "unknown error")")))
                        return
                    }
                    
                    firstNameField.value = firstName
                    lastNameField.value = lastName
                    emailField.value = email
                    
                    let newResponse = try await remediation.proceed()
                    completion(.success(true))

                    
                } else {
                    completion(.failure(HssOktaError.generalError("This is only available for iOS 15.0 and above")))
                }
            }
            
        }catch let error{
            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
        }
    }
    
    func recoverPassword(identifier: String, completion: @escaping (Result<IdxResponse, Error>) -> Void) {

            if(idxFlow == nil){
                completion(.failure(HssOktaError.credentialError("Start a flow first")))
                return
            }
            
            idxFlow!.resume(completion:{ result in
                switch(result){
                case .success(let resultResponse):
                    var response = resultResponse
                    
                    if let recoverable = response.authenticators.current?.recoverable {
                        recoverable.recover(completion: { recoverResponse in
                            switch(recoverResponse){
                            case .success(let recoverResult):
                                Task{
                                    var response = recoverResult
                                    var remediations = [String]()
                                    
                                    response.remediations.forEach{ r in
                                        remediations.append(r.name)
                                    }
                                    
                                    guard let remediation = response.remediations[.identifyRecovery],
                                          let identifierField = remediation["identifier"]
                                    else {
                                        // Handle error
                                        return
                                    }

                                    identifierField.value = identifier

                                    if #available(iOS 15.0, *) {
                                        response =  try await recoverable.recover()
                                        
                                        completion(.success(self.mapResponeToIdxResponse(response:response)))
                                        
                                    } else {
                                        completion(.failure(HssOktaError.generalError("This methid is only available for iOS 15.0 and above")))
                                    }
                                    
                                }
                                
                                break
                            case .failure:
                                let error = response.messages.first?.message
                                completion(.failure(HssOktaError.generalError("Failed with remidation : \(error ?? "unknown error")")))
                            }
                        })
                        
                       
                       
                    }else{
                        completion(.failure(HssOktaError.generalError("Password Recovery is not enabled")))
                    }
                    break
                case .failure(let error):
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                }
            })

    }
    
    func getIdxResponse(completion: @escaping (Result<IdxResponse, Error>) -> Void) {
        return safeIdxResponse(completion: {res in
            switch(res){
            case .success(let result):
                completion(.success(self.mapResponeToIdxResponse(response: result)))
                break
            case.failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func safeIdxResponse(completion: @escaping (Result<Response,Error>) -> Void){
        
        if(idxFlow == nil){
            completion(.failure(HssOktaError.credentialError("Start a flow first")))
        }
        
        idxFlow?.resume(completion: { result in
            switch(result){
            case .success(let resultResponse):
                completion(.success(resultResponse))
                break
            case .failure(let error):
                completion(.failure(HssOktaError.credentialError(error.localizedDescription)))
            }
        })
        
    }
            
            func mapResponeToIdxResponse(response : Response) -> IdxResponse{
                return IdxResponse(expiresAt: response.expiresAt?.millisecondsSince1970, canCancel: response.canCancel,isLoginSuccessful: response.isLoginSuccessful, intent: RequestIntent(rawValue: Int(response.intent.getIndex)) ?? RequestIntent.unknown,messages: response.messages.allMessages.map{$0.message},userInfo: UserInfo(userId: response.user?.id ?? "", givenName: response.user?.profile?.firstName ?? "", middleName:"", familyName: response.user?.profile?.lastName ?? "", gender: "", email: "", phoneNumber: "", username: response.user?.username ?? ""))
            }
    
    
}
 


// Move this somewhere else
extension Response.Intent{
        public var getIndex: Int64{
        switch self{
        case .enrollNewUser:
            return   0
        case .login:
            return  1
        case .credentialEnrollment:
            return  2
        case .credentialUnenrollment:
            return 3
        case .credentialRecovery:
          return 4
        case .credentialModify:
            return  5
        default:
            return 6
        }
    }
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
