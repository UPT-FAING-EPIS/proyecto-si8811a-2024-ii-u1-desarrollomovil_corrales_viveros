import 'package:flutter/material.dart';
import 'services/auth.dart';
import 'screens/menu.dart';

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
          title: 'Flutter Demo Home Page', navigatorKey: navigatorKey),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.navigatorKey});

  final String title;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget.navigatorKey);
    _authService.initialize();
  }

  void _login() async {
    try {
      final userName = await _authService.login();
      if (userName != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(userName: userName),
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
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
        child: ElevatedButton(
          onPressed: _login,
          child: const Text('Login with Azure'),
        ),
      ),
    );
  }
}
