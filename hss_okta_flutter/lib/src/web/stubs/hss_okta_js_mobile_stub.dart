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
  Future<bool?> signOut() => throw UnimplementedError();

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

import 'package:js/js.dart'=> throw UnimplementedError();
import 'package:hss_okta_flutter/hss_okta_flutter.dart'=> throw UnimplementedError();

class IdxAPI {
  // // lowest level api
  // interact: (options?: InteractOptions) => Promise<InteractResponse>=> throw UnimplementedError();
  // introspect: (options?: IntrospectOptions) => Promise<IdxResponse>=> throw UnimplementedError();
  // makeIdxResponse: (rawIdxResponse: RawIdxResponse, toPersist: IdxToPersist, requestDidSucceed: boolean) => IdxResponse=> throw UnimplementedError();

   Future<IdxTransaction> authenticate([
    AuthenticationOptions? options,
  ])=> throw UnimplementedError();

   Future<IdxTransaction> proceed(ProceedOptions? options)=> throw UnimplementedError();

   Future<IdxTransaction> cancel(IdxOption? options)=> throw UnimplementedError();

   Future<IdxTransaction> start(StartOptions? options)=> throw UnimplementedError();
  //  Future<IdxTransaction> register(
  //   RegistrationOptions? options,
  // )=> throw UnimplementedError();
  //  Future<IdxTransaction> recoverPassword(
  //   PasswordRecoveryOptions? options,
  // )=> throw UnimplementedError();
  //  Future<IdxTransaction> unlockAccount(
  //   AccountUnlockOptions? options,
  // )=> throw UnimplementedError();
  //  Future<IdxTransaction> poll(
  //   IdxPollOptions? options,
  // )=> throw UnimplementedError();

  // // flow entrypoints
  // authenticate: (options?: AuthenticationOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // register: (options?: RegistrationOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // recoverPassword: (options?: PasswordRecoveryOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // unlockAccount: (options?: AccountUnlockOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // poll: (options?: IdxPollOptions) => Promise<IdxTransaction>=> throw UnimplementedError();

  // // flow control
  // start: (options?: StartOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // canProceed(options?: ProceedOptions): boolean=> throw UnimplementedError();
  // cancel: (options?: CancelOptions) => Promise<IdxTransaction>=> throw UnimplementedError();
  // getFlow(): FlowIdentifier | undefined=> throw UnimplementedError();
  // setFlow(flow: FlowIdentifier): void=> throw UnimplementedError();

  // // call `start` instead of `startTransaction`. `startTransaction` will be removed in next major version (7.0)
  // startTransaction: (options?: StartOptions) => Promise<IdxTransaction>=> throw UnimplementedError();

  // // redirect callbacks
  // isInteractionRequired: (hashOrSearch?: string) => boolean=> throw UnimplementedError();
  // isInteractionRequiredError: (error: Error) => boolean=> throw UnimplementedError();
  // handleInteractionCodeRedirect: (url: string) => Promise<void>=> throw UnimplementedError();
  // isEmailVerifyCallback: (search: string) => boolean=> throw UnimplementedError();
  // parseEmailVerifyCallback: (search: string) => EmailVerifyCallbackResponse=> throw UnimplementedError();
  // handleEmailVerifyCallback: (search: string) => Promise<IdxTransaction | undefined>=> throw UnimplementedError();
  // isEmailVerifyCallbackError: (error: Error) => boolean=> throw UnimplementedError();

  // // transaction meta
  // getSavedTransactionMeta: (options?: IdxTransactionMetaOptions) => IdxTransactionMeta | undefined=> throw UnimplementedError();
  // createTransactionMeta: (options?: IdxTransactionMetaOptions) => Promise<IdxTransactionMeta>=> throw UnimplementedError();
  // getTransactionMeta: (options?: IdxTransactionMetaOptions) => Promise<IdxTransactionMeta>=> throw UnimplementedError();
  // saveTransactionMeta: (meta: unknown) => void=> throw UnimplementedError();
  // clearTransactionMeta: () => void=> throw UnimplementedError();
  // isTransactionMetaValid: (meta: unknown) => boolean=> throw UnimplementedError();
}

