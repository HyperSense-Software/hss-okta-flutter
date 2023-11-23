import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hss_okta_flutter/src/web/interfaces/hss_okta_flutter_web_interface.dart';
import 'package:hss_okta_flutter/src/web/hss_okta_flutter_web_platform_interface.dart';
import 'package:hss_okta_flutter/src/web/js/hss_okta_js_external.dart';
import 'package:js/js_util.dart';

class HssOktaFlutterWeb extends HssOktaFlutterWebPlatformInterface
    implements HssOktaFlutterWebInterface {
  static void registerWith(Registrar registrar) {
    HssOktaFlutterWebPlatformInterface.instance = HssOktaFlutterWeb();
  }

  late OktaAuth _auth;

  /// Getter for the OktaAuth JS Object
  ///
  /// For general use, You should use the methods provided by this class instead of accessing the JS object directly.
  OktaAuth? get oktaAuth => _auth;

  /// Initialize the Okta client with the provided configuration.
  @override
  Future<void> initializeClient({required OktaConfig oktaConfig}) async {
    _auth = OktaAuth(oktaConfig);
  }

  /// Create token using a redirect.
  ///  After a successful authentication, the browser will be redirected to the configured redirectUri.
  ///  The authorization code, access, or ID Tokens will be available as parameters appended to this URL.
  ///  Values will be returned in either the search query or hash fragment portion of the URL depending on the responseMode
  @override
  Future<void> startRedirectAuthentication({AuthorizeOptions? options}) async {
    await promiseToFuture<void>(_auth.token.getWithRedirect(options));
  }

  ///Parses the authorization code, access, or ID Tokens from the URL after a successful authentication redirect.
  /// Values are parsed from either the search query or hash fragment portion of the URL depending on the responseMode.
  /// The following configuration options can be included in token.getWithoutPrompt,
  /// token.getWithPopup, or token.getWithRedirect.
  /// If an option with the same name is accepted in the constructor,
  /// passing the option to one of these methods will override the previously set value.
  ///
  ///If an authorization code is present, it will be exchanged for token(s) by posting to the tokenUrl endpoint.
  ///
  ///Note: Authorization code has a lifetime of one minute and can only be used once.
  ///The ID token will be verified and validated before available for use.
  /// In case access token is a part of OIDC flow response, its hash will be checked against ID token's at_hash claim.
  ///
  ///The state string which was passed to getWithRedirect will be also be available on the response.
  @override
  Future<TokenResponse> parseFromUrl() async {
    final res =
        await promiseToFuture<TokenResponse>(_auth.token.parseFromUrl());

    return res;
  }

  /// Create token with a popup.
  @override
  Future<TokenResponse> startPopUpAuthentication(
      {AuthorizeOptions? options}) async {
    final res =
        await promiseToFuture<TokenResponse>(_auth.token.getWithPopup(options));
    return res;
  }

  /// Returns a new token if the Okta session is still valid.
  @override
  Future<TokenResponse> renew(String tokenToRenew) async {
    final res = await promiseToFuture(_auth.token.renew(tokenToRenew));
    return res;
  }

  /// Decode a token.
  @override
  Future<TokenResponse> decode(String idTokenString) async {
    final res = await promiseToFuture(_auth.token.decode(idTokenString));
    return res;
  }

  ///After receiving an access_token or id_token, add it to the tokenManager to manage token expiration and renew operations.
  /// When a token is added to the tokenManager, it is automatically renewed when it expires.
  ///
  ///[key]- Unique key to store the token in the tokenManager. This is used later when you want to get, delete, or renew the token.
  /// [token] - Token object that will be added
  @override
  void addToken(String key, Token token) async {
    await promiseToFuture(_auth.tokenManager.add(key, token));
  }

  ///Get a [Token] that you have previously added to the tokenManager with the given key.
  /// The [Token] object will be returned if it exists in storage. Tokens will be removed from storage if they have expired and autoRenew is false or if there was an error while renewing the token.
  /// The [TokenManager] will emit a removed event when tokens are removed.
  @override
  Future<Token> getToken(String key) async {
    final res = await promiseToFuture(_auth.tokenManager.get(key));
    return res;
  }

  ///Remove a [Token] from the tokenManager with the given key.
  ///[key] - Key for the token you want to remove
  @override
  void removeToken(String key) async {
    _auth.tokenManager.remove(key);
  }

  ///Remove all tokens from the tokenManager.
  @override
  void clearTokens() async {
    _auth.tokenManager.clear();
  }

  /// Returns true if the current page is a redirect from the authorization server.
  @override
  bool isRedirect() {
    return _auth.isRedirect();
  }

  /// Check window.location to verify if the app is in OAuth callback state or not. This function is synchronous and returns true or false.
  @override
  String getAccessToken() {
    return _auth.getAccessToken();
  }

  /// Returns the id token string retrieved if it exists.
  @override
  String getIdToken() {
    return _auth.getIdToken();
  }

  @override
  Future<TokenResponse> getUserInfo({required String accessToken}) {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<TokenResponse> renewToken({required String refreshToken}) {
    // TODO: implement renewToken
    throw UnimplementedError();
  }
}
