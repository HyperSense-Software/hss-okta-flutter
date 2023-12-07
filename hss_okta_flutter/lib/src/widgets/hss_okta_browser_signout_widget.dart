import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

/// {@template browser_sign_out_widget}
///
/// Provides the native platform view for the browser signout
/// returns a [Stream<bool>] which emits true when the user has successfully
/// signed in,
/// Deletes the default [AuthenticationResult] and the [UserInfo] from the
/// device
///
/// {@endtemplate}

class HssOktaBrowserSignOutWidget extends StatelessWidget {
  ///{@macro browser_sign_out_widget}
  const HssOktaBrowserSignOutWidget({
    super.key,
    this.builder,
    this.onResult,
    this.onError,
  });

  /// Called when the native view is created
  final AuthBrowserBuilder? builder;

  /// Called when the user has successfully signed out
  final ValueSetter<bool>? onResult;

  /// Called when an error occurs
  final ValueSetter<Object>? onError;

  final _channel = const EventChannel(
    'dev.hypersense.software.hss_okta.channels.browser_signout',
  );
  final _platformViewName =
      'dev.hypersense.software.hss_okta.views.browser.signout';

  Stream<bool> get _browserSignOutStream {
    return _channel.receiveBroadcastStream().map((event) => event as bool);
  }

  Widget get _iosNativeView {
    return SizedBox.shrink(
      child: UiKitView(
        viewType: _platformViewName,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (i) {
          _browserSignOutStream.listen(
            (event) async {
              if (event) {
                onResult?.call(true);
              }
            },
            onError: onError ?? (Exception e) => throw e,
          );
        },
      ),
    );
  }

  Widget get _andrdoiNativeView {
    return AndroidView(
      viewType: _platformViewName,
      layoutDirection: TextDirection.ltr,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        _browserSignOutStream.listen(
          (event) async {
            if (event) {
              onResult?.call(true);
            }
          },
          onError: onError ?? (Exception e) => throw e,
        );
      },
    );
  }

  Widget get _nativeView {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosNativeView;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return _andrdoiNativeView;
    } else {
      throw UnsupportedError(
        'The platform $defaultTargetPlatform is not supported',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Removed after 3.16:
    /// current sdk version not allow condition flow for constructors
    final builder = this.builder;

    if (builder != null) {
      return builder.call(context, _nativeView);
    }

    return _nativeView;
  }
}
