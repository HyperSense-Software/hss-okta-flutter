import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hss_okta_flutter/pigeon/direct_auth_generated.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _api = DirectAuthAPI();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await hssOktaLoginWithUserAndPass(
          'aldrin.francisco@designli.co', 'tZTEvb2vZNrFTVB');
    });
  }

  Future<void> hssOktaLoginWithUserAndPass(
      String username, String password) async {
    await _api.signInWithCredentials(
        HSSOktaNativeAuthRequest(username: username, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (context) {
          return const Center(
            child: Text('Okta HSS'),
          );
        }),
      ),
    );
  }
}
