import 'package:agrodroneanalytics/screens/login_screen.dart';
import 'package:agrodroneanalytics/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _secondController;

  late Animation<Offset> _slideFromBottomLeft;
  late Animation<Offset> _slideUnionUp;
  late Animation<double> _fadeInOpacity;
  late Animation<double> _fadeFinalImage1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _secondController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideFromBottomLeft = Tween<Offset>(
      begin: const Offset(-1.1, 3.5),
      end: const Offset(-0.1, 2.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeInOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideUnionUp = Tween<Offset>(
      begin: const Offset(0.0, 3.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _secondController, curve: Curves.easeOut));

    _fadeFinalImage1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondController, curve: Curves.easeIn),
    );

    _controller.forward();
    _secondController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF5DBE84),
      body: Stack(
        children: [
          // Fondo verde animado - Union.png
          SlideTransition(
            position: _slideUnionUp,
            child: FadeTransition(
              opacity: _fadeFinalImage1,
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width * 1.5,
                maxHeight: MediaQuery.of(context).size.height * 1.5,
                child: Transform.scale(
                  scale: 1.98,
                  child: Image.asset(
                    'assets/images/Union.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Imagen decorativa inferior izquierda - Group 3.png
          SlideTransition(
            position: _slideFromBottomLeft,
            child: FadeTransition(
              opacity: _fadeInOpacity,
              child: Image.asset(
                'assets/images/Group 3.png',
                width: 300,
              ),
            ),
          ),

          // Botones y contenido
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón Sign In
                  SizedBox(
                    width: 240,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón Sign Up
                  SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1C8A52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Imagen central encima de todo
          Center(
            child: Image.asset(
              'assets/images/Group 18348.png',
              width: 300, // puedes ajustar este tamaño
            ),
          ),

        ],
      ),
    );
  }
}
