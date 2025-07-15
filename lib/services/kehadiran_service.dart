import 'dart:convert';
import 'package:http/http.dart' as http;

class KehadiranService {
  static const String baseUrl = 'http://localhost:3000';

  // ✅ Ambil riwayat kehadiran
  static Future<List<Map<String, dynamic>>> fetchKehadiran(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/attendance/history'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal mengambil data kehadiran');
    }
  }

  // ✅ Absen Masuk dengan waktu manual (check_in dalam UTC ISO)
  static Future<String> absenMasuk(String token, {required String checkIn}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance/mark'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'check_in': checkIn, // 🕒 Kirim waktu absen masuk manual
      }),
    );

    if (response.statusCode == 201) {
      return 'Berhasil absen masuk.';
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal absen masuk');
    }
  }

  // ✅ Absen Keluar (jika backend pakai waktu server)
  static Future<String> absenKeluar(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance/clock-out'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return 'Berhasil absen keluar.';
    } else {
      final body = json.decode(response.body);
      throw Exception(body['message'] ?? 'Gagal absen keluar');
    }
  }
}
