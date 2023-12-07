import 'package:hss_okta_flutter/src/web/hss_okta_flutter_web.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// {@template hss_okta_flutter_platform_interface}
/// Platform interface for web implementations of the HssOktaFlutter plugin.
/// {@endtemplate}
class HssOktaFlutterWebPlatformInterface extends PlatformInterface {
  /// {@macro hss_okta_flutter_platform_interface}
  HssOktaFlutterWebPlatformInterface() : super(token: _token);

  static final Object _token = Object();
  static HssOktaFlutterWebPlatformInterface _instance = HssOktaFlutterWeb();

  /// {@macro hss_okta_flutter_platform_interface}
  static HssOktaFlutterWebPlatformInterface get instance => _instance;

  /// {@macro hss_okta_flutter_platform_interface}
  static set instance(HssOktaFlutterWebPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
