import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/widgets/hss_okta_browser_signin_widget.dart';
import 'package:hss_okta_flutter/widgets/hss_okta_browser_signout_widget.dart';
import 'package:hss_okta_flutter_example/constants.dart';

class WebSignInExample extends StatelessWidget {
  const WebSignInExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: HssOktaBrowserSignInWidget(
        clientId: Constants.clientId,
        issuer: Constants.issuer,
        scopes: Constants.scopes,
        signInRedirectUrl: Constants.signInRedirectUrl,
        signOutRedirectUrl: Constants.signOutRedirectUrl,
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
