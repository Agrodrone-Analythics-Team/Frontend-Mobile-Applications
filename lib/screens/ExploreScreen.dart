import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'RutaGuardadaScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedIndex = 1;
  final MapController _mapController = MapController();
  double _zoom = 2;
  LatLng _currentCenter = LatLng(-16.409047, -71.537451);
  LatLng? _searchedPoint;
  final TextEditingController _scanFrequencyController = TextEditingController();
  final TextEditingController _animalCountController = TextEditingController();

  final TextEditingController _coordController = TextEditingController(text: "-16.409047, -71.537451");
  final TextEditingController _removeController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  List<LatLng> _points = [];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  void _zoomIn() {
    setState(() => _zoom++);
    _mapController.move(_currentCenter, _zoom);
  }

  void _zoomOut() {
    setState(() => _zoom--);
    _mapController.move(_currentCenter, _zoom);
  }

  void _goToCoordinates() {
    final coords = _coordController.text.split(',');
    if (coords.length == 2) {
      final lat = double.tryParse(coords[0].trim());
      final lng = double.tryParse(coords[1].trim());
      if (lat != null && lng != null) {
        final newPoint = LatLng(lat, lng);
        setState(() {
          _currentCenter = newPoint;
          _searchedPoint = newPoint; // Guardar punto buscado
        });
        _mapController.move(_currentCenter, _zoom);
      }
    }
  }

  void _removePoint() {
    final index = int.tryParse(_removeController.text);
    if (index != null && index > 0 && index <= _points.length) {
      setState(() {
        _points.removeAt(index - 1);
      });
    }
  }

  void _clearAllPoints() {
    setState(() => _points.clear());
  }

  void _addPoint(LatLng point) {
    setState(() {
      _points.add(point);
    });
  }

  void _openFlightManagementPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.97,
        maxChildSize: 1.0,
        minChildSize: 0.8,


        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setModalState) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Gestión de Vuelos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1C8A52))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _coordController,
                          decoration: const InputDecoration(labelText: 'Latitud, Longitud'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF1C8A52)),
                        onPressed: () {
                          _goToCoordinates();
                          setModalState(() {});
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              center: _currentCenter,
                              zoom: _zoom,
                              onTap: (tapPosition, point) {
                                _addPoint(point);
                                setModalState(() {});
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              PolygonLayer(
                                polygons: [
                                  Polygon(
                                    points: _points,
                                    color: Colors.green.withOpacity(0.5), // O sin opacidad si prefieres
                                    borderColor: Colors.green[800]!,
                                    borderStrokeWidth: 2.0,
                                    isFilled: true, // Este es opcional, pero algunos lo necesitan según versión
                                  )
                                ],
                              ),


                              MarkerLayer(
                                markers: [
                                  // Puntos rojos enumerados
                                  for (int i = 0; i < _points.length; i++)
                                    Marker(
                                      point: _points[i],
                                      width: 40,
                                      height: 40,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                          Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),

                                  // Punto verde para la búsqueda
                                  if (_searchedPoint != null)
                                    Marker(
                                      point: _searchedPoint!,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
                                    ),
                                ],
                              ),

                            ],
                          ),
                          // Botones de Zoom
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  heroTag: 'zoomIn',
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    setState(() => _zoom++);
                                    _mapController.move(_currentCenter, _zoom);
                                  },
                                  child: const Icon(Icons.zoom_in, color: Colors.black),
                                ),
                                const SizedBox(height: 8),
                                FloatingActionButton(
                                  heroTag: 'zoomOut',
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    setState(() => _zoom--);
                                    _mapController.move(_currentCenter, _zoom);
                                  },
                                  child: const Icon(Icons.zoom_out, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _removeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Eliminar punto #'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removePoint();
                          setModalState(() {});
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          _clearAllPoints();
                          setModalState(() {});
                        },
                        child: const Text('Eliminar todos'),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Horario del vuelo'),
                  Row(
                    children: [
                      Expanded(
                        child:TextField(
                          controller: _startTimeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Inicio (hh:mm:ss)',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            final formatted = _formatToTime(value);
                            setState(() {
                              _startTimeController.text = formatted;
                            });
                          },
                        ),





                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _endTimeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Fin (hh:mm:ss)',
                            border: OutlineInputBorder(),
                          ),
                          onEditingComplete: () {
                            final formatted = _formatToTime(_endTimeController.text);
                            setState(() {
                              _endTimeController.text = formatted;
                            });
                          },
                        ),


                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Text('Frecuencia de escaneo'),
                  TextField(
                    controller: _scanFrequencyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Ej. 5 veces que escanerea el dron',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Cantidad de animales'),
                  TextField(
                    controller: _animalCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Ej. 20 animales que hay en el área',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RutaGuardadaScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C8A52),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Aplicar'),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  String _formatToTime(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.padLeft(6, '0');
    final hh = value.substring(0, 2);
    final mm = value.substring(2, 4);
    final ss = value.substring(4, 6);
    return '$hh:$mm:$ss';
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C8A52),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _openFlightManagementPanel,
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Lista de vuelos\ndel Dron',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          _buildAreaItem('Central', 'assets/images/area_central.png'),
                          _buildAreaItem('Area 01', 'assets/images/area_01.png'),
                          _buildAreaItem('Area 02', 'assets/images/area_02.png'),
                          _buildAreaItem('Area 03', 'assets/images/area_03.png'),
                          _buildAreaItem('Area 04', 'assets/images/area_04.png'),
                          _buildAreaItem('Area 05', 'assets/images/area_05.png'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFFFF),
                        foregroundColor: const Color(0xFF1C8A52),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Iniciar vuelo de monitor',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Explore.png')),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Agro Assistant.png')),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/Profile.png')),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildAreaItem(String label, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            imagePath,
            height: 65,
            width: 65,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
