import 'package:agrodroneanalytics/screens/HomeScreen.dart';
import 'package:flutter/material.dart';


class SuccessScreen2 extends StatefulWidget {
  const SuccessScreen2({super.key});

  @override
  State<SuccessScreen2> createState() => _SuccessScreen2State();
}

class _SuccessScreen2State extends State<SuccessScreen2> with TickerProviderStateMixin {
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

    _fadeInOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideUnionUp = Tween<Offset>(
      begin: const Offset(0.0, 3.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _secondController, curve: Curves.easeOut));

    _fadeFinalImage1 = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _secondController, curve: Curves.easeIn));

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
          // Fondo verde animado Union.png
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

          // Imagen decorativa inferior izquierda Group 3.png
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

          // Contenido principal
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Great',
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'You are in',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 350,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1C8A52),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
