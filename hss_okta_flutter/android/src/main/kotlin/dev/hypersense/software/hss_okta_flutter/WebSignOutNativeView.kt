package dev.hypersense.software.hss_okta_flutter

import android.content.Context
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.TextView
import com.okta.authfoundation.client.OidcClientResult
import com.okta.authfoundation.credential.Credential
import com.okta.authfoundation.events.EventHandler
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.webauthenticationui.WebAuthenticationClient.Companion.createWebAuthenticationClient
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class WebSignOutNativeViewFactory constructor(private val signOutEventChannel: EventChannel) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {

        val creationParams = args as Map<String?, Any?>?
        return WebSignOutNativeView(context, viewId, creationParams,signOutEventChannel)
    }

    companion object{
        const
        val platformViewName = "dev.hypersense.software.hss_okta.views.browser.signout"
    }
}

internal class WebSignOutNativeView(private val context: Context,
                                   id: Int,
                                   creationParams: Map<String?, Any?>?,
                                   private val channel : EventChannel) : PlatformView,EventChannel.StreamHandler {
    private val textView: TextView = TextView(context)
    private var eventSink: EventChannel.EventSink? = null

    init {
        channel.setStreamHandler(this)
    }

    override fun getView(): View {

        return textView
    }

    override fun dispose() {}

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        CoroutineScope(Dispatchers.Main).launch {
            val credential: Credential = CredentialBootstrap.defaultCredential()
            val webAuthenticationClient =
                CredentialBootstrap.oidcClient.createWebAuthenticationClient()
            when(val result = webAuthenticationClient.logoutOfBrowser(context,BuildConfig.SIGN_OUT_REDIRECT_URI,"${credential.token?.idToken}")){
                is OidcClientResult.Error -> {
                    eventSink?.error(
                        "Browser Sign out Exception",
                        result.exception.localizedMessage,
                     ""
                    )
                }
                is OidcClientResult.Success -> {
                    eventSink?.success(true)
                }
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink?.error(
            "User Cancel",
            "Flow canceled",
            "")
        eventSink = null
    }

}

