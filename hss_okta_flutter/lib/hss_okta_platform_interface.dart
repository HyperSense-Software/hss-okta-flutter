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

  Future<OktaAuthenticationResult> startDirectAuthenticationFlow(
      DirectAuthRequest request) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> revokeDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> refreshDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<OktaAuthenticationResult> getCredential() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<OktaAuthenticationResult> continueDirectAuthenticationMfaFlow(
      String otp) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<OktaAuthenticationResult> startBrowserAuthenticationFlow() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> startSignOutFlow() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void init(
    String clientid,
    String signInRedirectUrl,
    String signOutRedirectUrl,
    String issuer,
    String scopes,
  ) {
    throw UnimplementedError('init() has not been implemented.');
  }
}
