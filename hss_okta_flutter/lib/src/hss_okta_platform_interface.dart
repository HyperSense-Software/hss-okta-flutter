import 'package:hss_okta_flutter/src/generated/hss_okta_flutter.g.dart';
import 'package:hss_okta_flutter/src/hss_okta_flutter_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// {@template hss_okta_flutter_platform_interface}
/// Interface for calling methods by their platform name
/// {@endtemplate}
abstract class HssOktaFlutterPlatformInterface extends PlatformInterface {
  ///{@macro hss_okta_flutter_platform_interface}
  HssOktaFlutterPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static HssOktaFlutterPlatformInterface _instance = HssOktaFlutterChannel();

  /// The default instance of [HssOktaFlutterPlatformInterface] to use.
  static HssOktaFlutterPlatformInterface get instance => _instance;

  static set instance(HssOktaFlutterPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Interface to start direct authentication flow
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<AuthenticationResult?> startDirectAuthenticationFlow(
    DirectAuthRequest request,
  ) {
    throw UnimplementedError();
  }

  /// Interface to revoke default token
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<bool> revokeDefaultToken() {
    throw UnimplementedError();
  }

  /// Interface to refresh default token
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<bool> refreshDefaultToken() {
    throw UnimplementedError();
  }

  /// Interface to get credential from authentication flow.
  /// See [startDirectAuthenticationFlow] for more details
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<AuthenticationResult?> getCredential() {
    throw UnimplementedError();
  }

  /// Interface to continue direct authentication flow with MFA enabled.
  /// See [startDirectAuthenticationFlow] for more details.
  ///
  /// throws [UnimplementedError] if the platform does not support this method.
  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(
    String otp,
  ) {
    throw UnimplementedError();
  }

  /// Interface to start device authorization flow
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() {
    throw UnimplementedError();
  }

  /// Interface to resume device authorization flow.
  /// See [startDeviceAuthorizationFlow] for more details.
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() {
    throw UnimplementedError();
  }

  /// Interface to start direct authentication flow
  ///
  /// throws [UnimplementedError] if the platform does not support this method
  Future<AuthenticationResult?> startTokenExchangeFlow({
    required String deviceSecret,
    required String idToken,
  }) {
    throw UnimplementedError();
  }
}
