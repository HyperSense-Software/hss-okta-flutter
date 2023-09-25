import 'package:hss_okta_direct_auth/generated/hss_okta_direct_auth.g.dart';

import 'hss_okta_direct_auth_platform_interface.dart';

class HssOktaDirectAuth {
  Future<HssOktaDirectAuthResult> signIn() async {
    var result = await HssOktaDirectAuthPlatform.instance.signInWithCredentials(
        HssOktaDirectAuthRequest(
            username: 'AldrinFrancisco@ntsafety.com', password: 'S@asAppD3!'));

    return result;
  }

  Future<bool> revokeDefaultToken() async {
    var result = await HssOktaDirectAuthPlatform.instance.revokeDefaultToken();

    return result;
  }

  Future<bool> refreshDefaultToken() async {
    var result = await HssOktaDirectAuthPlatform.instance.refreshDefaultToken();

    return result;
  }
}
