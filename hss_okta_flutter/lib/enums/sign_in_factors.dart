/// Used to determine which factor to use for MFA in [DirectAuthentication]
enum OktaSignInFactor {
  otp('otp'),
  oob('oob');

  final String factor;
  const OktaSignInFactor(this.factor);
}
