package dev.hypersense.software.hss_okta_flutter
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.credential.Token
import com.okta.idx.kotlin.client.InteractionCodeFlow
import com.okta.idx.kotlin.client.InteractionCodeFlow.Companion.createInteractionCodeFlow
import dev.hypersense.software.hss_okta.IdxResponse
import dev.hypersense.software.hss_okta.OktaToken
import dev.hypersense.software.hss_okta.RequestIntent
import dev.hypersense.software.hss_okta.UserInfo
import kotlinx.coroutines.runBlocking


class HssOktaFlutterIdx(oidcClient : OidcClient) {
    private var client = oidcClient
    private lateinit var flow : InteractionCodeFlow

    init {
        flow = runBlocking {
            client.createInteractionCodeFlow(redirectUrl = BuildConfig.SIGN_IN_REDIRECT_URI)
        }.getOrThrow()
    }
    companion object{
        suspend fun idxFlow(client:OidcClient):InteractionCodeFlow{
            return client.createInteractionCodeFlow(redirectUrl = BuildConfig.SIGN_IN_REDIRECT_URI).getOrThrow()
        }
    }

   suspend fun authenticateWithEmailAndPassword(
        email: String,
        password: String,
        callback: (Result<IdxResponse?>) -> Unit
    ) {

        var response = flow.resume().getOrThrow()
        val remediation = response.remediations["identify"]
        val emailField = remediation?.form?.get("identifier")
        val passwordField = remediation?.form?.get("credentials.passcode")

       if(remediation == null || emailField == null || passwordField == null)
           throw HssOktaException("Failed in finding remediation identify")

       emailField.value = email
       passwordField.value = password

       val proceedResponse = flow.proceed(remediation).getOrThrow()

       

       if(response.isLoginSuccessful){
           val token = flow.exchangeInteractionCodeForTokens(remediation = remediation).getOrThrow()

           callback.invoke(Result.success(composeIdxResult(token,proceedResponse)))
       }else{
           if(proceedResponse.messages.isEmpty()){
               callback.invoke(Result.success(composeIdxResult(null,proceedResponse)))
           }else{
               callback.invoke(Result.failure(HssOktaException(
                  proceedResponse.messages.messages.first().message ?: "Login Failed, Check your username/password or proceed with another remediation",
               )))
           }

       }
    }

     suspend fun continueWithGoogleAuthenticator(
        code: String,
        callback: (Result<IdxResponse?>) -> Unit
    ) {
 
         var response = flow.resume().getOrThrow()
         val remediation = response.remediations["selectAuthenticatorAuthenticate"]
         val authenticator = remediation?.get("authenticator")
         val googleAuthOption = authenticator?.options?.find { it.label == "Google Authenticator" }

         if(remediation == null || authenticator == null || googleAuthOption == null){
             callback.invoke(Result.failure(HssOktaException("Failed to find remediation")))
         }

         authenticator?.selectedOption = googleAuthOption
         var proceedResponse = flow.proceed(remediation!!).getOrThrow()

         val googleAuth = proceedResponse.remediations["challengeAuthenticator"]
         val codeField = googleAuth?.get("credentials.passcode")

         if(googleAuth == null || codeField == null)
             callback.invoke(Result.failure(HssOktaException("Failed to find remediation")))
         else{
             codeField.value = code
             val result = flow.proceed(googleAuth).getOrThrow()
             if(result.isLoginSuccessful){
                 val token = flow.exchangeInteractionCodeForTokens(remediation = remediation).getOrThrow()

                 callback.invoke(Result.success(composeIdxResult(token,proceedResponse)))
             }else{
                 callback.invoke(Result.failure(HssOktaException(
                     result.messages.messages.first().message ?: "Login Failed, Check your username/password or proceed with another remediation",
                 )))
             }
         }
    }
    
    private fun composeIdxResult(token : Token?, response : com.okta.idx.kotlin.dto.IdxResponse) : IdxResponse {

        val user = response.user
        
        if (token != null) {
            return IdxResponse(
                expiresAt = token.expiresIn.toLong(),
                user = UserInfo(
                    userId = user?.id ?: "",
                    givenName = user?.profile?.firstName?: "",
                    middleName = "",
                    familyName = user?.profile?.lastName?: "",
                    gender = "",
                    email = user?.username?: "",
                    phoneNumber =  "",
                    username = user?.username ?: ""
                ),
                intent = RequestIntent.LOGIN,
                canCancel = true,
                isLoginSuccessful =response.isLoginSuccessful,
                messages = response.messages.messages.map { m -> m.message }.toList(),
                token =
                OktaToken(
                    token = token.idToken,
                    accessToken = token.accessToken,
                    refreshToken =token.refreshToken,
                    scope = token.scope,
                    tokenType = token.tokenType,
                    id = token.idToken
                )


            )
        }else{
            return IdxResponse(
                expiresAt = null,
                user = UserInfo(
                    userId = user?.id ?: "",
                    givenName = user?.profile?.firstName?: "",
                    middleName = "",
                    familyName = user?.profile?.lastName?: "",
                    gender = "",
                    email = user?.username?: "",
                    phoneNumber =  "",
                    username = user?.username ?: ""
                ),
                intent = RequestIntent.LOGIN,
                canCancel = true,
                isLoginSuccessful =response.isLoginSuccessful,
                messages = response.messages.messages.map { m -> m.message }.toList(),
                token = null)
        }
    }
}