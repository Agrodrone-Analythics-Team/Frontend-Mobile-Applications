import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'SuccessScreen3.dart';

const String apiUrl = 'http://10.0.2.2:8000/api';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isOtpVerified = false; // <-- NUEVA VARIABLE para controlar el flujo

  // --- Función para reenviar el OTP ---
  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      if (mounted) {
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          final otp = responseData['otp'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Tu nuevo código es: $otp'),
            duration: const Duration(seconds: 15),
            backgroundColor: Colors.blue,
          ));
        }
      }
    } catch(e) {
      // Manejar error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Función NUEVA solo para verificar el OTP ---
  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': _otpController.text,
        }),
      );
      if (mounted) {
        if (response.statusCode == 200) {
          setState(() => _isOtpVerified = true); // <-- Si es correcto, cambiamos de vista
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
        }
      }
    } catch(e) {
      // Manejar error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Función para cambiar la contraseña (el paso final) ---
  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contraseñas no coinciden.")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': _otpController.text, // Reenviamos el OTP por seguridad
          'new_password': _passwordController.text,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SuccessScreen3()),
            ModalRoute.withName('/'),
          );
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${errorData['detail']}')));
        }
      }
    } catch (e) {
      // Manejar error
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                  // --- Usamos un IF para mostrar una vista u otra ---
                  if (!_isOtpVerified) ...[
                    // --- VISTA 1: VERIFICAR OTP ---
                    const Text('Verificar Código', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Ingrese el código enviado a ${widget.email}', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Enter OTP', filled: true, fillColor: const Color(0xFFF1F1F1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                    ),
                    const SizedBox(height: 16),
                    Center(child: TextButton(onPressed: _resendOtp, child: const Text('¿No recibió código? Reenviar', style: TextStyle(color: Color(0xFF1C8A52))))),
                    const Spacer(),
                    Center(child: _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF61C086), padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        child: const Text('Verificar')))
                  ] else ...[
                    // --- VISTA 2: CAMBIAR CONTRASEÑA ---
                    const Text('Establecer Nueva Contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('El código es correcto. Ahora ingrese su nueva contraseña.', style: TextStyle(color: Colors.black54)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'New Password', filled: true, fillColor: const Color(0xFFF1F1F1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Confirm New Password', filled: true, fillColor: const Color(0xFFF1F1F1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                    ),
                    const Spacer(),
                    Center(child: _isLoading ? const CircularProgressIndicator() : ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF61C086), padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                        child: const Text('Cambiar')))
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}