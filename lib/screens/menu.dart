import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final String userName;

  const MenuScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Text('Bienvenido: $userName'),
      ),
    );
  }
}
