// ignore_for_file: public_member_api_docs, sort_constructors_first
@JS()
library hss_okta_js;

// import 'package:js/js.dart';
import 'package:js/js.dart';

/// The Http Client used for all the Okta API calls
@JS()
class OktaAuth {
  external factory OktaAuth(OktaConfig options);
  external Token get token;
  external TokenManager get tokenManager;

  /// Parses tokens from the redirect url and stores them.
  external Future<void> storeTokensFromRedirect();

  ///Handle a redirect to the configured redirectUri that happens on the end of login flow, enroll authenticator flow or on an error.
  ///Stores tokens from redirect url into storage (for login flow), then redirect users back to the originalUri.
  /// When using PKCE authorization code flow, this method also exchanges authorization code for tokens.
  /// By default it calls window.location.replace for the redirection.
  /// The default behavior can be overrided by providing options.restoreOriginalUri.
  /// By default, originalUri will be retrieved from storage, but this can be overridden by specifying originalUri in the first parameter to this function.
  external Future<void> handleRedirect(String? originalUri);

  /// Check window.location to verify if the app is in OAuth callback state or not. This function is synchronous and returns true or false.
  external bool isRedirect();

  /// Returns the access token string retrieved from [AuthState] if it exists.
  external String getAccessToken();

  ///Returns the id token string retrieved from [AuthState] if it exists.
  external String getIdToken();
}

/// Used With [OktaAuth]'s Initializer
@JS()
@anonymous
class OktaConfig {
  external factory OktaConfig(
      {String? issuer,
      String? clientId,
      String? redirectUri,
      String? scopes,
      String? state,
      bool? pkce,
      String? authorizeUrl,
      String? userinfoUrl,
      String? tokenUrl,
      String? revokeUrl,
      String? logoutUrl,
      String? clientSecret,
      String? responseType});

  external String? issuer;
  external String? clientId;
  external String? redirectUri;
  external String? scopes;
  external String? state;
  external bool? pkce;
  external String? authorizeUrl;
  external String? userinfoUrl;
  external String? tokenUrl;
  external String? revokeUrl;
  external String? logoutUrl;
  external String? responseType;

  /// For server-side web applications ONLY!
  external String? clientSecret;
}

/// Contains methods for accessing tokens.
@JS()
class Token {
  /// Create token with a popup.
  external Future<TokenResponse> getWithPopup(AuthorizeOptions? options);

  /// Create token using a redirect.
  ///  After a successful authentication, the browser will be redirected to the configured redirectUri.
  ///  The authorization code, access, or ID Tokens will be available as parameters appended to this URL.
  ///  Values will be returned in either the search query or hash fragment portion of the URL depending on the responseMode
  external Future getWithRedirect(AuthorizeOptions? options);

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
  external Future parseFromUrl();

  /// Decode a token.
  external Future decode(String idTokenString);

  /// Returns a new token if the Okta session is still valid.
  external Future renew(AbstractToken tokenToRenew);

  ///Retrieve the details about a user.
  ///
  ///accessTokenObject - (optional) an access token returned by this library. Note: this is not the raw access token.
  ///idTokenObject - (optional) an ID token returned by this library. Note: this is not the raw ID token.
  ///
  ///By default, if no parameters are passed, both the access token and ID token objects will be retrieved from the TokenManager.
  /// It is assumed that the access token is stored using the key "accessToken" and the ID token is stored under the key "idToken".
  ///  If you have stored either token in a non-standard location, this logic can be skipped by passing the access and ID token objects directly.
  external Future getUserInfo(
      AccessToken? accessTokenObject, IDToken? idTokenObject);
}

/// Class that manages tokens.
@JS()
class TokenManager {
  external Future<void> add(String key, Token token);
  external Future<Token> get(String key);
  external Future<Tokens> getTokens();
  external void setTokens(Tokens tokens);
  external Future<void> remove(String key);
  external Future<void> clear();
  external Future<void> renew(String key);
}

/// Options used in getWithPopup and getWithRedirect
@JS()
@staticInterop
@anonymous
class AuthorizeOptions {
  external factory AuthorizeOptions({
    List<String>? responseType,
    String? sessionToken,
    List<String>? scopes,
  });
}

/// Extension Interop for [AuthorizeOptions]
extension AuthorizeOptionsExtension on AuthorizeOptions {
  /// Specify an Okta sessionToken to skip reauthentication when the user already authenticated using the Authentication Flow.
  external List<String>? responseType;

  /// Specify the response type for OIDC authentication when using the Implicit OAuth Flow. The default value is 'token', 'id_token' which will request both an access token and ID token. If pkce is true, both the access and ID token will be requested and this option will be ignored.
  external String? sessionToken;

  ///Specify what information to make available in the returned id_token or access_token. For OIDC, you must include openid as one of the scopes. Defaults to 'openid', 'email'. For a list of available scopes, see Scopes and Claims.
  external List<String>? scopes;
}

/// Web API Response from getWithPopup and getWithRedirect
@JS()
@anonymous
class TokenResponse {
  external Tokens tokens;
  external String state;
  external String? code;
}

/// Container for the two kinds of Token
@JS()
class Tokens {
  external AccessToken? accessToken;
  external IDToken? idToken;
}

///AuthStateManager evaluates and emits AuthState based on the events from TokenManager for downstream clients to consume.
@JS()
class AuthStateManager {
  external Future<AuthState?> getAuthState();
}

@JS()
class AuthState {
  external bool isAuthenticated;
  external String accessToken;
  external String idToken;
  external String error;
}

@JS()
abstract class AbstractToken {
  external int expiresAt;
  external String authorizeUrl;
  external List<String> scopes;
  external bool? pendingRemove;
}

/// An Access Token containing the user's Access token and UserInformation URL
@JS()
@anonymous
class AccessToken extends AbstractToken {
  external factory AccessToken({
    String? accessToken,
    String? tokenType,
    String? userinfoUrl,
    expiresAt,
    authorizeUrl,
    scopes,
    pendingRemove,
  });

  external String accessToken;
  external String tokenType;
  external String userinfoUrl;
  // TODO: Add user claims
}

/// An ID Token containing the user's ID token, issuer, and client ID
@JS()
@anonymous
class IDToken extends AbstractToken {
  external factory IDToken({
    required idToken,
    required issuer,
    required clientId,
    expiresAt,
    authorizeUrl,
    scopes,
    pendingRemove,
  });

  external String idToken;
  external String issuer;
  external String clientId;
  // TODO: Add user claims
}

@JS()
@anonymous
class RefreshToken extends AbstractToken {
  external factory RefreshToken({
    required refreshToken,
    required tokenUrl,
    required issuer,
    expiresAt,
    authorizeUrl,
    scopes,
    pendingRemove,
  });

  external String refreshToken;
  external String tokenUrl;
  external String issuer;
}
