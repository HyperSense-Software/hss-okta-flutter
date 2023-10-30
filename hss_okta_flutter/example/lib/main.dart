import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/enums/sign_in_factors.dart';
import 'package:hss_okta_flutter/generated/hss_okta_flutter.g.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter_example/web_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'screens/device_sso_confirmation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _plugin = HssOktaFlutter();

  String _errors = '';
  String res = 'None';
  String username = "";
  String password = "";

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _usernamecontroller =
      TextEditingController(text: "aldrin.francisco@designli.co");
  final TextEditingController _passwordcontroller =
      TextEditingController(text: "tZTEvb2vZNrFTVB");

  final PageController _pageController = PageController(initialPage: 0);

  OktaAuthenticationResult? result;

  @override
  void initState() {
    super.initState();

    // For android
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getCredential(context);
      if (result != null) {
        _pageController.jumpToPage(2);
      }
    });
  }

  Future<void> getCredential(BuildContext context) async {
    try {
      result = await _plugin.getCredential();

      debugPrint(result?.token?.accessToken.toString());
    } catch (e, s) {
      _errors = '$e';
      debugPrint(e.toString() + s.toString());
      if (mounted) {
        ScaffoldMessenger.maybeOf(context)
            ?.showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
    setState(() {});
  }

  Widget _mfa() {
    return Column(
      children: [
        const Text('OTP'),
        TextField(
          controller: _controller,
        ),
        OutlinedButton(
            onPressed: () async {
              await _plugin
                  .mfaOtpSignInWithCredentials(_controller.text)
                  .then((value) async {
                if (value.result == AuthenticationResult.success) {
                  result = value;

                  await getCredential(context);
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
              });
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
                  await _plugin.startDirectAuthenticationFlow(
                      email: _usernamecontroller.text,
                      password: _passwordcontroller.text,
                      factors: [OktaSignInFactor.otp]).then((res) {
                    _processResult(res, formContext);

                    setState(() {});
                  });
                } catch (e, s) {
                  debugPrint(e.toString() + s.toString());
                  if (mounted) {
                    ScaffoldMessenger.of(formContext).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')));
                  }
                }
              },
              child: const Text('Submit')),
          const SizedBox(
            height: 24,
          ),
          OutlinedButton(
              onPressed: () async {
                var result = await Navigator.of(formContext).push(
                    MaterialPageRoute(
                        builder: (c) => const WebSignInExample()));

                if (result) {
                  await _plugin.getCredential().then((cred) {
                    _processResult(cred, formContext);
                    setState(() {});
                  });
                }
              },
              child: const Text('Browser sign in')),
          const SizedBox(
            height: 24,
          ),
          OutlinedButton(
              onPressed: () async => await _plugin
                      .startDeviceAuthorizationFlow()
                      .then((value) async {
                    await Navigator.of(formContext)
                        .push(
                      MaterialPageRoute(
                        builder: (c) => DeviceSSOConfirmationScreen(
                          session: value,
                          onConfirm: (innerContext) async {
                            await _plugin.resumeDeviceAuthorizationFlow().then(
                                (value) => Navigator.of(innerContext).pop());
                          },
                        ),
                      ),
                    )
                        .then((value) async {
                      await _plugin.getCredential().then((credential) =>
                          _processResult(credential, formContext));
                      setState(() {});
                    });
                  }),
              child: const Text('Device SSO'))
        ],
      ),
    );
  }

  void _processResult(OktaAuthenticationResult res, BuildContext context) {
    if (res.result == AuthenticationResult.success) {
      result = res;
      _pageController.animateToPage(2,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }

    if (res.result == AuthenticationResult.error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${res.error}')));
    }

    if (res.result == AuthenticationResult.mfaRequired) {
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  Widget _profile(BuildContext profileContext) {
    if (result == null) return const CircularProgressIndicator.adaptive();

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: RefreshIndicator(
        onRefresh: () async => await getCredential(context),
        child: ListView(children: [
          Text('Authentication Result : ${result?.result}'),
          if (result!.result != AuthenticationResult.success)
            Text('error : ${result?.error}')
          else ...[
            Text('id : ${result?.token?.id}'),
            Text(
                'Issued At : ${DateTime.fromMillisecondsSinceEpoch(result?.token?.issuedAt ?? 0)}'),
            SelectableText('refresh token : ${result?.token?.refreshToken}'),
            Text('Scope : ${result?.token?.scope}'),
            Text('Token Type: ${result?.token?.tokenType}'),
            SelectableText('Access Token : ${result?.token?.accessToken}'),
            const Divider(
              thickness: 4,
            ),
            if (result?.token?.token != null)
              Text(
                  'JWT Token: ${JwtDecoder.decode(result?.token?.token ?? '')}'),
            const Divider(
              thickness: 4,
            ),
            if (result!.userInfo != null) ...[
              Text('User ID : ${result?.userInfo!.userId ?? ''}'),
              Text('Given name : ${result?.userInfo!.givenName ?? ''}'),
              Text('Middle name : ${result?.userInfo!.middleName ?? ''}'),
              Text('Family Name : ${result?.userInfo!.familyName ?? ''}'),
              Text('Gender : ${result?.userInfo!.gender ?? ''}'),
              Text('Phone Number : ${result?.userInfo!.phoneNumber ?? ''}'),
              Text('Email : ${result?.userInfo!.email ?? ''}'),
              Text('Username : ${result?.userInfo!.username ?? ''}'),
            ],
            const SizedBox(
              height: 24,
            ),
            if (result != null) ...[
              OutlinedButton(
                  onPressed: () async {
                    try {
                      await _plugin.revokeDefaultToken();
                      var result = await Navigator.of(profileContext).push(
                          MaterialPageRoute(
                              builder: (c) => const WebSignOutExample()));

                      if (result) {
                        _pageController.jumpTo(0);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(profileContext).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  child: const Text('WebAuth Signout')),
              OutlinedButton(
                  onPressed: () async {
                    try {
                      await _plugin.revokeDefaultToken().then((value) {
                        if (value) {
                          result = null;
                          _pageController.jumpTo(0);
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(profileContext).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  child: const Text('Revoke token'))
            ]
          ]
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Okta Direct Authentication Example'),
        ),
        body: Builder(builder: (builderContext) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _form(builderContext),
              _mfa(),
              _profile(builderContext),
            ],
          );
        }),
      ),
    );
  }
}
