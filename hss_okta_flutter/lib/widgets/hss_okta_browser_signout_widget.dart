import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLogOutBuilder = Widget Function(
    BuildContext context, Widget child);

/// Provides the native platform view for the browser signout
/// returns a [Stream<bool>] which emits true when the user has successfully signed in,
/// Deletes the default [Credential] and the [UserInfo] from the device
class HssOktaBrowserSignOutWidget extends StatelessWidget {
  final AuthBrowserLogOutBuilder? builder;
  final ValueSetter<bool>? onResult;
  final ValueSetter<Object>? onError;

  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signout");
  final platformViewName =
      'dev.hypersense.software.hss_okta.views.browser.signout';

  const HssOktaBrowserSignOutWidget(
      {super.key, this.builder, this.onResult, this.onError});

  Stream<bool> get browserSignOutStream {
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
          browserSignOutStream.listen((event) async {
            if (event) {
              onResult?.call(true);
            }
          }, onError: onError ?? (e) => throw e);
        },
      ),
    );
  }

  Widget get _andrdoiNativeView {
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: platformViewName,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        browserSignOutStream.listen((event) async {
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
      return _andrdoiNativeView;
    } else {
      throw UnsupportedError(
          "The platform ${defaultTargetPlatform.toString()} is not supported");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (builder != null) return builder!(context, _nativeView);

    return _nativeView;
  }
}
