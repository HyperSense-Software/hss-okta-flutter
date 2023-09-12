import 'package:flutter_test/flutter_test.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter/hss_okta_flutter_platform_interface.dart';
import 'package:hss_okta_flutter/hss_okta_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHssOktaFlutterPlatform
    with MockPlatformInterfaceMixin
    implements HssOktaFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HssOktaFlutterPlatform initialPlatform = HssOktaFlutterPlatform.instance;

  test('$MethodChannelHssOktaFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHssOktaFlutter>());
  });

  test('getPlatformVersion', () async {
    HssOktaFlutter hssOktaFlutterPlugin = HssOktaFlutter();
    MockHssOktaFlutterPlatform fakePlatform = MockHssOktaFlutterPlatform();
    HssOktaFlutterPlatform.instance = fakePlatform;

    expect(await hssOktaFlutterPlugin.getPlatformVersion(), '42');
  });
}
