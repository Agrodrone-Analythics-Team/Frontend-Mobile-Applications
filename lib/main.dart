import 'package:agrodroneanalytics/screens/Detecci%C3%B3nDron.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'screens/splash_screen.dart';
import 'screens/HomeScreen.dart';
import 'screens/ExploreScreen.dart';
import 'screens/HistoryScreen.dart';
import 'screens/NotificationScreen.dart';
import 'screens/profile_screen.dart';
import 'screens/CameraScreen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/explore':
            return MaterialPageRoute(builder: (_) => const ExploreScreen());
          case '/history':
            return MaterialPageRoute(builder: (_) => const HistoryScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/camera':
            return MaterialPageRoute(builder: (_) => CameraScreen(cameras: cameras));
          case '/deteccion':
            return MaterialPageRoute(builder: (_) => OpcionesCamara(cameras: cameras));
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Ruta no encontrada')),
              ),
            );
        }
      },
    );
  }
}
