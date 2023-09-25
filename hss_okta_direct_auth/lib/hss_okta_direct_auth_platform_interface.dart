import 'package:hss_okta_direct_auth/generated/hss_okta_direct_auth.g.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hss_okta_direct_auth_channel.dart';

abstract class HssOktaDirectAuthPlatform extends PlatformInterface {
  HssOktaDirectAuthPlatform() : super(token: _token);
  static final Object _token = Object();
  static HssOktaDirectAuthPlatform _instance = HssOktaDirectAuthChannel();
  static HssOktaDirectAuthPlatform get instance => _instance;

  static set instance(HssOktaDirectAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<HssOktaDirectAuthResult> signInWithCredentials(
      HssOktaDirectAuthRequest request) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> revokeDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> refreshDefaultToken() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<HssOktaDirectAuthResult> getCredential() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
