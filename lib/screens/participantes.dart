import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Participante> _participantes = [];
  List<Participante> _participantesFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchParticipantes();
  }

  Future<void> _fetchParticipantes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://161.132.37.95:8080/api/Participante'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          _participantes =
              jsonResponse.map((data) => Participante.fromJson(data)).toList();
          _participantesFiltrados = _participantes;
        });
      } else {
        throw Exception('Failed to load participantes');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterParticipantes(String query) {
    setState(() {
      if (query.isEmpty) {
        _participantesFiltrados = _participantes;
      } else {
        _participantesFiltrados = _participantes
            .where((participante) =>
                participante.nombre
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                participante.detalle
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                participante.equipoId
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participantes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade800, Colors.red.shade200],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar participantes...',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterParticipantes('');
                    },
                  ),
                ),
                onChanged: _filterParticipantes,
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : _participantesFiltrados.isEmpty
                      ? Center(
                          child: Text('No se encontraron participantes',
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          itemCount: _participantesFiltrados.length,
                          itemBuilder: (context, index) {
                            final participante = _participantesFiltrados[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.red.shade800,
                                            child: Text(
                                              participante.nombre
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              participante.nombre,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        participante.detalle,
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Equipo ID: ${participante.equipoId}',
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
