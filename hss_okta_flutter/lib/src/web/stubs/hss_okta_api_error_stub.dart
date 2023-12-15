class FieldError {
  String get errorSummary => throw UnimplementedError();
  String? get reason => throw UnimplementedError();
  String? get location => throw UnimplementedError();
  String? get locationType => throw UnimplementedError();
  String? get domain => throw UnimplementedError();
}

class APIError {
  String get errorSummary => throw UnimplementedError();
  String? get errorCode => throw UnimplementedError();
  String? get errorLink => throw UnimplementedError();
  String? get errorId => throw UnimplementedError();
  List<FieldError>? get errorCauses => throw UnimplementedError();
}
