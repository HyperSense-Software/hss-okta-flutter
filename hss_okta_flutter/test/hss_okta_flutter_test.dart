import 'package:flutter_test/flutter_test.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter/src/hss_okta_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHssOktaFlutterPlatform
    with MockPlatformInterfaceMixin
    implements HssOktaFlutterPlatformInterface {
  @override
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) {
    // TODO: implement continueDirectAuthenticationMfaFlow
    throw UnimplementedError();
  }

  @override
  Future<AuthenticationResult?> getCredential() {
    // TODO: implement getCredential
    throw UnimplementedError();
  }

  @override
  Future<bool> refreshDefaultToken() {
    // TODO: implement refreshDefaultToken
    throw UnimplementedError();
  }

  @override
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() {
    // TODO: implement resumeDeviceAuthorizationFlow
    throw UnimplementedError();
  }

  @override
  Future<bool> revokeDefaultToken() {
    // TODO: implement revokeDefaultToken
    throw UnimplementedError();
  }

  @override
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() {
    // TODO: implement startDeviceAuthorizationFlow
    throw UnimplementedError();
  }

  @override
  Future<AuthenticationResult?> startDirectAuthenticationFlow(
      DirectAuthRequest request) {
    // TODO: implement startDirectAuthenticationFlow
    throw UnimplementedError();
  }

  @override
  Future<AuthenticationResult?> startTokenExchangeFlow(
      {required String deviceSecret, required String idToken}) {
    // TODO: implement startTokenExchangeFlow
    throw UnimplementedError();
  }
  // @override
  // Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HssOktaFlutterPlatformInterface initialPlatform =
      HssOktaFlutterPlatformInterface.instance;

  // test('$MethodChannelHssOktaFlutter is the default instance', () {
  //   expect(initialPlatform, isInstanceOf<MethodChannelHssOktaFlutter>());
  // });

  test('getPlatformVersion', () async {
    HssOktaFlutter hssOktaFlutterPlugin = HssOktaFlutter();
    MockHssOktaFlutterPlatform fakePlatform = MockHssOktaFlutterPlatform();

    HssOktaFlutterPlatformInterface.instance = fakePlatform;

    // expect(await hssOktaFlutterPlugin.getPlatformVersion(), '42');
  });
}
