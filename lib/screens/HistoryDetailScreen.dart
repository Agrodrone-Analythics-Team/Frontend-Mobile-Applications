import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({super.key});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  String _sortBy = 'fecha';

  List<Map<String, dynamic>> data = [
    {
      'area': 'Area #1',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 20,
    },
    {
      'area': 'Area #2',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 12,
    },
    {
      'area': 'Area #3',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 21,
    },
    {
      'area': 'Area #4',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 10,
    },
    {
      'area': 'Area #5',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 5,
    },
    {
      'area': 'Centro',
      'product': '5 min',
      'status': 'active',
      'perdidas': 2,
      'fecha': DateTime(2023, 8, 8),
      'total': 40,
    },
    {
      'area': 'Area #1',
      'product': '5 min',
      'status': 'Cancelled',
      'perdidas': 2,
      'fecha': DateTime(2024, 8, 8),
      'total': 10,
    },
    {
      'area': 'Area #2',
      'product': '5 min',
      'status': 'Cancelled',
      'perdidas': 2,
      'fecha': DateTime(2024, 8, 8),
      'total': 21500,
    },
  ];

  void sortData() {
    setState(() {
      if (_sortBy == 'perdidas') {
        data.sort((a, b) => b['perdidas'].compareTo(a['perdidas']));
      } else if (_sortBy == 'tiempo') {
        data.sort((a, b) {
          int tiempoA = int.tryParse(a['product'].toString().split(' ').first) ?? 0;
          int tiempoB = int.tryParse(b['product'].toString().split(' ').first) ?? 0;
          return tiempoB.compareTo(tiempoA);
        });
      }
      else if (_sortBy == 'fecha') {
        data.sort((a, b) => b['fecha'].compareTo(a['fecha']));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sortData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/images/Group 18156.png', height: 40),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],


        elevation: 1,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab('Pérdidas', 'perdidas'),
              _buildTab('Tiempo de vuelo', 'tiempo'),
              _buildTab('Fecha de análisis', 'fecha'),
            ],
          ),
          const Divider(thickness: 1),

          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['area'],
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(DateFormat('dd/MM/yyyy').format(item['fecha']),
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Productos/Servicios: ${item['product']}'),
                      Text('Estado: ${item['status']}'),
                      Text('Pérdidas: ${item['perdidas']}'),
                      const SizedBox(height: 8),
                      Text('Total anames: ${item['total']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String value) {
    final bool isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        _sortBy = value;
        sortData();
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              height: 3,
              width: 30,
              color: Colors.green,
            )
        ],
      ),
    );
  }
}
