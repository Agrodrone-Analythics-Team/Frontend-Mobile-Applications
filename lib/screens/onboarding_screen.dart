import 'package:flutter/material.dart';

import 'OnboardingScreen2.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen superior con altura definida (por ejemplo, 55% de pantalla)
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.63, // ⬅️ ajusta aquí
              width: double.infinity,
              child: Image.asset(
                'assets/images/image.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenedor blanco en parte inferior, no afectado por la imagen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 360,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícono
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.asset(
                      'assets/images/Cash (1) 1.png',
                      width: 80,
                      color: Color(0xFF61C086),
                    ),
                  ),

                  const SizedBox(height: 40),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: const [
                        TextSpan(text: 'Welcome to Agro'),
                        TextSpan(
                          text: 'Drone',
                          style: TextStyle(
                            color: Color(0xFF61C086), // Verde
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 20),

                  const Text(
                    'Optimiza la ganadería con monitoreo inteligente en tiempo real.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF61C086),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OnboardingScreen2()),
                          );
                        },

                        child: const Text('Get Started'),
                      ),

                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration:  BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF61C086),
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}