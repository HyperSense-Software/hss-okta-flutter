import OktaIdx
public class HSSOktaFlutterIdx{
    var idxFlow : InteractionCodeFlow
    
    init() throws{
        idxFlow = try InteractionCodeFlow()
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
                        completion(.failure(HssOktaError.credentialError(response.messages.first?.message ?? "Unknown error")))
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
    
    func startUserEnrollmentFlow(firstName: String, lastName: String, email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
            Task{
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow.start()
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
            
        
    }
    
    func recoverPassword(identifier: String, completion: @escaping (Result<IdxResponse, Error>) -> Void) {
            idxFlow.resume(completion:{ result in
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
                                        
                                        completion(.success(self.mapResponeToIdxResponse(response:response, token: nil)))
                                        
                                    } else {
                                        completion(.failure(HssOktaError.generalError("This methid is only available for iOS 15.0 and above")))
                                    }
                                    
                                }
                                
                                break
                            case .failure(_):
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
    
    func getRemidiations(completion: @escaping (Result<[String], Error>) -> Void) {
        
        if(idxFlow.context == nil){
            Task{
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow.start()
                    var remidiationOptions = [String]()
                    
                    response.remediations.forEach{ option in
                        remidiationOptions.append(option.name)
                    }
                    completion(.success(remidiationOptions))
                    
                } else {
                    completion(.failure(HssOktaError.configError("Only Available to iOS 15.*")))
                }
            }
        }else{
            
            
            idxFlow.resume(completion: {resumeResult in
                switch(resumeResult){
                case .success(let response):
                    
                    var remidiationOptions = [String]()
                    
                    response.remediations.forEach{ option in
                        remidiationOptions.append(option.name)
                    }
                    completion(.success(remidiationOptions))
                    
                    break
                case .failure(let error):
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                }
                
            })}
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
    
    func getRemidiationsFields(remidiation: String,fields:String?, completion: @escaping (Result<[String], Error>) -> Void) {
        
        if(idxFlow.context == nil){
            Task{
                if #available(iOS 15.0, *) {
                    var response = try await idxFlow.start()
                    var forms = [String]()
                    let remidiationForm = response.remediations[remidiation]
                    
                    if(fields != nil){
                        remidiationForm?[fields!]?.form?.forEach({
                            forms.append($0.name ?? "")
                        })

                    }else{
                        remidiationForm?.form.fields.forEach({
                            forms.append($0.name ?? "")
                        })
                    }
                    
                    completion(.success(forms))
                    
                } else {
                    completion(.failure(HssOktaError.configError("Only Available to iOS 15.*")))
                }
            }
        }else{
            
            idxFlow.resume(completion: {result in
                
                switch(result){
                    
                case .success(let response):
                    var forms = [String]()
                    let remidiationForm = response.remediations[remidiation]
                    
                    if(fields != nil){
                        remidiationForm?[fields!]?.form?.forEach({
                            forms.append($0.name ?? "")
                        })

                    }else{
                        remidiationForm?.form.fields.forEach({
                            forms.append($0.name ?? "")
                        })
                    }
                    
                    break
                case .failure(let error):
                    completion(.failure(HssOktaError.generalError(error.localizedDescription)))
                }
                
            })}
        
    }
    
    func mapResponeToIdxResponse(response : Response,token : OktaToken?) -> IdxResponse{
        return IdxResponse(expiresAt: response.expiresAt?.millisecondsSince1970, user: UserInfo(userId: response.user?.id ?? "", givenName: response.user?.profile?.firstName ?? "", middleName:"", familyName: response.user?.profile?.lastName ?? "", gender: "", email: "", phoneNumber: "", username: response.user?.username ?? ""), canCancel: response.canCancel,isLoginSuccessful: response.isLoginSuccessful, intent: RequestIntent(rawValue: Int(response.intent.getIndex)) ?? RequestIntent.unknown,messages: response.messages.allMessages.map{$0.message},token: token)
            }
}
