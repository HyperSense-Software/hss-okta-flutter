import 'hss_okta_authn_stub.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OktaAuth {
  Token get token => throw UnimplementedError();
  TokenManager get tokenManager => throw UnimplementedError();

  /// Parses tokens from the redirect url and stores them.
  Future<void> storeTokensFromRedirect() => throw UnimplementedError();

  ///Handle a redirect to the configured redirectUri that happens on the end of login flow, enroll authenticator flow or on an error.
  ///Stores tokens from redirect url into storage (for login flow), then redirect users back to the originalUri.
  /// When using PKCE authorization code flow, this method also exchanges authorization code for tokens.
  /// By default it calls window.location.replace for the redirection.
  /// The default behavior can be overrided by providing options.restoreOriginalUri.
  /// By default, originalUri will be retrieved from storage, but this can be overridden by specifying originalUri in the first parameter to this function.
  Future<void> handleRedirect(String? originalUri) =>
      throw UnimplementedError();

  /// Check window.location to verify if the app is in OAuth callback state or not. This function is synchronous and returns true or false.
  bool isRedirect() => throw UnimplementedError();

  /// Returns the access token string retrieved from [AuthState] if it exists.
  String getAccessToken() => throw UnimplementedError();

  ///Returns the id token string retrieved from [AuthState] if it exists.
  String getIdToken() => throw UnimplementedError();

  ///Retrieve the details about a user.
  ///
  ///accessTokenObject - (optional) an access token returned by this library. Note: this is not the raw access token.
  ///idTokenObject - (optional) an ID token returned by this library. Note: this is not the raw ID token.
  ///
  ///By default, if no parameters are passed, both the access token and ID token objects will be retrieved from the TokenManager.
  /// It is assumed that the access token is stored using the key "accessToken" and the ID token is stored under the key "idToken".
  ///  If you have stored either token in a non-standard location, this logic can be skipped by passing the access and ID token objects directly.
  Future getUserInfo({
    AccessToken? accessTokenObject,
    IDToken? idTokenObject,
  }) =>
      throw UnimplementedError();

  /// Revokes the access token for this application so it can no longer be used to authenticate API requests. The [accessToken] parameter is optional. By default, revokeAccessToken will look for a token object named accessToken within the TokenManager. If you have stored the access token object in a different location, you should retrieve it first and then pass it here. Returns a promise that resolves when the operation has completed. This method will succeed even if the access token has already been revoked or removed.
  Future revokeAccessToken(AccessToken accessToken) =>
      throw UnimplementedError();

  /// Revokes the refresh token (if any) for this application so it can no longer be used to mint new tokens. The [refreshToken] parameter is optional. By default, revokeRefreshToken will look for a token object named refreshToken within the TokenManager. If you have stored the refresh token object in a different location, you should retrieve it first and then pass it here. Returns a promise that resolves when the operation has completed. This method will succeed even if the refresh token has already been revoked or removed.
  Future revokeRefreshToken(RefreshToken refreshToken) =>
      throw UnimplementedError();

  Future getUser() => throw UnimplementedError();

  void setOriginalUri(String uri) => throw UnimplementedError();
  void removeOriginalUri() => throw UnimplementedError();
  void getOriginalUri() => throw UnimplementedError();

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
  Future<bool?> signOut([SignoutOptions? options]) =>
      throw UnimplementedError();

  Future<AuthState> updateAuthState() => throw UnimplementedError();
}

class OktaConfig {
  String? issuer;
  String? clientId;
  String? redirectUri;
  String? scopes;
  String? state;
  bool? pkce;
  String? authorizeUrl;
  String? userinfoUrl;
  String? tokenUrl;
  String? revokeUrl;
  String? logoutUrl;
  String? responseType;
  String? clientSecret;

  OktaConfig({
    this.issuer,
    this.clientId,
    this.redirectUri,
    this.scopes,
    this.state,
    this.pkce,
    this.authorizeUrl,
    this.userinfoUrl,
    this.tokenUrl,
    this.revokeUrl,
    this.logoutUrl,
    this.responseType,
    this.clientSecret,
  });
}

class Token {
  Future<TokenResponse> getWithPopup(AuthorizeOptions? options) =>
      throw UnimplementedError();
  Future getWithRedirect(AuthorizeOptions? options) =>
      throw UnimplementedError();
  Future parseFromUrl() => throw UnimplementedError();
  Future decode(String idTokenString) => throw UnimplementedError();
  Future renew(AbstractToken tokenToRenew) => throw UnimplementedError();
}

