// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final String clientId;
  final String issuer;
  final String scopes;
  final String signInRedirectUrl;
  final String signOutRedirectUrl;
  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signin");

  const HssOktaBrowserSignInWidget({
    Key? key,
    this.builder,
    this.onResult,
    required this.clientId,
    required this.issuer,
    required this.scopes,
    required this.signInRedirectUrl,
    required this.signOutRedirectUrl,
  }) : super(key: key);

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  @override
  Widget build(BuildContext context) {
    /// iOS version
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: _platformView(),
          ),
        ),
      ],
    );
  }

  Widget? _platformView() {
    // This is used in the platform side to register the view.
    Map<String, dynamic> creationParams = <String, dynamic>{
      'clientId': clientId,
      'issuer': issuer,
      'scopes': scopes,
      'signInRedirectUrl': signInRedirectUrl,
      'signOutRedirectUrl': signOutRedirectUrl,
    };

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
        return AndroidWebSignIn(
          creationParams: creationParams,
          onPlatformViewCreated: (i) {
            browserSigninStream.listen((event) async {
              if (event) {
                onResult?.call(true);
              }
            }, onError: (e) {
              debugPrint('$e');
              onResult?.call(false);
            });
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (i) {
            browserSigninStream.listen((event) async {
              if (event) {
                onResult?.call(true);
              }
            }, onError: (e) {
              debugPrint('$e');
              onResult?.call(false);
            });
          },
        );
    }
  }
}

class AndroidWebSignIn extends StatefulWidget {
  const AndroidWebSignIn({
    required this.creationParams,
    required this.onPlatformViewCreated,
    super.key,
  });
  final Map<String, dynamic> creationParams;
  final void Function(int id) onPlatformViewCreated;
  @override
  State<AndroidWebSignIn> createState() => _AndroidWebSignInState();
}

class _AndroidWebSignInState extends State<AndroidWebSignIn> {
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
          creationParams: widget.creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener((int listener) {
            params.onPlatformViewCreated(listener);
            widget.onPlatformViewCreated.call(listener);
          })
          ..create();
        return platformView;
      },
    );
  }
}
