import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';

import 'hss_okta_platform_interface.dart';

class HssOktaFlutterChannel extends HssOktaFlutterPluginPlatform {
  final _api = HssOktaFlutterPluginApi();

  @override
  Future<OktaAuthenticationResult> startDirectAuthenticationFlow(
      DirectAuthRequest request) async {
    var res = await _api.startDirectAuthenticationFlow(request);
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
  Future<OktaAuthenticationResult> getCredential() async {
    var res = await _api.getCredential();
    if (res == null) throw Exception("Null result from getCredential");
    return res;
  }

  @override
  Future<OktaAuthenticationResult> continueDirectAuthenticationMfaFlow(
      String otp) async {
    var res = await _api.continueDirectAuthenticationMfaFlow(otp);
    if (res == null) {
      throw Exception("Null result from mfaOtpSignInWithCredentials");
    }

    return res;
  }

  @override
  Future<OktaAuthenticationResult> startBrowserAuthenticationFlow() async {
    var res = await _api.startBrowserAuthenticationFlow();

    if (res == null) {
      throw Exception("Null result from mfaOtpSignInWithCredentials");
    }

    return res;
  }

  @override
  Future<bool> startSignOutFlow() async {
    var res = await _api.startWebSignoutFlow();

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
    _api.initializeConfiguration(
      clientid,
      signInRedirectUrl,
      signOutRedirectUrl,
      issuer,
      scopes,
    );
  }
}
