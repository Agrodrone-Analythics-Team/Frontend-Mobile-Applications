import 'package:agrodroneanalytics/screens/profile_details_screen.dart';
import 'package:flutter/material.dart';

// 1. Convertido a StatefulWidget
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 2. Controladores para capturar los datos de los campos de texto
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  // 3. Variables para guardar la selección de los Dropdowns
  String? _selectedGender;
  String? _selectedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF6F0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
            backgroundColor: const Color(0xFFECF6F0),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: null,
            flexibleSpace: // ... (AppBar se queda igual)
            SafeArea(
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
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (Títulos se quedan igual)
              Center(
                child: Image.asset('assets/images/Group 18132.png', height: 40),
              ),
              const SizedBox(height: 40),
              const Text('Información personal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Agregue su información personal'),
              const SizedBox(height: 20),

              // 4. Conectamos los controladores y variables a los campos
              _buildTextField(label: 'First Name', controller: _firstNameController),
              _buildTextField(label: 'Last Name', controller: _lastNameController),
              _buildTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
              _buildDropdown(
                  label: 'Gender',
                  items: ['Masculino', 'Femenino', 'Otro'],
                  value: _selectedGender,
                  onChanged: (val) => setState(() => _selectedGender = val)),
              _buildTextField(label: 'Address', controller: _addressController),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                        label: 'State',
                        items: ['Lima', 'Cusco', 'Arequipa'],
                        value: _selectedState,
                        onChanged: (val) => setState(() => _selectedState = val)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _buildTextField(label: 'City', controller: _cityController)),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  // 5. Modificamos el onPressed para pasar los datos a la siguiente pantalla
                  onPressed: () {
                    // Validaciones simples (puedes hacerlas más complejas)
                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, llene todos los campos.')));
                      return;
                    }

                    // Creamos un mapa con los datos de esta pantalla
                    final personalInfo = {
                      'first_name': _firstNameController.text,
                      'last_name': _lastNameController.text,
                      'email': _emailController.text,
                      'gender': _selectedGender ?? '',
                      'address': _addressController.text,
                      'state': _selectedState ?? '',
                      'city': _cityController.text,
                    };

                    // Navegamos y pasamos el mapa a ProfileDetailsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetailsScreen(personalInfo: personalInfo),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C8A52),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modificamos los builders para aceptar controladores y valores
  Widget _buildTextField({required String label, required TextEditingController controller, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white),
      ),
    );
  }

  Widget _buildDropdown({required String label, required List<String> items, String? value, required Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}