// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:hss_okta_direct_auth/generated/hss_okta_direct_auth.g.dart';
import 'dart:async';

import 'package:hss_okta_direct_auth/hss_okta_direct_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _hssOktaDirectAuthPlugin = HssOktaDirectAuth();
  String res = 'None';
  String username = "";
  String password = "";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _usernamecontroller =
      TextEditingController(text: "AldrinFrancisco@ntsafety.com");
  final TextEditingController _passwordcontroller =
      TextEditingController(text: "S@asAppD3v!");
  final PageController _pageController = PageController(initialPage: 0);

  HssOktaDirectAuthResult? result;

  @override
  void initState() {
    super.initState();
  }

  Widget _mfa() {
    return Column(
      children: [
        const Text('OTP'),
        TextField(
          controller: _controller,
        ),
        OutlinedButton(
            onPressed: () {
              _hssOktaDirectAuthPlugin
                  .mfaOtpSignInWithCredentials(_controller.text);
            },
            child: const Text('Submit'))
      ],
    );
  }

  Widget _form(BuildContext formContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('Username'),
          TextField(
            controller: _usernamecontroller,
          ),
          const Text('Password'),
          TextField(
            controller: _passwordcontroller,
          ),
          OutlinedButton(
              onPressed: () async {
                try {
                  await _hssOktaDirectAuthPlugin
                      .signIn(
                          email: _usernamecontroller.text,
                          password: _passwordcontroller.text)
                      .then((res) {
                    if (res.result == DirectAuthResult.success) {
                      result = res;
                      _pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    }

                    if (res.result == DirectAuthResult.error) {
                      ScaffoldMessenger.of(formContext).showSnackBar(
                          SnackBar(content: Text('Error: ${res.error}')));
                    }

                    setState(() {});
                  });
                } catch (e, s) {
                  debugPrint(e.toString() + s.toString());
                  ScaffoldMessenger.of(formContext).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')));
                }
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }

  Widget _profile() {
    if (result == null) return const CircularProgressIndicator.adaptive();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ListView(children: [
        Text('Authentication Result : ${result?.result}'),
        if (result!.result != DirectAuthResult.success)
          Text('error : ${result?.error}')
        else ...[
          Text('id : ${result?.id}'),
          Text(
              'Issued At : ${DateTime.fromMillisecondsSinceEpoch(result?.issuedAt ?? 0)}'),
          Text('refresh token : ${result?.refreshToken}'),
          Text('Scope : ${result?.scope}'),
          Text('Token Type: ${result?.tokenType}'),
          if (result?.token != null)
            Text('JWT Token: ${JwtDecoder.decode(result?.token ?? '')}'),
        ]
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (_builderContext) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _form(_builderContext),
              _mfa(),
              _profile(),
            ],
          );
        }),
      ),
    );
  }
}
