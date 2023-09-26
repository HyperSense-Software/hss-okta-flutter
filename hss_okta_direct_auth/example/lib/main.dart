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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    await _hssOktaDirectAuthPlugin.signIn(
        email: 'AldrinFrancisco@ntsafety.com', password: 'S@asAppD3v!');
  }

  Future<HssOktaDirectAuthResult> getCredential() async {
    await init();
    var res = await _hssOktaDirectAuthPlugin.getCredential();
    return res;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<HssOktaDirectAuthResult?>(
            future: getCredential(),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.data!.result == DirectAuthResult.mfaRequired) {
                  return _mfa();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _hssOktaDirectAuthPlugin.refreshDefaultToken();
                    await getCredential();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ListView(children: [
                      Text('Authentication Result : ${snapshot.data?.result}'),
                      if (snapshot.data!.result != DirectAuthResult.success)
                        Text('error : ${snapshot.data?.error}')
                      else ...[
                        Text('id : ${snapshot.data?.id}'),
                        Text(
                            'Issued At : ${DateTime.fromMillisecondsSinceEpoch(snapshot.data?.issuedAt ?? 0)}'),
                        Text('refresh token : ${snapshot.data?.refreshToken}'),
                        Text('Scope : ${snapshot.data?.scope}'),
                        Text('Token Type: ${snapshot.data?.tokenType}'),
                        if (snapshot.data?.token != null)
                          Text(
                              'JWT Token: ${JwtDecoder.decode(snapshot.data?.token ?? '')}'),
                      ]
                    ]),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
