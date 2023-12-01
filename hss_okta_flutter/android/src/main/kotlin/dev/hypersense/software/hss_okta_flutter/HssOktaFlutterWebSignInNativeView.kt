package dev.hypersense.software.hss_okta_flutter

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import android.widget.FrameLayout
import com.okta.authfoundation.credential.Credential
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.webauthenticationui.WebAuthenticationClient.Companion.createWebAuthenticationClient
import io.flutter.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class HssOktaFlutterWebSignInNativeView(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    companion object {
        const val platformViewName = "dev.hypersense.software.hss_okta.method.browser.signin"
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WebSignInNativeView(context, messenger, viewId, args as Map<String, Any?>)
    }
}

class WebSignInNativeView(
    context: Context,
    messenger: BinaryMessenger,
    viewId: Int,
    args: Map<String, Any?>
) : PlatformView {
    private val view: View = FrameLayout(context)
    private var eventChannel: EventChannel? = null;

    init {
        eventChannel =
            EventChannel(messenger, "dev.hypersense.software.hss_okta.channels.browser_signin")
        eventChannel?.setStreamHandler(
            BrowserAuthenticationHandler(
                view,
                context,
                args!!["signInRedirectUrl"].toString()
            )
        )
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {

        eventChannel = null
    }

}

class BrowserAuthenticationHandler(
    private val view: View,
    private val context: Context,
    private val redirect: String
) : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null
    private val auth = CredentialBootstrap.oidcClient.createWebAuthenticationClient();

    private suspend fun startAuthenticationFlow(): Boolean {

        return try {
            val result = auth.login(context, redirectUrl = redirect)
            Log.println(Log.INFO, "LOGIN BROWSER:", "$result")

            true
        } catch (e: java.lang.Exception) {
            throw e
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
        CoroutineScope(Dispatchers.IO).launch {
            try {

                val result = startAuthenticationFlow()
                events?.success(result)
            } catch (e: java.lang.Exception) {
                events?.error("FATAL",e.message,"$e")
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }
}