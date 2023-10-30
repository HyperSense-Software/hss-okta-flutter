import 'dart:async';

import 'package:hss_okta_flutter/enums/sign_in_factors.dart';
import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';
import 'package:hss_okta_flutter/hss_okta_platform_interface.dart';

class HssOktaFlutter {
  /// Starts the Direct Authentication /Resource Owner Flow
  ///
  /// [factors] is either [AuthenticationFactor.otp] or [AuthenticationFactor.oob] or both, this is only Available for iOS
  /// returns [OktaAuthenticationResult] which contains the [OktaToken] and [UserInfo]
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

  /// Revokes the default Credential stored on the device
  /// returns [true] if the operation was successful
  /// returns [false] if the operation failed
  ///
  /// This will prompt the user to re-login
  Future<bool> revokeDefaultToken() async {
    var result =
        await HssOktaFlutterPluginPlatform.instance.revokeDefaultToken();

    return result;
  }

  /// Refreshes the default Credential stored on the device
  /// returns [true] if the operation was successful
  /// returns [false] if the operation failed
  Future<bool> refreshDefaultToken() async {
    var result =
        await HssOktaFlutterPluginPlatform.instance.refreshDefaultToken();

    return result;
  }

  /// tries to get the default Credential stored on the device
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

  Future<DeviceAuthorizationSession> startDeviceAuthorizationFlow() async {
    var result = await HssOktaFlutterPluginPlatform.instance
        .startDeviceAuthorizationFlow();
    return result;
  }

  Future<OktaAuthenticationResult> resumeDeviceAuthorizationFlow() async {
    var result = await HssOktaFlutterPluginPlatform.instance
        .resumeDeviceAuthorizationFlow();
    return result;
  }
}
