import 'package:agrodroneanalytics/screens/ExploreScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'SuccessScreen2.dart';

class RutaGuardadaScreen extends StatefulWidget {
  const RutaGuardadaScreen({super.key});

  @override
  State<RutaGuardadaScreen> createState() => _RutaGuardadaScreenState();
}

class _RutaGuardadaScreenState extends State<RutaGuardadaScreen> {
  File? _imageFile;
  final TextEditingController _areaController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Icono ubicación
            const Icon(Icons.location_on, color: Color(0xFF61C086), size: 48),

            const SizedBox(height: 12),
            const Text(
              'Agrega imagen a tu ruta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            const Text(
              'Selecciona una imagen de tu galería o fotos que tengas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            // Selector de imagen
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _imageFile == null
                    ? const Center(
                  child: Icon(Icons.add_photo_alternate_outlined, size: 60),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Text('Ingresa nombre del Área'),

            const SizedBox(height: 12),

            // Campo de texto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _areaController,
                decoration: InputDecoration(
                  hintText: 'Área',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Botón Guardar vuelo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF61C086),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccessScreen2()),
                );
              },
              child: const Text('Guardar vuelo'),
            ),

            const SizedBox(height: 12),

            // Botón Regresar
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExploreScreen()),
                );
              },
              child: const Text(
                'Regresar',
                style: TextStyle(color: Color(0xFF61C086)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
