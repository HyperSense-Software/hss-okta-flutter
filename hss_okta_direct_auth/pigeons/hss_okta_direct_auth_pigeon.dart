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

  final String id;
  final int issuedAt;
  final String tokenType;
  final String accessToken;
  final String scope;
  final String refreshToken;
  // final String idToken;
  // final String context;

  HssOktaDirectAuthResult({
    required this.success,
    this.error,
    required this.id,
    required this.issuedAt,
    required this.tokenType,
    required this.accessToken,
    required this.scope,
    required this.refreshToken,
    // required this.idToken,
    // required this.context
  });

  // DateTime get issueDate =>
  //     DateTime.fromMillisecondsSinceEpoch(issuedAt * 1000);
}

// extension HssDirectAuthExtension on HssOktaDirectAuthResult {
//   DateTime get issueDate =>
//       DateTime.fromMillisecondsSinceEpoch(issuedAt * 1000);
// }

@HostApi()
abstract class HssOktaDirectAuthPluginApi {
  @async
  HssOktaDirectAuthResult? signInWithCredentials(
      HssOktaDirectAuthRequest request);
}
