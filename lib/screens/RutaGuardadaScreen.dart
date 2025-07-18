import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'SuccessScreen2.dart';

const String apiUrl = 'http://10.0.2.2:8000/api';

class RutaGuardadaScreen extends StatefulWidget {
  // 1. Recibe el ID del plan de vuelo
  final int flightPlanId;
  const RutaGuardadaScreen({super.key, required this.flightPlanId});

  @override
  State<RutaGuardadaScreen> createState() => _RutaGuardadaScreenState();
}

class _RutaGuardadaScreenState extends State<RutaGuardadaScreen> {
  File? _imageFile;
  final TextEditingController _areaController = TextEditingController();
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // 2. Nueva función para subir los detalles al backend
  Future<void> _uploadDetails() async {
    if (_imageFile == null || _areaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor, seleccione una imagen y un nombre para el área.")));
      return;
    }

    setState(() => _isSaving = true);

    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Usuario no autenticado.")));
      setState(() => _isSaving = false);
      return;
    }

    try {
      // 3. Usamos una MultipartRequest para enviar archivos y texto juntos
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$apiUrl/flight-plans/${widget.flightPlanId}/details'),
      );

      // 4. Añadimos las cabeceras, los campos de texto y el archivo
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['name'] = _areaController.text;
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      // 5. Enviamos la petición
      var response = await request.send();

      if (mounted) {
        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen2()),
                (route) => route.isFirst, // Vuelve a la pantalla inicial (Explore)
          );
        } else {
          final responseBody = await response.stream.bytesToString();
          final errorData = jsonDecode(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.location_on, color: Color(0xFF61C086), size: 48),
              const SizedBox(height: 12),
              const Text('Agrega imagen a tu ruta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Selecciona una imagen de tu galería o fotos que tengas', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
                  child: _imageFile == null
                      ? const Center(child: Icon(Icons.add_photo_alternate_outlined, size: 60))
                      : ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_imageFile!, fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Ingresa nombre del Área'),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    hintText: 'Área',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // 6. Conectamos el botón a la nueva función
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF61C086),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _isSaving ? null : _uploadDetails,
                child: _isSaving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Guardar vuelo'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Simplemente vuelve atrás
                  Navigator.of(context).pop();
                },
                child: const Text('Regresar', style: TextStyle(color: Color(0xFF61C086))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
