import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'HomeScreen.dart';
import 'PasswordRecoveryScreen.dart';

const String apiUrl = 'http://10.0.2.2:8000/api'; // URL de tu API

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    // 1. Validar campos antes de hacer nada
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor, ingrese usuario y contraseña")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Hacer la petición a la API
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      // Es buena práctica verificar si el widget sigue montado
      if (!mounted) return;

      // 3. Procesar la respuesta
      if (response.statusCode == 200) {
        // Éxito
        final tokenData = jsonDecode(response.body);
        final accessToken = tokenData['access_token'];
        print('Token de acceso: $accessToken');

        // --- LÓGICA PARA GUARDAR EL TOKEN EN EL LUGAR CORRECTO ---
        const storage = FlutterSecureStorage();
        await storage.write(key: 'access_token', value: accessToken);
        // ---------------------------------------------------------

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Error del servidor (ej: credenciales incorrectas)
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
      }
    } catch (e) {
      // Error de conexión o similar
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      // 4. Asegurarse de detener el indicador de carga
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF6F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contenedor del Logo
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              child: Image.asset(
                'assets/images/Group 18156.png', // Logo AgroDrone Analytics
                height: 80,
              ),
            ),

            // Contenedor del formulario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre de Usuario',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'NameUser',
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Contraseña',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('¿Te olvidaste tu contraseña? Ingresa '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PasswordRecoveryScreen()),
                          );
                        },
                        child: const Text(
                          'aquí',
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C8A52),
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
