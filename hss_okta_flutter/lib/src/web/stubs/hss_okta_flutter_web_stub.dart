import 'package:hss_okta_flutter/hss_okta_flutter.dart';

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

  Future<TokenResponse> renewToken({required AbstractToken tokenToRefresh}) {
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

  Future<UserClaims> getUser() => throw UnimplementedError();

  void removeOriginalUri() => throw UnimplementedError();
  void setOriginalUri() => throw UnimplementedError();
  void getOriginalUri() => throw UnimplementedError();

  Future<void> handleRedirect({String? originalUri}) =>
      throw UnimplementedError();

  void setHeaders(Object headers) => throw UnimplementedError();

  /// Subscribes a callback that will be called when the [AuthState]
  /// event happens.

  void subscribe(void Function(AuthState authState) cb) =>
      throw UnimplementedError();

  /// Unsubscribes callback for [AuthState] event. It will unregister all
  /// handlers if no callback handler is provided.
  void unsubscribe(void Function(AuthState? authState) cb) =>
      throw UnimplementedError();

  /// The goal of this authentication flow is to set an
  /// Okta [session cookie on the user's browser](https://developer.okta.com/use_cases/authentication/session_cookie#retrieving-a-session-cookie-by-visiting-a-session-redirect-link) or retrieve
  /// an [IDToken] or [AccessToken]. The flow is started
  /// using [signInWithCredentials].
  ///
  /// [username] - User’s non-qualified short-name (e.g. dade.murphy)
  /// or unique fully-qualified login
  ///
  /// [password] - User’s password
  Future<AuthnTransaction> signInWithCredentials({
    required String username,
    required String password,
  }) =>
      throw UnimplementedError();

  /// This allows you to create a session using a sessionToken.
  ///
  /// [sessionToken] - Ephemeral one-time token used to
  /// bootstrap an Okta session.
  ///
  /// [redirectUri] - After setting a cookie, Okta redirects to the specified
  ///  URI. The default is the current URI.
  void setCookieAndRedirect(String? sessionToken, {String? redirectUri}) =>
      throw UnimplementedError();

  Future<bool> isAuthenticated() => throw UnimplementedError();

  /// When you've obtained a sessionToken from the authorization flows,
  /// or a session already exists, you can obtain a token or tokens without
  /// prompting the user to log in.
  ///
  ///
  /// Example:
  ///
  /// ```dart
  ///    final result =
  ///      await provider.pluginWeb.signInWithCredentials(
  ///    username: _usernamecontroller.text,
  ///    password: _passwordcontroller.text,
  ///  );

  ///  if (result.status == 'SUCCESS') {
  ///    final token = await provider.pluginWeb.getWithoutPrompt(
  ///        sessionToken: result.sessionToken!,
  ///        scopes: ['openid', 'email', 'profile'],
  ///        responseType: ['token', 'id_token']);
  ///    final idToken = token.tokens.idToken?.idToken;
  ///    final accessToken = token.tokens.accessToken?.accessToken;
  ///    Navigator.of(context).push(
  ///      MaterialPageRoute(
  ///        builder: (c) => WebProfileScreen(
  ///          token: idToken!,
  ///          accessToken: accessToken!,
  ///        ),
  ///      ),
  ///    );
  ///  }
  /// ```
  Future<TokenResponse> getWithoutPrompt({
    List<String>? responseType,
    required String sessionToken,
    List<String>? scopes,
  }) =>
      throw UnimplementedError();

  /// Revokes refreshToken or accessToken, clears all local tokens,
  /// then redirects to Okta to end the SSO session.
  Future<bool?> signOut() => throw UnimplementedError();

  Future<AuthState> updateAuthState() => throw UnimplementedError();

  Future<bool> isSessionExists() => throw UnimplementedError();

  Future<SessionObject> getActiveSession() => throw UnimplementedError();
  Future<SessionObject> refreshSession() => throw UnimplementedError();

  AuthState? getPreviousAuthState() => throw UnimplementedError();
}