class AuthorizeOptions {
  external factory AuthorizeOptions(
      {List<String>? responseType,
      String? sessionToken,
      List<String>? scopes,
      String? nonce,
      String? state,
      String? idp,
      String? prompt,
      int? maxAge,
      String? loginHint,
      String? display});
}

class Tokens {
  AccessToken? accessToken;
  IDToken? idToken;
  Tokens({
    this.accessToken,
    this.idToken,
  });
}

class TokenResponse {
  Tokens tokens;
  String state;
  String code;
  TokenResponse({
    required this.tokens,
    required this.state,
    required this.code,
  });
}

class TokenManager {
  Future<void> add(String key, AbstractToken token) =>
      throw UnimplementedError();
  Future<AbstractToken> get(String key) => throw UnimplementedError();
  Future<Tokens> getTokens() => throw UnimplementedError();
  Future<void> setTokens(Tokens tokens) => throw UnimplementedError();
  Future<void> remove(String key) => throw UnimplementedError();
  Future<void> clear() => throw UnimplementedError();
  Future<void> renew(String key) => throw UnimplementedError();
}

/// Superclass for [AccessToken], [IDToken], and [RefreshToken]
class AbstractToken {
  int expiresAt;
  String authorizeUrl;
  List<String> scopes;
  bool? pendingRemove;

  AbstractToken({
    required this.expiresAt,
    required this.authorizeUrl,
    required this.scopes,
    this.pendingRemove,
  });
}

/// An Access Token containing the user's Access token and UserInformation URL

class AccessToken extends AbstractToken {
  AccessToken({
    required this.accessToken,
    required this.tokenType,
    required this.userinfoUrl,
    required super.expiresAt,
    required super.authorizeUrl,
    required super.scopes,
    required this.claims,
    super.pendingRemove,
  });

  String accessToken;
  String tokenType;
  String userinfoUrl;
  UserClaims claims;
}

/// An ID Token containing the user's ID token, issuer, and client ID

class IDToken extends AbstractToken {
  IDToken({
    required this.idToken,
    required this.issuer,
    required this.clientId,
    required super.expiresAt,
    required super.authorizeUrl,
    required super.scopes,
    required this.claims,
    super.pendingRemove,
  });

  String idToken;
  String issuer;
  String clientId;
  UserClaims claims;
  // TODO: Add user claims
}

class RefreshToken extends AbstractToken {
  RefreshToken({
    required this.refreshToken,
    required this.tokenUrl,
    required this.issuer,
    required super.expiresAt,
    required super.authorizeUrl,
    required super.scopes,
    super.pendingRemove,
  });

  String refreshToken;
  String tokenUrl;
  String issuer;
}

class UserClaims {
  String authTtime;
  String aud;
  String email;

  String emailVerified;
  String exp;

  String familyName;

  String givenName;
  String iat;
  String iss;
  String jti;
  String locale;
  String name;
  String nonce;

  String preferredUsername;
  String sub;

  String updatedAt;
  String ver;
  String zoneinfo;

  String atHash;
  String acr;
  UserClaims({
    required this.authTtime,
    required this.aud,
    required this.email,
    required this.emailVerified,
    required this.exp,
    required this.familyName,
    required this.givenName,
    required this.iat,
    required this.iss,
    required this.jti,
    required this.locale,
    required this.name,
    required this.nonce,
    required this.preferredUsername,
    required this.sub,
    required this.updatedAt,
    required this.ver,
    required this.zoneinfo,
    required this.atHash,
    required this.acr,
  });
}

class AuthState {
  external bool get isAuthenticated;
  external AccessToken get accessToken;
  external IDToken get idToken;
  external String get error;
}

class SessionObject {
  external String get status;
  external Future refresh();
  external Future user();
}

class SessionAPI {
  external Future close();
  external Future<bool?> exists();
  external Future<SessionObject> get();
  external Future refresh();
  external void setCookieAndRedirect(
    String? sessionToken,
    String? redirectUrl,
  );
}

class SignoutOptions {
  external factory SignoutOptions({
    bool? revokeAccessToken,
    bool? revokeRefreshToken,
    AbstractToken? accessToken,
    AbstractToken? refreshToken,
    bool? clearTokensBeforeRedirect,
    String? postLogoutRedirectUri,
    IDToken? idToken,
    String? state,
  });
}
