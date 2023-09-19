import 'package:hss_okta_flutter/hss_okta_flutter_interface.dart';
import 'package:hss_okta_flutter/pigeon/direct_auth_generated.g.dart';

class HssOktaFlutter {
  Future<void> signInWithCredentials(HSSOktaNativeAuthRequest request) async {
    var rest =
        HssOktaFlutterInterfacePlatform.instance.signInWithCredentials(request);

    print(rest);
  }
}
