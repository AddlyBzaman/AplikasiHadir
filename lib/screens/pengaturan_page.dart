import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PengaturanPage extends StatefulWidget {
  final String token;

  PengaturanPage({required this.token});

  @override
  _PengaturanPageState createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updateProfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:3000/auth/user/update');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'name': _namaController.text,
        'email': _emailController.text,
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Profil berhasil diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal memperbarui: ${jsonDecode(response.body)['message']}')),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Color(0xFF8FAFC6);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Profil'),
        backgroundColor: colorTheme,
      ),
      backgroundColor: Color(0xFFF0F4F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Ubah Data Profil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A5160),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Email tidak boleh kosong' : null,
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _updateProfil,
                        icon: Icon(Icons.save),
                        label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorTheme,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
