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
import com.okta.authfoundation.credential.CredentialDataSource
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundation.credential.RevokeTokenType
import com.okta.authfoundation.credential.Token
import com.okta.authfoundationbootstrap.*
import com.okta.oauth2.DeviceAuthorizationFlow
import com.okta.oauth2.DeviceAuthorizationFlow.Companion.createDeviceAuthorizationFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import com.okta.oauth2.TokenExchangeFlow
import com.okta.oauth2.TokenExchangeFlow.Companion.createTokenExchangeFlow
import dev.hypersense.software.hss_okta.AuthenticationResult
import dev.hypersense.software.hss_okta.DeviceAuthorizationSession
import dev.hypersense.software.hss_okta.DirectAuthRequest
import dev.hypersense.software.hss_okta.HssOktaFlutterPluginApi
import dev.hypersense.software.hss_okta.DirectAuthenticationResult
import dev.hypersense.software.hss_okta.HssOktaFlutterException
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
        callback: (Result<AuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            val flow = CredentialBootstrap.oidcClient.createResourceOwnerFlow()

            when(val res = flow.start(request.username,request.password)){
                is OidcClientResult.Error -> {

                    callback.invoke(Result.failure(HssOktaFlutterException(
                        code = "Start error",
                        message = res.exception.message,
                        details = res.exception.stackTraceToString()
                    )))
                }
                is OidcClientResult.Success -> {

                    CredentialBootstrap.defaultCredential().storeToken(token = res.result)
                    var userInfo = CredentialBootstrap.defaultCredential().getUserInfo()
                    var userInfoResult = userInfo.getOrThrow()


                    callback.invoke(Result.success(composeOktaResult(res.result,userInfoResult)))
                }
            }
        }
    }
    
    override fun continueDirectAuthenticationMfaFlow(
        otp: String,
        callback: (Result<AuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code= "Error",
                    message ="Okta Android doesn't provide MFA OTP")))
            }catch (e: java.lang.Exception){

                callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = e.message,
                    details = e.stackTraceToString()
                )))
            }
        }
    }

    override fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().refreshToken()){
                is OidcClientResult.Error ->   callback.invoke(Result.failure(
                    HssOktaFlutterException(
                    code = "Error",
                    message = result.exception.message,
                    details = result.exception.stackTraceToString()
                )))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().revokeToken(RevokeTokenType.ACCESS_TOKEN)){
                is OidcClientResult.Error -> callback.invoke(Result.failure(
                    HssOktaFlutterException(
                    code = "Error",
                    message = result.exception.message,
                    details = result.exception.stackTraceToString()
                )))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun getCredential(callback: (Result<AuthenticationResult?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            val credential = try{
                CredentialBootstrap.defaultCredential();
            }catch(e: java.lang.Exception){
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = e.message,
                    details = e.stackTraceToString()
                )))
                null
            } ?: return@launch

            val userInfo = try{
                credential.getUserInfo().getOrThrow()
            }catch(e: java.lang.Exception){
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = e.message,
                    details = e.stackTraceToString()
                )))
                null
            } ?: return@launch

            if(credential.token?.idToken == null){
                credential.delete()
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code ="Token error",
                    message = "Previous token is empty and will be deleted")))
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
                    callback.invoke(Result.failure(HssOktaFlutterException(
                        code = "Error",
                        message = session.exception.message,
                        details = session.exception.stackTraceToString()
                    )))
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
            callback.invoke(Result.failure(HssOktaFlutterException(
                code = "Error",
                message = exception.message,
                details = exception.stackTraceToString()
            )))
        }
    }

    override fun resumeDeviceAuthorizationFlow(callback: (Result<AuthenticationResult?>) -> Unit) {
        try {
            CoroutineScope(Dispatchers.IO).launch {

                when(val session = deviceAuthorizationFlow.resume(deviceAuthorizationFlowContext)){
                    is OidcClientResult.Error -> {
                        callback.invoke(Result.failure(HssOktaFlutterException(
                            code = "Error",
                            message = session.exception.message,
                            details = session.exception.stackTraceToString()
                        )))
                    }
                    is OidcClientResult.Success -> {
                        CredentialBootstrap.defaultCredential().storeToken(session.result)

                        when(val userInfo = CredentialBootstrap.defaultCredential().getUserInfo()){
                            is OidcClientResult.Error ->  callback.invoke(Result.failure(HssOktaFlutterException(
                                code = "Error",
                                message = userInfo.exception.message,
                                details = userInfo.exception.stackTraceToString()
                            )))
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
            callback.invoke(Result.failure(HssOktaFlutterException(
                code = "Error",
                message = exception.message,
                details = exception.stackTraceToString()
            )))
        }}

    override fun startTokenExchangeFlow(
        deviceSecret: String,
        idToken: String,
        callback: (Result<AuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            val credentialDataSource: CredentialDataSource = CredentialBootstrap.credentialDataSource

            val tokenExchangeFlow: TokenExchangeFlow = CredentialBootstrap.oidcClient.createTokenExchangeFlow()
            when(val result =tokenExchangeFlow.start(idToken, deviceSecret)){
                is OidcClientResult.Error -> callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = result.exception.message,
                    details = result.exception.stackTraceToString()
                )))
                is OidcClientResult.Success ->{
                    CredentialBootstrap.defaultCredential().storeToken(token = result.result)

                    when(val userInfo = CredentialBootstrap.defaultCredential().getUserInfo()){
                        is OidcClientResult.Error ->  callback.invoke(Result.failure(HssOktaFlutterException(
                            code = "Error",
                            message = userInfo.exception.message,
                            details = userInfo.exception.stackTraceToString()
                        )))
                        is OidcClientResult.Success ->{
                            callback.invoke(Result.success(
                                composeOktaResult(result.result,userInfo.result)
                            ))
                        }
                    }
                }
            }
        }
    }

    override fun getAllUserIds(callback: (Result<List<String>>) -> Unit) {
       CoroutineScope(Dispatchers.IO).launch {
           try{
               val credentialList = CredentialBootstrap.credentialDataSource.listCredentials()
               val ids = credentialList.mapNotNull { credential -> credential.token?.idToken }

               callback.invoke(Result.success(ids))
           }catch (exception : Exception){
               callback.invoke(Result.failure(HssOktaFlutterException(
                   code = "Error",
                   message = exception.message,
                   details = exception.stackTraceToString()
               )))
           }

       }
    }

    override fun getToken(tokenId: String, callback: (Result<AuthenticationResult?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            try{
                val credentialList = CredentialBootstrap.credentialDataSource.listCredentials()
                val selectedCredential = credentialList.firstOrNull { credential ->  credential.token?.idToken == tokenId}

               if(selectedCredential != null){
                   callback.invoke(Result.success(selectedCredential.token?.let {
                       composeOktaResult(
                           res = it,
                           userInfoResult = selectedCredential.getUserInfo().getOrThrow(),
                       )
                   }))
               }

                callback.invoke(Result.failure(HssOktaFlutterException(code = "Error","No token found")))
            }catch (exception : Exception){
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = exception.message,
                    details = exception.stackTraceToString()
                )))
            }

        }
    }

    override fun removeCredential(tokenId: String, callback: (Result<Boolean>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            try{
                val credentialList = CredentialBootstrap.credentialDataSource.listCredentials()
                val selectedCredential = credentialList.firstOrNull { credential ->  credential.token?.idToken == tokenId}

                if(selectedCredential != null){
                    selectedCredential.delete()
                    callback.invoke(Result.success(true))
                }

                callback.invoke(Result.failure(
                    HssOktaFlutterException(
                    code = "Error",
                    message ="Failed to delete credential, Token not found")))

            }catch (exception : Exception){
                callback.invoke(Result.failure(HssOktaFlutterException(
                    code = "Error",
                    message = exception.message,
                    details = exception.stackTraceToString()
                )))
            }

        }
    }

    /// NOT AVAILABLE FOR ANDROID
    override fun setDefaultToken(tokenId: String, callback: (Result<Boolean>) -> Unit) {
       throw HssOktaFlutterException(code = "Missing", message = "This is not available for Android")
    }


    private fun composeOktaResult(res : Token, userInfoResult : OidcUserInfo) : AuthenticationResult{
        return AuthenticationResult(
            result = DirectAuthenticationResult.SUCCESS,
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



}