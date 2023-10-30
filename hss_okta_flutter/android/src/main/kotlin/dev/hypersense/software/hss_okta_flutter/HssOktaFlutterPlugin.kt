package dev.hypersense.software.hss_okta_flutter


import android.content.Context
import android.media.metrics.Event
import android.os.Build
import com.okta.authfoundation.claims.*
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.client.dto.OidcUserInfo
import com.okta.authfoundation.credential.Credential
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundation.credential.RevokeTokenType
import com.okta.authfoundation.credential.Token
import com.okta.authfoundationbootstrap.*
import com.okta.oauth2.DeviceAuthorizationFlow
import com.okta.oauth2.DeviceAuthorizationFlow.Companion.createDeviceAuthorizationFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import dev.hypersense.software.hss_okta.AuthenticationResult
import dev.hypersense.software.hss_okta.DeviceAuthorizationSession
import dev.hypersense.software.hss_okta.DirectAuthRequest
import dev.hypersense.software.hss_okta.HssOktaFlutterPluginApi
import dev.hypersense.software.hss_okta.OktaAuthenticationResult
import dev.hypersense.software.hss_okta.OktaToken
import dev.hypersense.software.hss_okta.UserInfo
import io.flutter.plugin.common.EventChannel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.HttpUrl.Companion.toHttpUrl

class HssOktaFlutterPlugin : HssOktaFlutterPluginApi, FlutterPlugin{
    private var context : Context? = null
    private val browserSignInChannelName = "dev.hypersense.software.hss_okta.channels.browser_signin";
    private val browserSignOutChannelName = "dev.hypersense.software.hss_okta.channels.browser_signout"

    private lateinit var browserSignInEventChannel : EventChannel
    private lateinit var browserSignOutEventChannel : EventChannel

    private lateinit var deviceAuthorizationFlow : DeviceAuthorizationFlow
    private lateinit var deviceAuthorizationFlowContext : DeviceAuthorizationFlow.Context

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

    private fun composeOktaResult(res : Token, userInfoResult : OidcUserInfo) : OktaAuthenticationResult{
        return OktaAuthenticationResult(
            result = AuthenticationResult.SUCCESS,
            token = OktaToken(
                id = "",
                issuedAt = userInfoResult.issuedAt?.toLong(),
                tokenType = res.tokenType,
                scope = res.scope,
                refreshToken = res.refreshToken,
                accessToken = res.accessToken,
                token = res.idToken
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


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {

        HssOktaFlutterPluginApi.setUp(binding.binaryMessenger, this)

        browserSignInEventChannel = EventChannel(binding.binaryMessenger,browserSignInChannelName)
        browserSignOutEventChannel = EventChannel(binding.binaryMessenger,browserSignOutChannelName)

        binding.platformViewRegistry.registerViewFactory(
            WebSignInNativeViewFactory.platformViewName,
            WebSignInNativeViewFactory(browserSignInEventChannel)
        )

        binding.platformViewRegistry.registerViewFactory(
            WebSignOutNativeViewFactory.platformViewName,
            WebSignOutNativeViewFactory(browserSignOutEventChannel)
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


                return composeOktaResult(res.result,userInfoResult)
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


            callback.invoke(Result.success(composeOktaResult(credential.token!!,userInfo)))
        }
    }

    override fun startDeviceAuthorizationFlow(callback: (Result<DeviceAuthorizationSession?>) -> Unit) {
        try {
        CoroutineScope(Dispatchers.IO).launch {
            deviceAuthorizationFlow = CredentialBootstrap.oidcClient.createDeviceAuthorizationFlow()

            when(val session = deviceAuthorizationFlow.start()){

                is OidcClientResult.Error -> {
                    callback.invoke(Result.failure(Exception("Failed to start session")))
                }
                is OidcClientResult.Success -> {
                    deviceAuthorizationFlowContext = session.result

                    callback.invoke(Result.success(
                        DeviceAuthorizationSession(
                            session.result.userCode,
                            session.result.verificationUri
                        )
                    ))
                }
            }
        }
        }catch (exception : Exception){
            callback.invoke(Result.failure(exception))
        }
    }

    override fun resumeDeviceAuthorizationFlow(callback: (Result<OktaAuthenticationResult?>) -> Unit) {
        try {
            CoroutineScope(Dispatchers.IO).launch {

                when(val session = deviceAuthorizationFlow.resume(deviceAuthorizationFlowContext)){
                    is OidcClientResult.Error -> {
                        callback.invoke(Result.failure(Exception("Failed to start session")))
                    }
                    is OidcClientResult.Success -> {
                        CredentialBootstrap.defaultCredential().storeToken(session.result)

                        when(val userInfo = CredentialBootstrap.defaultCredential().getUserInfo()){
                            is OidcClientResult.Error -> callback.invoke(Result.failure(Exception("Failed to get user info")))
                            is OidcClientResult.Success ->{
                                callback.invoke(Result.success(
                                    composeOktaResult(session.result,userInfo.result)
                                ))
                            }
                        }


                    }
                }
            }
        }catch (exception : Exception){
            callback.invoke(Result.failure(exception))
        }}


    }

