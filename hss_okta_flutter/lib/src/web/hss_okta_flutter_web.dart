import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter/src/web/hss_okta_flutter_web_platform_interface.dart';
import 'package:js/js_util.dart';

///{@template hss_okta_flutter_web}
/// Wrapper for Okta Auth JS for Flutter/Dart Web
///
/// Intialize using [initializeClient] method with [OktaConfig] object before
/// using other methods.
///
/// {@endtemplate}

class HssOktaFlutterWeb extends HssOktaFlutterWebPlatformInterface {
  /// {@macro hss_okta_flutter_web}
  @visibleForTesting
  static void registerWith(Registrar registrar) {
    HssOktaFlutterWebPlatformInterface.instance = HssOktaFlutterWeb();
  }

  late OktaAuth _auth;

  /// Initialize the Okta client with the provided configuration.
  Future<void> initializeClient({required OktaConfig oktaConfig}) async {
    _auth = OktaAuth(oktaConfig);
  }

  /// Create token using a redirect.
  /// After a successful authentication, the browser will be redirected to the
  /// configured redirectUri.
  ///
  /// The authorization code, access, or ID Tokens will be available as
  /// parameters appended to this URL.
  ///
  /// Values will be returned in either the search query or hash fragment
  /// portion of the URL depending on the responseMode
  ///
  /// To process the result of the redirect, use the [parseFromUrl] method.
  Future<void> startRedirectAuthentication({AuthorizeOptions? options}) async {
    await promiseToFuture<void>(_auth.token.getWithRedirect(options));
  }

  /// Parses the authorization code, access, or ID Tokens from the URL after a
  /// successful authentication redirect.
  ///
  /// Values are parsed from either the search query or hash fragment portion of
  /// the URL depending on the responseMode.
  ///
  /// The following configuration options can be included in
  /// token.getWithoutPrompt, token.getWithPopup, or token.getWithRedirect.
  ///
  /// If an option with the same name is accepted in the constructor,
  /// passing the option to one of these methods will override the previously
  /// set value.
  ///
  /// If an authorization code is present, it will be exchanged for token(s) by
  /// posting to the tokenUrl endpoint.
  ///
  /// Note: Authorization code has a lifetime of one minute and can only be used
  /// once.
  /// The ID token will be verified and validated before available for use.
  /// In case access token is a part of OIDC flow response, its hash will be
  /// checked against ID token's at_hash claim.
  ///
  /// The state string which was passed to getWithRedirect will be also be
  /// available on the response.

  Future<TokenResponse> parseFromUrl() async {
    final res =
        await promiseToFuture<TokenResponse>(_auth.token.parseFromUrl());

    return res;
  }

  /// Create token with a popup. Launches a separate browser window to
  /// authenticate
  /// [AuthorizeOptions] - (optional) options for the authorization request.
  Future<TokenResponse> startPopUpAuthentication({
    AuthorizeOptions? options,
  }) async {
    final res =
        await promiseToFuture<TokenResponse>(_auth.token.getWithPopup(options));

    return res;
  }

  /// Returns a new token if the Okta session is still valid.
  /// Manually renew a token before it expires and update the stored value.
  ///
  ///[key] - Key for the token you want to renew
  Future<TokenResponse> renew(String key) async {
    final res = await promiseToFuture<TokenResponse>(_auth.token.renew(key));
    return res;
  }

  /// Decode a token.

  Future<TokenResponse> decode(String idTokenString) async {
    final res =
        await promiseToFuture<TokenResponse>(_auth.token.decode(idTokenString));
    return res;
  }

  ///After receiving an access_token or id_token, add it to the tokenManager to
  ///manage token expiration and renew operations.
  ///
  /// When a token is added to the tokenManager, it is automatically renewed
  /// when it expires.
  ///
  ///[key]- Unique key to store the token in the tokenManager.
  ///This is used later when you want to get, delete, or renew the token.
  ///
  /// [token] - Token object that will be added

  Future<void> addToken(String key, AbstractToken token) async {
    await promiseToFuture<void>(_auth.tokenManager.add(key, token));
  }

  ///Adds storage key agnostic tokens to storage. It uses default token storage
  ///keys (idToken, accessToken) in storage.
  Future<void> setTokens(Tokens tokens) async {
    _auth.tokenManager.setTokens(tokens);
  }

