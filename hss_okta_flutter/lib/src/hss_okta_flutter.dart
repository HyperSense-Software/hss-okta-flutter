import 'enums/sign_in_factors.dart';
import 'generated/hss_okta_flutter.g.dart';
import 'hss_okta_platform_interface.dart';

class HssOktaFlutter {
  /// Starts the Direct Authentication /Resource Owner Flow
  ///
  /// factors is either [AuthenticationFactor.otp] or [AuthenticationFactor.oob] or both.
  /// factors is not needed for Android as it cannot handle Directauthentication MFA
  /// Throws an [Exception] When used on Android
  Future<AuthenticationResult?> startDirectAuthenticationFlow(
      {required String email,
      required String password,
      required List<OktaSignInFactor> factors}) async {
    var factorString = factors.map((e) => e.factor).toList();

    var result = await HssOktaFlutterPlatformInterface.instance
        .startDirectAuthenticationFlow(DirectAuthRequest(
            username: email, password: password, factors: factorString));

    return result;
  }

  /// Revokes the default Credential stored on the device
  Future<bool> revokeDefaultToken() async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.revokeDefaultToken();

    return result;
  }

  /// Refreshes the default Credential stored on the device
  Future<bool> refreshDefaultToken() async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.refreshDefaultToken();

    return result;
  }

  /// tries to get the default Credential stored on the device
  Future<AuthenticationResult?> getCredential() async {
    var result = await HssOktaFlutterPlatformInterface.instance.getCredential();

    return result;
  }

  /// To be used with DirectAuthentication Flow
  /// returns [AuthenticationResult] which contains the [OktaToken] and [UserInfo]
  ///
  /// This can only be used for iOS and when using Identity Engine
  /// [OktaSignInFactor.otp] or [OktaSignInFactor.oob] needs to be enabled on the Okta App.
  Future<AuthenticationResult?> mfaOtpSignInWithCredentials(String otp) async {
    var result = await HssOktaFlutterPlatformInterface.instance
        .continueDirectAuthenticationMfaFlow(otp);

    return result;
  }

  /// Starts the Device Authorization flow
  ///
  /// The Device Authorization Flow is designed for Internet connected devices that either lack a browser to perform a user-agent based authorization,
  ///  or are input constrained to the extent that requiring the user to input text in order to authenticate during the authorization flow is impractical.
  ///
  /// returns [DeviceAuthorizationSession] which contains the DeviceCode and VerificationUri
  /// Users will need to input the DeviceCode and VerificationUri on a browser
  ///
  /// Call on [resumeDeviceAuthorizationFlow] to continue the flow and access the [AuthenticationResult]
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    var result = await HssOktaFlutterPlatformInterface.instance
        .startDeviceAuthorizationFlow();
    return result;
  }

  /// Continues the DeviceAuthorization flow, this should be called once the user has inputted the DeviceCode and VerificationUri
  ///  on a browser
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    var result = await HssOktaFlutterPlatformInterface.instance
        .resumeDeviceAuthorizationFlow();
    return result;
  }

  /// Starts the Token Exchange flow
  /// The Token Exchange Flow exchanges an ID Token and a Device Secret for a new set of tokens.
  /// [deviceSecret] and [idToken] are obtained from the and Existing Session
  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.startTokenExchangeFlow(
      deviceSecret: deviceSecret,
      idToken: idToken,
    );
    return result;
  }

  /// Gets all the UserIds stored on the device
  Future<List<String?>> getAllUserIds() async {
    var result = await HssOktaFlutterPlatformInterface.instance.getAllUserIds();
    return result;
  }

  /// Gets the Credential stored on the device
  Future<AuthenticationResult?> getToken(String tokenId) async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.getToken(tokenId);
    return result;
  }

  /// Removes the Credential stored on the device
  Future<bool> removeCredential(String tokenId) async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.removeCredential(
      tokenId,
    );
    return result;
  }

  /// Sets the default Credential stored on the device
  /// This is used to set the default Credential when using multiple Credentials
  /// This is only available on iOS
  Future<bool> setDefaultToken(String tokenId) async {
    var result = await HssOktaFlutterPlatformInterface.instance.setDefaultToken(
      tokenId,
    );
    return result;
  }

  Future<AuthenticationResult> startBrowserSignIn() async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.startBrowserSignin();
    return result;
  }

  Future<bool> startBrowserSignout() async {
    var result =
        await HssOktaFlutterPlatformInterface.instance.startBrowserSignout();
    return result;
  }
}
