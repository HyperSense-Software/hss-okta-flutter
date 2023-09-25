import 'generated/hss_okta_direct_auth.g.dart';
import 'hss_okta_direct_auth_platform_interface.dart';

/// An implementation of [HssOktaDirectAuthPlatform] that uses method channels.
class HssOktaDirectAuthChannel extends HssOktaDirectAuthPlatform {
  final _api = HssOktaDirectAuthPluginApi();

  @override
  Future<HssOktaDirectAuthResult> signInWithCredentials(
      HssOktaDirectAuthRequest request) async {
    var res = await _api.signInWithCredentials(request);
    if (res == null) throw Exception("Null result from signInWithCredentials");
    return res;
  }
}