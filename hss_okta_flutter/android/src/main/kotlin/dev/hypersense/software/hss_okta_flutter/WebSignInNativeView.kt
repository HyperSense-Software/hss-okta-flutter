package dev.hypersense.software.hss_okta_flutter

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.credential.Credential
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.webauthenticationui.WebAuthenticationClient.Companion.createWebAuthenticationClient
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class WebSignInNativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return WebSignInNativeView(context, viewId, creationParams)
    }



    companion object{
        const
        val platformViewName = "dev.hypersense.software.hss_okta.views.browser.signin"
    }
}

internal class WebSignInNativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.height = 50
        textView.text = "TESRTING 22"

        CoroutineScope(Dispatchers.IO).launch {
            val credential: Credential = CredentialBootstrap.defaultCredential()
            val webAuthenticationClient = CredentialBootstrap.oidcClient.createWebAuthenticationClient()
            when (val result = webAuthenticationClient.login(context, "${BuildConfig.SIGN_IN_REDIRECT_URI}")) {
                is OidcClientResult.Error -> {

                }
                is OidcClientResult.Success -> {
                    credential.storeToken(token = result.result)

                }
            }
        }
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
    }
}
