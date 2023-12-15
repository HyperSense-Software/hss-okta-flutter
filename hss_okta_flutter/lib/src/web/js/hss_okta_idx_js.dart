@JS()
library hss_okta_js;

import 'dart:js';

import 'package:js/js.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

@JS()
class IdxAPI {
  // // lowest level api
  // interact: (options?: InteractOptions) => Promise<InteractResponse>;
  // introspect: (options?: IntrospectOptions) => Promise<IdxResponse>;
  // makeIdxResponse: (rawIdxResponse: RawIdxResponse, toPersist: IdxToPersist, requestDidSucceed: boolean) => IdxResponse;

  external Future<IdxTransaction> authenticate(AuthenticationOptions? options);

  external Future<IdxTransaction> proceed(ProceedOptions? options);

  external Future<IdxTransaction> cancel(IdxOption? options);

  external Future<IdxTransaction> start(StartOptions? options);
  // external Future<IdxTransaction> register(
  //   RegistrationOptions? options,
  // );
  // external Future<IdxTransaction> recoverPassword(
  //   PasswordRecoveryOptions? options,
  // );
  // external Future<IdxTransaction> unlockAccount(
  //   AccountUnlockOptions? options,
  // );
  // external Future<IdxTransaction> poll(
  //   IdxPollOptions? options,
  // );

  // // flow entrypoints
  // authenticate: (options?: AuthenticationOptions) => Promise<IdxTransaction>;
  // register: (options?: RegistrationOptions) => Promise<IdxTransaction>;
  // recoverPassword: (options?: PasswordRecoveryOptions) => Promise<IdxTransaction>;
  // unlockAccount: (options?: AccountUnlockOptions) => Promise<IdxTransaction>;
  // poll: (options?: IdxPollOptions) => Promise<IdxTransaction>;

  // // flow control
  // start: (options?: StartOptions) => Promise<IdxTransaction>;
  // canProceed(options?: ProceedOptions): boolean;
  // cancel: (options?: CancelOptions) => Promise<IdxTransaction>;
  // getFlow(): FlowIdentifier | undefined;
  // setFlow(flow: FlowIdentifier): void;

  // // call `start` instead of `startTransaction`. `startTransaction` will be removed in next major version (7.0)
  // startTransaction: (options?: StartOptions) => Promise<IdxTransaction>;

  // // redirect callbacks
  // isInteractionRequired: (hashOrSearch?: string) => boolean;
  // isInteractionRequiredError: (error: Error) => boolean;
  // handleInteractionCodeRedirect: (url: string) => Promise<void>;
  // isEmailVerifyCallback: (search: string) => boolean;
  // parseEmailVerifyCallback: (search: string) => EmailVerifyCallbackResponse;
  // handleEmailVerifyCallback: (search: string) => Promise<IdxTransaction | undefined>;
  // isEmailVerifyCallbackError: (error: Error) => boolean;

  // // transaction meta
  // getSavedTransactionMeta: (options?: IdxTransactionMetaOptions) => IdxTransactionMeta | undefined;
  // createTransactionMeta: (options?: IdxTransactionMetaOptions) => Promise<IdxTransactionMeta>;
  // getTransactionMeta: (options?: IdxTransactionMetaOptions) => Promise<IdxTransactionMeta>;
  // saveTransactionMeta: (meta: unknown) => void;
  // clearTransactionMeta: () => void;
  // isTransactionMetaValid: (meta: unknown) => boolean;
}

@JS()
@anonymous
class IdxTransaction {
  external Tokens? get tokens;
  external String get status;
  external String? get interactionCode;
  external bool? get requestDidSucceed;
  external bool? get stepUp;
  external List<IdxMessage>? get messages;
  external List<IdxRemediation>? get neededToProceed;
  external IdxTransactionMeta? get meta;
  external List<String>? get enabledFeatures;
  external NextStep? get nextStep;
  external APIError? get error;
  external RawIdxResponse? get rawIdxState;
  external JsObject? get actions;
  external IdxContext? get context;
  external Future<IdxResponse> proceed(
    String remediationName,
    dynamic params,
  );
}

@JS()
@anonymous
class IdxTransactionMeta {
  external String? get interactionHandle;
  external List<String>? get remediations;

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
  ///   | 'unlockAccount';
  external String? get flow;
  external bool? get withCredentials;
  external String? get activationToken;
  external String? get recoveryToken;
  external String? get maxAge;
  external String? get acrValues;
}

