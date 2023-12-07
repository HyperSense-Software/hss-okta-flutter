import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../provider/plugin_provider.dart';

class WebProfileScreen extends StatelessWidget {
  const WebProfileScreen({
    required this.accessToken,
    super.key,
    required this.token,
  });
  final String token;
  final String accessToken;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            onPressed: () async {
              final provider = PluginProvider.of(context);
              if (kIsWeb) {
                await provider.pluginWeb.signOut();
                // if (isSignedOut) {
                //   Navigator.of(context).pushReplacementNamed('/');
                // }
              }
            },
            child: const Text("Sign out"))
      ],
    );
  }
}
