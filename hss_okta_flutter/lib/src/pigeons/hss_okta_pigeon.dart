import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeons/hss_okta_pigeon.dart',
    dartOut: 'lib/src/generated/hss_okta_flutter.g.dart',
    swiftOut: 'ios/Classes/HssOktaFlutterPlugin.g.swift',
    kotlinOut:
        'android/src/main/kotlin/dev/hypersense/software/hss_okta_flutter/HssOktaFlutterPluginApi.kt',
    kotlinOptions: KotlinOptions(
      package: "dev.hypersense.software.hss_okta",
      errorClassName: "HssOktaFlutterException",
    ),
    swiftOptions: SwiftOptions(
      errorClassName: "HssOktaFlutterException",
    ),
  ),
)
enum AuthenticationType { browser, sso, directAuth }

enum DirectAuthenticationResult { success, mfaRequired, error }

enum AuthenticationFactor {
  otp("otp"),
  oob("oob");

  final String value;
  const AuthenticationFactor(this.value);
}

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

class DirectAuthRequest {
  final String username;
  final String password;
  final List<String?> factors;

  DirectAuthRequest(
      {required this.username, required this.password, required this.factors});
}

class DeviceAuthorizationSession {
  final String? userCode;
  final String? verificationUri;

  DeviceAuthorizationSession(
      {required this.userCode, required this.verificationUri});
}

@HostApi()
abstract class HssOktaFlutterPluginApi {
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

  @async
  AuthenticationResult? startTokenExchangeFlow(
    String deviceSecret,
    String idToken,
  );

  // Token and Credential Management
  @async
  List<String> getAllUserIds();

  @async
  AuthenticationResult? getToken(String tokenId);

  @async
  bool removeCredential(String tokenId);
  @async
  bool setDefaultToken(String tokenId);

  @async
  AuthenticationResult startBrowserSignin();

  @async
  bool startBrowserSignout();
}
