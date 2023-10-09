import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/widgets/hss_okta_browser_authenticator_widget.dart';

class WebAuthExample extends StatefulWidget {
  const WebAuthExample({super.key});

  @override
  State<WebAuthExample> createState() => _WebAuthExampleState();
}

class _WebAuthExampleState extends State<WebAuthExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: HssOktaBrowserSignInWidget(
        onResult: (v) {
          if (v) {
            Navigator.pop(context, v);
          }
        },
        builder: (context) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: CircularProgressIndicator.adaptive())],
          );
        },
      )),
    );
  }
}
