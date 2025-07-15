import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_screen.dart'; // ganti sesuai lokasi file login kamu

import 'pengaturan_page.dart';

class AkunPage extends StatefulWidget {
  final String token;

  AkunPage({required this.token});

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String name = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/auth/profile'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'];
          email = data['email'];
          isLoading = false;
        });
      } else {
        print('Gagal mengambil data profil. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetch user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akun Saya"),
        backgroundColor: Color(0xFF8FAFC6),
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/images/avatar_user.jpeg'),
            ),
          ),
          SizedBox(height: 16),
          isLoading
              ? CircularProgressIndicator()
              : Column(
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          Divider(height: 40),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Pengaturan"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengaturanPage(token: widget.token),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()), // ganti dengan nama file kamu
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
