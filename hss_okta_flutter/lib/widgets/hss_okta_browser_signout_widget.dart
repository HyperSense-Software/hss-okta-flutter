import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLogOutBuilder = Widget Function(
    BuildContext context, Widget child);

class HssOktaBrowserSignOutWidget extends StatelessWidget {
  final AuthBrowserLogOutBuilder? builder;
  final ValueSetter<bool>? onResult;
  final ValueSetter<Object>? onError;

  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signout");
  final platformViewName =
      'dev.hypersense.software.hss_okta.views.browser.signin';

  const HssOktaBrowserSignOutWidget(
      {super.key, this.builder, this.onResult, this.onError});

  Stream<bool> get browserSignOutStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  Widget get _iosNativeView {
    return SizedBox.shrink(
      child: UiKitView(
        viewType: 'dev.hypersense.software.hss_okta.views.browser.signout',
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

    return PlatformViewLink(
      viewType: platformViewName,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: platformViewName,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
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
