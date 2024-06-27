// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    input: 'pigeons/hss_okta_pigeon.dart',
    dartOut: 'lib/src/generated/hss_okta_flutter.g.dart',
    swiftOut: 'ios/Classes/HssOktaFlutterPlugin.g.swift',
    kotlinOut:
        'android/src/main/kotlin/dev/hypersense/software/hss_okta_flutter/HssOktaFlutterPluginApi.kt',
    kotlinOptions: KotlinOptions(
      package: "dev.hypersense.software.hss_okta",
    ),
  ),
)
enum AuthenticationType { browser, sso, directAuth }

enum DirectAuthenticationResult { success, mfaRequired, error }

enum AuthenticationFactor {
  otp("otp"),
  oob("oob");

  final String value;
  const AuthenticationFactor(this.value);
}

class AuthenticationResult {
  final DirectAuthenticationResult? result;
  final String? error;
  final OktaToken? token;
  final UserInfo? userInfo;

  AuthenticationResult(
      {required this.result, this.error, required this.token, this.userInfo
      // required this.idToken,
      // required this.context
      });
}

class OktaToken {
  final String? id;
  final String? token;
  final int? issuedAt;
  final String? tokenType;
  final String? accessToken;
  final String? scope;
  final String? refreshToken;

  OktaToken(
      {required this.id,
      required this.token,
      required this.issuedAt,
      required this.tokenType,
      required this.accessToken,
      required this.scope,
      required this.refreshToken});
}

class UserInfo {
  final String userId;
  final String givenName;
  final String middleName;
  final String familyName;
  final String gender;
  final String email;
  final String phoneNumber;
  final String username;

  UserInfo({
    required this.userId,
    required this.givenName,
    required this.middleName,
    required this.familyName,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.username,
  });
}

class DirectAuthRequest {
  final String username;
  final String password;
  final List<String?> factors;

  DirectAuthRequest(
      {required this.username, required this.password, required this.factors});
}

class DeviceAuthorizationSession {
  final String? userCode;
  final String? verificationUri;

  DeviceAuthorizationSession(
      {required this.userCode, required this.verificationUri});
}

class IdxResponse {
  final int? expiresAt;
  final UserInfo? user;
  final bool canCancel;
  final bool isLoginSuccessful;
  final RequestIntent intent;
  final List<String?> messages;
  List<String?>? remediations;
  List<String?>? authenticators;
  OktaToken? token;

  IdxResponse({
    required this.expiresAt,
    required this.user,
    required this.canCancel,
    required this.intent,
    required this.isLoginSuccessful,
    required this.messages,
    this.authenticators,
    this.remediations,
    this.token,
  });
}

enum RequestIntent {
  enrollNewUser,
  login,
  credentialEnrollment,
  credentialUnenrollment,
  credentialRecovery,
  credentialModify,
  unknown,
}

@HostApi()
abstract class HssOktaFlutterPluginApi {
  @async
  AuthenticationResult? startDirectAuthenticationFlow(
      DirectAuthRequest request);

  @async
  AuthenticationResult? continueDirectAuthenticationMfaFlow(String otp);

  @async
  bool? refreshDefaultToken();

  @async
  bool? revokeDefaultToken();

  @async
  AuthenticationResult? getCredential();

  @async
  DeviceAuthorizationSession? startDeviceAuthorizationFlow();

  @async
  AuthenticationResult? resumeDeviceAuthorizationFlow();

  @async
  AuthenticationResult? startTokenExchangeFlow(
    String deviceSecret,
    String idToken,
  );

  // Token and Credential Management
  @async
  List<String> getAllUserIds();

  @async
  AuthenticationResult? getToken(String tokenId);

  @async
  bool removeCredential(String tokenId);
  @async
  bool setDefaultToken(String tokenId);

  // IDX Section
  @async
  IdxResponse? authenticateWithEmailAndPassword(String email, String password);

  @async
  IdxResponse? startInteractionCodeFlow(
      {String? email, required String remidiation});

  @async
  bool startSMSPhoneEnrollment(String phoneNumber);

  // Continues

  @async
  bool continueSMSPhoneEnrollment(String passcode);

  @async
  IdxResponse? continueWithGoogleAuthenticator(String code);

  @async
  IdxResponse? continueWithPasscode(String passcode);

  @async
  void sendEmailCode();

  @async
  IdxResponse? pollEmailCode();

  @async
  bool recoverPassword(String identifier);

  @async
  @async
  IdxResponse? getIdxResponse();

  @async
  bool cancelCurrentTransaction();

  // @async
  // List<String> getRemidiations();

  // @async
  // List<String> getRemidiationsFields(String remidiation, {String? fields});

  // @async
  // List<String> getRemidiationAuthenticators(String remidiation,
  //     {String? fields});

  // Enrollments

  @async
  bool startUserEnrollmentFlow({
    required String email,
    required Map<String, String> details,
  });

  @async
  String getEnrollmentOptions();

  @async
  bool enrollSecurityQuestion(Map<String, String> questions);
}
