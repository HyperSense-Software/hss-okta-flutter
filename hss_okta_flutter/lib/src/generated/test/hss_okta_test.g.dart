// Autogenerated from Pigeon (v13.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, unnecessary_import
// ignore_for_file: avoid_relative_lib_imports
import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;
import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../hss_okta_flutter.g.dart';

class _HssOktaFlutterPluginApiTestCodec extends StandardMessageCodec {
  const _HssOktaFlutterPluginApiTestCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AuthenticationResult) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is DeviceAuthorizationSession) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is DirectAuthRequest) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is OktaToken) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is UserInfo) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128: 
        return AuthenticationResult.decode(readValue(buffer)!);
      case 129: 
        return DeviceAuthorizationSession.decode(readValue(buffer)!);
      case 130: 
        return DirectAuthRequest.decode(readValue(buffer)!);
      case 131: 
        return OktaToken.decode(readValue(buffer)!);
      case 132: 
        return UserInfo.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class HssOktaFlutterPluginApiTest {
  static TestDefaultBinaryMessengerBinding? get _testBinaryMessengerBinding => TestDefaultBinaryMessengerBinding.instance;
  static const MessageCodec<Object?> codec = _HssOktaFlutterPluginApiTestCodec();

  Future<AuthenticationResult?> startDirectAuthenticationFlow(DirectAuthRequest request);

  Future<AuthenticationResult?> continueDirectAuthenticationMfaFlow(String otp);

  Future<bool?> refreshDefaultToken();

  Future<bool?> revokeDefaultToken();

  Future<AuthenticationResult?> getCredential();

  Future<DeviceAuthorizationSession?> startDeviceAuthorizationFlow();

  Future<AuthenticationResult?> resumeDeviceAuthorizationFlow();

  Future<AuthenticationResult?> startTokenExchangeFlow(String deviceSecret, String idToken);

  Future<List<String?>> getAllUserIds();

  Future<AuthenticationResult?> getToken(String tokenId);

  Future<bool> removeCredential(String tokenId);

  Future<bool> setDefaultToken(String tokenId);

  static void setup(HssOktaFlutterPluginApiTest? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final DirectAuthRequest? arg_request = (args[0] as DirectAuthRequest?);
          assert(arg_request != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDirectAuthenticationFlow was null, expected non-null DirectAuthRequest.');
          try {
            final AuthenticationResult? output = await api.startDirectAuthenticationFlow(arg_request!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_otp = (args[0] as String?);
          assert(arg_otp != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.continueDirectAuthenticationMfaFlow was null, expected non-null String.');
          try {
            final AuthenticationResult? output = await api.continueDirectAuthenticationMfaFlow(arg_otp!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.refreshDefaultToken', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final bool? output = await api.refreshDefaultToken();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.revokeDefaultToken', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final bool? output = await api.revokeDefaultToken();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getCredential', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final AuthenticationResult? output = await api.getCredential();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startDeviceAuthorizationFlow', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final DeviceAuthorizationSession? output = await api.startDeviceAuthorizationFlow();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.resumeDeviceAuthorizationFlow', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final AuthenticationResult? output = await api.resumeDeviceAuthorizationFlow();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_deviceSecret = (args[0] as String?);
          assert(arg_deviceSecret != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow was null, expected non-null String.');
          final String? arg_idToken = (args[1] as String?);
          assert(arg_idToken != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.startTokenExchangeFlow was null, expected non-null String.');
          try {
            final AuthenticationResult? output = await api.startTokenExchangeFlow(arg_deviceSecret!, arg_idToken!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getAllUserIds', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          try {
            final List<String?> output = await api.getAllUserIds();
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getToken', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getToken was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_tokenId = (args[0] as String?);
          assert(arg_tokenId != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.getToken was null, expected non-null String.');
          try {
            final AuthenticationResult? output = await api.getToken(arg_tokenId!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.removeCredential', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.removeCredential was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_tokenId = (args[0] as String?);
          assert(arg_tokenId != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.removeCredential was null, expected non-null String.');
          try {
            final bool output = await api.removeCredential(arg_tokenId!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.setDefaultToken', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, null);
      } else {
        _testBinaryMessengerBinding!.defaultBinaryMessenger.setMockDecodedMessageHandler<Object?>(channel, (Object? message) async {
          assert(message != null,
          'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.setDefaultToken was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_tokenId = (args[0] as String?);
          assert(arg_tokenId != null,
              'Argument for dev.flutter.pigeon.hss_okta_flutter.HssOktaFlutterPluginApi.setDefaultToken was null, expected non-null String.');
          try {
            final bool output = await api.setDefaultToken(arg_tokenId!);
            return <Object?>[output];
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          }          catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}
