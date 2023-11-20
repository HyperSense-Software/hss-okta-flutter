import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter_example/provider/plugin_provider.dart';
import 'package:hss_okta_flutter_example/screens/device_sso_confirmation_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../web_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.token});

  final String? token;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  AuthenticationResult? result;

  @override
  void dispose() {
    _pageController.dispose();
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Future<void> getCredential(BuildContext context) async {
    try {
      result = (await PluginProvider.of(context).plugin.getCredential())!;

      debugPrint(result?.token?.token ?? '');
    } catch (e) {
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
              await PluginProvider.of(context)
                  .plugin
                  .mfaOtpSignInWithCredentials(_controller.text)
                  .then((value) async {
                if (value?.result == DirectAuthenticationResult.success) {
                  result = value!;

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
                  await PluginProvider.of(context)
                      .plugin
                      .startDirectAuthenticationFlow(
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
                if (kIsWeb) {
                  final value = await PluginProvider.of(context)
                      .pluginWeb
                      .startPopUpAuthentication(
                          options: AuthorizeOptions(
                        responseType: ['token', 'id_token'],
                      ));
                  debugPrint(value.tokens.accessToken?.accessToken ?? '');
                } else {
                  var result = await Navigator.of(formContext).push(
                      MaterialPageRoute(
                          builder: (c) => const WebSignInExample()));

                  if (result) {
                    await PluginProvider.of(context)
                        .plugin
                        .getCredential()
                        .then((cred) {
                      _processResult(cred, formContext);
                      setState(() {});
                    });
                  }
                }
              },
              child: const Text('Browser sign in')),
          const SizedBox(
            height: 24,
          ),
          OutlinedButton(
              onPressed: () async => await PluginProvider.of(context)
                      .plugin
                      .startDeviceAuthorizationFlow()
                      .then((value) async {
                    if (value == null) return;

                    await Navigator.of(formContext)
                        .push(
                      MaterialPageRoute(
                        builder: (c) => DeviceSSOConfirmationScreen(
                          session: value,
                          onConfirm: (innerContext) async {
                            await PluginProvider.of(context)
                                .plugin
                                .resumeDeviceAuthorizationFlow()
                                .then((value) =>
                                    Navigator.of(innerContext).pop());
                          },
                        ),
                      ),
                    )
                        .then((value) async {
                      await PluginProvider.of(context)
                          .plugin
                          .getCredential()
                          .then((credential) =>
                              _processResult(credential, formContext));
                      setState(() {});
                    });
                  }),
              child: const Text('Device SSO'))
        ],
      ),
    );
  }

  void _processResult(AuthenticationResult? res, BuildContext context) {
    if (res == null) {
      return;
    }

    if (res.result == DirectAuthenticationResult.success) {
      result = res;
      _pageController.animateToPage(2,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }

    if (res.result == DirectAuthenticationResult.error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${res.result}')));
    }

    if (res.result == DirectAuthenticationResult.mfaRequired) {
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
          if (result?.result != null)
            Text('DirectAuthentication Result : ${result?.result}'),
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
            Text('JWT Token: ${JwtDecoder.decode(result?.token?.token ?? '')}'),
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
                  if (kIsWeb) {
                  } else {
                    try {
                      await PluginProvider.of(context)
                          .plugin
                          .revokeDefaultToken()
                          .then((value) {
                        if (value) {
                          result = null;
                          _pageController.jumpTo(0);
                        }
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(profileContext).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  }
                },
                child: const Text('Revoke token'))
          ]
        ]),
      ),
    );
  }
}
