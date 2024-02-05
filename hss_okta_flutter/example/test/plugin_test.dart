import 'package:flutter_test/flutter_test.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final pluginTest = HssOktaPluginTest();
  HssOktaFlutterPluginApiTest.setup(pluginTest);

  test('startDirectAuthenticationFlow', () async {
    final response = await pluginTest.startDirectAuthenticationFlow(
      DirectAuthRequest(
        username: 'username',
        password: 'password',
        factors: ['factors'],
      ),
    );
    expect(response, isNotNull);
  });

  test('continueDirectAuthenticationMfaFlow', () async {
    final response =
        await pluginTest.continueDirectAuthenticationMfaFlow('otp');
    expect(response, isNotNull);
  });

  test('refreshDefaultToken', () async {
    final response = await pluginTest.refreshDefaultToken();
    expect(response, isNotNull);
  });

  test('revokeDefaultToken', () async {
    final response = await pluginTest.revokeDefaultToken();
    expect(response, isNotNull);
  });

  test('getCredential', () async {
    final response = await pluginTest.getCredential();
    expect(response, isNotNull);
  });

  test('startDeviceAuthorizationFlow', () async {
    final response = await pluginTest.startDeviceAuthorizationFlow();
    expect(response, isNotNull);
  });

  test('resumeDeviceAuthorizationFlow', () async {
    final response = await pluginTest.resumeDeviceAuthorizationFlow();
    expect(response, isNotNull);
  });

  test('startTokenExchangeFlow', () async {
    final response =
        await pluginTest.startTokenExchangeFlow('deviceSecret', 'idToken');
    expect(response, isNotNull);
  });

  test('getAllUserIds', () async {
    final response = await pluginTest.getAllUserIds();
    expect(response, isNotNull);
  });

  test('getToken', () async {
    final response = await pluginTest.getToken('tokenId');
    expect(response, isNotNull);
  });

  test('removeCredential', () async {
    final response = await pluginTest.removeCredential('tokenId');
    expect(response, isNotNull);
  });

  test('setDefaultToken', () async {
    final response = await pluginTest.setDefaultToken('tokenId');
    expect(response, isNotNull);
  });
}
