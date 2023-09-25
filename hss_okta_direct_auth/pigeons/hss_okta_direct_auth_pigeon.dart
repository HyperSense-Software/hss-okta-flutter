import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  input: 'pigeons/hss_okta_direct_auth_pigeon.dart',
  dartOut: 'lib/generated/hss_okta_direct_auth.g.dart',
  swiftOut: 'ios/Classes/HssOktaDirectAuthPluginApi.g.swift',
  // cppHeaderOut: 'ios/Classes/HssOktaDirectAuthPlugin.h',
  // cppSourceOut: 'ios/Classes/HssOktaDirectAuthPlugin.m',
))
class HssOktaDirectAuthRequest {
  final String username;
  final String password;

  HssOktaDirectAuthRequest({required this.username, required this.password});
}

class HssOktaDirectAuthResult {
  final bool success;
  final String? error;

  final String? id;
  final String? token;
  final int? issuedAt;
  final String? tokenType;
  final String? accessToken;
  final String? scope;
  final String? refreshToken;

  HssOktaDirectAuthResult({
    required this.success,
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
  @async
  HssOktaDirectAuthResult? signInWithCredentials(
      HssOktaDirectAuthRequest request);

  @async
  bool? refreshDefaultToken();

  @async
  bool? revokeDefaultToken();

  @async
  HssOktaDirectAuthResult? getCredential();

  //TODO:
  // find token by id
  // logout
}
