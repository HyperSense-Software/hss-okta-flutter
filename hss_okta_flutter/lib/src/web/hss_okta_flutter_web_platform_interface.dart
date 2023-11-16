import 'package:hss_okta_flutter/src/web/hss_okta_flutter_web.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class HssOktaFlutterWebPlatformInterface extends PlatformInterface {
  HssOktaFlutterWebPlatformInterface() : super(token: _token);

  static final Object _token = Object();
  static HssOktaFlutterWebPlatformInterface _instance = HssOktaFlutterWeb();
  static HssOktaFlutterWebPlatformInterface get instance => _instance;

  static set instance(HssOktaFlutterWebPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
