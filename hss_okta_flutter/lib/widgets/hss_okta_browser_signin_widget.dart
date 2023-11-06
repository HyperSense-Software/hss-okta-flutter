import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

typedef AuthBrowserLoginBuilder = Widget Function(
    BuildContext context, Widget child);

/// Provides the native platform view for the browser signin
/// returns a [Stream<bool>] which emits true when the user has successfully signed in,
/// the [Credential] will be saved as teh default
class HssOktaBrowserSignInWidget extends StatelessWidget {
  final AuthBrowserLoginBuilder? builder;
  final ValueSetter<bool>? onResult;
  final ValueSetter<Object>? onError;

  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signin");
  final platformViewName =
      'dev.hypersense.software.hss_okta.views.browser.signin';
  const HssOktaBrowserSignInWidget(
      {super.key, this.builder, this.onResult, this.onError});

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  Widget get _iosNativeView {
    return SizedBox.shrink(
      child: UiKitView(
        viewType: platformViewName,
        layoutDirection: TextDirection.ltr,
        creationParams: const {},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (i) {
          browserSigninStream.listen((event) async {
            if (event) {
              onResult?.call(true);
            }
          }, onError: onError ?? (e) => throw e);
        },
      ),
    );
  }

  Widget get _andrdoidNativeView {
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: platformViewName,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        browserSigninStream.listen((event) async {
          if (event) {
            onResult?.call(true);
          }
        }, onError: onError ?? (e) => throw e);
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
          "The platform ${defaultTargetPlatform.toString()} is not supported.");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (builder != null) return builder!(context, _nativeView);

    return _nativeView;
  }
}
