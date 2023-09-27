import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.oauth2.ResourceOwnerFlow.Companion.createResourceOwnerFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.runBlocking
import java.lang.Exception
import kotlin.coroutines.*


class HssOktaDirectAuthPlugin : HssOktaDirectAuthPluginApi, FlutterPlugin {
    
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaDirectAuthPluginApi.Companion.setUp(binding.binaryMessenger,this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        HssOktaDirectAuthPluginApi.Companion.setUp(binding.binaryMessenger,null)


    }
    override fun signInWithCredentials(
        request: HssOktaDirectAuthRequest,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        runBlocking {
            var flow = CredentialBootstrap.oidcClient.createResourceOwnerFlow()
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