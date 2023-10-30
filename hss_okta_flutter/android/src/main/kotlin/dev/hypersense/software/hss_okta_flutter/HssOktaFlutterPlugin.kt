package dev.hypersense.software.hss_okta_flutter


import android.content.Context
import android.os.Build
import com.okta.authfoundation.claims.*
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.credential.Credential
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundation.credential.RevokeTokenType
import com.okta.authfoundationbootstrap.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import dev.hypersense.software.hss_okta.AuthenticationResult
import dev.hypersense.software.hss_okta.DeviceAuthorizationSession
import dev.hypersense.software.hss_okta.DirectAuthRequest
import dev.hypersense.software.hss_okta.HssOktaFlutterPluginApi
import dev.hypersense.software.hss_okta.OktaAuthenticationResult
import dev.hypersense.software.hss_okta.OktaToken
import dev.hypersense.software.hss_okta.UserInfo
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.HttpUrl.Companion.toHttpUrl

class HssOktaFlutterPlugin : HssOktaFlutterPluginApi, FlutterPlugin{
    private var context : Context? = null

   private fun initializeOIDC() {
       println("Initializing OIDC Configuration")
       var credential: Credential

       val oidcConfiguration = OidcConfiguration(
           clientId =  BuildConfig.CLIENT_ID,
           defaultScope = BuildConfig.SCOPES,
       )

       println("${BuildConfig.ISSUER.toHttpUrl()}")

       val oidcClient = OidcClient.createFromDiscoveryUrl(
           oidcConfiguration,
           "${BuildConfig.ISSUER}/.well-known/openid-configuration".toHttpUrl(),)


       if(context == null){
           throw  Exception("Context is null")
       }

       CredentialBootstrap.initialize(oidcClient.createCredentialDataSource(context!!))

       println("Done Initializing OIDC Configuration /()")

       CoroutineScope(Dispatchers.IO).launch{
           credential = CredentialBootstrap.defaultCredential()
       }
   }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaFlutterPluginApi.setUp(binding.binaryMessenger, this)

        binding.platformViewRegistry.registerViewFactory(
            WebSignInNativeViewFactory.platformViewName,
            WebSignInNativeViewFactory()
        )

        binding.platformViewRegistry.registerViewFactory(
            WebSignOutNativeViewFactory.platformViewName,
            WebSignOutNativeViewFactory()
        )
        context = binding.applicationContext

        initializeOIDC()
    }
    
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaFlutterPluginApi.setUp(binding.binaryMessenger, null)

    }


    override fun startDirectAuthenticationFlow(
        request: DirectAuthRequest,
        callback: (Result<OktaAuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {

            try {
                var result = directAuthFlow(request)
                callback.invoke(Result.success(result))
            }catch (e: java.lang.Exception){
                callback.invoke(Result.failure(e))
            }
        }
    }
    
    override fun continueDirectAuthenticationMfaFlow(
        otp: String,
        callback: (Result<OktaAuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {

            try {
                callback.invoke(Result.failure(Exception("Okta Android doesn't provide MFA OTP")))
            }catch (e: java.lang.Exception){
                callback.invoke(Result.failure(e))
            }
        }
    }


    private suspend fun directAuthFlow(request : DirectAuthRequest): OktaAuthenticationResult {
        val flow = CredentialBootstrap.oidcClient.createResourceOwnerFlow()

        when(val res = flow.start(request.username,request.password)){
            is OidcClientResult.Error -> {
                return OktaAuthenticationResult(
                    result = AuthenticationResult.ERROR,
                    error = res.exception.message
                )
            }
            is OidcClientResult.Success -> {

                CredentialBootstrap.defaultCredential().storeToken(token = res.result)
                var userInfo = CredentialBootstrap.defaultCredential().getUserInfo()
                var userInfoResult = userInfo.getOrThrow()


                return OktaAuthenticationResult(
                    result = AuthenticationResult.SUCCESS,
                    token = OktaToken(
                        id = res.result.idToken,
                        issuedAt = userInfoResult.issuedAt?.toLong(),
                        tokenType = res.result.tokenType,
                        scope = res.result.scope,
                        refreshToken = res.result.refreshToken,
                    ),
                    userInfo = UserInfo(
                        userId = userInfoResult.userId?:"",
                        givenName = userInfoResult.givenName?:"",
                        middleName = userInfoResult.middleName?:"",
                        familyName = userInfoResult.familyName?:"",
                        gender = userInfoResult.gender?:"",
                        email = userInfoResult.email?:"",
                        phoneNumber = userInfoResult.phoneNumber?:"",
                        username = userInfoResult.username?:""
                    )
                )
            }
        }
    }


    override fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().refreshToken()){
                is OidcClientResult.Error -> callback.invoke(Result.failure(Exception("Failed to refresh token")))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().revokeToken(RevokeTokenType.ACCESS_TOKEN)){
                is OidcClientResult.Error -> callback.invoke(Result.failure(Exception("Failed to revoke token")))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun getCredential(callback: (Result<OktaAuthenticationResult?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val credential = try{
                CredentialBootstrap.defaultCredential();
            }catch(e: java.lang.Exception){
                callback.invoke(Result.failure(e))
                null
            } ?: return@launch

            val userInfo = try{
                credential.getUserInfo().getOrThrow()
            }catch(e: java.lang.Exception){
               callback.invoke(Result.failure(e))
                null
            } ?: return@launch

            if(credential.token?.idToken == null){
                credential.delete()
                callback.invoke(Result.failure(Exception("Token error : Previous token is empty and will be deleted")))
            }


            callback.invoke(Result.success(OktaAuthenticationResult(
                result = AuthenticationResult.SUCCESS,
                token = OktaToken(
                    issuedAt = userInfo.issuedAt?.toLong(),
                    tokenType = credential.token?.tokenType,
                    scope = credential.token?.scope,
                    refreshToken = credential.token?.refreshToken,
                    id = "",
                    accessToken = credential.token?.accessToken,
                    token = credential.token?.idToken
                ),
                userInfo = UserInfo(
                    userId = userInfo.userId?:"",
                    givenName = userInfo.givenName?:"",
                    middleName = userInfo.middleName?:"",
                    familyName = userInfo.familyName?:"",
                    gender = userInfo.gender?:"",
                    email = userInfo.email?:"",
                    phoneNumber = userInfo.phoneNumber?:"",
                    username = userInfo.username?:""
                )
            )))

        }
    }

    override fun startDeviceAuthorizationFlow(callback: (Result<DeviceAuthorizationSession?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun resumeDeviceAuthorizationFlow(callback: (Result<OktaAuthenticationResult?>) -> Unit) {
        TODO("Not yet implemented")
    }

}