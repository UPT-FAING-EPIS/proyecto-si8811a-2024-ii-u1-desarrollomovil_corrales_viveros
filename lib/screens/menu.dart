import 'package:flutter/material.dart';
import 'eventos.dart';
import 'equipos.dart';
import 'participantes.dart';
import '../services/auth.dart'; // Solo si necesitas usar AuthService aquí, de lo contrario, elimínalo

class MenuScreen extends StatelessWidget {
  final String userName;

  const MenuScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Bienvenido, $userName'), // Mostrar el nombre del usuario aquí
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard('Eventos', 'assets/eventos.png', Colors.blue, context,
                  EventosScreen()),
              _buildCard('Ubicaciones', 'assets/ubicaciones.png', Colors.green,
                  context, null),
              _buildCard('Equipos', 'assets/equipos.png', Colors.orange,
                  context, EquiposScreen()),
              _buildCard('Participantes', 'assets/participantes.png',
                  Colors.red, context, ParticipantesScreen()),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      final authService = AuthService(
          Navigator.of(context).widget.key as GlobalKey<NavigatorState>);
      await authService.logout();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  Widget _buildCard(String title, String imagePath, Color color,
      BuildContext context, Widget? destination) {
    return Card(
      color: color,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Espacio entre cards
      child: InkWell(
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 120.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
