import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

class PluginProvider extends InheritedWidget {
  final HssOktaFlutterWeb pluginWeb;
  final HssOktaFlutter plugin;

  const PluginProvider({
    super.key,
    required super.child,
    required this.plugin,
    required this.pluginWeb,
  });

  static PluginProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PluginProvider>();
  }

  static PluginProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'No PluginProvider found in context');
    return provider!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
