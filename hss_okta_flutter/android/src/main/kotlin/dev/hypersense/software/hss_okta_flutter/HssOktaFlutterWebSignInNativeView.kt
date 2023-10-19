package dev.hypersense.software.hss_okta_flutter
import android.content.Context
import android.graphics.Color
import android.view.View
import android.webkit.WebView
import android.widget.TextView
import com.okta.authfoundationbootstrap.CredentialBootstrap
import com.okta.oauth2.AuthorizationCodeFlow.Companion.createAuthorizationCodeFlow
import com.okta.oauth2.DeviceAuthorizationFlow.Companion.createDeviceAuthorizationFlow
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import okhttp3.HttpUrl.Companion.toHttpUrl

internal class HssOktaFlutterWebSignIn(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView,
    MethodChannel.MethodCallHandler{
    private val textView: TextView
    init {
        textView = TextView(context)
    }


    override fun getView(): View? {
        return textView

    }

    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }


}