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
  final String result;

  HssOktaDirectAuthResult({required this.result});
}

@HostApi()
abstract class HssOktaDirectAuthPluginApi {
  @async
  HssOktaDirectAuthResult signInWithCredentials(
      HssOktaDirectAuthRequest request);
}
