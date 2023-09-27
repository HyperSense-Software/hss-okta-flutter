import 'generated/hss_okta_direct_auth.g.dart';
import 'hss_okta_direct_auth_platform_interface.dart';

/// An implementation of [HssOktaDirectAuthPlatform] that uses method channels.
class HssOktaDirectAuthChannel extends HssOktaDirectAuthPlatform {
  final _api = HssOktaDirectAuthPluginApi();

  @override
  Future<HssOktaDirectAuthResult> signInWithCredentials(
      HssOktaDirectAuthRequest request) async {
    var res = await _api.signInWithCredentials(request);
    if (res == null) throw Exception("Null result from signInWithCredentials");
    return res;
  }

  @override
  Future<bool> revokeDefaultToken() async {
    var res = await _api.revokeDefaultToken();
    if (res == null) throw Exception("Null result from revokeDefaultToken");
    return res;
  }

  @override
  Future<bool> refreshDefaultToken() async {
    var res = await _api.refreshDefaultToken();
    if (res == null) throw Exception("Null result from refreshDefaultToken");
    return res;
  }

  @override
  Future<HssOktaDirectAuthResult> getCredential() async {
    var res = await _api.getCredential();
    if (res == null) throw Exception("Null result from getCredential");
    return res;
  }

  @override
  Future<HssOktaDirectAuthResult> mfaOtpSignInWithCredentials(
      String otp) async {
    var res = await _api.mfaOtpSignInWithCredentials(otp);
    if (res == null) {
      throw Exception("Null result from mfaOtpSignInWithCredentials");
    }

    return res;
  }

  @override
  void init(
    String clientid,
    String signInRedirectUrl,
    String signOutRedirectUrl,
    String issuer,
    String scopes,
  ) {
    _api.init(
      clientid,
      signInRedirectUrl,
      signOutRedirectUrl,
      issuer,
      scopes,
    );
  }
}
