import 'package:flutter/widgets.dart';
import 'package:hss_okta_flutter/hss_okta_flutter.dart';

/// function signature for the [HssOktaBrowserSignOutWidget.builder] property
/// The [child] is the native platform view for the browser
typedef AuthBrowserBuilder = Widget Function(
  BuildContext context,
  Widget child,
);
