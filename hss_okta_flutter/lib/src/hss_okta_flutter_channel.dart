import 'package:hss_okta_flutter/src/generated/hss_okta_flutter.g.dart';
import 'package:hss_okta_flutter/src/hss_okta_platform_interface.dart';

/// {@template hss_okta_flutter_channel}
/// A Flutter channel for calling methods by their platform name
/// {@endtemplate}
class HssOktaFlutterChannel extends HssOktaFlutterPlatformInterface {
  final _api = HssOktaFlutterPluginApi();

  @override
  Future<AuthenticationResult> startDirectAuthenticationFlow(
    DirectAuthRequest request,
  ) async {
    final res = await _api.startDirectAuthenticationFlow(request);
    if (res == null) throw Exception('Null result from signInWithCredentials');
    return res;
  }

  @override
  Future<bool> revokeDefaultToken() async {
    final res = await _api.revokeDefaultToken();
    if (res == null) throw Exception('Null result from revokeDefaultToken');
    return res;
  }

  @override
  Future<bool> refreshDefaultToken() async {
    final res = await _api.refreshDefaultToken();
    if (res == null) throw Exception('Null result from refreshDefaultToken');
    return res;
  }

  @override
  Future<AuthenticationResult?> getCredential() async {
    final res = await _api.getCredential();
    return res;
  }

  @override
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
    String otp,
  ) async {
    final res = await _api.continueDirectAuthenticationMfaFlow(otp);
    if (res == null) {
      throw Exception('Null result from mfaOtpSignInWithCredentials');
    }

    return res;
  }

  @override
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    final res = await _api.startDeviceAuthorizationFlow();
    if (res == null) {
      throw Exception('Null result from startDeviceAuthorizationFlow');
    }

    return res;
  }

  @override
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    final res = await _api.resumeDeviceAuthorizationFlow();

    return res;
  }

  @override
  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) async {
    final res = await _api.startTokenExchangeFlow(deviceSecret, idToken);

    return res;
  }
}
