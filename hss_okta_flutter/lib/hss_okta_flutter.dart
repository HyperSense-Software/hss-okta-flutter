
import 'hss_okta_flutter_platform_interface.dart';

class HssOktaFlutter {
  Future<String?> getPlatformVersion() {
    return HssOktaFlutterPlatform.instance.getPlatformVersion();
  }
}