class IdxTransaction {
   Tokens? get tokens=> throw UnimplementedError();
   String get status=> throw UnimplementedError();
   String? get interactionCode=> throw UnimplementedError();
   bool? get requestDidSucceed=> throw UnimplementedError();
   bool? get stepUp=> throw UnimplementedError();
   List<IdxMessage>? get messages=> throw UnimplementedError();
   List<IdxRemediation>? get neededToProceed=> throw UnimplementedError();
   IdxTransactionMeta? get meta=> throw UnimplementedError();
   List<String>? get enabledFeatures=> throw UnimplementedError();
   NextStep? get nextStep=> throw UnimplementedError();
   APIError? get error=> throw UnimplementedError();
   RawIdxResponse? get rawIdxState=> throw UnimplementedError();
   JsObject? get actions=> throw UnimplementedError();
   IdxContext? get context=> throw UnimplementedError();
   Future<IdxResponse> proceed(
    String remediationName,
    dynamic params,
  )=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxTransactionMeta {
   String? get interactionHandle=> throw UnimplementedError();
   List<String>? get remediations=> throw UnimplementedError();

  /// 'default'
  ///   | 'proceed'
  ///   // idx.authenticate
  ///   | 'authenticate'
  ///   | 'login'
  ///   | 'signin'
  ///   // idx.register
  ///   | 'register'
  ///   | 'signup'
  ///   | 'enrollProfile'
  ///   // idx.recoverPassword
  ///   | 'recoverPassword'
  ///   | 'resetPassword'
  ///   // idx.unlockAccount
  ///   | 'unlockAccount'=> throw UnimplementedError();
   String? get flow=> throw UnimplementedError();
   bool? get withCredentials=> throw UnimplementedError();
   String? get activationToken=> throw UnimplementedError();
   String? get recoveryToken=> throw UnimplementedError();
   String? get maxAge=> throw UnimplementedError();
   String? get acrValues=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxContext {
   String get version=> throw UnimplementedError();
   String get stateHandle=> throw UnimplementedError();
   String get expiresAt=> throw UnimplementedError();
   String get intent=> throw UnimplementedError();
   CurrentAuthenticator? get currentAuthenticator=> throw UnimplementedError();
   CurrentAuthenticatorEnrollment? get currentAuthenticatorEnrollment=> throw UnimplementedError();
   Authenticators? get authenticators=> throw UnimplementedError();
   AuthenticatorEnrollments? get authenticatorEnrollments=> throw UnimplementedError();
   EnrollmentAuthenticator get enrollmentAuthenticator=> throw UnimplementedError();

   UserAuthenticator? get user=> throw UnimplementedError();
   IdxContextUIDisplay? get uiDisplay=> throw UnimplementedError();
   IdxAuthenticationApp? get app=> throw UnimplementedError();
   IdxMessages? get messages=> throw UnimplementedError();
   IdxRemediation? get success=> throw UnimplementedError();
   IdxRemediation? get failure=> throw UnimplementedError();
}

@JS()
@anonymous
class EnrollmentAuthenticator {
   String get type=> throw UnimplementedError();
   IdxAuthenticator get value=> throw UnimplementedError();
}

@JS()
@anonymous
class CurrentAuthenticator {
   String get type=> throw UnimplementedError();
   IdxAuthenticator get value=> throw UnimplementedError();
}

@JS()
@anonymous
class CurrentAuthenticatorEnrollment {
   String get type=> throw UnimplementedError();
   IdxAuthenticator get value=> throw UnimplementedError();
}

@JS()
@anonymous
class Authenticators {
   String get type=> throw UnimplementedError();
   List<IdxAuthenticator> get authenticators=> throw UnimplementedError();
}

@JS()
@anonymous
class AuthenticatorEnrollments {
   String get type=> throw UnimplementedError();
   List<IdxAuthenticator> get authenticators=> throw UnimplementedError();
}

@JS()
@anonymous
class UserAuthenticator {
   String get type=> throw UnimplementedError();
   JsObject get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxContextUIDisplay {
   String get type=> throw UnimplementedError();
   IdxContextUIDisplayValue get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxContextUIDisplayValue {
   String? get label=> throw UnimplementedError();
   String? get buttonLabel=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticationApp {
   String get type=> throw UnimplementedError();
   JsObject get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxMessages {
   JsObject get type=> throw UnimplementedError();
   List<IdxMessage> get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxMessage {
   String get message=> throw UnimplementedError();
  @JS('class')
   String get className=> throw UnimplementedError();
   IdxMessageI18n get i18n=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxMessageI18n {
   String get key=> throw UnimplementedError();
   List<String>? get params=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxRemediation {
   String get name=> throw UnimplementedError();
   String? get label=> throw UnimplementedError();
   List<IdxRemediationValue>? get value=> throw UnimplementedError();
   IdxRemediationRelatesTo? get relatesTo=> throw UnimplementedError();
   IdpConfig? get idp=> throw UnimplementedError();
   String? get href=> throw UnimplementedError();
   String? get method=> throw UnimplementedError();
   String? get type=> throw UnimplementedError();
   String? get accepts=> throw UnimplementedError();
   String? get produces=> throw UnimplementedError();
   num? get refresh=> throw UnimplementedError();
   List<String>? get rel=> throw UnimplementedError();
   Future<IdxResponse> action(JsObject? params)=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxRemediationValue {
   String get name=> throw UnimplementedError();
   String? get label=> throw UnimplementedError();
   String? get type=> throw UnimplementedError();
   bool? get required=> throw UnimplementedError();
   bool? get secret=> throw UnimplementedError();
   bool? get visible=> throw UnimplementedError();
   bool? get mutable=> throw UnimplementedError();
   dynamic get value=> throw UnimplementedError();
   IdxForm? get form=> throw UnimplementedError();
   List<IdxOption>? get options=> throw UnimplementedError();
   IdxMessages? get messages=> throw UnimplementedError();
   num? get minLength=> throw UnimplementedError();
   num? get maxLength=> throw UnimplementedError();
   IdxRemediationRelatesTo? get relatesTo=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxForm {
   List<IdxRemediationValue> get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxOption {
   dynamic get value=> throw UnimplementedError();
   String? get label=> throw UnimplementedError();
   IdxAuthenticator? get relatesTo=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxOptions {
   factory IdxOptions({
      dynamic flow,
      bool? exchangeCodeForTokens,
      bool? autoRemediate,
      String? step,
      bool? withCredentials
    }) 
}

@JS()
@anonymous
class StartOptions{
   factory StartOptions({
    String? interactionHandle,
    bool? withCredentials,
    String? stateHandle,
    String? version,
    String? codeChallenge,
    String? codeChallengeMethod,
    String? state,
    String? nonce,
    List<String>? scopes,
    String? clientSecret,
    num? maxAge,
    String? acrValues,
    dynamic actions,
    dynamic remediators,
    bool? useGenericRemidator,
  })=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxRemediationRelatesTo {
   String? get type=> throw UnimplementedError();
   IdxAuthenticator? get value=> throw UnimplementedError();
}

@JS()
@anonymous
class NextStep {
   String? get name=> throw UnimplementedError();
   bool? canSkip=> throw UnimplementedError();
   bool? canResend=> throw UnimplementedError();
   List<Input>? get inputs=> throw UnimplementedError();
   IdxAuthenticator? get authenticator=> throw UnimplementedError();
   List<IdxAuthenticator>? get authenticatorEnrollments=> throw UnimplementedError();
   IdxPollOptions? get poll=> throw UnimplementedError();
   Future<IdxTransaction> action(JsObject? params)=> throw UnimplementedError();
   IdpConfig? get idp=> throw UnimplementedError();
   String? get href=> throw UnimplementedError();
   NextStepRelatesTo? get relatesTo=> throw UnimplementedError();
   num? get refresh=> throw UnimplementedError();
}

@JS()
@anonymous
class IdpConfig {
   String? get id=> throw UnimplementedError();
   String? get name=> throw UnimplementedError();
}

@JS()
@anonymous
class NextStepRelatesTo {
   String? get type=> throw UnimplementedError();
   IdxAuthenticator? get value=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxPollOptions {
   bool? required=> throw UnimplementedError();
   num? refresh=> throw UnimplementedError();
}

@JS()
@anonymous
class Input {
   String? get name=> throw UnimplementedError();
   String? get label=> throw UnimplementedError();
   String? get type=> throw UnimplementedError();
   String? get secret=> throw UnimplementedError();
   String? get required=> throw UnimplementedError();
   JsObject get value=> throw UnimplementedError();
   num? get minLength=> throw UnimplementedError();
   num? get maxLength=> throw UnimplementedError();
   List<IdxOption>? get options=> throw UnimplementedError();
   bool? get mutable=> throw UnimplementedError();
   bool? get visible=> throw UnimplementedError();
   bool? get customLabel=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticator {
   String get displayName=> throw UnimplementedError();
   String get id=> throw UnimplementedError();
   String get key=> throw UnimplementedError();
   List<IdxAuthenticatorMethod> get methods=> throw UnimplementedError();
   String get type=> throw UnimplementedError();
   IdxAuthenticatorSettings? get settings=> throw UnimplementedError();
   ContextualData? get contextualData=> throw UnimplementedError();
   String? get credentialId=> throw UnimplementedError();
   String? get enrollmentId=> throw UnimplementedError();
   JsObject? get profile=> throw UnimplementedError();
   JsObject? get resend=> throw UnimplementedError();
   JsObject? get poll=> throw UnimplementedError();
   JsObject? get recover=> throw UnimplementedError();
   bool? get deviceKnown=> throw UnimplementedError();
}

@JS()
@anonymous
class ContextualData {
   IdxAuthenticatorSettingsEnrolledQuestion? get enrolledQuestion=> throw UnimplementedError();
   IdxAuthenticatorSettingsQrcode? get qrcode=> throw UnimplementedError();
   String? get sharedSecret=> throw UnimplementedError();
   List<IdxAuthenticatorSettingsEnrolledQuestion>? get questions=> throw UnimplementedError();
   List<String>? get questionKeys=> throw UnimplementedError();
   String? get selectedChannel=> throw UnimplementedError();
   ActivationData? get activationData=> throw UnimplementedError();
   ChallengeData? get challengeData=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticatorSettings {
   dynamic? get complexity=> throw UnimplementedError();
   dynamic? get age=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticatorSettingsEnrolledQuestion {
   String get question=> throw UnimplementedError();
   String get questionKey=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticatorSettingsQrcode {
   String get href=> throw UnimplementedError();
   String get method=> throw UnimplementedError();
   String get type=> throw UnimplementedError();
}

@JS()
@anonymous
class ActivationData {
   String get challenge=> throw UnimplementedError();
   ActivationDataRp get rp=> throw UnimplementedError();
   ActivationDataUser get user=> throw UnimplementedError();
   List<PubKeyCredParams> get pubKeyCredParams=> throw UnimplementedError();
   String? get attestation=> throw UnimplementedError();
   AuthenticatorSelection? get authenticatorSelection=> throw UnimplementedError();
   List<ExcludeCredentials>? get excludeCredentials=> throw UnimplementedError();
}

@JS()
@anonymous
class ChallengeData {
   String get challenge=> throw UnimplementedError();
   String get userVerification=> throw UnimplementedError();
   ChallengeDataExtension? get extensions=> throw UnimplementedError();
}

@JS()
@anonymous
class ChallengeDataExtension {
   String get appid=> throw UnimplementedError();
}

@JS()
@anonymous
class ExcludeCredentials {
   String get id=> throw UnimplementedError();
   String get type=> throw UnimplementedError();
}

@JS()
@anonymous
class AuthenticatorSelection {
   String? get authenticatorAttachment=> throw UnimplementedError();
   bool? get requireResidentKey=> throw UnimplementedError();
   String? get userVerification=> throw UnimplementedError();
   String? get residentKey=> throw UnimplementedError();
}

@JS()
@anonymous
class ActivationDataRp {
   String get name=> throw UnimplementedError();
}

@JS()
@anonymous
class ActivationDataUser {
   String get id=> throw UnimplementedError();
   String get name=> throw UnimplementedError();
   String get displayName=> throw UnimplementedError();
}

@JS()
@anonymous
class PubKeyCredParams {
   String get type=> throw UnimplementedError();
   num get alg=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxAuthenticatorMethod {
   String get type=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxResponse {
   Future<IdxResponse> proceed(
    String remediationName,
    dynamic params,
  )=> throw UnimplementedError();

   List<IdxRemediation>? get neededToProceed=> throw UnimplementedError();
   RawIdxResponse? get rawIdxState=> throw UnimplementedError();
   dynamic get actions=> throw UnimplementedError();
   IdxContext? get context=> throw UnimplementedError();
   String? get interactionCode=> throw UnimplementedError();
   IdxToPersist get toPersist=> throw UnimplementedError();
   bool? get requestDidSucceed=> throw UnimplementedError();
   bool? get stepUp=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxToPersist {
   String? get interactionHandle=> throw UnimplementedError();
   bool? withCredentials=> throw UnimplementedError();
}

@JS()
@anonymous
class RawIdxResponse {
   String get version=> throw UnimplementedError();
   String get stateHandle=> throw UnimplementedError();
   String get expiresAt=> throw UnimplementedError();
   String get intent=> throw UnimplementedError();
   IdxRemediationResponse get remediation=> throw UnimplementedError();
   CurrentAuthenticator? get currentAuthenticator=> throw UnimplementedError();
   CurrentAuthenticatorEnrollment? get currentAuthenticatorEnrollment=> throw UnimplementedError();
   Authenticators? get authenticators=> throw UnimplementedError();
   AuthenticatorEnrollments? get authenticatorEnrollments=> throw UnimplementedError();
   EnrollmentAuthenticator get enrollmentAuthenticator=> throw UnimplementedError();

   UserAuthenticator? get user=> throw UnimplementedError();
   IdxContextUIDisplay? get uiDisplay=> throw UnimplementedError();
   IdxAuthenticationApp? get app=> throw UnimplementedError();
   IdxMessages? get messages=> throw UnimplementedError();
   IdxRemediation? get success=> throw UnimplementedError();
   IdxRemediation? get failure=> throw UnimplementedError();
}

@JS()
@anonymous
class IdxRemediationResponse {
   String get type=> throw UnimplementedError();
   List<IdxRemediation> get value=> throw UnimplementedError();
}

@JS()
@anonymous
class AuthenticationOptions {
   factory AuthenticationOptions({
    String? username,
    String? password,
    String? newPassword,
    bool? rememberMe,
    String? state,
    String? stateHandle,
    List<String>? scopes,
    String? codeChallenge,
    String? codeChallengeMethod,
    String? activationToken,
    String? recoveryToken,
    String? clientSecret,
    num? maxAge,
    String? acrValues,
    String? nonce,
    String? interactionHandle,
    String? version,
    bool? exchangeCodeForTokens,
    bool? autoRemediate,
    bool? withCredentials,
    String? step,
    bool? useGenericRemediator,
    dynamic actions,

//   'default'
//   | 'proceed'
// // idx.authenticate
//   | 'authenticate'
//   | 'login'
//   | 'signin'
// // idx.register
//   | 'register'
//   | 'signup'
//   | 'enrollProfile'
// // idx.recoverPassword
//   | 'recoverPassword'
//   | 'resetPassword'
// // idx.unlockAccount
//   | 'unlockAccount'
    String? flow,
    dynamic remediators,
    List<String>? authenticators,
  })=> throw UnimplementedError();
}

@JS()
@anonymous
class ProceedOptions {
   factory ProceedOptions({
    String? username,
    String? password,
    String? newPassword,
    bool? rememberMe,
    String? state,
    String? stateHandle,
    List<String>? scopes,
    String? codeChallenge,
    String? codeChallengeMethod,
    String? activationToken,
    String? recoveryToken,
    String? clientSecret,
    num? maxAge,
    String? acrValues,
    String? nonce,
    String? interactionHandle,
    String? version,
    bool? exchangeCodeForTokens,
    bool? autoRemediate,
    bool? withCredentials,
    String? step,
    bool? useGenericRemediator,
    dynamic actions,
    bool? resend,
    List<Authenticators> authenticatorsData,
    String? flow,
    dynamic remediators,
    List<String>? authenticators,
  })=> throw UnimplementedError();
}
