import 'package:flutter/material.dart';

import 'CameraScreen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // Encabezado con íconos y saludo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.fullscreen, size: 40),
                  onPressed: () {
                    Navigator.pushNamed(context, '/deteccion'); // ✅ usa la ruta segura
                  },
                ),


                Image.asset('assets/images/Group 18156.png', height: 40),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline, size: 28),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                )
              ],
            ),
            const SizedBox(height: 12),

            // Bienvenida y ubicación
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Welcome John,', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Arequipa, AG', style: TextStyle(color: Colors.grey)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // Vista general de métricas
            const Text('Vista general de métricas',
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 140,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/vacas.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.4),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Número total de animales', style: TextStyle(color: Colors.white, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('99%', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('Protección activa', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Animales perdidos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Animales perdidos hoy', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Ver más', style: TextStyle(color: Colors.teal)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilterChip(label: Text('All'), selected: true, onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: Text('Vaca'), selected: false, onSelected: (_) {}),
                const SizedBox(width: 8),
                FilterChip(label: Text('Oveja'), selected: false, onSelected: (_) {}),
              ],
            ),

            const SizedBox(height: 20),

            // Área
            const Text('Area', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(
              height: 175, // ← Aumentado para evitar overflow
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAreaCard('Area 01', 'Vaca', 'N=2', 'assets/images/Mask group.png'),
                  const SizedBox(width: 12),
                  _buildAreaCard('Area 04', 'Oveja', 'N=0', 'assets/images/Mask group (1).png'),
                ],
              ),
            ),


            const SizedBox(height: 20),

            // Actividad promedio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Actividad promedio (últimas 24h).', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Ver más', style: TextStyle(color: Colors.teal)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildActivityCard('Seeds for Vegetation', 'assets/images/seeds.jpg'),
                  const SizedBox(width: 12),
                  _buildActivityCard('Cattles', 'assets/images/cattles.jpg'),
                ],
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
            case 0:
            // Ya estás en Home
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/explore');
              break;
            case 2:
             Navigator.pushReplacementNamed(context, '/history');
              break;
            case 3:
             Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
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

  Widget _buildAreaCard(String area, String tipo, String cantidad, String imagePath) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(area, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(tipo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(cantidad, style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActivityCard(String title, String imagePath) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
