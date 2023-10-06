import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef AuthBrowserLoginBuilder = Widget Function(BuildContext context);

class HssOktaBrowserAuthenticatorWidget extends StatefulWidget {
  final AuthBrowserLoginBuilder? builder;
  final ValueSetter<bool>? onResult;
  const HssOktaBrowserAuthenticatorWidget({
    super.key,
    this.builder,
    this.onResult,
  });

  @override
  State<HssOktaBrowserAuthenticatorWidget> createState() =>
      _HssOktaBrowserAuthenticatorWidgetState();
}

class _HssOktaBrowserAuthenticatorWidgetState
    extends State<HssOktaBrowserAuthenticatorWidget> {
  var channel = const EventChannel("dev.hss.okta_flutter.browser_signin");

  Stream<bool> get browserSigninStream {
    return channel.receiveBroadcastStream().map((event) => event);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.shrink(
          child: UiKitView(
            viewType: 'dev.hypersense.software.hss_okta.browser-signin-widget',
            layoutDirection: TextDirection.ltr,
            creationParams: const {},
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (i) {
              browserSigninStream.listen((event) async {
                if (event) {
                  widget.onResult?.call(true);
                }
              });
            },
          ),
        ),
        if (widget.builder != null) widget.builder!(context),
      ],
    );
  }
}
