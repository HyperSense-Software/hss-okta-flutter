import 'generated/hss_okta_flutter.g.dart';
import 'hss_okta_platform_interface.dart';

class HssOktaFlutterChannel extends HssOktaFlutterPlatformInterface {
  final _api = HssOktaFlutterPluginApi();

  @override
  Future<AuthenticationResult> startDirectAuthenticationFlow(
      DirectAuthRequest request) async {
    var res = await _api.startDirectAuthenticationFlow(request);
    if (res == null) throw Exception("Null result from signInWithCredentials");
    return res;
  }

  @override
  Future<bool> revokeDefaultToken() async {
    var res = await _api.revokeDefaultToken();
    if (res == null) throw Exception("Null result from revokeDefaultToken");
    return res;
  }

  @override
  Future<bool> refreshDefaultToken() async {
    var res = await _api.refreshDefaultToken();
    if (res == null) throw Exception("Null result from refreshDefaultToken");
    return res;
  }

  @override
  Future<AuthenticationResult?> getCredential() async {
    var res = await _api.getCredential();
    return res;
  }

  @override
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
      String otp) async {
    var res = await _api.continueDirectAuthenticationMfaFlow(otp);
    if (res == null) {
      throw Exception("Null result from mfaOtpSignInWithCredentials");
    }

    return res;
  }

  @override
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    var res = await _api.startDeviceAuthorizationFlow();
    if (res == null) {
      throw Exception("Null result from startDeviceAuthorizationFlow");
    }

    return res;
  }

  @override
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    var res = await _api.resumeDeviceAuthorizationFlow();

    return res;
  }

  @override
  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) async {
    var res = await _api.startTokenExchangeFlow(deviceSecret, idToken);

    return res;
  }

  @override
  Future<List<String?>> getAllUserIds() async {
    return await _api.getAllUserIds();
  }

  @override
  Future<AuthenticationResult?> getToken(String tokenId) async {
    return await _api.getToken(tokenId);
  }

  @override
  Future<bool> removeCredential(String tokenId) async {
    return await _api.removeCredential(tokenId);
  }

  @override
  Future<bool> setDefaultToken(String tokenId) async {
    return await _api.setDefaultToken(tokenId);
  }

  @override
  Future<IdxResponse?> startEmailAuthenticationFlow(String email) async {
    return await _api.startEmailAuthenticationFlow(email);
  }

  @override
  Future<OktaToken?> continueWithPassword(String password) async {
    return await _api.continueWithPassword(password);
  }

  @override
  Future<bool> startSMSPhoneEnrollment(String phoneNumber) async {
    return await _api.startSMSPhoneEnrollment(phoneNumber);
  }

  @override
  Future<bool> continueSMSPhoneEnrollment(String passcode) {
    return _api.continueSMSPhoneEnrollment(passcode);
  }

  @override
  Future<bool> startUserEnrollmentFlow({
    required String firstName,
    required String lastName,
    required String email,
  }) {
    return _api.startUserEnrollmentFlow(
        firstName: firstName, lastName: lastName, email: email);
  }

  @override
  Future<IdxResponse> recoverPassword(String identifier) {
    return _api.recoverPassword(identifier);
  }

  @override
  Future<IdxResponse?> getIdxResponse() {
    return _api.getIdxResponse();
  }
}