  /// Returns storage key agnostic tokens set for available tokens from storage.
  /// It returns empty object ({}) if no token is in storage.
  Future<Tokens> getTokens() async {
    final res = await promiseToFuture<Tokens>(_auth.tokenManager.getTokens());
    return res;
  }

  /// Get a [Token] that you have previously added to the tokenManager with the
  /// given key.
  ///
  /// The [Token] object will be returned if it exists in storage. Tokens will
  /// be removed from storage if they have expired and autoRenew is false or if
  /// there was an error while renewing the token.
  ///
  /// The [TokenManager] will emit a removed event when tokens are removed.

  Future<AbstractToken> getToken(String key) async {
    final res =
        await promiseToFuture<AbstractToken>(_auth.tokenManager.get(key));
    return res;
  }

  ///Remove a [Token] from the tokenManager with the given key.
  ///[key] - Key for the token you want to remove

  Future<void> removeToken(String key) async {
    _auth.tokenManager.remove(key);
  }

  ///Remove all tokens from the tokenManager.

  Future<void> clearTokens() async {
    _auth.tokenManager.clear();
  }

  /// Returns true if the current page is a redirect from
  /// the authorization server.
  bool isRedirect() {
    return _auth.isRedirect();
  }

  /// Check window.location to verify if the app is in
  /// OAuth callback state or not. This function is synchronous
  /// and returns true or false.

  String getAccessToken() {
    return _auth.getAccessToken();
  }

  /// Returns the id token string retrieved if it exists.

  String getIdToken() {
    return _auth.getIdToken();
  }

  /// Retrieve the details about a user.
  ///
  /// [accessTokenObject] - (optional) an access token returned by this library.
  /// [idTokenObject] - (optional) an ID token.
  ///
  /// By default, if no parameters are passed, both the access token and ID
  /// token objects will be retrieved from the TokenManager.
  /// It is assumed that the access token is stored using the key "accessToken"
  /// and the ID token is stored under the key "idToken".
  /// If you have stored either token in a non-standard location, this logic can
  /// be skipped by passing the access and ID token objects directly.

  Future<UserClaims> getUserInfo({
    AccessToken? accessTokenObject,
    IDToken? idTokenObject,
  }) async {
    final res = await promiseToFuture<UserClaims>(
      _auth.token.getUserInfo(
        accessTokenObject,
        idTokenObject,
      ),
    );

    return res;
  }

  /// Not implemented yet
  Future<TokenResponse> renewToken({required String refreshToken}) {
    throw UnimplementedError();
  }

  /// Checkif token is expired from [TokenManager]
  Future<bool> hasTokenExpired(AbstractToken token) async =>
      _auth.tokenManager.hasExpired(token);

  /// Returns the current [AuthState]. User must register the [subscribe]
  /// callback to get the [AuthState] event.
  Future<AuthState?> getAuthState() async {
    return promiseToFuture<AuthState?>(_auth.authStateManager.getAuthState());
  }

  /// Subscribes a callback that will be called when the [AuthState]
  /// event happens.

  void subscribe(void Function(AuthState authState) cb) {
    _auth.authStateManager.subscribe(allowInterop(cb));
  }

