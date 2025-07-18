import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'ResetPasswordScreen.dart';


const String apiUrl = 'http://10.0.2.2:8000/api';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _requestReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor, ingrese un correo.")));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _emailController.text}),
      );

      if (!mounted) return;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final otp = responseData['otp'];

        // Mostramos la notificación flotante (SnackBar) con el OTP
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tu código de verificación es: $otp'),
            duration: const Duration(seconds: 15), // Desaparece en 4 segundos
            backgroundColor: Colors.green,
          ),
        );

        // Navegamos a la nueva pantalla, pasando el correo
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: _emailController.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseData['detail']}')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF6F0),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Image.asset('assets/images/Group 18156.png', height: 80),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('¿Verificar tu correo electrónico?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Ingrese el correo electrónico registrado de tu cuenta.', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _requestReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF61C086),
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Next'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}