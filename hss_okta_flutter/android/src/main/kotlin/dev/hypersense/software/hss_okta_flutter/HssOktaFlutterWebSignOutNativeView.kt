package dev.hypersense.software.hss_okta_flutter

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.webauthenticationui.WebAuthenticationClient.Companion.createWebAuthenticationClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class HssOktaFlutterWebSignOutNativeView(private val messenger: BinaryMessenger) :
    PlatformViewFactory(
        StandardMessageCodec.INSTANCE
    ) {
    companion object {
        const val platformViewName = "dev.hypersense.software.hss_okta.method.browser.signout"
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WebSignOutNativeView(context, messenger, viewId, args as Map<String, Any?>)
    }
}

class WebSignOutNativeView(
    context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    args: Map<String, Any?>
) :
    PlatformView {
    private val view: View = FrameLayout(context)

    init {
        val browserAuth =
            EventChannel(messenger, "dev.hypersense.software.hss_okta.channels.browser_signout")
        browserAuth.setStreamHandler(
            BrowserLogoutAuthenticationHandler(
                view,
                context,
                args!!["signOutRedirectUrl"].toString(),
                args!!["idToken"].toString()
            )
        )
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {

    }

}

class BrowserLogoutAuthenticationHandler(
    private val view: View,
    private val context: Context,
    private val redirect: String,
    private val idToken: String
) : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null
    private val auth = CredentialBootstrap.oidcClient.createWebAuthenticationClient();

    private suspend fun startAuthenticationFlow(): Boolean {
        return try {
            auth.logoutOfBrowser(context, redirectUrl = redirect, idToken = idToken)
            true
        } catch (e: java.lang.Exception) {
            false
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        CoroutineScope(Dispatchers.IO).launch {

            val result = startAuthenticationFlow()
            events?.success(result)
        }
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}