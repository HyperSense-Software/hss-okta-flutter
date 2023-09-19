import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BrowserSignInScreen extends StatefulWidget {
  const BrowserSignInScreen({super.key});

  @override
  State<BrowserSignInScreen> createState() => _BrowserSignInScreenState();
}

class _BrowserSignInScreenState extends State<BrowserSignInScreen> {
  String viewType = '<platform-view-type>';
  Map<String, dynamic> creationParams = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
