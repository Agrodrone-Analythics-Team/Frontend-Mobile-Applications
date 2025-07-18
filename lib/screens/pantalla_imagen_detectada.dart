import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Importa el paquete 'image'
import 'package:http_parser/http_parser.dart'; // Necesario para MediaType

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

  static const List<String> classNames =['cow','objet', 'sheep',];

  @override
  State<PantallaImagenDetectada> createState() => _PantallaImagenDetectadaState();
}

class _PantallaImagenDetectadaState extends State<PantallaImagenDetectada> {
  File? _imagenOriginal; // Guarda la referencia al archivo original
  Uint8List? _bytesImagenParaMostrar; // Bytes de la imagen para mostrar en la UI (original)
  Uint8List? _bytesImagenParaEnviar; // Bytes de la imagen (recodificada con alta calidad) para enviar
  List<Detection> _detecciones = [];
  int _width = 60; // Ancho de la imagen
  int _height = 60; // Alto de la imagen
  bool _cargando = false;


  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100, // Solicita la máxima calidad posible del archivo original
      // Puedes añadir maxWidth o maxHeight aquí si quisieras limitar la resolución
      // Por ejemplo: maxWidth: 1024, maxHeight: 768, para redimensionar si la imagen es más grande
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final bytesOriginal = await file.readAsBytes(); // Lee los bytes originales
    final decodedImage = await decodeImageFromList(bytesOriginal); // Decodifica para obtener dimensiones

    // --- MODIFICACIÓN CLAVE: Recodificación JPEG con calidad superior ---
    final img.Image? imageLib = img.decodeImage(bytesOriginal); // Decodifica a objeto Image del paquete 'image'
    if (imageLib == null) {
      print("Error: No se pudo decodificar la imagen seleccionada para recodificar.");
      return;
    }

    // Recodifica la imagen a JPEG con una calidad muy alta (ej. 95 o 100).
    // Esto asegura una compresión mínima, manteniendo la resolución original.
    final compressedBytes = img.encodeJpg(imageLib, quality: 100); // <-- AJUSTA LA CALIDAD AQUÍ (95-100)
    // ---------------------------------------------------------------------

    setState(() {
      _imagenOriginal = file;
      _bytesImagenParaMostrar = bytesOriginal; // Para mostrar la imagen original en la UI
      _bytesImagenParaEnviar = Uint8List.fromList(compressedBytes); // Los bytes recodificados para enviar
      _width = decodedImage.width; // Mantiene el ancho original
      _height = decodedImage.height; // Mantiene el alto original
      _detecciones = [];
    });
  }

  Future<void> _detectarImagen() async {
    if (_bytesImagenParaEnviar == null) return;
    setState(() { _cargando = true; });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/detect/'), // Asegúrate de que esta IP sea la correcta
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _bytesImagenParaEnviar!, // Envía los bytes JPEG recodificados con alta calidad
          filename: _imagenOriginal!.path.split('/').last, // Usa el nombre original del archivo
          contentType: MediaType('image', 'jpeg'), // Especifica que es JPEG
        ),
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
                onPressed: (_bytesImagenParaEnviar != null && !_cargando) ? _detectarImagen : null,
              ),
              const SizedBox(height: 24),
              if (_cargando)
                const CircularProgressIndicator(),
              if (_bytesImagenParaMostrar != null)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxW = constraints.maxWidth;
                      final double maxH = constraints.maxHeight;
                      final double imgW = _width.toDouble();
                      final double imgH = _height.toDouble();

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
                              _bytesImagenParaMostrar!, // Muestra la imagen original
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

              if (_bytesImagenParaMostrar == null && !_cargando)
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
      ..color = Colors.greenAccent
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
