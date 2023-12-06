@JS()
library hss_okta_js;

import 'dart:js_interop';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

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

  /// Revokes the access token for this application so it can no longer be used to authenticate API requests. The [accessToken] parameter is optional. By default, revokeAccessToken will look for a token object named accessToken within the TokenManager. If you have stored the access token object in a different location, you should retrieve it first and then pass it here. Returns a promise that resolves when the operation has completed. This method will succeed even if the access token has already been revoked or removed.
  external Future revokeAccessToken(AccessToken accessToken);

  /// Revokes the refresh token (if any) for this application so it can no longer be used to mint new tokens. The [refreshToken] parameter is optional. By default, revokeRefreshToken will look for a token object named refreshToken within the TokenManager. If you have stored the refresh token object in a different location, you should retrieve it first and then pass it here. Returns a promise that resolves when the operation has completed. This method will succeed even if the refresh token has already been revoked or removed.
  external Future revokeRefreshToken(RefreshToken refreshToken);

  ///Alias method of token.getUserInfo.
  external Future getUser();

  ///Stores the current URL state before a redirect occurs.
  external void setOriginalUri(String uri);

  /// Removes the stored URI string stored by [setOriginalUri] from storage
  external void removeOriginalUri();

  /// Returns the stored URI string stored by [setOriginalUri].
  external String getOriginalUri();

  /// Can set (or unset) request headers after construction.
  external void setHeaders(Object headers);

  external Future<AuthnTransaction> signInWithCredentials(
      SigninOptions? options);

  external Future<AuthnTransaction> signIn(SigninOptions? options);
}

@JS()
@anonymous
class SigninOptions {
  String? relayState;
  bool? sendFingerprint;
  String? stateToken;
  String? username;
  String? password;

  external factory SigninOptions(
      {String? relayState,
      bool? sendFingerprint,
      String? stateToken,
      String? username,
      String? password});
}

@JS()
class AuthnTransaction {
  external String? sessionToken;
  external String? status;
  external JSObject user;
  external JSObject factor;
  external JSObject? factors;
  external JSObject? policy;
  external JSObject? scopes;
  external JSObject? target;
  external JSObject? authentication;
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
  external Future renew(String key);

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
  /// After receiving an access_token or id_token
  ///  add it to the tokenManager to manage token expiration and renew operations.
  ///  When a token is added to the tokenManager, it is automatically renewed when it expires.
  ///
  /// [key] - Unique key to store the token in the tokenManager. This is used later when you want to get, delete, or renew the token.
  /// [token] - Token object that will be added

  external Future<void> add(String key, AbstractToken token);

  /// Get a token that you have previously added to the tokenManager with the given key.
  ///  The token object will be returned if it exists in storage.
  /// Tokens will be removed from storage if they have expired and autoRenew is false or if there was an error while renewing the token.
  ///  The tokenManager will emit a removed event when tokens are removed.
  external Future<AbstractToken> get(String key);

  ///Returns storage key agnostic tokens set for available tokens from storage.
  /// It returns empty object ({}) if no token is in storage.

  external Future<Tokens> getTokens();

  /// Adds storage key agnostic tokens to storage. It uses default token storage keys (idToken, accessToken) in storage.
  external void setTokens(Tokens tokens);
  external void remove(String key);
  external void clear();

  /// Manually renew a token before it expires and update the stored value.
  external Future<void> renew(String key);

  /// A synchronous method which returns true if the token has expired.
  ///  The tokenManager will automatically remove expired tokens in the background.
  ///  However, when the app first loads this background process may not have completed,
  ///  so there is a chance that an expired token may exist in storage. This method can be called to avoid this potential race condition.
  external bool hasExpired(AbstractToken token);
}

/// Options used in getWithPopup and getWithRedirect
///
/// [responseType] - Specify the response type for OIDC authentication when using the Implicit OAuth Flow.
///  The default value is 'token', 'id_token' which will request both an access token and ID token.
///  If pkce is true, both the access and ID token will be requested and this option will be ignored.
///
/// [scopes] - Specify what information to make available in the returned id_token or access_token.
///  For OIDC, you must include openid as one of the scopes. Defaults to 'openid', 'email'.
///
///[idp] - Identity provider to use if there is no Okta Session.
///
///[state] - A string that will be passed to /authorize endpoint and returned in the OAuth response.
/// The value is used to validate the OAuth response and prevent cross-site request forgery (CSRF).
///  The state value passed to getWithRedirect will be returned along with any requested tokens from parseFromUrl.
///  Your app can use this string to perform additional validation and/or pass information from the login page. Defaults to a random string.
///
///[nonce] - Specify a nonce that will be validated in an id_token.
/// This is usually only provided during redirect flows to obtain an authorization code that will be exchanged for an id_token.
///  Defaults to a random string.
///
///[prompt] - Determines whether the Okta login will be displayed on failure. Use none to prevent this behavior.
/// Valid values: none, consent, login, or consent login.
///
///[loginHint] - Provides a hint indicating the user's email address or username.
/// The hint will be used to either pre-fill the email box on the login page or select the username tile on the login page.
///
/// [maxAge] -  	Allowable elapsed time, in seconds, since the last time the end user was actively authenticated by Okta.
///
/// [display] - 	The display parameter to be passed to the Social Identity Provider when performing Social Login.
///
/// [sessionToken] - Specify an Okta sessionToken to skip reauthentication when the user already authenticated using the Authentication Flow.
@JS()
@anonymous
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

/// Superclass for [AccessToken], [IDToken], and [RefreshToken]
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
  external UserClaims claims;
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
  external UserClaims claims;
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

@JS()
class UserClaims {
  @JS('auth_time')
  external String authTtime;
  external String aud;
  external String email;
  @JS('email_verified')
  external String emailVerified;
  external String exp;
  @JS('family_name')
  external String familyName;
  @JS('given_name')
  external String givenName;
  external String iat;
  external String iss;
  external String jti;
  external String locale;
  external String name;
  external String nonce;
  @JS('preferred_username')
  external String preferredUsername;
  external String sub;
  @JS('updated_at')
  external String updatedAt;
  external String ver;
  external String zoneinfo;
  @JS('at_hash')
  external String atHash;
  external String acr;
}
