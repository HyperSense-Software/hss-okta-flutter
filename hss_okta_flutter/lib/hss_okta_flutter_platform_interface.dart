import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hss_okta_flutter_method_channel.dart';

abstract class HssOktaFlutterPlatform extends PlatformInterface {
  /// Constructs a HssOktaFlutterPlatform.
  HssOktaFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static HssOktaFlutterPlatform _instance = MethodChannelHssOktaFlutter();

  /// The default instance of [HssOktaFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelHssOktaFlutter].
  static HssOktaFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HssOktaFlutterPlatform] when
  /// they register themselves.
  static set instance(HssOktaFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
