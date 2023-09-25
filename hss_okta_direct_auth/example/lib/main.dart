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

  @override
  void initState() {
    super.initState();
  }

  Future<HssOktaDirectAuthResult> initSigninToOktaTest() async {
    var result = await _hssOktaDirectAuthPlugin.signIn();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<HssOktaDirectAuthResult?>(
            future: initSigninToOktaTest(),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Authentication is successful : ${snapshot.data?.success}'),
                        Text('id : ${snapshot.data?.id}'),
                        Text(
                            'Issued At : ${DateTime.fromMillisecondsSinceEpoch(snapshot.data?.issuedAt ?? 0)}'),
                        Text('refresh token : ${snapshot.data?.refreshToken}'),
                        Text('Scope : ${snapshot.data?.scope}'),
                        Text('Token Type: ${snapshot.data?.tokenType}'),
                        Text(
                            'JWT Token: ${JwtDecoder.decode(snapshot.data?.token ?? '')}'),
                      ]),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
