import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  late Future<List<Evento>> _eventos;

  @override
  void initState() {
    super.initState();
    _eventos = fetchEventos();
  }

  Future<List<Evento>> fetchEventos() async {
    // Usa la URL del endpoint copiado desde Swagger
    final response = await http.get(Uri.parse('http://localhost:9091/api/eventos'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Evento.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load eventos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Eventos'),
      ),
      body: FutureBuilder<List<Evento>>(
        future: _eventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            final eventos = snapshot.data!;
            return ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return ListTile(
                  title: Text(evento.nombre),
                  subtitle: Text('Desde: ${evento.fechaInicio} Hasta: ${evento.fechaTermino}'),
                  trailing: Text(evento.facultad),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Evento {
  final String id;
  final String nombre;
  final String fechaInicio;
  final String fechaTermino;
  final String facultad;

  Evento({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.facultad,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: json['fechaInicio'],
      fechaTermino: json['fechaTermino'],
      facultad: json['facultad'],
    );
  }
}
