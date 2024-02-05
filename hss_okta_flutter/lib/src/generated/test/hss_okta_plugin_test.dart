import '../hss_okta_flutter.g.dart';
import 'hss_okta_test.g.dart';

class HssOktaPluginTest implements HssOktaFlutterPluginApiTest {
  @override
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) async {
    return await continueDirectAuthenticationMfaFlow(otp);
  }

  @override
  Future<List<String?>> getAllUserIds() async {
    return await getAllUserIds();
  }

  @override
  Future<AuthenticationResult?> getCredential() async {
    return await getCredential();
  }

  @override
  Future<AuthenticationResult?> getToken(String tokenId) async {
    return await getToken(tokenId);
  }

  @override
  Future<bool?> refreshDefaultToken() async {
    return await refreshDefaultToken();
  }

  @override
  Future<bool> removeCredential(String tokenId) async {
    return await removeCredential(tokenId);
  }

  @override
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    return await resumeDeviceAuthorizationFlow();
  }

  @override
  Future<bool?> revokeDefaultToken() async {
    return await revokeDefaultToken();
  }

  @override
  Future<bool> setDefaultToken(String tokenId) async {
    return await setDefaultToken(tokenId);
  }

  @override
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() {
    return startDeviceAuthorizationFlow();
  }

  @override
  Future<AuthenticationResult?> startDirectAuthenticationFlow(
      DirectAuthRequest request) async {
    return await startDirectAuthenticationFlow(request);
  }

  @override
  Future<AuthenticationResult?> startTokenExchangeFlow(
      String deviceSecret, String idToken) async {
    return await startTokenExchangeFlow(deviceSecret, idToken);
  }
}
