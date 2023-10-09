import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLoginBuilder = Widget Function(BuildContext context);

class HssOktaBrowserSignOutWidget extends StatelessWidget {
  final AuthBrowserLoginBuilder? builder;
  final ValueSetter<bool>? onResult;
  final channel = const EventChannel("dev.hss.okta_flutter.browser_signout");

  const HssOktaBrowserSignOutWidget({super.key, this.builder, this.onResult});

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.shrink(
          child: UiKitView(
            viewType: 'dev.hypersense.software.hss_okta.browser-signout-widget',
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
          ),
        ),
        if (builder != null) builder!(context),
      ],
    );
  }
}
