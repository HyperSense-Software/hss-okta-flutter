/// {@template okta_sign_in_factor}
/// Factors for the Direct Authentication Flow
/// {@endtemplate}
enum OktaSignInFactor {
  /// One time password
  otp('otp'),

  /// Out of band
  oob('oob');

  /// {@macro okta_sign_in_factor}
  const OktaSignInFactor(this.factor);

  /// factor name for iOS
  final String factor;
}
