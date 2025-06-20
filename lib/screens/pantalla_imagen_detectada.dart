import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Detection {
  final double x1, y1, x2, y2, confidence;
  final int classId;

  Detection({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.confidence,
    required this.classId,
  });
}

class PantallaImagenDetectada extends StatefulWidget {
  const PantallaImagenDetectada({Key? key}) : super(key: key);

  // 👇 Ponla aquí:
  static const List<String> classNames = [
    'bull', 'calf', 'cow', 'yearling', 'Sheep', 'object'
  ];

  @override
  State<PantallaImagenDetectada> createState() => _PantallaImagenDetectadaState();
}

class _PantallaImagenDetectadaState extends State<PantallaImagenDetectada> {
  File? _imagen;
  Uint8List? _bytesImagen;
  List<Detection> _detecciones = [];
  int _width = 416;
  int _height = 416;
  bool _cargando = false;


  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100, // Usa la mejor calidad posible (no reduce)
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final bytes = await file.readAsBytes();
    final decodedImage = await decodeImageFromList(bytes);

    setState(() {
      _imagen = file;
      _bytesImagen = bytes;
      _width = decodedImage.width;
      _height = decodedImage.height;
      _detecciones = [];
    });
  }

  Future<void> _detectarImagen() async {
    if (_imagen == null) return;
    setState(() { _cargando = true; });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.72:8000/detect/'), // Cambia la IP si es necesario
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', _imagen!.path),
      );
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Respuesta backend: $responseBody');
      final result = json.decode(responseBody);

      print('Detecciones recibidas: ${result['detections']}');
      List detections = result['detections'] ?? [];
      setState(() {
        _detecciones = detections.map<Detection>((d) => Detection(
          x1: (d["x1"] ?? 0.0).toDouble(),
          y1: (d["y1"] ?? 0.0).toDouble(),
          x2: (d["x2"] ?? 0.0).toDouble(),
          y2: (d["y2"] ?? 0.0).toDouble(),
          confidence: (d["confidence"] ?? 0.0).toDouble(),
          classId: d["class_id"] ?? 0,
        )).toList();
        _cargando = false;
      });
    } catch (e) {
      print("❌ Error backend: $e");
      setState(() { _cargando = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detectar en imagen de prueba')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Seleccionar imagen'),
                onPressed: _cargando ? null : _seleccionarImagen,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('Detectar'),
                onPressed: (_imagen != null && !_cargando) ? _detectarImagen : null,
              ),
              const SizedBox(height: 24),
              if (_cargando)
                const CircularProgressIndicator(),
              if (_bytesImagen != null)
              // En tu build (sólo cambia esta parte)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxW = constraints.maxWidth;
                      final double maxH = constraints.maxHeight;
                      final double imgW = _width.toDouble();
                      final double imgH = _height.toDouble();

                      // Calcula el factor de escala y offsets para centrar la imagen
                      final double scale = (imgW / imgH > maxW / maxH)
                          ? maxW / imgW
                          : maxH / imgH;
                      final double displayW = imgW * scale;
                      final double displayH = imgH * scale;
                      final double offsetX = (maxW - displayW) / 2;
                      final double offsetY = (maxH - displayH) / 2;

                      return Stack(
                        children: [
                          Positioned(
                            left: offsetX,
                            top: offsetY,
                            width: displayW,
                            height: displayH,
                            child: Image.memory(
                              _bytesImagen!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          if (_detecciones.isNotEmpty)
                            Positioned(
                              left: offsetX,
                              top: offsetY,
                              width: displayW,
                              height: displayH,
                              child: CustomPaint(
                                painter: _BoxPainter(
                                  _detecciones,
                                  imgW,
                                  imgH,
                                  PantallaImagenDetectada.classNames,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

              if (_bytesImagen == null && !_cargando)
                const Text('No has seleccionado imagen.'),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoxPainter extends CustomPainter {
  final List<Detection> detections;
  final double previewW, previewH;
  final List<String> classNames;

  _BoxPainter(this.detections, this.previewW, this.previewH, this.classNames);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent // Bien visible
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    for (final d in detections) {
      final rect = Rect.fromLTRB(
        d.x1 * size.width / previewW,
        d.y1 * size.height / previewH,
        d.x2 * size.width / previewW,
        d.y2 * size.height / previewH,
      );
      canvas.drawRect(rect, paint);
      final className = d.classId < classNames.length ? classNames[d.classId] : 'unknown';
      final label = '$className ${(d.confidence * 100).toStringAsFixed(1)}%';
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.black,
          backgroundColor: Colors.yellow.withOpacity(0.9),
          fontSize: 18,
        ),
      );
      textPainter.layout();
      double dx = rect.left;
      double dy = rect.top - 24;
      if (dy < 0) dy = rect.top + 2;
      textPainter.paint(canvas, Offset(dx, dy));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
