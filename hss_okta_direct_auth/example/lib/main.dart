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
  }

  Future<String> initSigninToOktaTest() async {
    var result = await _hssOktaDirectAuthPlugin.signIn() ?? 'Fail';

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<String>(
            future: initSigninToOktaTest(),
            initialData: '',
            builder: (context, snapshot) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return Center(
                  child: Text(
                      'Hypersense software - Okta Sign in result : ${snapshot.data}'),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
