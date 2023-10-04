library hss_okta_flutter;

import 'package:hss_okta_direct_auth/hss_okta_direct_auth.dart';

class HssOktaFlutter {
  static HssOktaFlutter? _instance;
  final HssOktaDirectAuth _hssOktaDirectAuth = HssOktaDirectAuth();

  HssOktaFlutter._();

  factory HssOktaFlutter() => _instance ??= HssOktaFlutter._();
}
