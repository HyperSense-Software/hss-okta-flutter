package dev.hypersense.software.hss_okta_direct_auth


import android.content.Context
import com.okta.authfoundation.claims.issuedAt
import com.okta.authfoundation.claims.scope
import com.okta.authfoundation.claims.userId
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundationbootstrap.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
//import com.okta.idx.kotlin.*
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import okhttp3.HttpUrl.Companion.toHttpUrl
import java.util.Date

class HssOktaDirectAuthPlugin : HssOktaDirectAuthPluginApi, FlutterPlugin{
    var oidcConfiguration : OidcConfiguration? = null
    var oidcClient : OidcClient? = null
    var context : Context? = null



    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaDirectAuthPluginApi.setUp(binding.binaryMessenger, this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaDirectAuthPluginApi.setUp(binding.binaryMessenger, null)
    }

    override fun initializeConfiguration(
        clientid: String,
        signInRedirectUrl: String,
        signOutRedirectUrl: String,
        issuer: String,
        scopes: String
    ) {
        oidcConfiguration = OidcConfiguration(
            clientId =  clientid,
            defaultScope = scopes,
        )

        oidcClient = OidcClient.createFromDiscoveryUrl(
            oidcConfiguration!!,
            "${issuer}/.well-known/openid-configuration".toHttpUrl(),)
        
        if(context != null && oidcClient != null)
        {
            CredentialBootstrap.initialize(oidcClient!!.createCredentialDataSource(context!!))
        }

    }


    private suspend fun signInWithCredentialsRoutine(request : HssOktaDirectAuthRequest): HssOktaDirectAuthResult {
        val flow = CredentialBootstrap.oidcClient.createResourceOwnerFlow()
        when(val res = flow.start(request.username,request.password)){
            is OidcClientResult.Error -> {
                throw Exception(res.exception)
            }
            is OidcClientResult.Success -> {

                CredentialBootstrap.defaultCredential().storeToken(token = res.result)
                var userInfo = CredentialBootstrap.defaultCredential().getUserInfo()
                var userInfoResult = userInfo.getOrThrow()

                return HssOktaDirectAuthResult(
                    result = DirectAuthResult.SUCCESS,
                    id = userInfoResult.userId,
                    token = res.result.accessToken,
                    issuedAt = userInfoResult.issuedAt?.toLong(),
                    tokenType = res.result.tokenType,
                    scope = res.result.scope,
                    refreshToken = res.result.refreshToken
                )
            }
        }
    }

    override fun signInWithCredentials(
        request: HssOktaDirectAuthRequest,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        CoroutineScope(Dispatchers.IO).launch {
           var result = signInWithCredentialsRoutine(request)
            callback.invoke(Result.success(result))
        }
    }

    override fun mfaOtpSignInWithCredentials(
        otp: String,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        TODO("Not yet implemented")
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

    override fun getCredential(callback: (Result<HssOktaDirectAuthResult?>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            var credential = CredentialBootstrap.defaultCredential()
            var userInfo = credential.getUserInfo().getOrThrow()
            
            callback.invoke(Result.success(HssOktaDirectAuthResult(
                result = DirectAuthResult.SUCCESS,
                id = userInfo.userId,
                token = credential.token?.accessToken,
                issuedAt = userInfo.issuedAt?.toLong(),
                tokenType = credential.token?.tokenType,
                scope = credential.token?.scope,
                refreshToken = credential.token?.refreshToken,

            )))

    }

}}