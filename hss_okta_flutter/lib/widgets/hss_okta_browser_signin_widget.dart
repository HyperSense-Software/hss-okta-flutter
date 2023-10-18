import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLoginBuilder = Widget Function(
    BuildContext context, Widget? child);

class HssOktaBrowserSignInWidget extends StatelessWidget {
  final AuthBrowserLoginBuilder? builder;
  final ValueSetter<bool>? onResult;
  final ValueSetter<Object>? onError;

  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signin");

  const HssOktaBrowserSignInWidget(
      {super.key, this.builder, this.onResult, this.onError});

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  Widget get _nativeView {
    return SizedBox.shrink(
      child: UiKitView(
        viewType: 'dev.hypersense.software.hss_okta.views.browser.signin',
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

  @override
  Widget build(BuildContext context) {
    if (builder != null) builder!(context, _nativeView);

    return _nativeView;
  }
}
