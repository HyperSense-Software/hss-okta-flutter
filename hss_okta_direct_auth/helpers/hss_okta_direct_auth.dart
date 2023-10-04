import '../pigeons/hss_okta_direct_auth_pigeon.dart';

extension HssOktaDirectAuthResultExtension on HssOktaDirectAuthResult {
  DateTime get issueDate =>
      DateTime.fromMillisecondsSinceEpoch((issuedAt ?? 0) * 1000);
}
