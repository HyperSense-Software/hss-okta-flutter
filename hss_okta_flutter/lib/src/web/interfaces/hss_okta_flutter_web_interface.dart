import 'package:hss_okta_flutter/src/web/js/hss_okta_js_external.dart';

abstract class HssOktaFlutterWebInterface {
  Future<void> initializeClient({required OktaConfig oktaConfig});
  Future<void> startRedirectAuthentication({AuthorizeOptions? options});
  Future<TokenResponse> parseFromUrl();
  Future<TokenResponse> startPopUpAuthentication({AuthorizeOptions? options});
  Future<TokenResponse> renewToken({required String refreshToken});
  void clearTokens();
  Future<TokenResponse> getUserInfo({required String accessToken});
  Future<TokenResponse> renew(String tokenToRenew);
  Future<TokenResponse> decode(String idTokenString);
  void addToken(String key, Token token);
  Future<Token> getToken(String key);
  void removeToken(String key);
  bool isRedirect();
  String getAccessToken();
  String getIdToken();
}
