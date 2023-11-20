import 'package:flutter/material.dart';
import 'package:hss_okta_flutter_example/provider/plugin_provider.dart';

class RedirectForm extends StatefulWidget {
  const RedirectForm({
    super.key,
  });

  @override
  State<RedirectForm> createState() => _RedirectFormState();
}

class _RedirectFormState extends State<RedirectForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final res = await PluginProvider.of(context).pluginWeb.parseFromUrl();

      if (mounted) {
        Navigator.of(context).pushNamed('/web-profile',
            arguments: {'token': res.tokens.accessToken?.accessToken ?? ''});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('parsing token...'),
      ),
    );
  }
}
