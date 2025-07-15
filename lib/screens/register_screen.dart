import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String error = '';

  void handleRegister(BuildContext context) async {
    final success = await AuthService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
      'employee', // default role, optional, bisa dihapus tergantung backend
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrasi berhasil!')),
      );
      Navigator.pop(context);
    } else {
      setState(() {
        error = 'Registrasi gagal. Coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F6),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Registrasi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A5160),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => handleRegister(context),
                      icon: Icon(Icons.app_registration),
                      label: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8FAFC6),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
