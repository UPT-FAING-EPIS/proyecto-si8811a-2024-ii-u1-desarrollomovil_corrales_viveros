import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para almacenar el token
import 'listareventos.dart'; // Asegúrate de importar listareventos.dart

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String authorizationUrl = 'http://localhost:5000/login'; // URL de tu API Flask
  final String redirectUri = 'com.yourapp://callback'; // URI de redirección

  Future<void> _login() async {
    final result = await FlutterWebAuth.authenticate(
      url: authorizationUrl,
      callbackUrlScheme: 'com.yourapp',
    );

    // Extrae el token de acceso del resultado
    final Uri resultUri = Uri.parse(result);
    final String? accessToken = resultUri.queryParameters['access_token'];

    if (accessToken != null) {
      // Guarda el token de acceso
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      // Navega a la pantalla de eventos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventsListScreen()),
      );
    } else {
      // Maneja el error si no se obtiene el token
      print('Error: No se obtuvo el token de acceso');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Microsoft'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: Text('Login with Microsoft'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
