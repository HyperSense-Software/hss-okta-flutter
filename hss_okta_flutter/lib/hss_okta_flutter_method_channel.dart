import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hss_okta_flutter_platform_interface.dart';

/// An implementation of [HssOktaFlutterPlatform] that uses method channels.
class MethodChannelHssOktaFlutter extends HssOktaFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hss_okta_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
