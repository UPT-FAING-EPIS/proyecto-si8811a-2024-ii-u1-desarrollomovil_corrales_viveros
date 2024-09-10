import 'package:flutter/material.dart';
import 'services/auth.dart';
import 'screens/menu.dart'; // Asegúrate de que esta importación sea correcta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        navigatorKey: navigatorKey,
      ),
      routes: {
        '/login': (context) => MyHomePage(
              title: 'Flutter Demo Home Page',
              navigatorKey: navigatorKey,
            ),
        '/menu': (context) => MenuScreen(
            userName:
                'userName'), // Asegúrate de definir userName adecuadamente
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.navigatorKey,
  });

  final String title;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AuthService _authService;
  String? userName;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.navigatorKey);
  }

  void _login() async {
    try {
      print('Iniciando sesión...');
      final name = await _authService.login();
      if (name != null) {
        setState(() {
          userName = name;
        });
        _navigateToMenu();
      }
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
    }
  }

  void _navigateToMenu() {
    if (userName != null) {
      Navigator.pushReplacementNamed(
        context,
        '/menu',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: userName == null
            ? ElevatedButton(
                onPressed: _login,
                child: const Text('Login with Azure'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido, $userName!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
      ),
    );
  }
}
