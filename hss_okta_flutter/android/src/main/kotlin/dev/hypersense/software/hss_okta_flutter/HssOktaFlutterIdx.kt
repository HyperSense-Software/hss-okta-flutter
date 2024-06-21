package dev.hypersense.software.hss_okta_flutter

import android.provider.Settings.Global
import com.okta.authfoundation.claims.email
import com.okta.authfoundation.claims.familyName
import com.okta.authfoundation.claims.gender
import com.okta.authfoundation.claims.givenName
import com.okta.authfoundation.claims.issuedAt
import com.okta.authfoundation.claims.middleName
import com.okta.authfoundation.claims.phoneNumber
import com.okta.authfoundation.claims.userId
import com.okta.authfoundation.claims.username
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.client.OidcEndpoints
import com.okta.authfoundation.client.dto.OidcUserInfo
import com.okta.authfoundation.credential.Token
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.idx.kotlin.client.InteractionCodeFlow
import com.okta.idx.kotlin.client.InteractionCodeFlow.Companion.createInteractionCodeFlow
import com.okta.idx.kotlin.dto.IdxUser
import dev.hypersense.software.hss_okta.AuthenticationResult
import dev.hypersense.software.hss_okta.DirectAuthenticationResult
import dev.hypersense.software.hss_okta.IdxResponse
import dev.hypersense.software.hss_okta.OktaToken
import dev.hypersense.software.hss_okta.RequestIntent
import dev.hypersense.software.hss_okta.UserInfo
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.internal.wait


class HssOktaFlutterIdx(iodcClient : OidcClient) {
    private var client = iodcClient

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
       var flow = runBlocking {
           idxFlow(client)
       }


        var response = flow.resume().getOrThrow()
        val remediation = response.remediations.get("identify")
        val emailField = remediation?.form?.get("identifier")
        val passwordField = remediation?.form?.get("credentials.passcode")

       if(remediation == null || emailField == null || passwordField == null)
           throw HssOktaException("Failed in finding remediation identify")

       emailField.value = email
       passwordField.value = passwordField

       val proceedResponse = flow.proceed(remediation).getOrThrow()



       if(response.isLoginSuccessful){
           val token = flow.exchangeInteractionCodeForTokens(remediation = remediation).getOrThrow()

           callback.invoke(Result.success(composeIdxResult(token,proceedResponse)))
       }else{
           callback.invoke(Result.failure(HssOktaException(
               response.messages.messages.firstOrNull()?.message ?: "Login Failed, Check possible remediations",
           )))
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