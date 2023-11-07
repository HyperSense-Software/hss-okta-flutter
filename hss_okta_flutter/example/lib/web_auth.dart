import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter_plugin.dart';

class WebSignInExample extends StatelessWidget {
  const WebSignInExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HssOktaBrowserSignInWidget(
        onResult: (v) {
          if (v) {
            Navigator.pop(context, v);
          }
        },
        onError: (value) {},
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: child),
              const Center(child: CircularProgressIndicator.adaptive())
            ],
          );
        },
      ),
    );
  }
}

class WebSignOutExample extends StatelessWidget {
  const WebSignOutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: HssOktaBrowserSignOutWidget(
        onResult: (v) {
          if (v) {
            Navigator.pop(context, v);
          }
        },
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: child),
              const Center(child: CircularProgressIndicator.adaptive())
            ],
          );
        },
      )),
    );
  }
}
