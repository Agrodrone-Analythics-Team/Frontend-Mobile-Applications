import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'RutaGuardadaScreen.dart';

const String apiUrl = 'http://10.0.2.2:8000/api';

// Modelo para manejar los datos de un plan de vuelo
class FlightPlan {
  final int id;
  final String name;
  final List<LatLng> points;
  final String? imagePath;

  FlightPlan({required this.id, required this.name, required this.points, this.imagePath});

  // --- CONSTRUCTOR CORREGIDO ---
  factory FlightPlan.fromJson(Map<String, dynamic> json) {
    List<LatLng> pointsList = [];
    if (json['points'] != null && json['points'] is List) {
      // El backend ya envía una lista, no necesitamos jsonDecode.
      // Simplemente la usamos directamente.
      var parsedPoints = json['points'] as List;
      pointsList = List<LatLng>.from(
          parsedPoints.map((p) => LatLng(p['latitude'], p['longitude'])));
    }
    return FlightPlan(
      id: json['id'],
      name: json['name'],
      points: pointsList,
      imagePath: json['image_path'],
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Estado de la UI principal
  int _selectedIndex = 1;
  late Future<List<FlightPlan>> _flightPlansFuture;

  // Controladores y estado para el panel de gestión de vuelos
  final MapController _mapController = MapController();
  final TextEditingController _flightPlanNameController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _scanFrequencyController = TextEditingController();
  final TextEditingController _animalCountController = TextEditingController();

  List<LatLng> _points = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _flightPlansFuture = _fetchFlightPlans();
  }

  // --- LÓGICA DE API Y AUTENTICACIÓN ---

  Future<String?> _getAuthToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'access_token');
  }

  Future<void> _refreshFlightPlans() {
    setState(() {
      _flightPlansFuture = _fetchFlightPlans();
    });
    return _flightPlansFuture;
  }

  Future<List<FlightPlan>> _fetchFlightPlans() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Usuario no autenticado. Por favor, inicie sesión.');

    final response = await http.get(
      Uri.parse('$apiUrl/flight-plans/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => FlightPlan.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los planes de vuelo.');
    }
  }

  Future<void> _saveFlightPlan() async {
    if (_points.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Defina al menos 3 puntos para crear un área.")));
      return;
    }

    setState(() => _isSaving = true);

    final token = await _getAuthToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error de autenticación.")));
      setState(() => _isSaving = false);
      return;
    }

    final pointsForApi = _points.map((p) => {'latitude': p.latitude, 'longitude': p.longitude}).toList();

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/flight-plans/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': _flightPlanNameController.text,
          'points': pointsForApi,
          'start_time': _startTimeController.text,
          'end_time': _endTimeController.text,
          'scan_frequency': int.tryParse(_scanFrequencyController.text) ?? 0,
          'animal_count': int.tryParse(_animalCountController.text) ?? 0,
        }),
      );

      if (mounted) {
        if (response.statusCode == 201) {
          final newPlanData = jsonDecode(response.body);
          final newPlanId = newPlanData['id'];

          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RutaGuardadaScreen(flightPlanId: newPlanId)),
          ).then((_) {
            _refreshFlightPlans();
          });

        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
        }
      }
    } catch(e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // --- FUNCIONES DE LA INTERFAZ ---

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0: Navigator.pushReplacementNamed(context, '/home'); break;
      case 1: break;
      case 2: Navigator.pushReplacementNamed(context, '/history'); break;
      case 3: Navigator.pushReplacementNamed(context, '/profile'); break;
    }
  }

  void _openFlightManagementPanel() {
    _points.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _scanFrequencyController.clear();
    _animalCountController.clear();
    _flightPlanNameController.text = "Plan Vuelo ${DateTime.now().hour}:${DateTime.now().minute}";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        maxChildSize: 1.0,
        minChildSize: 0.5,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setModalState) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Gestión de Vuelos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C8A52))),
                const SizedBox(height: 12),
                TextField(controller: _flightPlanNameController, decoration: const InputDecoration(labelText: 'Nombre del Plan de Vuelo', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: const LatLng(-16.409047, -71.537451),
                        initialZoom: 5,
                        onTap: (tapPosition, point) => setModalState(() => _points.add(point)),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.agrodroneanalytics',
                        ),
                        PolygonLayer(polygons: [ if (_points.length > 1) Polygon(points: _points, color: Colors.green.withOpacity(0.5), borderColor: Colors.green[800]!, borderStrokeWidth: 2.0, isFilled: true)]),
                        MarkerLayer(markers: [ for (int i = 0; i < _points.length; i++) Marker(point: _points[i], width: 40, height: 40, child: Stack(alignment: Alignment.center, children: [ const Icon(Icons.location_pin, color: Colors.red, size: 40), Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => setModalState(() => _points.clear()), child: const Text('Eliminar todos')),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Horario del vuelo'),
                Row(children: [
                  Expanded(child: TextField(controller: _startTimeController, decoration: const InputDecoration(labelText: 'Inicio (hh:mm:ss)', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _endTimeController, decoration: const InputDecoration(labelText: 'Fin (hh:mm:ss)', border: OutlineInputBorder()))),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: TextField(controller: _scanFrequencyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Frecuencia', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _animalCountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'N° Animales', border: OutlineInputBorder()))),
                ]),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveFlightPlan,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C8A52), foregroundColor: Colors.white),
                      child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Siguiente'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C8A52),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Lista de vuelos\ndel Dron', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ]),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshFlightPlans,
                        child: FutureBuilder<List<FlightPlan>>(
                          future: _flightPlansFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No hay planes de vuelo guardados."));
                            }
                            final plans = snapshot.data!;
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                              itemCount: plans.length,
                              itemBuilder: (context, index) {
                                final plan = plans[index];
                                final imageWidget = plan.imagePath != null && plan.imagePath!.isNotEmpty
                                    ? Image.network('http://10.0.2.2:8000/${plan.imagePath!.replaceAll('\\', '/')}', fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.asset('assets/images/area_01.png', fit: BoxFit.cover))
                                    : Image.asset('assets/images/area_01.png', fit: BoxFit.cover);

                                return _buildAreaItem(plan.name, imageWidget);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _openFlightManagementPanel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C8A52),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Crear Plan de Vuelo', style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1C8A52),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Home.png')), label: 'Home'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Explore.png')), label: 'Explore'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Agro Assistant.png')), label: 'Historial'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Profile.png')), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildAreaItem(String label, Widget image) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: SizedBox(
            height: 65,
            width: 65,
            child: image,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
