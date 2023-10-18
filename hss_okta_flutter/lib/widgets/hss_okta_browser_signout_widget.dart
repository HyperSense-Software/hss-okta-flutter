import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLogOutBuilder = Widget Function(
    BuildContext context, Widget child);

class HssOktaBrowserSignOutWidget extends StatelessWidget {
  final AuthBrowserLogOutBuilder? builder;
  final ValueSetter<bool>? onResult;
  final ValueSetter<Object>? onError;

  final channel = const EventChannel(
      "dev.hypersense.software.hss_okta.channels.browser_signout");

  const HssOktaBrowserSignOutWidget(
      {super.key, this.builder, this.onResult, this.onError});

  Stream<bool> get browserSignOutStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  Widget get _nativeView {
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

  @override
  Widget build(BuildContext context) {
    if (builder != null) return builder!(context, _nativeView);

    return _nativeView;
  }
}
