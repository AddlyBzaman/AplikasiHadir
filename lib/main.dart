import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ Tambahkan import intl
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Wajib sebelum async init
  await initializeDateFormatting('id_ID', null); // ✅ Inisialisasi locale Indonesia
  runApp(KehadiranApp());
}

class KehadiranApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kehadiran',
      theme: ThemeData(
        primaryColor: Color(0xFF8FAFC6),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(), // Halaman awal
      debugShowCheckedModeBanner: false,
    );
  }
}
