@JS()
library hss_okta_js;

import 'dart:js';

import 'package:js/js.dart';

@JS()
@anonymous
class FieldError {
  external String get errorSummary;
  external String? get reason;
  external String? get location;
  external String? get locationType;
  external String? get domain;
}

@JS()
@anonymous
class APIError {
  external String get errorSummary;
  external String? get errorCode;
  external String? get errorLink;
  external String? get errorId;
  external List<FieldError>? get errorCauses;
}
