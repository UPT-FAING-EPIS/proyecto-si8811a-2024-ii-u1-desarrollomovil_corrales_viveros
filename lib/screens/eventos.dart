import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventosScreen extends StatefulWidget {
  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  late Future<List<Evento>> _eventos;
  List<Evento> _eventosFiltrados = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _eventos = fetchEventos();
  }

  Future<List<Evento>> fetchEventos() async {
    final response = await http.get(Uri.parse('http://161.132.48.189:9091/evento'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Evento> eventos = data.map((json) => Evento.fromJson(json)).toList();
      _eventosFiltrados = eventos;
      return eventos;
    } else {
      throw Exception('Failed to load eventos');
    }
  }

  void _filterEventos(String query) {
    setState(() {
      if (query.isEmpty) {
        _eventos.then((eventos) {
          _eventosFiltrados = eventos;
        });
      } else {
        _eventos.then((eventos) {
          _eventosFiltrados = eventos
              .where((evento) =>
                  evento.nombre.toLowerCase().contains(query.toLowerCase()))
              .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade200],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar eventos...',
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
                      _filterEventos('');
                    },
                  ),
                ),
                onChanged: _filterEventos,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Evento>>(
                future: _eventos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.white));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No se encontraron eventos', style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: _eventosFiltrados.length,
                      itemBuilder: (context, index) {
                        final evento = _eventosFiltrados[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                evento.nombre,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade800),
                                      SizedBox(width: 8),
                                      Text(
                                        '${DateFormat('dd/MM/yyyy').format(evento.fechaInicio)} - ${DateFormat('dd/MM/yyyy').format(evento.fechaTermino)}',
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.school, size: 16, color: Colors.blue.shade800),
                                      SizedBox(width: 8),
                                      Text(
                                        evento.facultad,
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                                      SizedBox(width: 8),
                                      Text(
                                        'Resultado: ${evento.resultado == 'Vacio' ? 'Aún por verse' : evento.resultado}',
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade800),
                              onTap: () {
                                // Aquí puedes agregar la navegación a los detalles del evento
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
          ],
        ),
      ),
    );
  }
}

class Evento {
  final String id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaTermino;
  final String facultad;
  final String resultado;

  Evento({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.facultad,
    required this.resultado,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nombre: json['nombre'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaTermino: DateTime.parse(json['fechaTermino']),
      facultad: json['facultad'],
      resultado: json['resultado'],
    );
  }
}