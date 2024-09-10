import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EquiposScreen extends StatefulWidget {
  @override
  _EquiposScreenState createState() => _EquiposScreenState();
}

class _EquiposScreenState extends State<EquiposScreen> {
  late Future<List<Equipo>> _equipos;

  @override
  void initState() {
    super.initState();
    _equipos = fetchEquipos();
  }

  Future<List<Equipo>> fetchEquipos() async {
    final response = await http.get(Uri.parse('http://161.132.37.95:8080/api/Equipo'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Equipo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load equipos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Equipos'),
      ),
      body: FutureBuilder<List<Equipo>>(
        future: _equipos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No equipos found'));
          } else {
            final equipos = snapshot.data!;
            return ListView.builder(
              itemCount: equipos.length,
              itemBuilder: (context, index) {
                final equipo = equipos[index];
                return ListTile(
                  title: Text(equipo.nombre),
                  subtitle: Text(equipo.detalle),
                  trailing: Text('Participantes: ${equipo.participantes.length}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Equipo {
  final String id;
  final String nombre;
  final String detalle;
  final List<String> participantes;

  Equipo({
    required this.id,
    required this.nombre,
    required this.detalle,
    required this.participantes,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      participantes: List<String>.from(json['participantes']),
    );
  }
}
