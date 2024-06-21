package dev.hypersense.software.hss_okta_flutter


import android.content.Context
import android.media.metrics.Event
import android.os.Build
import android.util.Log
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
import com.okta.idx.kotlin.client.InteractionCodeFlow
import com.okta.idx.kotlin.client.InteractionCodeFlow.Companion.createInteractionCodeFlow
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
import dev.hypersense.software.hss_okta.IdxResponse
import dev.hypersense.software.hss_okta.OktaToken
import dev.hypersense.software.hss_okta.UserInfo
import io.flutter.plugin.common.EventChannel

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.internal.wait

class HssOktaFlutterPlugin : HssOktaFlutterPluginApi, FlutterPlugin{
    private var context : Context? = null
    private val browserSignInChannelName = "dev.hypersense.software.hss_okta.channels.browser_signin";
    private val browserSignOutChannelName = "dev.hypersense.software.hss_okta.channels.browser_signout"

    private lateinit var browserSignInEventChannel : EventChannel
    private lateinit var browserSignOutEventChannel : EventChannel

    private lateinit var deviceAuthorizationFlow : DeviceAuthorizationFlow
    private lateinit var deviceAuthorizationFlowContext : DeviceAuthorizationFlow.Context
    private lateinit var idx : HssOktaFlutterIdx
   
   private fun initializeOIDC() {
       if(context == null){
           throw  Exception("Context is null")
       }

       val oidcConfiguration = OidcConfiguration(
           clientId =  BuildConfig.CLIENT_ID,
           defaultScope = BuildConfig.SCOPES,
       )

       println("${BuildConfig.ISSUER.toHttpUrl()}")

       val oidcClient = OidcClient.createFromDiscoveryUrl(
           oidcConfiguration,
           "${BuildConfig.ISSUER}/.well-known/openid-configuration".toHttpUrl(),)

       CredentialBootstrap.initialize(oidcClient.createCredentialDataSource(context!!))

      this.idx = HssOktaFlutterIdx(oidcClient)
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
                    callback.invoke(Result.failure(res.exception))
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
                callback.invoke(Result.failure(Exception("Okta Android doesn't provide MFA OTP")))
            }catch (e: java.lang.Exception){
                callback.invoke(Result.failure(e))
            }
        }
    }


    override fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().refreshToken()){
                is OidcClientResult.Error -> callback.invoke(Result.failure(Exception(result.exception)))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            when(val result = CredentialBootstrap.defaultCredential().revokeToken(RevokeTokenType.ACCESS_TOKEN)){
                is OidcClientResult.Error -> callback.invoke(Result.failure(Exception(result.exception)))
                is OidcClientResult.Success -> callback.invoke(Result.success(true))
            }
        }
    }

    override fun getCredential(callback: (Result<AuthenticationResult?>) -> Unit) {
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
                    callback.invoke(Result.failure(Exception(session.exception)))
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

    override fun resumeDeviceAuthorizationFlow(callback: (Result<AuthenticationResult?>) -> Unit) {
        try {
            CoroutineScope(Dispatchers.IO).launch {

                when(val session = deviceAuthorizationFlow.resume(deviceAuthorizationFlowContext)){
                    is OidcClientResult.Error -> {
                        callback.invoke(Result.failure(Exception(session.exception)))
                    }
                    is OidcClientResult.Success -> {
                        CredentialBootstrap.defaultCredential().storeToken(session.result)

                        when(val userInfo = CredentialBootstrap.defaultCredential().getUserInfo()){
                            is OidcClientResult.Error -> callback.invoke(Result.failure(Exception(userInfo.exception)))
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

    override fun startTokenExchangeFlow(
        deviceSecret: String,
        idToken: String,
        callback: (Result<AuthenticationResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            val credentialDataSource: CredentialDataSource = CredentialBootstrap.credentialDataSource

            val tokenExchangeFlow: TokenExchangeFlow = CredentialBootstrap.oidcClient.createTokenExchangeFlow()
            when(val result =tokenExchangeFlow.start(idToken, deviceSecret)){
                is OidcClientResult.Error -> callback.invoke(Result.failure(result.exception))
                is OidcClientResult.Success ->{
                    CredentialBootstrap.defaultCredential().storeToken(token = result.result)

                    when(val userInfo = CredentialBootstrap.defaultCredential().getUserInfo()){
                        is OidcClientResult.Error -> callback.invoke(Result.failure(userInfo.exception))
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
               callback.invoke(Result.failure(exception))
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

                callback.invoke(Result.failure(Exception("No token found")))
            }catch (exception : Exception){
                  callback.invoke(Result.failure(exception))
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

                callback.invoke(Result.failure(Exception("Failed to delete credential, Token not found")))

            }catch (exception : Exception){
                callback.invoke(Result.failure(exception))
            }

        }
    }

    /// NOT AVAILABLE FOR ANDROID
    override fun setDefaultToken(tokenId: String, callback: (Result<Boolean>) -> Unit) {
       throw NotImplementedError()
    }

    override fun authenticateWithEmailAndPassword(
        email: String,
        password: String,
        callback: (Result<IdxResponse?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            idx.authenticateWithEmailAndPassword(email, password, callback)
        }
    }

    override fun startInteractionCodeFlow(
        email: String?,
        remidiation: String,
        callback: (Result<IdxResponse?>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun startSMSPhoneEnrollment(phoneNumber: String, callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun continueSMSPhoneEnrollment(passcode: String, callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun continueWithGoogleAuthenticator(
        code: String,
        callback: (Result<IdxResponse?>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun continueWithPasscode(passcode: String, callback: (Result<IdxResponse?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun sendEmailCode(callback: (Result<Unit>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun pollEmailCode(callback: (Result<IdxResponse?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun startUserEnrollmentFlow(
        email: String,
        details: Map<String, String>,
        callback: (Result<Boolean>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun recoverPassword(identifier: String, callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun getIdxResponse(callback: (Result<IdxResponse?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun cancelCurrentTransaction(callback: (Result<Boolean>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun getRemidiations(callback: (Result<List<String>>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun getRemidiationsFields(
        remidiation: String,
        fields: String?,
        callback: (Result<List<String>>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun getRemidiationAuthenticators(
        remidiation: String,
        fields: String?,
        callback: (Result<List<String>>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun getEnrollmentOptions(callback: (Result<String>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun enrollSecurityQuestion(
        questions: Map<String, String>,
        callback: (Result<Boolean>) -> Unit
    ) {
        TODO("Not yet implemented")
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

class HssOktaException : Exception{
    constructor() : super()
    constructor(message : String) : super(message)
    constructor(message: String,cause :Throwable) : super(message,cause)
}
