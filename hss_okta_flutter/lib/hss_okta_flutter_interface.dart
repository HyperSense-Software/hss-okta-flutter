import 'package:hss_okta_flutter/hss_okta_flutter_usage.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pigeon/direct_auth_generated.g.dart';

abstract class HssOktaFlutterInterfacePlatform extends PlatformInterface {
  /// Constructs a AppUsagePlatform.
  HssOktaFlutterInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static HssOktaFlutterInterfacePlatform _instance = HssOktaFlutterUsage();

  static HssOktaFlutterInterfacePlatform get instance => _instance;

  static set instance(HssOktaFlutterInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  HSSOktaNativeAuthResult signInWithCredentials(
      HSSOktaNativeAuthRequest request) {
    throw UnimplementedError(
        'signInWithCredentials() has not been implemented.');
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }

  // Future<List<UsedApp>> get apps async {
  //   throw UnimplementedError('apps has not been implemented.');
  // }

  // Future<TimeLimitResult> setAppTimeLimit(
  //     String appId, Duration duration) async {
  //   throw UnimplementedError('setAppTimeLimit() has not been implemented.');
  // }
}
