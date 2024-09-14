import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UbicacionesScreen extends StatefulWidget {
  @override
  _UbicacionesScreenState createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  late Future<Lugar> _lugar;

  @override
  void initState() {
    super.initState();
    _lugar = fetchLugar();
  }

  Future<Lugar> fetchLugar() async {
    final response = await http.get(Uri.parse(
        'http://161.132.48.189:8000/lugares/3b466d5f-a86a-46dd-b8d7-f7be46edc8b0'));

    if (response.statusCode == 200) {
      return Lugar.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load lugar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Ubicaciones', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade800, Colors.green.shade200],
          ),
        ),
        child: FutureBuilder<Lugar>(
          future: _lugar,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData) {
              return Center(
                  child: Text('No se encontró el lugar',
                      style: TextStyle(color: Colors.white)));
            } else {
              final lugar = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lugar.nombreLugar,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SizedBox(height: 8),
                        Text('Descripción: ${lugar.descripcion}'),
                        SizedBox(height: 8),
                        Text('Capacidad: ${lugar.capacidad}'),
                        SizedBox(height: 8),
                        Text('Latitud: ${lugar.latitud}'),
                        Text('Longitud: ${lugar.longitud}'),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Lugar {
  final String id;
  final String rev;
  final String nombreLugar;
  final String direccionId;
  final int capacidad;
  final String descripcion;
  final double latitud;
  final double longitud;
  final String idCategoria;

  Lugar({
    required this.id,
    required this.rev,
    required this.nombreLugar,
    required this.direccionId,
    required this.capacidad,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.idCategoria,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      id: json['_id'],
      rev: json['_rev'],
      nombreLugar: json['nombre_lugar'],
      direccionId: json['direccion_id'],
      capacidad: json['capacidad'],
      descripcion: json['descripcion'],
      latitud: json['latitud'].toDouble(),
      longitud: json['longitud'].toDouble(),
      idCategoria: json['id_categoria'],
    );
  }
}
