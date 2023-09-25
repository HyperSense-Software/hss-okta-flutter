// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

class HssOktaDirectAuthRequest {
  HssOktaDirectAuthRequest({
    required this.username,
    required this.password,
  });

  String username;

  String password;

  Object encode() {
    return <Object?>[
      username,
      password,
    ];
  }

  static HssOktaDirectAuthRequest decode(Object result) {
    result as List<Object?>;
    return HssOktaDirectAuthRequest(
      username: result[0]! as String,
      password: result[1]! as String,
    );
  }
}

class HssOktaDirectAuthResult {
  HssOktaDirectAuthResult({
    required this.success,
    this.error,
    required this.id,
    required this.issuedAt,
    required this.tokenType,
    required this.accessToken,
    required this.scope,
    required this.refreshToken,
  });

  bool success;

  String? error;

  String id;

  int issuedAt;

  String tokenType;

  String accessToken;

  String scope;

  String refreshToken;

  Object encode() {
    return <Object?>[
      success,
      error,
      id,
      issuedAt,
      tokenType,
      accessToken,
      scope,
      refreshToken,
    ];
  }

  static HssOktaDirectAuthResult decode(Object result) {
    result as List<Object?>;
    return HssOktaDirectAuthResult(
      success: result[0]! as bool,
      error: result[1] as String?,
      id: result[2]! as String,
      issuedAt: result[3]! as int,
      tokenType: result[4]! as String,
      accessToken: result[5]! as String,
      scope: result[6]! as String,
      refreshToken: result[7]! as String,
    );
  }
}

class _HssOktaDirectAuthPluginApiCodec extends StandardMessageCodec {
  const _HssOktaDirectAuthPluginApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is HssOktaDirectAuthRequest) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is HssOktaDirectAuthResult) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return HssOktaDirectAuthRequest.decode(readValue(buffer)!);
      case 129: 
        return HssOktaDirectAuthResult.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class HssOktaDirectAuthPluginApi {
  /// Constructor for [HssOktaDirectAuthPluginApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  HssOktaDirectAuthPluginApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _HssOktaDirectAuthPluginApiCodec();

  Future<HssOktaDirectAuthResult?> signInWithCredentials(HssOktaDirectAuthRequest arg_request) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.hss_okta_direct_auth.HssOktaDirectAuthPluginApi.signInWithCredentials', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_request]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as HssOktaDirectAuthResult?);
    }
  }
}
