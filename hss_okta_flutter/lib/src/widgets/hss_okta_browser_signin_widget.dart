import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

///{@template browser_sign_in_widget}
///
/// Provides the native platform view for the browser signin
/// returns a [Stream<bool>] which emits true when the user has successfully
/// signed in,
/// the [AuthenticationResult] will be saved as the default.
///{@endtemplate}
class HssOktaBrowserSignInWidget extends StatelessWidget {
  ///{@macro browser_sign_in_widget}
  const HssOktaBrowserSignInWidget({
    super.key,
    this.builder,
    this.onResult,
    this.onError,
  });

  /// Called when the native view is created.
  final AuthBrowserBuilder? builder;

  /// Called when the user has successfully signed in or not.
  final ValueSetter<bool>? onResult;

  /// Called when an error occurs.
  final ValueSetter<Object>? onError;

  final _channel = const EventChannel(
    'dev.hypersense.software.hss_okta.channels.browser_signin',
  );
  final _platformViewName =
      'dev.hypersense.software.hss_okta.views.browser.signin';

  Stream<bool> get _browserSigninStream {
    return _channel
        .receiveBroadcastStream()
        .map<bool>((event) => event as bool);
  }

  Widget get _iosNativeView {
    return SizedBox.shrink(
      child: UiKitView(
        viewType: _platformViewName,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (i) {
          _browserSigninStream.listen(
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

  Widget get _andrdoidNativeView {
    return AndroidView(
      viewType: _platformViewName,
      layoutDirection: TextDirection.ltr,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        _browserSigninStream.listen(
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
      return _andrdoidNativeView;
    } else {
      throw UnsupportedError(
        'The platform $defaultTargetPlatform is not supported.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Removed after 3.16:
    /// current sdk version not allow condition flow for constructors
    final builder = this.builder;

    if (builder != null) return builder.call(context, _nativeView);

    return _nativeView;
  }
}