@JS()
@anonymous
class IdxContext {
  external String get version;
  external String get stateHandle;
  external String get expiresAt;
  external String get intent;
  external CurrentAuthenticator? get currentAuthenticator;
  external CurrentAuthenticatorEnrollment? get currentAuthenticatorEnrollment;
  external Authenticators? get authenticators;
  external AuthenticatorEnrollments? get authenticatorEnrollments;
  external EnrollmentAuthenticator get enrollmentAuthenticator;

  external UserAuthenticator? get user;
  external IdxContextUIDisplay? get uiDisplay;
  external IdxAuthenticationApp? get app;
  external IdxMessages? get messages;
  external IdxRemediation? get success;
  external IdxRemediation? get failure;
}

@JS()
@anonymous
class EnrollmentAuthenticator {
  external String get type;
  external IdxAuthenticator get value;
}

@JS()
@anonymous
class CurrentAuthenticator {
  external String get type;
  external IdxAuthenticator get value;
}

@JS()
@anonymous
class CurrentAuthenticatorEnrollment {
  external String get type;
  external IdxAuthenticator get value;
}

@JS()
@anonymous
class Authenticators {
  external String get type;
  external List<IdxAuthenticator> get authenticators;
}

@JS()
@anonymous
class AuthenticatorEnrollments {
  external String get type;
  external List<IdxAuthenticator> get authenticators;
}

@JS()
@anonymous
class UserAuthenticator {
  external String get type;
  external JsObject get value;
}

@JS()
@anonymous
class IdxContextUIDisplay {
  external String get type;
  external IdxContextUIDisplayValue get value;
}

@JS()
@anonymous
class IdxContextUIDisplayValue {
  external String? get label;
  external String? get buttonLabel;
}

@JS()
@anonymous
class IdxAuthenticationApp {
  external String get type;
  external JsObject get value;
}

@JS()
@anonymous
class IdxMessages {
  external JsObject get type;
  external List<IdxMessage> get value;
}

@JS()
@anonymous
class IdxMessage {
  external String get message;
  @JS('class')
  external String get className;
  external IdxMessageI18n get i18n;
}

@JS()
@anonymous
class IdxMessageI18n {
  external String get key;
  external List<String>? get params;
}

@JS()
@anonymous
class IdxRemediation {
  external String get name;
  external String? get label;
  external List<IdxRemediationValue>? get value;
  external IdxRemediationRelatesTo? get relatesTo;
  external IdpConfig? get idp;
  external String? get href;
  external String? get method;
  external String? get type;
  external String? get accepts;
  external String? get produces;
  external num? get refresh;
  external List<String>? get rel;
  external Future<IdxResponse> action(JsObject? params);
}

@JS()
@anonymous
class IdxRemediationValue {
  external String get name;
  external String? get label;
  external String? get type;
  external bool? get required;
  external bool? get secret;
  external bool? get visible;
  external bool? get mutable;
  external dynamic get value;
  external IdxForm? get form;
  external List<IdxOption>? get options;
  external IdxMessages? get messages;
  external num? get minLength;
  external num? get maxLength;
  external IdxRemediationRelatesTo? get relatesTo;
}

@JS()
@anonymous
class IdxForm {
  external List<IdxRemediationValue> get value;
}

@JS()
@anonymous
class IdxOption {
  external dynamic get value;
  external String? get label;
  external IdxAuthenticator? get relatesTo;
}

@JS()
@anonymous
class IdxOptions {
  external factory IdxOptions(
      {dynamic flow,
      bool? exchangeCodeForTokens,
      bool? autoRemediate,
      String? step,
      bool? withCredentials});
}

@JS()
@anonymous
class StartOptions {
  external factory StartOptions({
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
  });
}

@JS()
@anonymous
class IdxRemediationRelatesTo {
  external String? get type;
  external IdxAuthenticator? get value;
}

@JS()
@anonymous
class NextStep {
  external String? get name;
  external bool? canSkip;
  external bool? canResend;
  external List<Input>? get inputs;
  external IdxAuthenticator? get authenticator;
  external List<IdxAuthenticator>? get authenticatorEnrollments;
  external IdxPollOptions? get poll;
  external Future<IdxTransaction> action(JsObject? params);
  external IdpConfig? get idp;
  external String? get href;
  external NextStepRelatesTo? get relatesTo;
  external num? get refresh;
}

@JS()
@anonymous
class IdpConfig {
  external String? get id;
  external String? get name;
}

@JS()
@anonymous
class NextStepRelatesTo {
  external String? get type;
  external IdxAuthenticator? get value;
}

@JS()
@anonymous
class IdxPollOptions {
  external bool? required;
  external num? refresh;
}

