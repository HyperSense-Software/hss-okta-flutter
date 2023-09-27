package dev.hypersense.software.hss_okta_direct_auth


import HssOktaDirectAuthPluginApi
import HssOktaDirectAuthRequest
import HssOktaDirectAuthResult
import android.content.Context
import com.okta.authfoundation.client.OidcClient
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.client.OidcConfiguration
import com.okta.authfoundation.credential.CredentialDataSource.Companion.createCredentialDataSource
import com.okta.authfoundationbootstrap.CredentialBootstrap
import io.flutter.embedding.engine.plugins.FlutterPlugin
//import com.okta.idx.kotlin.*
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import kotlinx.coroutines.runBlocking
import okhttp3.HttpUrl.Companion.toHttpUrl

class HssOktaDirectAuthPlugin : HssOktaDirectAuthPluginApi, FlutterPlugin {
    var oidcConfiguration : OidcConfiguration? = null
    var oidcClient : OidcClient? = null
    var context : Context? = null
    override fun init(
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

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaDirectAuthPluginApi.Companion.setUp(binding.binaryMessenger, this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // HssOktaDirectAuthPluginApi.setUp(binding.binaryMessenger, null)
    }



    override fun signInWithCredentials(
        request: HssOktaDirectAuthRequest,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        runBlocking {
            val flow = CredentialBootstrap.oidcClient.createResourceOwnerFlow()
            when(val res = flow.start(request.username,request.password)){
                is OidcClientResult.Error -> {
                    throw Exception(res.exception)
                }
                is OidcClientResult.Success -> {
                    CredentialBootstrap.defaultCredential().storeToken(token = res.result)
                    callback.invoke(Result.success(HssOktaDirectAuthResult(
                        result = DirectAuthResult.SUCCESS,
                        error = null,
                        id = res.result.idToken,
                        token = res.result.deviceSecret,
                        issuedAt = null,
                        tokenType = res.result.tokenType,
                        accessToken = res.result.accessToken,
                        scope = res.result.scope,
                        refreshToken = res.result.accessToken
                    )))
                }
            }
        }


}

    override fun mfaOtpSignInWithCredentials(
        otp: String,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        TODO("Not yet implemented")
    }

    override fun refreshDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun revokeDefaultToken(callback: (Result<Boolean?>) -> Unit) {
        TODO("Not yet implemented")
    }

    override fun getCredential(callback: (Result<HssOktaDirectAuthResult?>) -> Unit) {
        TODO("Not yet implemented")
    }



}