  /// Unsubscribes callback for [AuthState] event. It will unregister all
  /// handlers if no callback handler is provided.
  void unsubscribe(void Function(AuthState? authState) cb) {
    _auth.authStateManager.unsubscribe(allowInterop(cb));
  }

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
  }) {
    final response = promiseToFuture<AuthnTransaction>(
      _auth.signInWithCredentials(
        SigninWithCredentialsOptions(
          username: username,
          password: password,
        ),
      ),
    );
    return response;
  }

  /// This allows you to create a session using a sessionToken.
  ///
  /// [sessionToken] - Ephemeral one-time token used to
  /// bootstrap an Okta session.
  ///
  /// [redirectUri] - After setting a cookie, Okta redirects to the specified
  ///  URI. The default is the current URI.
  void setCookieAndRedirect(String? sessionToken, {String? redirectUri}) {
    _auth.session.setCookieAndRedirect(sessionToken, redirectUri);
  }

  /// Returns true if both [AccessToken] and [IDToken] are not expired
  /// If [renew] option is set, will attempt to renew expired tokens before
  /// returning.
  Future<bool> isAuthenticated() {
    return promiseToFuture<bool>(_auth.isAuthenticated());
  }

  /// Returns [AbstractToken].
  /// Can be either [AccessToken] and [IDToken].
  Future<AbstractToken> get(String token) async {
    return promiseToFuture(_auth.tokenManager.get(token));
  }

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
  ///   // do something with tokens
  ///  }
  /// ```
  Future<TokenResponse> getWithoutPrompt({
    required String sessionToken,
    List<String>? responseType,
    List<String>? scopes,
  }) async {
    return promiseToFuture<TokenResponse>(
      _auth.token.getWithoutPrompt(
        AuthorizeOptions(
          sessionToken: sessionToken,
          scopes: scopes,
          responseType: responseType,
        ),
      ),
    );
  }

  /// Revokes refreshToken or accessToken, clears all local tokens,
  /// then redirects to Okta to end the SSO session.
  Future<bool?> signOut() async {
    return promiseToFuture<bool?>(_auth.signOut());
  }

  /// Returns newest [AuthState] after updating the state.
  Future<AuthState> updateAuthState() async {
    return promiseToFuture<AuthState>(_auth.authStateManager.updateAuthState());
  }

  /// Revokes the access token for this application so it can no longer be used
  /// to authenticate API requests. The [accessToken] parameter is optional.
  /// By default, revokeAccessToken will look for a token object named
  /// accessToken within the TokenManager.
  /// If you have stored the access token object in a different location,
  /// you should retrieve it first and then pass it here.
  /// Returns a promise that resolves when the operation has completed.
  /// This method will succeed even if the access token has already been revoked
  /// or removed.
  Future<void> revokeAccessToken(AccessToken accessToken) async {
    await promiseToFuture<void>(_auth.revokeAccessToken(accessToken));
  }

  /// Revokes the refresh token (if any) for this application so it can no
  /// longer be used to mint new tokens.
  ///
  /// The [refreshToken] parameter is optional.
  ///
  /// By default, revokeRefreshToken will look for a token object named
  /// refreshToken within the TokenManager. If you have stored the refresh
  /// token object in a different location, you should retrieve it first and
  /// then pass it here.
  ///
  /// Returns a [Future] that resolves when the operation has completed.
  ///
  /// This method will succeed even if the refresh token has
  /// already been revoked or removed.
  Future<void> revokeRefreshToken(RefreshToken refreshToken) async {
    await promiseToFuture<void>(_auth.revokeRefreshToken(refreshToken));
  }

  /// Retrieve the [details about a user](https://developer.okta.com/docs/api/resources/oidc#response-example-success).
  Future<UserClaims> getUser() async {
    final res = await promiseToFuture<UserClaims>(_auth.getUser());
    return res;
  }

  ///Removes the stored URI string stored by [setOriginalUri] from storage.
  void removeOriginalUri() {
    _auth.removeOriginalUri();
  }

  /// Stores the current URL state before a redirect occurs.
  void setOriginalUri(String uri) {
    _auth.setOriginalUri(uri);
  }

  /// Returns the stored URI string stored by [setOriginalUri].

  String getOriginalUri() {
    return _auth.getOriginalUri();
  }

  /// Handle a redirect to the configured redirectUri that happens on the end of
  /// login flow, enroll authenticator flow or on an error.
  ///Stores tokens from redirect url into storage (for login flow), then
  ///redirect users back to the originalUri.
  /// When using PKCE authorization code flow, this method also exchanges
  /// authorization code for tokens.
  ///
  /// By default it calls window.location.replace for the redirection.
  /// The default behavior can be overrided by providing
  /// options.restoreOriginalUri. By default, originalUri will be retrieved
  /// from storage, but this can be overridden by specifying originalUri in the
  /// first parameter to this function.
  Future<void> handleRedirect({String? originalUri}) async {
    await _auth.handleRedirect(originalUri);
  }

  ///Can set (or unset) request headers after construction.
  void setHeaders(Map<String, String> headers) {
    _auth.setHeaders(jsify(headers) as Object);
  }
}
