import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter/src/hss_okta_platform_interface.dart';

/// {@template hss_okta_flutter}
/// A Flutter plugin for Okta Authentication
/// {@endtemplate}
class HssOktaFlutter {
  final _instance = HssOktaFlutterPlatformInterface.instance;

  /// Starts the Direct Authentication /Resource Owner Flow
  ///
  /// factors is either [AuthenticationFactor.otp] or
  /// [AuthenticationFactor.oob] or both.
  /// factors is not needed for Android as it cannot handle
  /// Directauthentication MFA.
  ///
  /// Example:
  ///
  /// ```dart
  /// Future<void> startDirectAuthenticationFlow() async {
  ///   final result = await HssOktaFlutter().startDirectAuthenticationFlow(
  ///               email: 'test@test.com',
  ///               password: 'your_password_text',
  ///               factors: [OktaSignInFactor.otp]);
  ///
  ///   if (result != null) {
  ///     // do something with result
  ///   }
  /// }
  /// ```
  ///
  /// Throws an [Exception] When used on Android
  Future<AuthenticationResult?> startDirectAuthenticationFlow({
    required String email,
    required String password,
    required List<AuthenticationFactor> factors,
  }) async {
    final factorString = factors.map((e) => e.name).toList();

    final result = await _instance.startDirectAuthenticationFlow(
      DirectAuthRequest(
        username: email,
        password: password,
        factors: factorString,
      ),
    );

    return result;
  }

  /// Revokes the default Credential stored on the device
  Future<bool> revokeDefaultToken() async {
    final result = await _instance.revokeDefaultToken();

    return result;
  }

  /// Refreshes the default Credential stored on the device
  Future<bool> refreshDefaultToken() async {
    final result = await _instance.refreshDefaultToken();

    return result;
  }

  /// tries to get the default Credential stored on the device
  Future<AuthenticationResult?> getCredential() async {
    final result = await _instance.getCredential();

    return result;
  }

  /// To be used with DirectAuthentication Flow returns [AuthenticationResult]
  /// which contains the [OktaToken] and [UserInfo]
  ///
  /// This can only be used for iOS and when using Identity Engine
  /// [OktaSignInFactor.otp] or [OktaSignInFactor.oob] needs to be enabled
  /// on the Okta App.
  Future<AuthenticationResult?> mfaOtpSignInWithCredentials(String otp) async {
    final result = await _instance.continueDirectAuthenticationMfaFlow(otp);

    return result;
  }

  /// Starts the Device Authorization flow
  ///
  /// The Device Authorization Flow is designed for Internet connected devices
  /// that either lack a browser to perform a user-agent based authorization,
  /// or are input constrained to the extent that requiring the user to input
  /// text in order to authenticate during the authorization flow is
  /// impractical.
  ///
  /// returns [DeviceAuthorizationSession] which contains
  /// the DeviceCode and VerificationUri
  /// Users will need to input the DeviceCode and VerificationUri on a browser
  ///
  /// Call on [resumeDeviceAuthorizationFlow] to continue the flow and access
  /// the [AuthenticationResult]
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    final result = await _instance.startDeviceAuthorizationFlow();
    return result;
  }

  /// Continues the DeviceAuthorization flow, this should be called once the
  /// user has inputted the DeviceCode and VerificationUri on a browser
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    final result = await _instance.resumeDeviceAuthorizationFlow();
    return result;
  }

  /// Starts the Token Exchange flow
  /// The Token Exchange Flow exchanges an ID Token and a Device Secret
  /// for a new set of tokens.
  ///
  /// [deviceSecret] and [idToken] are obtained from the and Existing Session
  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) async {
    final result = await _instance.startTokenExchangeFlow(
      deviceSecret: deviceSecret,
      idToken: idToken,
    );
    return result;
  }
}
