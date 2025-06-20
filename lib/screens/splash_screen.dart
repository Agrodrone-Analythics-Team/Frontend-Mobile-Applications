import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _secondController;

  late Animation<Offset> _slideFromBottomLeft;
  late Animation<Offset> _slideFromTop;
  late Animation<double> _fadeInOpacity;
  late Animation<double> _fadeOverlayOpacity;
  late Animation<double> _fadeOutBaseOpacity;

  late Animation<double> _fadeFinalImage1;
  late Animation<Offset> _slideUnionUp;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideFromBottomLeft = Tween<Offset>(
      begin: const Offset(-1.1, 3.5),
      end: const Offset(-0.1, 2.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeInOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _fadeOverlayOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)));

    _fadeOutBaseOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));

    _slideFromTop = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeFinalImage1 = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _secondController, curve: Curves.easeIn));

    _slideUnionUp = Tween<Offset>(
      begin: const Offset(0.0, 3.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _secondController, curve: Curves.easeOut));

// Navegar al finalizar animaciones
    _controller.forward().whenComplete(() {
      _secondController.forward().whenComplete(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      });
    });

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo animado: Union.png sube y aparece
          SlideTransition(
            position: _slideUnionUp,
            child: FadeTransition(
              opacity: _fadeFinalImage1,
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width * 1.5,
                maxHeight: MediaQuery.of(context).size.height * 1.5,
                child: Transform.scale(
                  scale: 1.98, // Ajusta si deseas aún más grande
                  child: Image.asset(
                    'assets/images/Union.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),


          // Imagen base que desaparece
          Center(
            child: FadeTransition(
              opacity: _fadeOutBaseOpacity,
              child: Image.asset(
                'assets/images/Group 18347.png',
                width: 500,
              ),
            ),
          ),

          // Imagen que cae desde arriba
          Center(
            child: SlideTransition(
              position: _slideFromTop,
              child: FadeTransition(
                opacity: _fadeOverlayOpacity,
                child: Image.asset(
                  'assets/images/Group 18348.png',
                  width: 300,
                ),
              ),
            ),
          ),

          // Imagen decorativa inferior izquierda
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
        ],
      ),
    );
  }
}
