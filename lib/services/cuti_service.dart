import 'dart:convert';
import 'package:http/http.dart' as http;

class CutiService {
  static const String baseUrl = 'http://localhost:3000/attendance';

  // ✅ Mengajukan cuti
  static Future<bool> ajukanCuti({
    required String token,
    required String alasan,
    required String tanggalMulai,
    required String tanggalSelesai,
  }) async {
    final url = Uri.parse('$baseUrl/cuti');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'alasan': alasan,
        'tanggal_mulai': tanggalMulai,
        'tanggal_selesai': tanggalSelesai,
      }),
    );

    if (response.statusCode == 201) {
      print("✅ Pengajuan cuti berhasil");
      return true;
    } else {
      print("❌ Gagal mengajukan cuti: ${response.body}");
      return false;
    }
  }

  // ✅ Ambil riwayat cuti
  static Future<List<Map<String, dynamic>>> fetchRiwayatCuti(String token) async {
    final url = Uri.parse('$baseUrl/cuti/history'); // pastikan backend support endpoint ini

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('❌ Gagal mengambil riwayat cuti');
    }
  }
}
