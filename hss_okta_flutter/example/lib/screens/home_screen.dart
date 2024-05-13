import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter_example/provider/plugin_provider.dart';
import 'package:hss_okta_flutter_example/screens/device_sso_confirmation_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../web/web_profile_screen.dart';
import '../web_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.token});

  final String? token;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  final TextEditingController _usernamecontroller = TextEditingController(
    text: '',
  );

  final TextEditingController _passwordcontroller = TextEditingController(
    text: '',
  );

  final PageController _pageController = PageController(initialPage: 0);

  AuthenticationResult? result;

  late final StreamController<AuthState> _authStateController;

  StreamSubscription<AuthState>? _streamSubscription;
  TokenResponse? tokens;

  @override
  void initState() {
    _initStreams();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        PluginProvider.of(context).pluginWeb
          ..subscribe((authState) {
            if (authState.isAuthenticated) {
              _authStateController.add(authState);
            }
          })
          ..unsubscribe((authState) {
            _streamSubscription?.cancel();
            _streamSubscription = null;
          });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernamecontroller.dispose();
    _passwordcontroller.dispose();
    _pageController.dispose();
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  void _initStreams() {
    _authStateController = StreamController<AuthState>.broadcast();
    _streamSubscription = _authStateController.stream.listen((authState) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (c) => WebProfileScreen(
            tokens: tokens,
          ),
        ),
      );
    });
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
    } catch (e) {
      if (context.mounted) {
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
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernamecontroller,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    hintText: 'Enter your Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                OutlinedButton(
                    onPressed: () async {
                      final provider = PluginProvider.of(context);
                      try {
                        if (kIsWeb) {
                          final result =
                              await provider.pluginWeb.signInWithCredentials(
                            username: _usernamecontroller.text,
                            password: _passwordcontroller.text,
                          );

                          if (result.status == 'SUCCESS') {
                            final token = await provider.pluginWeb
                                .getWithoutPrompt(
                                    sessionToken: result.sessionToken!,
                                    scopes: ['openid', 'email', 'profile'],
                                    responseType: ['token', 'id_token']);

                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => WebProfileScreen(
                                    tokens: token,
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          await provider.plugin.startDirectAuthenticationFlow(
                              email: _usernamecontroller.text,
                              password: _passwordcontroller.text,
                              factors: [OktaSignInFactor.otp]).then((res) {
                            _processResult(res, formContext);

                            setState(() {});
                          });
                        }
                      } catch (e, s) {
                        debugPrint(e.toString() + s.toString());
                        if (formContext.mounted) {
                          ScaffoldMessenger.of(formContext).showSnackBar(
                              SnackBar(
                                  content: Text('Error: ${e.toString()}')));
                        }
                      }
                    },
                    child: const Text('Direct Authentication Login')),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Divider(),
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
                          scopes: ['openid', 'email', 'profile'],
                        ),
                      );
                  tokens = value;
                  if (mounted) {
                    PluginProvider.of(context)
                        .pluginWeb
                        .setTokens(value.tokens);
                  }
                } else {
                  var result = await Navigator.of(formContext).push(
                      MaterialPageRoute(
                          builder: (c) => const WebSignInExample()));

                  if (result) {
                    if (mounted) {
                      await PluginProvider.of(context)
                          .plugin
                          .getCredential()
                          .then((cred) {
                        _processResult(cred, formContext);
                        setState(() {});
                      });
                    }
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
              child: const Text('Device SSO')),
          const Divider(),
          Text(
            'IDX',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          OutlinedButton(
            onPressed: () async {
              await PluginProvider.of(context)
                  .plugin
                  .idx
                  .startInteractionCodeFlow();
            },
            child: const Text(
              'Interaction Code Flow',
            ),
          )
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
                    if (mounted) {
                      ScaffoldMessenger.of(profileContext).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')));
                    }
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
                      if (mounted) {
                        ScaffoldMessenger.of(profileContext).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')));
                      }
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
