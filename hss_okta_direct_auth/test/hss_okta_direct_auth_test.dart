// import 'package:flutter_test/flutter_test.dart';
// import 'package:hss_okta_direct_auth/hss_okta_direct_auth.dart';
// import 'package:hss_okta_direct_auth/hss_okta_direct_auth_platform_interface.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockHssOktaDirectAuthPlatform
//     with MockPlatformInterfaceMixin
//     implements HssOktaDirectAuthPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final HssOktaDirectAuthPlatform initialPlatform =
//       HssOktaDirectAuthPlatform.instance;
  
//   test('$MethodChannelHssOktaDirectAuth is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelHssOktaDirectAuth>());
//   });

//   test('getPlatformVersion', () async {
//     HssOktaDirectAuth hssOktaDirectAuthPlugin = HssOktaDirectAuth();
//     MockHssOktaDirectAuthPlatform fakePlatform =
//         MockHssOktaDirectAuthPlatform();
//     HssOktaDirectAuthPlatform.instance = fakePlatform;

//     expect(await hssOktaDirectAuthPlugin.getPlatformVersion(), '42');
//   });
// }
