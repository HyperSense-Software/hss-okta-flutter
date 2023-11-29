import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'generated/hss_okta_flutter.g.dart';
import 'hss_okta_flutter_channel.dart';

abstract class HssOktaFlutterPlatformInterface extends PlatformInterface {
  HssOktaFlutterPlatformInterface() : super(token: _token);
  static final Object _token = Object();
  static HssOktaFlutterPlatformInterface _instance = HssOktaFlutterChannel();
  static HssOktaFlutterPlatformInterface get instance => _instance;

  static set instance(HssOktaFlutterPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<AuthenticationResult?> startDirectAuthenticationFlow(
      DirectAuthRequest request) {
    throw UnimplementedError();
  }

  Future<bool> revokeDefaultToken() {
    throw UnimplementedError();
  }

  Future<bool> refreshDefaultToken() {
    throw UnimplementedError();
  }

  Future<AuthenticationResult?> getCredential() {
    throw UnimplementedError();
  }

  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) {
    throw UnimplementedError();
  }

  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() {
    throw UnimplementedError();
  }

  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() {
    throw UnimplementedError();
  }

  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) {
    throw UnimplementedError();
  }
}
