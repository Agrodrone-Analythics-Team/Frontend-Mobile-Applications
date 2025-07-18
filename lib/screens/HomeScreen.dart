import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// --- MODELOS DE DATOS ---

// Modelo para el perfil del usuario
class UserProfile {
  final String firstName;
  final String address;
  final String city;
  final String state;
  final int totalAnimalsDetected;

  UserProfile({
    required this.firstName,
    required this.address,
    required this.city,
    required this.state,
    required this.totalAnimalsDetected,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['first_name'] ?? 'Usuario',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      totalAnimalsDetected: json['total_animals_detected'] ?? 0,
    );
  }
}

// Modelo para los planes de vuelo
class FlightPlan {
  final String name;
  final int animalCount;
  final int scanFrequency;

  FlightPlan({
    required this.name,
    required this.animalCount,
    required this.scanFrequency,
  });

  factory FlightPlan.fromJson(Map<String, dynamic> json) {
    return FlightPlan(
      name: json['name'] ?? 'Área sin nombre',
      animalCount: json['animal_count'] ?? 0,
      scanFrequency: json['scan_frequency'] ?? 0,
    );
  }
}

// --- PANTALLA PRINCIPAL ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserProfile> _userProfileFuture;
  late Future<List<FlightPlan>> _flightPlansFuture;

  // Lista de imágenes para asignar al azar a las áreas
  final List<String> _areaImages = [
    'assets/images/area_01.png',
    'assets/images/area_02.png',
    'assets/images/area_03.png',
    'assets/images/area_04.png',
    'assets/images/area_05.png',
  ];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _fetchUserData();
    _flightPlansFuture = _fetchAllFlightPlans();
  }

  // --- FUNCIONES DE API ---

  Future<UserProfile> _fetchUserData() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error al cargar datos del usuario.');
    }
  }

  Future<List<FlightPlan>> _fetchAllFlightPlans() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/flight-plans/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => FlightPlan.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los planes de vuelo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.fullscreen, size: 40), onPressed: () => Navigator.pushNamed(context, '/deteccion')),
                Image.asset('assets/images/Group 18156.png', height: 40),
                IconButton(icon: const Icon(Icons.chat_bubble_outline, size: 28), onPressed: () => Navigator.pushNamed(context, '/notifications')),
              ],
            ),
            const SizedBox(height: 12),

            // Bienvenida y ubicación (con FutureBuilder)
            FutureBuilder<UserProfile>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  final location = [user.address, user.city, user.state].where((s) => s.isNotEmpty).join(', ');
                  return Row(children: [
                    const CircleAvatar(backgroundImage: AssetImage('assets/images/seeds.png')),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome ${user.firstName},', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(location.isNotEmpty ? location : 'Ubicación no definida', style: const TextStyle(color: Colors.grey)),
                    ]),
                  ]);
                }
                return const SizedBox.shrink(); // No muestra nada si hay error, para no romper la UI
              },
            ),
            const SizedBox(height: 20),

            // Vista general de métricas
            const Text('Vista general de métricas', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<UserProfile>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                final totalAnimals = snapshot.hasData ? snapshot.data!.totalAnimalsDetected : 0;
                return Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: const DecorationImage(image: AssetImage('assets/images/vacas.png'), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black.withOpacity(0.4)),
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Número total de animales', style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('$totalAnimals', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Protección activa', style: TextStyle(color: Colors.white70)),
                    ]),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Animales perdidos
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('Animales perdidos hoy', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Ver más', style: TextStyle(color: Colors.teal)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              FilterChip(label: const Text('All'), selected: true, onSelected: (_) {}),
              const SizedBox(width: 8),
              FilterChip(label: const Text('Vaca'), selected: false, onSelected: (_) {}),
              const SizedBox(width: 8),
              FilterChip(label: const Text('Oveja'), selected: false, onSelected: (_) {}),
            ]),
            const SizedBox(height: 20),

            // --- SECCIÓN DE ÁREA DINÁMICA ---
            const Text('Áreas Registradas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 175,
              child: FutureBuilder<List<FlightPlan>>(
                future: _flightPlansFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error al cargar áreas: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No hay áreas registradas."));
                  }

                  final plans = snapshot.data!;
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: plans.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final randomImagePath = _areaImages[_random.nextInt(_areaImages.length)];
                      return _buildAreaCard(plan, randomImagePath);
                    },
                  );
                },
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
        onTap: (index) {
          switch (index) {
            case 0: break;
            case 1: Navigator.pushReplacementNamed(context, '/explore'); break;
            case 2: Navigator.pushReplacementNamed(context, '/history'); break;
            case 3: Navigator.pushReplacementNamed(context, '/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Home.png')), label: 'Home'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Explore.png')), label: 'Explore'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Agro Assistant.png')), label: 'Historial'),
          BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/icons/Profile.png')), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildAreaCard(FlightPlan plan, String imagePath) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text("Animales: ${plan.animalCount}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Frecuencia: ${plan.scanFrequency}", style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
