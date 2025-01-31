import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

import '../provider/plugin_provider.dart';

class WebProfileScreen extends StatefulWidget {
  const WebProfileScreen({
    super.key,
    this.tokens,
  });

  final TokenResponse? tokens;

  @override
  State<WebProfileScreen> createState() => _WebProfileScreenState();
}

class _WebProfileScreenState extends State<WebProfileScreen> {
  final ValueNotifier<int> _nextExpiry = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nextExpiry.value = widget.tokens?.tokens.accessToken?.expiresAt ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final provider = PluginProvider.of(context);
                  if (kIsWeb) {
                    if (widget.tokens?.tokens.accessToken != null) {
                      var response = await provider.pluginWeb.renewToken(
                        tokenToRefresh: widget.tokens!.tokens.accessToken!,
                      );

                      if (context.mounted) {
                        _nextExpiry.value = (response as AccessToken).expiresAt;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Token refreshed, next Expiration : ${DateTime.fromMillisecondsSinceEpoch(_nextExpiry.value * 1000)} ',
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text("Renew Token"),
              ),
              ValueListenableBuilder<int>(
                  valueListenable: _nextExpiry,
                  builder: (context, expiry, _) {
                    return Flexible(
                      child: Text(
                        'Token expiry: ${DateTime.fromMillisecondsSinceEpoch(expiry * 1000)}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }),
              Flexible(
                child: Text(
                  'has Access Token: ${widget.tokens!.tokens.accessToken != null}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Flexible(
                child: Text(
                  'has Id Token: ${widget.tokens!.tokens.idToken != null}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          FutureBuilder<UserClaims>(
              future: PluginProvider.of(context).pluginWeb.getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  return Column(
                    children: [
                      Text('Email: ${user?.email}'),
                      Text('Name: ${user?.name}'),
                    ],
                  );
                }
                return const SizedBox();
              }),
          const Spacer(),
          OutlinedButton(
            onPressed: () async {
              final provider = PluginProvider.of(context);
              final result = await provider.pluginWeb.signOut() ?? false;
              if (context.mounted) {
                if (result) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
              }
            },
            child: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
