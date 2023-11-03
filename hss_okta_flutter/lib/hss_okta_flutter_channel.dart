import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';

import 'hss_okta_platform_interface.dart';

class HssOktaFlutterChannel extends HssOktaFlutterPluginPlatform {
  final _api = HssOktaFlutterPluginApi();

  @override
  Future<AuthenticationResult> startDirectAuthenticationFlow(
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
  Future<AuthenticationResult?> getCredential() async {
    var res = await _api.getCredential();
    return res;
  }

  @override
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) async {
    var res = await _api.continueDirectAuthenticationMfaFlow(otp);
    if (res == null) {
      throw Exception("Null result from mfaOtpSignInWithCredentials");
    }

    return res;
  }

  @override
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    var res = await _api.startDeviceAuthorizationFlow();
    if (res == null) {
      throw Exception("Null result from startDeviceAuthorizationFlow");
    }

    return res;
  }

  @override
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    var res = await _api.resumeDeviceAuthorizationFlow();

    return res;
  }

  @override
  Future<AuthenticationResult?> startTokenExchangeFlow() async {
    var res = await _api.startTokenExchangeFlow();

    return res;
  }
}
