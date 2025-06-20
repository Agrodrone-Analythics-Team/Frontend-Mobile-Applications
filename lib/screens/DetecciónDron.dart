import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

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

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  List<Detection> _detections = [];
  bool isProcessing = false;
  DateTime lastSend = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();
    setState(() => _isInitialized = true);
    _controller!.startImageStream(_processCameraImage);
  }

  void _processCameraImage(CameraImage image) async {
    if (isProcessing) return;
    if (DateTime.now().difference(lastSend).inMilliseconds < 400) return;

    isProcessing = true;
    lastSend = DateTime.now();

    try {
      img.Image rgb = _convertYUV420toImage(image);
      final jpeg = img.encodeJpg(rgb);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.72:8000/detect/'),
      );
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          jpeg,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final result = json.decode(responseBody);
      List detections = result["detections"] ?? [];

      setState(() {
        _detections = detections.map<Detection>((d) => Detection(
          x1: (d["x1"] ?? 0).toDouble(),
          y1: (d["y1"] ?? 0).toDouble(),
          x2: (d["x2"] ?? 0).toDouble(),
          y2: (d["y2"] ?? 0).toDouble(),
          confidence: (d["confidence"] ?? 0.0).toDouble(),
          classId: d["class_id"] ?? 0,
        )).toList();
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        _detections = [];
      });
    }

    isProcessing = false;
  }

  img.Image _convertYUV420toImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel!;

    final img.Image imgBuffer = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      final int uvRow = uvRowStride * (y ~/ 2);
      for (int x = 0; x < width; x++) {
        final int uvIndex = uvRow + (x ~/ 2) * uvPixelStride;
        final int yp = image.planes[0].bytes[y * image.planes[0].bytesPerRow + x];
        final int up = image.planes[1].bytes[uvIndex];
        final int vp = image.planes[2].bytes[uvIndex];

        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        imgBuffer.setPixelRgb(x, y, r, g, b);
      }
    }
    return imgBuffer;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara en vivo')),
      body: _isInitialized && _controller != null
          ? LayoutBuilder(
        builder: (context, constraints) {
          final previewSize = _controller!.value.previewSize;
          final double previewW = previewSize!.height;
          final double previewH = previewSize.width;
          final double widgetW = constraints.maxWidth;
          final double widgetH = constraints.maxHeight;

          // Calcula el factor de escala y el offset para centrar el preview sin deformar (BoxFit.contain)
          final double scale = (previewW / previewH > widgetW / widgetH)
              ? widgetW / previewW
              : widgetH / previewH;
          final double displayW = previewW * scale;
          final double displayH = previewH * scale;
          final double offsetX = (widgetW - displayW) / 2;
          final double offsetY = (widgetH - displayH) / 2;

          return Stack(
            children: [
              CameraPreview(_controller!),
              Positioned(
                left: offsetX,
                top: offsetY,
                width: displayW,
                height: displayH,
                child: CustomPaint(
                  painter: _detections.isNotEmpty
                      ? BoxPainter(_detections, previewW, previewH)
                      : null,
                  child: Container(),
                ),
              ),
            ],
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class BoxPainter extends CustomPainter {
  final List<Detection> detections;
  final double previewW, previewH;

  static const List<String> classNames = [
    'bull',
    'calf',
    'cow',
    'yearling',
    'Sheep',
    'object'
  ];

  BoxPainter(this.detections, this.previewW, this.previewH);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
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
          color: Colors.yellow,
          backgroundColor: Colors.black.withOpacity(0.6),
          fontSize: 14,
        ),
      );
      textPainter.layout();
      double dx = rect.left;
      double dy = rect.top - 18;
      if (dy < 0) dy = rect.top + 2;
      textPainter.paint(canvas, Offset(dx, dy));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
