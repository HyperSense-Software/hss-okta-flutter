import OktaIdx
public class HSSOktaFlutterIdx{
    var idxFlow : InteractionCodeFlow
    
    init() throws{
        idxFlow = try InteractionCodeFlow()
        
        Task{
                        if #available(iOS 15.0, *) {
                try await idxFlow.start()
            } else {
                throw HssOktaError.configError("This Wrapper is only available for iOS 15.0")
            }
        }
    }
    
    
    func authenticateWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
        Task{
            do{
                
                idxFlow = try InteractionCodeFlow();
                
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow.start()
                    
                    guard let remediation = response.remediations[.identify],
                          let usernameField = remediation["identifier"],
                          let passwordField = remediation["credentials.passcode"]
                    else{
                        return completion(.failure(HssOktaError.generalError("Failed indentifying remidiation, check available remidiation fields")))
                    }
                    
                    usernameField.value = email
                    passwordField.value = password
                    
                    response = try await remediation.proceed()
                
                    guard response.isLoginSuccessful
                    else{
                        completion(.success(self.mapResponeToIdxResponse(response: response, token: nil)))
                        return
                    }
                    
                    let token =  try await response.exchangeCode()
                    
                    completion(.success(self.mapResponeToIdxResponse(response: response,token: OktaToken(
                        id: token.id,
                        token: token.idToken?.rawValue ?? "",
                        issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
                        tokenType: token.tokenType,
                        accessToken: token.accessToken,
                        scope: token.scope ?? "",
                        refreshToken: token.refreshToken ?? ""
                    ))))
                    
                    
                } else {
                    completion(.failure(HssOktaError.generalError("This method is Only Avaialable to iOS 15.0 or newer")))
                }
                
            }catch let error{
                completion(.failure(HssOktaError.generalError(error.localizedDescription.debugDescription)))
            }
        }
    }
    
    func startSMSPhoneEnrollment(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Task{
            idxFlow.resume(
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
        
        idxFlow.resume(completion: { result in
            
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
    
    func startUserEnrollmentFlow(email: String,details: [String : String],  completion: @escaping (Result<Bool, Error>) -> Void) {
            Task{
                if #available(iOS 15.0, *) {
                    
                    var response = idxFlow.context != nil ? try await idxFlow.resume() : try await idxFlow.start()
                    
                    guard let selectEnrollRemediation = response.remediations[.selectEnrollProfile] else {
                        completion(.failure(HssOktaError.generalError("The organization doesn't have enrollProfile enabled")))
                        return
                    }
                    
                    response = try await selectEnrollRemediation.proceed()
                    
                    guard let enrollRemediation = response.remediations[.enrollProfile],
                          let emailField = enrollRemediation["userProfile.email"],
                          let passwordField = enrollRemediation["credentials.passcode"]
                    else {
                        let error = response.messages.first?.message
                        completion(.failure(HssOktaError.generalError("Failed with remidation : \(error ?? "unknown error")")))
                        return
                    }
                    
                    emailField.value = email
                    passwordField.value = "23321122aA"
                    details.forEach({key,value in
                        enrollRemediation[key]?.value = value
                    })
                    
                    response =  try await enrollRemediation.proceed()
                   
                    completion(.success(true))
                   
                } else {
                    completion(.failure(HssOktaError.generalError("This is only available for iOS 15.0 and above")))
                }
            }
            
        
    }
    
    func recoverPassword(identifier: String, completion: @escaping (Result<Bool, Error>) -> Void) {
      
        
            idxFlow.resume(completion:{ result in
                switch(result){
                case .success(let resultResponse):
                    let response = resultResponse
                    
                    if let recoverable = response.authenticators.current?.recoverable {
                        recoverable.recover(completion: { recoverResponse in
                            switch(recoverResponse){
                            case .success(let recoverResult):
                                Task{
                                    var response = recoverResult

                                    guard let remediation = response.remediations[.identifyRecovery],
                                          let identifierField = remediation["identifier"]
                                    else {
                                        completion(.failure(HssOktaError.generalError("Failed to find remediation identify recovery")))
                                        return
                                    }

                                    identifierField.value = identifier
                                    
                                
                                    
                                    remediation.proceed(completion:{ proceedResult in
                                        
                                        switch(proceedResult){
                                        case .success(let proceedResponse):
                                           guard let verification = proceedResponse.remediations[.authenticatorVerificationData],
                                                 let methodType = verification.form["authenticator.methodType"]
                                                    
                                            else{
                                               return
                                           }
                                            
                                            let option = methodType.options?.first
                                            
                                            methodType.selectedOption = option
                                            
                                            verification.proceed(completion:{
                                                verificationResult in
                                                switch(verificationResult){
                                                case .success(let verificationResultResponse):
                                                    
                                                    
                                                    
                                                    completion(.success(true))
                                                    break
                                                case .failure(let error):
                                                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                                                }
                                            })

                                            break
                                            
                                        case .failure(let error):
                                            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                                        }
                                        
                                    })

                                }
                                
                                break
                            case .failure(_):
                                let error = response.messages.first?.message
                                completion(.failure(HssOktaError.generalError("Failed with remidation : \(error ?? "unknown error")")))
                            }
                        })
                        
                       
                       
                    }else{
                        completion(.failure(HssOktaError.generalError("Failed to recover password : \(response.messages.allMessages.first?.message ?? "Unknown error")")))
                    }
                    break
                case .failure(let error):
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                }
            })

    }
  
    func getIdxResponse(completion: @escaping (Result<IdxResponse?, Error>) -> Void){
        return resumeFlow(completion: {res in
            switch(res){
            case .success(let result):
                completion(.success(self.mapResponeToIdxResponse(response: result,token: nil)))
                break
            case.failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func cancelCurrentTransaction(completion: @escaping (Result<Bool, Error>) -> Void) {
        idxFlow.cancel()
    }
    
    func resumeFlow(completion: @escaping (Result<Response,Error>) -> Void){
        
        idxFlow.resume(completion: { result in
            switch(result){
            case .success(let resultResponse):
                completion(.success(resultResponse))
                break
            case .failure(let error):
                completion(.failure(HssOktaError.credentialError(error.localizedDescription)))
            }
        })
        
    }
    
    func startInteractionCodeFlow(email: String?,remidiation: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
        idxFlow.start(completion: { result in
            switch(result){
            case .success(let response):
                
                guard let remidiation = response.remediations[remidiation]
                else{
                    completion(.failure(HssOktaError.generalError("Failed to find remidiation \(remidiation)")))
                    return
                }
                
                if(email != nil){
                    let field = remidiation["identifier"]
                    field?.value = email
                }
          
                
                remidiation.proceed(completion:{ remidiate in
                    switch(remidiate){
                    case .success(let r):
                        completion(.success(self.mapResponeToIdxResponse(response: r, token: nil)))
                        break
                    case .failure(let error):
                        completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                    }
                })
            
            case.failure(let error):
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
            
        })
    }
    
    func continueWithIdentifier(identifier: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
        idxFlow.resume(completion: { resume in
                Task{
                    switch(resume){
                    case .success(var result):
                        
                        var response = result
                        guard let remediation = result.remediations[.identify],
                                let identifierField = remediation["identifier"]
                        else{
                            completion(.failure(HssOktaError.generalError(response.messages.allMessages.first?.message ?? "Unknown error")))
                            return
                        }
                        
                        identifierField.value = identifier
                        
                        if #available(iOS 15.0, *) {
                            response = try await remediation.proceed()
                        } else {
                            completion(.failure(HssOktaError.configError("Only available for iOS 15.0")))
                        }
                        
                        completion(.success(self.mapResponeToIdxResponse(response: response, token: nil)))
                        
                        break
                    case .failure(let error):
                        completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                    }
                }
        })
    }
    
    func continueWithPasscode(passcode: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
        
       
        idxFlow.resume(completion: { resume in
                Task{
                    switch(resume){
                    case .success(let result):
                        
                        var response = result
                        guard let remediation = result.remediations[.challengeAuthenticator],
                                let passcodeField = remediation["credentials.passcode"]
                        else{
                            completion(.failure(HssOktaError.generalError(response.messages.allMessages.first?.message ?? "Remidation was not found")))
                            return
                        }
                        
                  
                        passcodeField.value = passcode
                        
                        if #available(iOS 15.0, *) {
                            do{
                                response = try await remediation.proceed()
                            }catch let error{
                                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                            }
                        } else {
                            completion(.failure(HssOktaError.configError("Only available for iOS 15.0")))
                        }
                        
                        
                        guard response.isLoginSuccessful
                            else{
                            completion(.failure(HssOktaError.generalError(response.messages.allMessages.first?.message ?? "Unknown error")))
                            return
                        }
                        
                        response.exchangeCode(completion:{
                            result in
                            switch(result){
                            case .success(let token):
                                completion(.success(self.mapResponeToIdxResponse(response: response, token: self.mapToOktaToken(token: token))))
                            case.failure(let error):
                                completion(.failure(HssOktaError.generalError(response.messages.allMessages.first?.message ?? error.localizedDescription)))
                            }

                        })
                        
                        break
                    case .failure(let error):
                        completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                    }
                }
        })
    }
    
    func mapResponeToIdxResponse(response : Response,token : OktaToken?) -> IdxResponse{
        
        var remediationOptions = response.remediations.map{$0.name}
        var authenticators = response.authenticators.map{$0.displayName}

        return IdxResponse(expiresAt: response.expiresAt?.millisecondsSince1970, user: UserInfo(userId: response.user?.id ?? "", givenName: response.user?.profile?.firstName ?? "", middleName:"", familyName: response.user?.profile?.lastName ?? "", gender: "", email: "", phoneNumber: "", username: response.user?.username ?? ""), canCancel: response.canCancel,isLoginSuccessful: response.isLoginSuccessful, intent: RequestIntent(rawValue: Int(response.intent.getIndex)) ?? RequestIntent.unknown,messages: response.messages.allMessages.map{$0.message},remediations: remediationOptions, authenticators: authenticators, token: token)
            }
    
    func mapToOktaToken(token : Token) -> OktaToken{
        
        
        
        
      return  OktaToken(
            id: token.id,
            token: token.idToken?.rawValue ?? "",
            issuedAt: Int64(((token.issuedAt?.timeIntervalSince1970 ?? 0) * 1000.0).rounded()),
            tokenType: token.tokenType,
            accessToken: token.accessToken,
            scope: token.scope ?? "",
            refreshToken: token.refreshToken ?? ""
        )
    }
    
    
    func continueWithGoogleAuthenticator(code: String, completion: @escaping (Result<IdxResponse?, Error>) -> Void){
        idxFlow.resume(completion: {resume in
            switch(resume){
            case .success(let response):
           
                    guard let remediation = response.remediations[.selectAuthenticatorAuthenticate],
                    let authenticator = remediation["authenticator"]
                    else{
                        completion(.failure(HssOktaError.generalError("Failed to find remidiation")))
                        return
                    }
                    let googleAuthOption = authenticator.options?.first(where: {field -> Bool in
                        field.label == "Google Authenticator"
                    })
                
                
                    
                    authenticator.selectedOption = googleAuthOption
//                    authenticator.value = code
              
                    
                    remediation.proceed(completion:{ remediationResult in
                        switch(remediationResult) {
                        case .success(let newResponse):
                            
                           guard let googleAuthenticator = newResponse.remediations[.challengeAuthenticator],
                            let codeField = googleAuthenticator["credentials.passcode"]
                            else{
                               completion(.failure(HssOktaError.generalError("Failed to find remediation")))
                               return
                           }
                            
                            codeField.value = code
                            googleAuthenticator.proceed(completion:{authResult in
                                switch(authResult){
                                case .success(let googleAuthResult):
                                    guard googleAuthResult.isLoginSuccessful
                                    else{
                                        completion(.failure(HssOktaError.generalError("Login Failed : \(googleAuthResult.messages.allMessages.first?.message ?? "Unknown error")")))
                                        return
                                    }
                                    
                                    googleAuthResult.exchangeCode(completion:{exchangeResult in
                                        switch(exchangeResult){
                                        case .success(let token):
                                            completion(.success(self.mapResponeToIdxResponse(response: googleAuthResult, token: self.mapToOktaToken(token: token))))
                                        break
                                        case .failure(let error):
                                            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                                        }
                                    })
                                    
                                    break
                                case .failure(let error):
                                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                                }})
                            
                        case .failure(let error):
                            completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                        }
                    })
                    
                    
                
                
                break
            case .failure(let error):
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
        })
    }
    
    func sendEmailCode(completion: @escaping (Result<Void, Error>) -> Void) {
        idxFlow.resume(completion: {resumeResult in
            switch(resumeResult){
            case .success(let resumeResponse):
                guard let remediation = resumeResponse.remediations[.selectAuthenticatorAuthenticate],
                      let authenticator = remediation["authenticator"]
                else{
                    completion(.failure(HssOktaError.generalError("Failed to select Authenticator authenticate")))
                    return
                }
                let emailAuthenticator = authenticator.options?.first(where: {field -> Bool in
                    field.label == "Email"
                })
                
                authenticator.selectedOption = emailAuthenticator
                remediation.proceed(completion:{ result in
                    completion(.success(()))
                })
                
                break
            case .failure(let error):
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                
            }
            })

    }
   
    
  
    
    func pollEmailCode(completion: @escaping (Result<IdxResponse?, Error>) -> Void) {
//        TESTING ON HOLD, CAN'T FIND THE MAGIC LINK URI SETTINGS ON OKTA
        
        idxFlow.resume(completion: {resumeResult in
            switch(resumeResult){
            case .success(let resumeResponse):
                Task{
                    guard let authenticator = resumeResponse.remediations[.challengeAuthenticator],
                                    let codeField = authenticator["credentials.passcode"]
                                    else{
                                       completion(.failure(HssOktaError.generalError("Failed to find remediation for challenge Authenticator")))
                                       return
                                   }
                    
                    
                    if let pollable = authenticator.pollable{
                        pollable.startPolling(completion:{ pollResult in
                            switch(pollResult){
                            case .success(let response):
                                
                                guard response.isLoginSuccessful
                                else{
                                    completion(.failure(HssOktaError.generalError("Login Failed : \(response.messages.allMessages.first?.message ?? "Unknown error")")))
                                    return
                                }
                                
                                response.exchangeCode(completion:{exchangeResult in
                                    switch(exchangeResult){
                                    case .success(let token):
                                        completion(.success(self.mapResponeToIdxResponse(response:response , token: self.mapToOktaToken(token: token))))
                                    break
                                    case .failure(let error):
                                        completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                                    }
                                })
                                
                                break
                            case .failure(let error):
                                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                            }
                            
                        })
                    }else{
                        completion(.failure(HssOktaError.configError("Email is not pollable, Check your org configuration")
))                    }
                    
                   
                }

                break
                
            case .failure(let error):
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
        })

    }
    
    func getEnrollmentOptions(completion: @escaping (Result<String, Error>) -> Void) {
        idxFlow.resume(completion: {resumeResult in
            switch(resumeResult){
            case .success(let resumeResponse):
                guard let remediation = resumeResponse.remediations[.identify]
                else{
                    completion(.failure(HssOktaError.generalError("Failed to find remediation for enroll authenticator")))
                    return
                }
                
                let r = remediation.authenticators
                

                break
                
            case .failure(let error):
                completion(.failure(HssOktaError.generalError(error.localizedDescription)))
            }
        })
    }
}
