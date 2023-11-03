import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
      input: 'pigeons/hss_okta_pigeon.dart',
      dartOut: 'lib/generated/hss_okta_flutter.g.dart',
      swiftOut: 'ios/Classes/HssOktaFlutterPlugin.g.swift',
      kotlinOut:
          'android/src/main/kotlin/dev/hypersense/software/hss_okta_flutter/HssOktaFlutterPluginApi.kt',
      kotlinOptions:
          KotlinOptions(package: "dev.hypersense.software.hss_okta")),
)

// START OF ENUMS
enum AuthenticationType { browser, sso, directAuth }

enum DirectAuthenticationResult { success, mfaRequired, error }

enum AuthenticationFactor {
  otp("otp"),
  oob("oob");

  final String value;
  const AuthenticationFactor(this.value);
}

// END OF ENUMS

/// [AuthenticationResult] is used to determine the result of the authentication for all authentication flows
/// return [AuthenticationResult.success] if the authentication was successful
/// return [AuthenticationResult.mfaRequired] if the authentication requires MFA, Only for IOS does nothing for Android
/// [error] returns the error message
/// [OktaToken] contains the [Credential] from retrieved from okta
/// [UserInfo] contains the user information retrieved from okta
class AuthenticationResult {
  final DirectAuthenticationResult? result;
  final String? error;
  final OktaToken? token;
  final UserInfo? userInfo;

  AuthenticationResult(
      {required this.result, this.error, required this.token, this.userInfo
      // required this.idToken,
      // required this.context
      });
}

/// Class for the credential retrieved information retrieved in okta
class OktaToken {
  final String? id;
  final String? token;
  final int? issuedAt;
  final String? tokenType;
  final String? accessToken;
  final String? scope;
  final String? refreshToken;

  OktaToken(
      {required this.id,
      required this.token,
      required this.issuedAt,
      required this.tokenType,
      required this.accessToken,
      required this.scope,
      required this.refreshToken});
}

/// Class for the user information retrieved in okta
class UserInfo {
  final String userId;
  final String givenName;
  final String middleName;
  final String familyName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String username;

  UserInfo({
    required this.userId,
    required this.givenName,
    required this.middleName,
    required this.familyName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.username,
  });
}

/// Authentication request for ResourceOwnerFlow
/// [Factors] should contain [AuthenticationFactor.otp] or [AuthenticationFactor.oob] this is not available for iOS
/// [username] and [password] are Okta Credentials
class DirectAuthRequest {
  final String username;
  final String password;
  final List<String?> factors;

  DirectAuthRequest(
      {required this.username, required this.password, required this.factors});
}

/// Class for the device authorization flow containing the retrived session information
/// [userCode] is the code that the user should enter in the browser
/// [verificationUri] is the Url the user needs to navigate and insert the [userCode] to verify the login
class DeviceAuthorizationSession {
  final String? userCode;
  final String? verificationUri;

  DeviceAuthorizationSession(
      {required this.userCode, required this.verificationUri});
}

@HostApi()
abstract class HssOktaFlutterPluginApi {
  // void initializeConfiguration(
  //   String clientid,
  //   String signInRedirectUrl,
  //   String signOutRedirectUrl,
  //   String issuer,
  //   String scopes,
  // );

  @async
  AuthenticationResult? startDirectAuthenticationFlow(
      DirectAuthRequest request);

  @async
  AuthenticationResult? continueDirectAuthenticationMfaFlow(String otp);

  @async
  bool? refreshDefaultToken();

  @async
  bool? revokeDefaultToken();

  @async
  AuthenticationResult? getCredential();

  @async
  DeviceAuthorizationSession? startDeviceAuthorizationFlow();

  @async
  AuthenticationResult? resumeDeviceAuthorizationFlow();
}
