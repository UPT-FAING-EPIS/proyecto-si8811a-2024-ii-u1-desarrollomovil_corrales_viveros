import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo para los participantes
class Participante {
  final String id;
  final String nombre;
  final String detalle;
  final String equipoId;

  Participante({
    required this.id,
    required this.nombre,
    required this.detalle,
    required this.equipoId,
  });

  factory Participante.fromJson(Map<String, dynamic> json) {
    return Participante(
      id: json['id'],
      nombre: json['nombre'],
      detalle: json['detalle'],
      equipoId: json['equipoId'],
    );
  }
}

class ParticipantesScreen extends StatefulWidget {
  @override
  _ParticipantesScreenState createState() => _ParticipantesScreenState();
}

class _ParticipantesScreenState extends State<ParticipantesScreen> {
  late Future<List<Participante>> _participantes;

  @override
  void initState() {
    super.initState();
    _participantes = fetchParticipantes();
  }

  Future<List<Participante>> fetchParticipantes() async {
    final response =
        await http.get(Uri.parse('http://161.132.37.95:8080/api/Participante'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Participante.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load participantes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participantes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<Participante>>(
        future: _participantes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay participantes disponibles.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final participante = snapshot.data![index];
                return ListTile(
                  title: Text(participante.nombre),
                  subtitle: Text(participante.detalle),
                  trailing: Text(participante.equipoId),
                );
              },
            );
          }
        },
      ),
    );
  }
}
