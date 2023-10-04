import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
      input: 'pigeons/hss_okta_direct_auth_pigeon.dart',
      dartOut: 'lib/generated/hss_okta_direct_auth.g.dart',
      swiftOut: 'ios/Classes/HssOktaDirectAuthPluginApi.g.swift',
      kotlinOut:
          'android/src/main/kotlin/dev/hypersense/software/hss_okta_direct_auth/HssOktaDirectAuthPluginApi.kt',
      kotlinOptions: KotlinOptions(
          package: "dev.hypersense.software.hss_okta_direct_auth")),

  // cppHeaderOut: 'ios/Classes/HssOktaDirectAuthPlugin.h',
  // cppSourceOut: 'ios/Classes/HssOktaDirectAuthPlugin.m',
)
enum DirectAuthResult { success, mfaRequired, error }

class HssOktaDirectAuthRequest {
  final String username;
  final String password;

  HssOktaDirectAuthRequest({required this.username, required this.password});
}

class HssOktaDirectAuthResult {
  final DirectAuthResult? result;
  final String? error;

  final String? id;
  final String? token;
  final int? issuedAt;
  final String? tokenType;
  final String? accessToken;
  final String? scope;
  final String? refreshToken;

  final UserInfo? userInfo;

  HssOktaDirectAuthResult(
      {required this.result,
      this.error,
      required this.id,
      required this.token,
      required this.issuedAt,
      required this.tokenType,
      required this.accessToken,
      required this.scope,
      required this.refreshToken,
      this.userInfo
      // required this.idToken,
      // required this.context
      });
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

@HostApi()
abstract class HssOktaDirectAuthPluginApi {
  void initializeConfiguration(
    String clientid,
    String signInRedirectUrl,
    String signOutRedirectUrl,
    String issuer,
    String scopes,
  );

  @async
  HssOktaDirectAuthResult? signInWithCredentials(
      HssOktaDirectAuthRequest request);

  @async
  HssOktaDirectAuthResult? mfaOtpSignInWithCredentials(String otp);

  @async
  bool? refreshDefaultToken();

  @async
  bool? revokeDefaultToken();

  @async
  HssOktaDirectAuthResult? getCredential();
}
