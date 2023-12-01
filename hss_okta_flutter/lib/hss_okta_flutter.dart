import 'dart:async';

import 'package:hss_okta_flutter/enums/sign_in_factors.dart';
import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';
import 'package:hss_okta_flutter/hss_okta_platform_interface.dart';

class HssOktaFlutter {
  Future<OktaAuthenticationResult> startDirectAuthenticationFlow(
      {required String email,
      required String password,
      required List<OktaSignInFactor> factors}) async {
    var factorString = factors.map((e) => e.factor).toList();

    var result = await HssOktaFlutterPluginPlatform.instance
        .startDirectAuthenticationFlow(DirectAuthRequest(
            username: email, password: password, factors: factorString));

    return result;
  }

  Future<bool> revokeDefaultToken() async {
    var result =
        await HssOktaFlutterPluginPlatform.instance.revokeDefaultToken();

    return result;
  }

  Future<bool> refreshDefaultToken() async {
    var result =
        await HssOktaFlutterPluginPlatform.instance.refreshDefaultToken();

    return result;
  }

  Future<OktaAuthenticationResult> getCredential() async {
    var result = await HssOktaFlutterPluginPlatform.instance.getCredential();

    return result;
  }

  Future<OktaAuthenticationResult> mfaOtpSignInWithCredentials(
      String otp) async {
    var result = await HssOktaFlutterPluginPlatform.instance
        .continueDirectAuthenticationMfaFlow(otp);

    return result;
  }

  void init({
    required String clientId,
    required String signInRedirectUrl,
    required String signOutRedirectUrl,
    required String issuer,
    required String scopes,
  }) {
    try {
      HssOktaFlutterPluginPlatform.instance.init(
        clientId,
        signInRedirectUrl,
        signOutRedirectUrl,
        issuer,
        scopes,
      );
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
