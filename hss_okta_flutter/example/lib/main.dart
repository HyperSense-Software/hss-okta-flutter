import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';
import 'package:hss_okta_flutter_example/provider/plugin_provider.dart';
import 'package:hss_okta_flutter_example/screens/home_screen.dart';
import 'package:hss_okta_flutter_example/web/redirect_form.dart';
import 'package:hss_okta_flutter_example/web/web_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationResult? result;
  final _pluginWeb = HssOktaFlutterWeb();
  final _plugin = HssOktaFlutter();

  @override
  void initState() {
    super.initState();
    // For WEB
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (kIsWeb) {
        await _pluginWeb.initializeClient(
            oktaConfig: OktaConfig(
          issuer: '',
          clientId: '',
          redirectUri: '',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final url = Uri.parse(settings.name!);
        final args = settings.arguments;

        switch (url.path) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const HomeScreen(),
            );
          case '/login':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const RedirectForm(),
            );
          case '/web-profile':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                if (args is Map<String, dynamic>) {
                  return WebProfileScreen(token: args['token'] as String);
                }

                return WebProfileScreen(token: '');
              },
            );
        }

        return null;
      },
      builder: (context, child) {
        return Scaffold(
            body: PluginProvider(
          pluginWeb: _pluginWeb,
          plugin: _plugin,
          child: child!,
        ));
      },
    );
  }
}
