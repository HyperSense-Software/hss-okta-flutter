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
  Future renew(String tokenToRenew) => throw UnimplementedError();
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

class AccessToken {
  String accessToken;
  String tokenType;
  String userinfoUrl;
  AccessToken({
    required this.accessToken,
    required this.tokenType,
    required this.userinfoUrl,
  });
}

class IDToken {
  String? idToken;
  String? issuer;
  String? clientId;
  IDToken({
    this.idToken,
    this.issuer,
    this.clientId,
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
  Future<Map<String, String>> getTokens() => throw UnimplementedError();
  Future<void> setTokens(Map<String, String> tokens) =>
      throw UnimplementedError();
  Future<void> remove(String key) => throw UnimplementedError();
  Future<void> clear() => throw UnimplementedError();
  Future<void> renew(String key) => throw UnimplementedError();
}
