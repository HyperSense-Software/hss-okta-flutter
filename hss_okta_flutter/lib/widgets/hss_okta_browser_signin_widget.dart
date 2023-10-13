import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLoginBuilder = Widget Function(BuildContext context);

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
    return Column(
      children: [
        SizedBox.shrink(
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
              });
            },
          ),
        ),
        if (builder != null) builder!(context),
      ],
    );
  }
}
