@JS()
library hss_okta_js;

import 'dart:js';

import 'package:js/js.dart';

typedef AuthnTransactionFunction = Future<AuthnTransaction> Function(
    JsObject? obj);

@JS()
class AuthnTransactionState {
  external String get status;
  external String? get stateToken;
  external String? get type;
  external String? get expiresAt;
  external String? get relayState;
  external String? get factoryResult;
  external String? get recoveryToken;
  external String? get recoveryType;
  external bool get autoPush;
  external bool get rememberDevice;
  external JsObject? get profile;
}

@JS()
class AuthnTransaction extends AuthnTransactionState {
  external String? sessionToken;
}

@JS()
class AuthTransactionAPI {
  external bool exists();
  external Future<JsObject> status(JsObject? args);
  external Future<JsObject> resume(JsObject? args);
  external Future<AuthnTransaction> introspect(JsObject? args);
  external AuthnTransaction createTransaction(AuthnTransactionState? res);
  // external Future<AuthnTransaction> postToTransaction(
  //     String url, RequestData? args, RequestOption? options);
}

@JS()
@anonymous
class SigninOptions {
  external factory SigninOptions({String? username, String? password});
}

@JS()
@anonymous
class SigninWithCredentialsOptions {
  external factory SigninWithCredentialsOptions({
    required String username,
    required String password,
  });
}

@JS()
class AuthApiError {
  external String get errorSummary;
  external String get errorCode;
  external String get errorLink;
  external String get errorId;
  external String get errorCauses;
  external String get message;
}
