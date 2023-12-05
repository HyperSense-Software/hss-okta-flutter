import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    return Text(JwtDecoder.decode(token).toString());
  }
}
