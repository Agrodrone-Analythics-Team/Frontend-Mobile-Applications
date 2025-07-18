import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "Tu área #1 se dirigió a un animal",
      "date": "08/08/2023",
      "time": "8:19 AM"
    },
    {
      "title": "Tu área #2 se dirigió a 2  animal",
      "date": "08/08/2023",
      "time": "8:19 AM"
    },
    {
      "title": "Intruso en el área #2",
      "date": "08/08/2023",
      "time": "8:19 AM"
    },
    {
      "title": "Pérdida de rendimiento  batería baja",
      "date": "08/08/2023",
      "time": "8:19 AM"
    },
    {
      "title": "Horario completado regresando a la central",
      "date": "08/08/2023",
      "time": "8:19 AM"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDF3E7),
        elevation: 0,
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: Color(0xFF5DBE84),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 20),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF5DBE84),
                child: Icon(Icons.message, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${notification["date"]}     ${notification["time"]}',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
