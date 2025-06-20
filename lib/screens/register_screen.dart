import 'package:agrodroneanalytics/screens/profile_details_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF6F0), // Fondo detrás del contenedor

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFFECF6F0),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: null,
          flexibleSpace: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image.asset(
                  'assets/images/Group 18156.png',
                  height: 85,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white, // Fondo blanco del formulario
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), // Bordes redondeados solo arriba
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/Group 18132.png', height: 40),
              ),
              const SizedBox(height: 40),
              const Text(
                'Información personal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('Agregue su información personal'),
              const SizedBox(height: 20),

              // Campos del formulario
              _buildTextField(label: 'First Name'),
              _buildTextField(label: 'Last Name'),
              _buildTextField(label: 'Email'),
              _buildDropdown(label: 'Gender', items: ['Masculino', 'Femenino', 'Otro']),
              _buildTextField(label: 'Address'),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(label: 'State', items: ['Lima', 'Cusco', 'Arequipa']),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(label: 'City')),
                ],
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileDetailsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C8A52),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdown({required String label, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: (value) {},
      ),
    );
  }
}