@JS()
@anonymous
class Input {
  external String? get name;
  external String? get label;
  external String? get type;
  external String? get secret;
  external String? get required;
  external JsObject get value;
  external num? get minLength;
  external num? get maxLength;
  external List<IdxOption>? get options;
  external bool? get mutable;
  external bool? get visible;
  external bool? get customLabel;
}

@JS()
@anonymous
class IdxAuthenticator {
  external String get displayName;
  external String get id;
  external String get key;
  external List<IdxAuthenticatorMethod> get methods;
  external String get type;
  external IdxAuthenticatorSettings? get settings;
  external ContextualData? get contextualData;
  external String? get credentialId;
  external String? get enrollmentId;
  external JsObject? get profile;
  external JsObject? get resend;
  external JsObject? get poll;
  external JsObject? get recover;
  external bool? get deviceKnown;
}

@JS()
@anonymous
class ContextualData {
  external IdxAuthenticatorSettingsEnrolledQuestion? get enrolledQuestion;
  external IdxAuthenticatorSettingsQrcode? get qrcode;
  external String? get sharedSecret;
  external List<IdxAuthenticatorSettingsEnrolledQuestion>? get questions;
  external List<String>? get questionKeys;
  external String? get selectedChannel;
  external ActivationData? get activationData;
  external ChallengeData? get challengeData;
}

@JS()
@anonymous
class IdxAuthenticatorSettings {
  external dynamic? get complexity;
  external dynamic? get age;
}

@JS()
@anonymous
class IdxAuthenticatorSettingsEnrolledQuestion {
  external String get question;
  external String get questionKey;
}

@JS()
@anonymous
class IdxAuthenticatorSettingsQrcode {
  external String get href;
  external String get method;
  external String get type;
}

@JS()
@anonymous
class ActivationData {
  external String get challenge;
  external ActivationDataRp get rp;
  external ActivationDataUser get user;
  external List<PubKeyCredParams> get pubKeyCredParams;
  external String? get attestation;
  external AuthenticatorSelection? get authenticatorSelection;
  external List<ExcludeCredentials>? get excludeCredentials;
}

@JS()
@anonymous
class ChallengeData {
  external String get challenge;
  external String get userVerification;
  external ChallengeDataExtension? get extensions;
}

@JS()
@anonymous
class ChallengeDataExtension {
  external String get appid;
}

@JS()
@anonymous
class ExcludeCredentials {
  external String get id;
  external String get type;
}

@JS()
@anonymous
class AuthenticatorSelection {
  external String? get authenticatorAttachment;
  external bool? get requireResidentKey;
  external String? get userVerification;
  external String? get residentKey;
}

@JS()
@anonymous
class ActivationDataRp {
  external String get name;
}

@JS()
@anonymous
class ActivationDataUser {
  external String get id;
  external String get name;
  external String get displayName;
}

@JS()
@anonymous
class PubKeyCredParams {
  external String get type;
  external num get alg;
}

@JS()
@anonymous
class IdxAuthenticatorMethod {
  external String get type;
}

@JS()
@anonymous
class IdxResponse {
  external Future<IdxResponse> proceed(
    String remediationName,
    dynamic params,
  );

  external List<IdxRemediation>? get neededToProceed;
  external RawIdxResponse? get rawIdxState;
  external dynamic get actions;
  external IdxContext? get context;
  external String? get interactionCode;
  external IdxToPersist get toPersist;
  external bool? get requestDidSucceed;
  external bool? get stepUp;
}

@JS()
@anonymous
class IdxToPersist {
  external String? get interactionHandle;
  external bool? withCredentials;
}

@JS()
@anonymous
class RawIdxResponse {
  external String get version;
  external String get stateHandle;
  external String get expiresAt;
  external String get intent;
  external IdxRemediationResponse get remediation;
  external CurrentAuthenticator? get currentAuthenticator;
  external CurrentAuthenticatorEnrollment? get currentAuthenticatorEnrollment;
  external Authenticators? get authenticators;
  external AuthenticatorEnrollments? get authenticatorEnrollments;
  external EnrollmentAuthenticator get enrollmentAuthenticator;

  external UserAuthenticator? get user;
  external IdxContextUIDisplay? get uiDisplay;
  external IdxAuthenticationApp? get app;
  external IdxMessages? get messages;
  external IdxRemediation? get success;
  external IdxRemediation? get failure;
}

@JS()
@anonymous
class IdxRemediationResponse {
  external String get type;
  external List<IdxRemediation> get value;
}

@JS()
@anonymous
class AuthenticationOptions {
  external factory AuthenticationOptions({
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
  });
}

@JS()
@anonymous
class ProceedOptions {
  external factory ProceedOptions({
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
  });
}
