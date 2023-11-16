@JS()
library hss_okta_js;

// import 'package:js/js.dart';
import 'package:js/js.dart';

/// The Http Client used for all the Okta API calls
@JS('OktaAuth')
class OktaAuth {
  external factory OktaAuth(OktaConfig options);
  external Token get token;
  external TokenManager get tokenManager;
}

/// Used With [OktaAuth]'s Initializer
@JS()
@anonymous
class OktaConfig {
  external factory OktaConfig({
    String? issuer,
    String? clientId,
    String? redirectUri,
  });

  external String issuer;
  external String clientId;
  external String redirectUri;
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
  external Future renew(String tokenToRenew);

  ///Retrieve the details about a user.
  ///
  ///accessTokenObject - (optional) an access token returned by this library. Note: this is not the raw access token.
  ///idTokenObject - (optional) an ID token returned by this library. Note: this is not the raw ID token.
  ///
  ///By default, if no parameters are passed, both the access token and ID token objects will be retrieved from the TokenManager.
  /// It is assumed that the access token is stored using the key "accessToken" and the ID token is stored under the key "idToken".
  ///  If you have stored either token in a non-standard location, this logic can be skipped by passing the access and ID token objects directly.
  // external JSPromise getUserInfo(
  //     {JSObject? accessTokenObject, JSObject idTokenObject});
}

/// Class that manages tokens.
@JS()
class TokenManager {
  external Future<void> add(String key, Token token);
  external Future<Token> get(String key);
  external Future<Map<String, String>> getTokens();
  external Future<void> setTokens(Map<String, String> tokens);
  external Future<void> remove(String key);
  external Future<void> clear();
  external Future<void> renew(String key);
}

/// Options used in [OktaAuth.token.getWithPopup] and [OktaAuth.token.getWithRedirect]
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

/// Web API Response from [OktaAuth.token.getWithPopup] and [OktaAuth.token.getWithRedirect]
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

/// An Access Token containing the user's Access token and UserInformation URL
@JS()
@anonymous
class AccessToken {
  external factory AccessToken({
    String? accessToken,
    String? tokenType,
    String? userinfoUrl,
  });
  external String accessToken;
  external String tokenType;
  external String userinfoUrl;
}

/// An ID Token containing the user's ID token, issuer, and client ID
@JS()
class IDToken {
  external String idToken;
  external String issuer;
  external String clientId;
}
