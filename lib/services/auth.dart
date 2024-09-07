import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthService(this.navigatorKey);

  late final AadOAuth oauth;

  void initialize() {
    final config = Config(
      tenant: 'b6b466ee-468d-4011-b9fc-fbdcf82ac90a',
      clientId: '7b76e06c-55f8-4c8e-a576-c42f68be15c3',
      scope: 'openid profile email offline_access',
      redirectUri:
          'https://login.microsoftonline.com/common/oauth2/nativeclient',
      navigatorKey: navigatorKey,
    );

    oauth = AadOAuth(config);
  }

  Future<String?> login() async {
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      print('Access token: $accessToken');
      String nametoken = accessToken.toString();
      final jwt = JWT.decode(nametoken);
      final name = jwt.payload['name'] as String?;

      return name ?? 'Usuario desconocido';
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
