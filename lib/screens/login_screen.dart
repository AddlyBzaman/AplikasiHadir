import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import '../home/home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  void handleLogin() async {
    final response = await AuthService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (response != null) {
      final user = response['user'];
      final token = response['token'];

      setState(() => error = '');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => KehadiranHomePage(
            name: user['name'],
            token: token,
          ),
        ),
      );
    } else {
      setState(() => error = 'Login gagal. Periksa email dan password.');
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
                    'Login ke HAD!R',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A5160),
                    ),
                  ),
                  SizedBox(height: 24),
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
                  SizedBox(height: 16),
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: handleLogin,
                      icon: Icon(Icons.login),
                      label: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8FAFC6),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Belum punya akun? Register',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
