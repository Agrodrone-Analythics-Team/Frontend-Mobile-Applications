import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'DetecciónDron.dart';
import 'pantalla_imagen_detectada.dart';

class OpcionesCamara extends StatelessWidget {
  final List<CameraDescription> cameras;
  const OpcionesCamara({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AgroDrone - Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.airplanemode_active),
              label: const Text('Entrar a cámara de dron'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(220, 48)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraScreen(cameras: cameras),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Enviar imagen de prueba'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(220, 48)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaImagenDetectada(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.video_library),
              label: const Text('Enviar video de prueba'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(220, 48)),
              onPressed: () {
                // Pendiente lógica de video
              },
            ),
          ],
        ),
      ),
    );
  }
}
