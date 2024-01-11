typedef AuthnTransactionFunction = Future<AuthnTransaction> Function(
    dynamic obj);

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
  external dynamic get profile;
}

class AuthnTransaction extends AuthnTransactionState {
  external String? sessionToken;
}

class AuthTransactionAPI {
  external bool exists();
  external Future status(dynamic args);
  external Future resume(dynamic args);
  external Future<AuthnTransaction> introspect(dynamic args);
  external AuthnTransaction createTransaction(AuthnTransactionState? res);
}

class SigninOptions {
  external factory SigninOptions({String? username, String? password});
}

class SigninWithCredentialsOptions {
  external factory SigninWithCredentialsOptions({
    required String username,
    required String password,
  });
}

class AuthApiError {
  external String get errorSummary;
  external String get errorCode;
  external String get errorLink;
  external String get errorId;
  external String get errorCauses;
  external String get message;
}
