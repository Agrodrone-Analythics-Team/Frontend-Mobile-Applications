import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

String? tipoTrabajoSeleccionado;
String? sistemaProduccionSeleccionado;
List<String> animalesSeleccionados = [];
List<String> animalesDisponibles = [
  'Vacas', 'Cabras', 'Pollos', 'Ovejas', 'Cerdos', 'Tortugas'
];

class _EditProfileScreenState extends State<EditProfileScreen> {
  String selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/images/Group 18156.png', height: 40),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 12),
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
              const SizedBox(height: 12),
              const Text("Edit Username", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField("Godfrey Onyeoghani"),
              const SizedBox(height: 20),
              _buildTextField("@godfrey_inc", icon: Icons.alternate_email),
              const SizedBox(height: 16),
              _buildTextField("Password", icon: Icons.lock),
              const SizedBox(height: 16),
              _buildTextField("Retype Password", icon: Icons.lock_outline),
              const SizedBox(height: 16),
              _buildTextField("Address", icon: Icons.home),

              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Yo soy,", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRoleOption('Ganadero\n(5 o 20 animales)', 'Ganadero'),
                  _buildRoleOption('Administrador\n(mas de 20 animales)', 'Administrador'),
                ],
              ),

              const SizedBox(height: 24),
              _buildEditableChipSection("Tipo de trabajo", ['Sector primario', 'Sector secundario'], tipoTrabajoSeleccionado, (val) {
                setState(() => tipoTrabajoSeleccionado = val);
              }),

              const SizedBox(height: 24),
              _buildEditableChipSection("Sistemas de producción ganadero", ['extensivos', 'intensivos', 'otros'], sistemaProduccionSeleccionado, (val) {
                setState(() => sistemaProduccionSeleccionado = val);
              }),

              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Selecciona los animales que manejas", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _mostrarSelectorAnimales,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    animalesSeleccionados.isEmpty
                        ? 'crop1, crop2'
                        : animalesSeleccionados.join(', '),
                    style: TextStyle(
                      color: animalesSeleccionados.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              ListTile(
                title: const Text("Help & Support"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Sobre AgroDrone Analytics"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const SizedBox(height: 20),
              const Text("Read our Terms and Privacy Policy", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C8A52),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Save changes"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {String? hint, IconData? icon}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildEditableChipSection(String title, List<String> options, String? selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((label) {
            return FilterChip(
              label: Text(label),
              selected: selected == label,
              onSelected: (_) => onSelect(label),
              selectedColor: const Color(0xFF1C8A52),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoleOption(String text, String value) {
    final bool isSelected = selectedRole == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });
      },
      child: Container(
        width: 166,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank_rounded,
              color: const Color(0xFF57B67C),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 13)),
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
                  const Text("Selecciona los animales", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          setState(() {});
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
                        setState(() {});
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