import 'package:flutter/material.dart';

import 'CameraScreen.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado superior con logo y acciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.fullscreen, size: 40),
                    onPressed: () {
                      Navigator.pushNamed(context, '/deteccion'); // ✅ usa la ruta segura
                    },
                  ),


                  Image.asset('assets/images/Group 18156.png', height: 60),
                  const SizedBox(
                    width: 40,
                  ), // mismo ancho que el icono izquierdo
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Foto de perfil y nombre
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
            const SizedBox(height: 8),
            const Text(
              "Onyeoghani Godfrey",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("@godfrey_inc", style: TextStyle(color: Colors.black54)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Color(0xFFE8F9F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "User",
                style: TextStyle(color: Color(0xFF1C8A52), fontSize: 12),
              ),
            ),
            const SizedBox(height: 4),
            const Text("Add a bio", style: TextStyle(color: Colors.black38)),

            const SizedBox(height: 8),
            const Text(
              "0 Followers",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            // Botones de Settings e Inbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },

                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.orange,
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text("Settings"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications'); // ← asegúrate de tener esta ruta definida
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF6464FB),
                          child: const Icon(Icons.inbox, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        const Text("Inbox"),
                      ],
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sección: novedades
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDEEFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Novedades\nView Bank account, withdraw & more",
                style: TextStyle(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDDF2E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "¿Cuál es tu oferta hoy?\nLet customers see what you are upto today?",
                style: TextStyle(color: Colors.black87),
              ),
            ),

            const SizedBox(height: 20),

            // Transacciones recientes
            const Text(
              "Transacciones recientes",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1C8A52),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildTransactionItem(
                    Icons.arrow_downward,
                    "dron en listo para monitor",
                    "Feb 14, 2023 at 08:20 AM",
                    "1 min",
                    Colors.green,
                  ),
                  _buildTransactionItem(
                    Icons.arrow_upward,
                    "recargando dron",
                    "Feb 14, 2023 at 08:11 AM",
                    "10 min",
                    Colors.red,
                  ),
                  _buildTransactionItem(
                    Icons.arrow_upward,
                    "dron baja bateria",
                    "Feb 14, 2023 at 08:01 AM",
                    "20 min",
                    Colors.red,
                  ),
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
        currentIndex: 3, // 👈 para marcar "Perfil" como activo
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/explore');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 3:
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

  Widget _buildTransactionItem(
    IconData icon,
    String title,
    String date,
    String duration,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(duration, style: TextStyle(color: color)),
    );
  }
}
