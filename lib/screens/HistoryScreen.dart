import 'package:flutter/material.dart';

import 'HistoryDetailScreen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo superior
            Image.asset(
              'assets/images/Group 18156.png',
              height: 60,
            ),

            const SizedBox(height: 40),

            // Título principal
            const Text(
              'Bienvenido al',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Historial\nde Actividades / Reportes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5DBE84),
              ),
            ),

            const SizedBox(height: 40),

            // Imagen ilustrativa del historial
            Image.asset(
              'assets/images/Group 18245.png',
              height: 250,
            ),

            const Spacer(),

            // Botón START
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryDetailScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DBE84),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔽 BottomNavigationBar aquí abajo 🔽
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1C8A52),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: 2, // ← para marcar "Historial" como activo
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/explore');
              break;
            case 2:
            // Ya estás en Historial
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
}
