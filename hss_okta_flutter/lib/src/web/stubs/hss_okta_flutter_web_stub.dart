import 'package:hss_okta_flutter/src/web/stubs/hss_okta_js_mobile_stub.dart';

class HssOktaFlutterWeb {
  void addToken(String key, Token token) => throw UnimplementedError();

  void clearTokens() => throw UnimplementedError();

  Future<TokenResponse> decode(String idTokenString) {
    throw UnimplementedError();
  }

  String getAccessToken() {
    throw UnimplementedError();
  }

  String getIdToken() {
    throw UnimplementedError();
  }

  Future<Token> getToken(String key) {
    throw UnimplementedError();
  }

  Future<UserClaims> getUserInfo({
    AccessToken? accessTokenObject,
    IDToken? idTokenObject,
  }) =>
      throw UnimplementedError();

  Future<void> initializeClient({required OktaConfig oktaConfig}) {
    throw UnimplementedError();
  }

  bool isRedirect() {
    throw UnimplementedError();
  }

  Future<TokenResponse> parseFromUrl() {
    throw UnimplementedError();
  }

  void removeToken(String key) => throw UnimplementedError();

  Future<TokenResponse> renew(AbstractToken tokenToRenew) {
    throw UnimplementedError();
  }

  Future<TokenResponse> renewToken({required String refreshToken}) {
    throw UnimplementedError();
  }

  Future<TokenResponse> startPopUpAuthentication({AuthorizeOptions? options}) {
    throw UnimplementedError();
  }

  Future<void> startRedirectAuthentication({AuthorizeOptions? options}) {
    throw UnimplementedError();
  }

  void setTokens(Tokens tokens) => throw UnimplementedError();

  Future<Tokens> getTokens(Tokens tokens) => throw UnimplementedError();

  Future<bool> hasTokenExpired(AbstractToken token) async =>
      throw UnimplementedError();
}
