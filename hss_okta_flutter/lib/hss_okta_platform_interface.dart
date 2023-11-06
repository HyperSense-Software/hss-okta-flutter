import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hss_okta_flutter_channel.dart';

abstract class HssOktaFlutterPluginPlatform extends PlatformInterface {
  HssOktaFlutterPluginPlatform() : super(token: _token);
  static final Object _token = Object();
  static HssOktaFlutterPluginPlatform _instance = HssOktaFlutterChannel();
  static HssOktaFlutterPluginPlatform get instance => _instance;

  static set instance(HssOktaFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<AuthenticationResult?> startDirectAuthenticationFlow(
      DirectAuthRequest request) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> revokeDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> refreshDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<AuthenticationResult?> getCredential() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
