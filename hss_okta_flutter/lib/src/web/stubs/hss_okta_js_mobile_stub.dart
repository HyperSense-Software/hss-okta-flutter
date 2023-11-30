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
  AuthorizeOptions({
    List<String>? responseType,
    String? sessionToken,
    List<String>? scopes,
  });

  List<String>? responseType;
  String? sessionToken;
  List<String>? scopes;
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
  Future<void> add(String key, Token token) => throw UnimplementedError();
  Future<Token> get(String key) => throw UnimplementedError();
  Future<Tokens> getTokens() => throw UnimplementedError();
  Future<void> setTokens(Tokens tokens) => throw UnimplementedError();
  Future<void> remove(String key) => throw UnimplementedError();
  Future<void> clear() => throw UnimplementedError();
  Future<void> renew(String key) => throw UnimplementedError();
}

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
    super.pendingRemove,
  });

  String accessToken;
  String tokenType;
  String userinfoUrl;
  // TODO: Add user claims
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
    super.pendingRemove,
  });

  String idToken;
  String issuer;
  String clientId;
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
