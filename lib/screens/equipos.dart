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
    final response =
        await http.get(Uri.parse('http://161.132.37.95:8080/api/Equipo'));
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
        title: Text('Equipos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade800, Colors.orange.shade200],
          ),
        ),
        child: FutureBuilder<List<Equipo>>(
          future: _equipos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No se encontraron equipos',
                      style: TextStyle(color: Colors.white)));
            } else {
              final equipos = snapshot.data!;
              return ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          equipo.nombre,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              equipo.detalle,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.people,
                                    size: 16, color: Colors.orange.shade800),
                                SizedBox(width: 8),
                                Text(
                                  'Participantes: ${equipo.participantes.length}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.orange.shade800),
                        onTap: () {
                          // Aquí puedes agregar la navegación a los detalles del equipo
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
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
