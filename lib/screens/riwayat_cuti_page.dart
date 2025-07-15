import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/cuti_service.dart';

class RiwayatCutiPage extends StatelessWidget {
  final String token;

  RiwayatCutiPage({required this.token});

  String formatTanggal(String rawDate) {
    try {
      final date = DateTime.parse(rawDate).toLocal();
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Cuti"),
        backgroundColor: Color(0xFF8FAFC6),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: CutiService.fetchRiwayatCuti(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("📄 Belum ada riwayat cuti."));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final alasan = item['alasan'] ?? '-';
              final mulai = formatTanggal(item['tanggal_mulai']);
              final selesai = formatTanggal(item['tanggal_selesai']);
              final dibuat = formatTanggal(item['created_at']);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.beach_access, color: Color(0xFF8FAFC6)),
                  title: Text("🗓️ $mulai - $selesai"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alasan: $alasan"),
                      Text("Dibuat: $dibuat"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
