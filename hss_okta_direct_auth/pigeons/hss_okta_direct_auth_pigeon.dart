import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/hss_okta_direct_auth_pigeon.dart',
  dartOut: 'lib/generated/hss_okta_direct_auth.g.dart',
  swiftOut: 'ios/Classes/HssOktaDirectAuthPluginApi.g.swift',
  kotlinOut:
      'android/src/main/kotlin/dev/hypersense/software/hss_okta_direct_auth/HssOktaDirectAuthPluginApi.g.kt',
)
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

  HssOktaDirectAuthResult({
    required this.result,
    this.error,
    required this.id,
    required this.token,
    required this.issuedAt,
    required this.tokenType,
    required this.accessToken,
    required this.scope,
    required this.refreshToken,
    // required this.idToken,
    // required this.context
  });
}

@HostApi()
abstract class HssOktaDirectAuthPluginApi {
  void init(
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
