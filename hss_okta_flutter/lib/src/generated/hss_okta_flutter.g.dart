// Autogenerated from Pigeon (v20.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

enum AuthenticationType {
  browser,
  sso,
  directAuth,
}

enum DirectAuthenticationResult {
  success,
  mfaRequired,
  error,
}

enum AuthenticationFactor {
  otp,
  oob,
}

class AuthenticationResult {
  AuthenticationResult({
    this.result,
    this.error,
    this.token,
    this.userInfo,
  });

  DirectAuthenticationResult? result;

  String? error;

  OktaToken? token;

  UserInfo? userInfo;

  Object encode() {
    return <Object?>[
      result,
      error,
      token,
      userInfo,
    ];
  }

  static AuthenticationResult decode(Object result) {
    result as List<Object?>;
    return AuthenticationResult(
      result: result[0] as DirectAuthenticationResult?,
      error: result[1] as String?,
      token: result[2] as OktaToken?,
      userInfo: result[3] as UserInfo?,
    );
  }
}

class OktaToken {
  OktaToken({
    this.id,
    this.token,
    this.issuedAt,
    this.tokenType,
    this.accessToken,
    this.scope,
    this.refreshToken,
  });

  String? id;

  String? token;

  int? issuedAt;

  String? tokenType;

  String? accessToken;

  String? scope;

  String? refreshToken;

  Object encode() {
    return <Object?>[
      id,
      token,
      issuedAt,
      tokenType,
      accessToken,
      scope,
      refreshToken,
    ];
  }

  static OktaToken decode(Object result) {
    result as List<Object?>;
    return OktaToken(
      id: result[0] as String?,
      token: result[1] as String?,
      issuedAt: result[2] as int?,
      tokenType: result[3] as String?,
      accessToken: result[4] as String?,
      scope: result[5] as String?,
      refreshToken: result[6] as String?,
    );
  }
}

class UserInfo {
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

  String userId;

  String givenName;

  String middleName;

  String familyName;

  String gender;

  String email;

  String phoneNumber;

  String username;

  Object encode() {
    return <Object?>[
      userId,
      givenName,
      middleName,
      familyName,
      gender,
      email,
      phoneNumber,
      username,
    ];
  }

  static UserInfo decode(Object result) {
    result as List<Object?>;
    return UserInfo(
      userId: result[0]! as String,
      givenName: result[1]! as String,
      middleName: result[2]! as String,
      familyName: result[3]! as String,
      gender: result[4]! as String,
      email: result[5]! as String,
      phoneNumber: result[6]! as String,
      username: result[7]! as String,
    );
  }
}

class DirectAuthRequest {
  DirectAuthRequest({
    required this.username,
    required this.password,
    required this.factors,
  });

  String username;

  String password;

  List<String?> factors;

  Object encode() {
    return <Object?>[
      username,
      password,
      factors,
    ];
  }

  static DirectAuthRequest decode(Object result) {
    result as List<Object?>;
    return DirectAuthRequest(
      username: result[0]! as String,
      password: result[1]! as String,
      factors: (result[2] as List<Object?>?)!.cast<String?>(),
    );
  }
}

class DeviceAuthorizationSession {
  DeviceAuthorizationSession({
    this.userCode,
    this.verificationUri,
  });

  String? userCode;

  String? verificationUri;

  Object encode() {
    return <Object?>[
      userCode,
      verificationUri,
    ];
  }

  static DeviceAuthorizationSession decode(Object result) {
    result as List<Object?>;
    return DeviceAuthorizationSession(
      userCode: result[0] as String?,
      verificationUri: result[1] as String?,
    );
  }
}


class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AuthenticationResult) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else     if (value is OktaToken) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else     if (value is UserInfo) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else     if (value is DirectAuthRequest) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else     if (value is DeviceAuthorizationSession) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else     if (value is AuthenticationType) {
      buffer.putUint8(134);
      writeValue(buffer, value.index);
    } else     if (value is DirectAuthenticationResult) {
      buffer.putUint8(135);
      writeValue(buffer, value.index);
    } else     if (value is AuthenticationFactor) {
      buffer.putUint8(136);
      writeValue(buffer, value.index);
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129: 
        return AuthenticationResult.decode(readValue(buffer)!);
      case 130: 
        return OktaToken.decode(readValue(buffer)!);
      case 131: 
        return UserInfo.decode(readValue(buffer)!);
      case 132: 
        return DirectAuthRequest.decode(readValue(buffer)!);
      case 133: 
        return DeviceAuthorizationSession.decode(readValue(buffer)!);
      case 134: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : AuthenticationType.values[value];
      case 135: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : DirectAuthenticationResult.values[value];
      case 136: 
        final int? value = readValue(buffer) as int?;
        return value == null ? null : AuthenticationFactor.values[value];
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class HssOktaFlutterPluginApi {
  /// Constructor for [HssOktaFlutterPluginApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  HssOktaFlutterPluginApi({BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : __pigeon_binaryMessenger = binaryMessenger,
        __pigeon_messageChannelSuffix = messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String __pigeon_messageChannelSuffix;

  Future<AuthenticationResult?> startDirectAuthenticationFlow(DirectAuthRequest request) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[request]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(String otp) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[otp]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<bool?> refreshDefaultToken() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.refreshDefaultToken$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as bool?);
    }
  }

  Future<bool?> revokeDefaultToken() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.revokeDefaultToken$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as bool?);
    }
  }

  Future<AuthenticationResult?> getCredential() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getCredential$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDeviceAuthorizationFlow$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as DeviceAuthorizationSession?);
    }
  }

  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.resumeDeviceAuthorizationFlow$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<AuthenticationResult?> startTokenExchangeFlow(String deviceSecret, String idToken) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[deviceSecret, idToken]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<List<String?>> getAllUserIds() async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getAllUserIds$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as List<Object?>?)!.cast<String?>();
    }
  }

  Future<AuthenticationResult?> getToken(String tokenId) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getToken$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[tokenId]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as AuthenticationResult?);
    }
  }

  Future<bool> removeCredential(String tokenId) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.removeCredential$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[tokenId]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as bool?)!;
    }
  }

  Future<bool> setDefaultToken(String tokenId) async {
    final String __pigeon_channelName = 'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.setDefaultToken$__pigeon_messageChannelSuffix';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[tokenId]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as bool?)!;
    }
  }
}
