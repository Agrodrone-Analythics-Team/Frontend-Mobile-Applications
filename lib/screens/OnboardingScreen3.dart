import 'package:flutter/material.dart';

import 'WelcomeScreen.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen superior
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.63,
              width: double.infinity,
              child: Image.asset(
                'assets/images/image 1.png', // <-- Cambia a tu imagen de la playa
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenedor blanco con contenido
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
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(text: 'Welcome to Agro'),
                        TextSpan(
                          text: 'Serve',
                          style: TextStyle(color: Color(0xFF61C086)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Gestiona tu ganado de forma remota y precisa, estés donde estés.',
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          );
                        },
                        child: const Text('Get Started'),
                      ),

                      Row(
                        children: [
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
