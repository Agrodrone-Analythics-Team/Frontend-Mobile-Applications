import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'SuccessScreen.dart'; // Asegúrate de que esta pantalla exista

const String apiUrl = 'http://10.0.2.2:8000/api';

class ProfileDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> personalInfo;
  const ProfileDetailsScreen({super.key, required this.personalInfo});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  // --- Controladores ---
  final _experienceController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  // --- Variables de Estado (CORREGIDO: AHORA ESTÁN DENTRO DE LA CLASE) ---
  String? tipoTrabajoSeleccionado;
  String? sistemaProduccionSeleccionado;
  List<String> animalesSeleccionados = [];
  List<String> animalesDisponibles = ['Vacas', 'Cabras', 'Pollos', 'Ovejas', 'Cerdos', 'Tortugas'];
  String selectedRole = '';
  bool _isLoading = false;

  // --- Función para registrar al usuario ---
  Future<void> _registerUser() async {
    // Validaciones
    if (selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, seleccione un rol (Ganadero o Administrador).')));
      return;
    }
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario y contraseña son requeridos.')));
      return;
    }
    if (_passwordController.text != _retypePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> fullData = {
        ...widget.personalInfo,
        'experience_years': int.tryParse(_experienceController.text) ?? 0,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'referral_code': _referralCodeController.text,
        'role': selectedRole,
        'job_type': tipoTrabajoSeleccionado ?? '',
        'production_system': sistemaProduccionSeleccionado ?? '',
        'managed_animals': animalesSeleccionados,
      };

      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(fullData),
      );

      if (response.statusCode == 201) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
            flexibleSpace: SafeArea(child: Center(child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image.asset('assets/images/Group 18156.png', height: 85, fit: BoxFit.contain))))),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/Group 18132 (1).png', height: 40)),
              const SizedBox(height: 20),
              const Align(alignment: Alignment.centerLeft, child: Text('¿Quién eres?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 4),
              const Align(alignment: Alignment.centerLeft, child: Text('Más información para conocerte mejor.')),
              const SizedBox(height: 20),
              const Align(alignment: Alignment.centerLeft, child: Text('Yo soy,', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRoleOption('Ganadero\n(5 a 20 animales)', 'Ganadero'),
                  _buildRoleOption('Administrador\n(más de 20 animales)', 'Administrador'),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField('Experience (Years)', _experienceController, keyboardType: TextInputType.number),
              _buildTextField('Username', _usernameController),
              _buildTextField('Password', _passwordController, isPassword: true),
              _buildTextField('Retype Password', _retypePasswordController, isPassword: true),
              _buildTextField('Referral Code (Optional)', _referralCodeController),
              const SizedBox(height: 30),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C8A52),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets y funciones auxiliares ---
  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
    );
  }

  Widget _buildRoleOption(String text, String value) {
    final bool isSelected = selectedRole == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedRole = value);
        mostrarVentanaDetallesProfesionales();
      },
      child: Container(
        width: 166,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded, color: const Color(0xFF57B67C)),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }

  void mostrarVentanaDetallesProfesionales() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(children: [
                const Text('Detalles profesionales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Proporcionar datos relacionados con su rol', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 20),
                const Text('Tipo de trabajo', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(children: [
                  _buildCheckOptionModal('Sector primario', tipoTrabajoSeleccionado, (val) => setModalState(() => tipoTrabajoSeleccionado = val)),
                  _buildCheckOptionModal('Sector secundario', tipoTrabajoSeleccionado, (val) => setModalState(() => tipoTrabajoSeleccionado = val)),
                ]),
                const SizedBox(height: 16),
                const Text('Sistemas de producción ganadero', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(children: [
                  _buildCheckOptionModal('extensivos', sistemaProduccionSeleccionado, (val) => setModalState(() => sistemaProduccionSeleccionado = val)),
                  _buildCheckOptionModal('intensivos', sistemaProduccionSeleccionado, (val) => setModalState(() => sistemaProduccionSeleccionado = val)),
                  _buildCheckOptionModal('otros', sistemaProduccionSeleccionado, (val) => setModalState(() => sistemaProduccionSeleccionado = val)),
                ]),
                const SizedBox(height: 16),
                const Text('Selecciona los animales que manejas.', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _mostrarSelectorAnimales(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(30)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(
                          child: Text(animalesSeleccionados.isEmpty ? 'Selecciona animales' : animalesSeleccionados.join(', '),
                              style: TextStyle(color: animalesSeleccionados.isEmpty ? Colors.grey : Colors.black),
                              overflow: TextOverflow.ellipsis)),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue', style: TextStyle(color: Color(0xFF1C8A52), fontWeight: FontWeight.bold))),
                )
              ]),
            );
          },
        );
      },
    ).whenComplete(() {
      // Importante: Actualiza el estado de la pantalla principal cuando se cierra el modal
      setState(() {});
    });
  }

  Widget _buildCheckOptionModal(String label, String? groupValue, Function(String) onSelect) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(label),
        child: Row(children: [
          Radio<String>(
              value: label,
              groupValue: groupValue,
              onChanged: (val) => onSelect(val!),
              activeColor: const Color(0xFF1C8A52)),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
        ]),
      ),
    );
  }

  void _mostrarSelectorAnimales(BuildContext parentContext) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Selecciona los animales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: animalesDisponibles.map((animal) {
                      final isSelected = animalesSeleccionados.contains(animal);
                      return FilterChip(
                          label: Text(animal),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                animalesSeleccionados.add(animal);
                              } else {
                                animalesSeleccionados.remove(animal);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF1C8A52),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black));
                    }).toList()),
                const SizedBox(height: 24),
                Center(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Aceptar')))
              ]),
            );
          },
        );
      },
    ).whenComplete(() {
      // Importante: Actualiza el estado de la pantalla principal cuando se cierra el modal de animales
      setState(() {});
    });
  }
}