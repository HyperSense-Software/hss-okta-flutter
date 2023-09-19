import 'package:hss_okta_flutter/hss_okta_flutter_interface.dart';
import 'package:hss_okta_flutter/pigeon/direct_auth_generated.g.dart';

class HssOktaFlutterUsage extends HssOktaFlutterInterfacePlatform {
  final HssOktaFlutterUsage _api = HssOktaFlutterUsage();

  @override
  HSSOktaNativeAuthResult signInWithCredentials(
      HSSOktaNativeAuthRequest request) {
    return _api.signInWithCredentials(request);
  }
}
