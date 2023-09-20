import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hss_okta_direct_auth/hss_okta_direct_auth.dart';

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
    initSigninToOktaTest().then((value) => res = value);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   res = await initSigninToOktaTest().whenComplete(() => setState(() {}));
    // });
  }

  Future<String> initSigninToOktaTest() async {
    var result = await _hssOktaDirectAuthPlugin.signIn() ?? 'Fail';
    print('RESULT : $result');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Hypersense software - Okta Sign in result : $res'),
        ),
      ),
    );
  }
}
