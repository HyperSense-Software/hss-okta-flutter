enum OktaSignInFactor {
  otp('otp'),
  oob('oob');

  final String factor;
  const OktaSignInFactor(this.factor);
}
