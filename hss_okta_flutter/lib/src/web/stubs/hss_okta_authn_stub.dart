typedef AuthnTransactionFunction = Future<AuthnTransaction> Function(
    dynamic obj)=> throw UnimplementedError();

class AuthnTransactionState {
   String get status=> throw UnimplementedError();
   String? get stateToken=> throw UnimplementedError();
   String? get type=> throw UnimplementedError();
   String? get expiresAt=> throw UnimplementedError();
   String? get relayState=> throw UnimplementedError();
   String? get factoryResult=> throw UnimplementedError();
   String? get recoveryToken=> throw UnimplementedError();
   String? get recoveryType=> throw UnimplementedError();
   bool get autoPush=> throw UnimplementedError();
   bool get rememberDevice=> throw UnimplementedError();
   dynamic get profile=> throw UnimplementedError();
}

class AuthnTransaction extends AuthnTransactionState {
   String? sessionToken=> throw UnimplementedError();
}

class AuthTransactionAPI {
  bool exists() => throw UnimplementedError();
  Future status(dynamic args) => throw UnimplementedError();
  Future resume(dynamic args) => throw UnimplementedError();
  Future<AuthnTransaction> introspect(dynamic args) =>
      throw UnimplementedError();
  AuthnTransaction createTransaction(AuthnTransactionState? res) =>
      throw UnimplementedError();
}

class SigninOptions {
   factory SigninOptions({String? username, String? password})=> throw UnimplementedError();
}

class SigninWithCredentialsOptions {
   factory SigninWithCredentialsOptions({
    required String username,
    required String password,
  })=> throw UnimplementedError();
}

class AuthApiError {
   String get errorSummary=> throw UnimplementedError();
   String get errorCode=> throw UnimplementedError();
   String get errorLink=> throw UnimplementedError();
   String get errorId=> throw UnimplementedError();
   String get errorCauses=> throw UnimplementedError();
   String get message=> throw UnimplementedError();
}
