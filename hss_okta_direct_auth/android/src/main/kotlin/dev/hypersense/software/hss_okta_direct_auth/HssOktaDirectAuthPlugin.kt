import io.flutter.embedding.engine.plugins.FlutterPlugin

class HssOktaDirectAuthPlugin : HssOktaDirectAuthPluginApi, FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        TODO("Not yet implemented")
    }
    override fun signInWithCredentials(
        request: HssOktaDirectAuthRequest,
        callback: (Result<HssOktaDirectAuthResult?>) -> Unit
    ) {
        TODO("Not yet implemented")
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