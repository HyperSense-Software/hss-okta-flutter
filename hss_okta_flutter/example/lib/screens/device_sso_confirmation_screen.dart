import 'package:flutter/material.dart';
import 'package:hss_okta_flutter/hss_okta_flutter_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceSSOConfirmationScreen extends StatelessWidget {
  const DeviceSSOConfirmationScreen(
      {super.key, required this.session, required this.onConfirm});
  final DeviceAuthorizationSession session;
  final ValueSetter<BuildContext>? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device SSO Confirmation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText('user code : ${session.userCode}'),
            GestureDetector(
                onTap: () async {
                  var uri = Uri.parse(session.verificationUri ?? '');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
                child: Text(
                  '${session.verificationUri}',
                  style: const TextStyle(
                      decoration: TextDecoration.underline, color: Colors.blue),
                )),
            ElevatedButton(
              onPressed: () async {
                onConfirm?.call(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
