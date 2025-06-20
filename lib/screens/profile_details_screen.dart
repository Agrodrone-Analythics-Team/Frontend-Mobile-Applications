import 'package:flutter/material.dart';

import 'SuccessScreen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

String? tipoTrabajoSeleccionado;
String? sistemaProduccionSeleccionado;
List<String> animalesSeleccionados = [];
List<String> animalesDisponibles = [
  'Vacas', 'Cabras', 'Pollos', 'Ovejas', 'Cerdos', 'Tortugas'
];


class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF6F0), // Fondo general

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
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Group 18132 (1).png',
                  height: 40,
                ),
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '¿Quién eres?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Más información para conocerte mejor.'),
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Yo soy,',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRoleOption('Ganadero\n(5 a 20 animales)', 'Ganadero'),
                  _buildRoleOption('Administrador\n(más de 20 animales)', 'Administrador'),
                ],
              ),



              const SizedBox(height: 20),

              // Campos del formulario
              _buildTextField('Experience (Years)'),
              _buildTextField('Username'),
              _buildTextField('Password', isPassword: true),
              _buildTextField('Retype Password', isPassword: true),
              _buildTextField('Referral Code (Optional)'),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuccessScreen()),
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

  void mostrarVentanaDetallesProfesionales() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                children: [
                  const Text(
                    'Detalles profesionales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Proporcionar datos relacionados con su rol',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Tipo de trabajo
                  const Text('Tipo de trabajo', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _buildCheckOptionModal('Sector primario', tipoTrabajoSeleccionado, (val) {
                        setModalState(() => tipoTrabajoSeleccionado = val);
                        setState(() => tipoTrabajoSeleccionado = val);
                      }),
                      _buildCheckOptionModal('Sector secundario', tipoTrabajoSeleccionado, (val) {
                        setModalState(() => tipoTrabajoSeleccionado = val);
                        setState(() => tipoTrabajoSeleccionado = val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sistema de producción
                  const Text('Sistemas de producción ganadero', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _buildCheckOptionModal('extensivos', sistemaProduccionSeleccionado, (val) {
                        setModalState(() => sistemaProduccionSeleccionado = val);
                        setState(() => sistemaProduccionSeleccionado = val);
                      }),
                      _buildCheckOptionModal('intensivos', sistemaProduccionSeleccionado, (val) {
                        setModalState(() => sistemaProduccionSeleccionado = val);
                        setState(() => sistemaProduccionSeleccionado = val);
                      }),
                      _buildCheckOptionModal('otros', sistemaProduccionSeleccionado, (val) {
                        setModalState(() => sistemaProduccionSeleccionado = val);
                        setState(() => sistemaProduccionSeleccionado = val);
                      }),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Selecciona los animales que manejas.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _mostrarSelectorAnimales,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              animalesSeleccionados.isEmpty
                                  ? 'Selecciona animales'
                                  : animalesSeleccionados.join(', '),
                              style: TextStyle(
                                color: animalesSeleccionados.isEmpty ? Colors.grey : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 24),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: Color(0xFF1C8A52), fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildCheckOptionModal(String label, String? selected, Function(String) onSelect) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(label),
        child: Row(
          children: [
            Checkbox(
              value: selected == label,
              onChanged: (_) => onSelect(label),
              activeColor: const Color(0xFF1C8A52),
            ),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }


  Widget _buildCheckOption(String label, String? selected, Function(String) onSelect) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            onSelect(label);
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: selected == label,
              onChanged: (_) {
                setState(() {
                  onSelect(label);
                });
              },
              activeColor: const Color(0xFF1C8A52),
            ),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(String label, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
  Widget _buildRoleOption(String text, String value) {
    final bool isSelected = selectedRole == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });
        mostrarVentanaDetallesProfesionales();
      },
      child: Container(
        width: 166,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded,
              color: isSelected ? Color(0xFF57B67C) :  Color(0xFF57B67C),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _mostrarSelectorAnimales() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona los animales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                          setState(() {}); // actualiza el input visual
                        },
                        selectedColor: const Color(0xFF1C8A52),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // <-- esto actualiza la pantalla principal
                        Navigator.pop(context);
                      },

                      child: const Text('Aceptar'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

}
