import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

class WebAuthenticationOkta extends StatefulWidget {
  const WebAuthenticationOkta({super.key});

  @override
  State<WebAuthenticationOkta> createState() => _WebAuthenticationOktaState();
}

class _WebAuthenticationOktaState extends State<WebAuthenticationOkta> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 0,
              width: 0,
              child: UiKitView(
                viewType: 'browser-redirect',
                layoutDirection: TextDirection.ltr,
                creationParams: {},
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (i) {},
              ),
            ),
            const Text("Authenticating..."),
            StreamBuilder(
                stream: HssOktaBrowserAuthenticator().browserSigninStream(),
                builder: (c, s) {
                  if (s.hasData) {
                    return Text(s.data.toString());
                  }
                  return const Text("");
                })
          ],
        ),
      ),
    );
  }
}
