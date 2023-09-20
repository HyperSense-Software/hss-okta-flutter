import 'generated/hss_okta_direct_auth.g.dart';
import 'hss_okta_direct_auth_platform_interface.dart';

/// An implementation of [HssOktaDirectAuthPlatform] that uses method channels.
class HssOktaDirectAuthChannel extends HssOktaDirectAuthPlatform {
  final _api = HssOktaDirectAuthPlugin();

  @override
  Future<HssOktaDirectAuthResult> signInWithCredentials(
      HssOktaDirectAuthRequest request) async {
    _api.signInWithCredentials(request);
    return HssOktaDirectAuthResult(result: 'Success');
  }
}
