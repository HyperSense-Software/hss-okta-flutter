package dev.hypersense.software.hss_okta_flutter


import android.content.Context
import com.okta.authfoundation.claims.*
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundationbootstrap.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import dev.hypersense.software.hss_okta.AuthenticationResult
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
    var context : Context? = null



    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaFlutterPluginApi.setUp(binding.binaryMessenger, this)
        context = binding.applicationContext
    }
    
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaFlutterPluginApi.setUp(binding.binaryMessenger, null)
    }

    override fun initializeConfiguration(
        clientid: String,
        signInRedirectUrl: String,
        signOutRedirectUrl: String,
        issuer: String,
        scopes: String
    ) {

        println("Initializing OIDC Configuration")
        val oidcConfiguration = OidcConfiguration(
            clientId =  clientid,
            defaultScope = scopes,
        )

        println("${issuer.toHttpUrl()}")

       val oidcClient = OidcClient.createFromDiscoveryUrl(
            oidcConfiguration,
           "${issuer}/.well-known/openid-configuration".toHttpUrl(),)


        if(context == null){
            throw  Exception("Context is null")
        }

        CredentialBootstrap.initialize(oidcClient.createCredentialDataSource(context!!))

        println("Done Initializing OIDC Configuration /()")
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
        TODO("Not yet implemented")
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
            when(val result = CredentialBootstrap.defaultCredential().refreshToken()){
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


            callback.invoke(Result.success(OktaAuthenticationResult(
                result = AuthenticationResult.SUCCESS,
                token = OktaToken(
                    issuedAt = userInfo.issuedAt?.toLong(),
                    tokenType = credential.token?.tokenType,
                    scope = credential.token?.scope,
                    refreshToken = credential.token?.refreshToken,
                    id = userInfo.userId,
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

 }