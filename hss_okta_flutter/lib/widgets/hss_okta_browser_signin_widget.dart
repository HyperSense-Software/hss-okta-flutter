import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLoginBuilder = Widget Function(BuildContext context);

const _viewType = 'dev.hypersense.software.hss_okta.views.browser.signin';

class HssOktaBrowserSignInWidget extends StatelessWidget {
  final AuthBrowserLoginBuilder? builder;
  final ValueSetter<bool>? onResult;
  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signin");

  const HssOktaBrowserSignInWidget({super.key, this.builder, this.onResult});

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  @override
  Widget build(BuildContext context) {
    /// iOS version
    return Column(
      children: [
        Flexible(
          child: SizedBox(
            child: _platformView(),
          ),
        ),
      ],
    );
  }

  Widget? _platformView() {
    // This is used in the platform side to register the view.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
      // TODO: Handle this case.
      case TargetPlatform.macOS:
      // TODO: Handle this case.
      case TargetPlatform.windows:
      // TODO: Handle this case.
      // TODO: Handle this case.
      case TargetPlatform.fuchsia:
        return null;

      /// TODO: Use Hybrid composition for Android
      /// TLHC is still under investigation
      case TargetPlatform.android:
        return const SizedBox.shrink();
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: const {},
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (i) {
            browserSigninStream.listen((event) async {
              if (event) {
                onResult?.call(true);
              }
            });
          },
        );
    }
  }
}

class AndroidWebSignIn extends StatefulWidget {
  const AndroidWebSignIn({super.key});

  @override
  State<AndroidWebSignIn> createState() => _AndroidWebSignInState();
}

class _AndroidWebSignInState extends State<AndroidWebSignIn> {
  static const Map<String, dynamic> creationParams = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformViewLink(
      viewType: _viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        final platformView = PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: _viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
        return platformView;
      },
    );
  }
}
