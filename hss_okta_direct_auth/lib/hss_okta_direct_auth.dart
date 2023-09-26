import 'package:hss_okta_direct_auth/generated/hss_okta_direct_auth.g.dart';

import 'hss_okta_direct_auth_platform_interface.dart';

class HssOktaDirectAuth {
  Future<HssOktaDirectAuthResult> signIn(
      {required String email, required String password}) async {
    var result = await HssOktaDirectAuthPlatform.instance.signInWithCredentials(
        HssOktaDirectAuthRequest(username: email, password: password));

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

  Future<HssOktaDirectAuthResult> getCredential() async {
    var result = await HssOktaDirectAuthPlatform.instance.getCredential();

    return result;
  }

  Future<HssOktaDirectAuthResult> mfaOtpSignInWithCredentials(
      String otp) async {
    var result = await HssOktaDirectAuthPlatform.instance
        .mfaOtpSignInWithCredentials(otp);

    return result;
  }
}
