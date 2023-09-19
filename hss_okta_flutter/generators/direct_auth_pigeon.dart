import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
    input: 'generators/direct_auth_pigeon.dart',
    dartOut: 'lib/pigeon/direct_auth_generated.g.dart',
    swiftOut: 'ios/Classes/DirectAuthOut.swift'))
class HSSOktaNativeAuthRequest {
  final String username;
  final String password;

  HSSOktaNativeAuthRequest({required this.username, required this.password});
}

class HSSOktaNativeAuthResult {
  final String result;

  HSSOktaNativeAuthResult({required this.result});
}

@HostApi()
abstract class DirectAuthAPI {
  @async
  HSSOktaNativeAuthResult signInWithCredentials(
      HSSOktaNativeAuthRequest request);
}
