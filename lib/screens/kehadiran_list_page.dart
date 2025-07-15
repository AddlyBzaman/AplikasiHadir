import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/kehadiran_service.dart';

class KehadiranListPage extends StatefulWidget {
  final String token;

  KehadiranListPage({required this.token});

  @override
  _KehadiranListPageState createState() => _KehadiranListPageState();
}

class _KehadiranListPageState extends State<KehadiranListPage> {
  late Future<List<Map<String, dynamic>>> _kehadiranList;

  @override
  void initState() {
    super.initState();
    _kehadiranList = KehadiranService.fetchKehadiran(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Color(0xFF8FAFC6);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kehadiran'),
        backgroundColor: colorTheme,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _kehadiranList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '📄 Tidak ada data kehadiran.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              final formattedDate = formatTanggal(item['date']);
              final jamMasuk = formatJam(item['check_in']);
              final jamKeluar = formatJam(item['check_out']);
              final status = item['status'] ?? 'present';

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: colorTheme),
                  title: Text(
                    formattedDate,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masuk: $jamMasuk'),
                      Text(
                        jamKeluar != '-' ? 'Keluar: $jamKeluar' : '❌ Belum absen keluar',
                        style: TextStyle(
                          color: jamKeluar != '-' ? Colors.black87 : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    status == 'present' ? 'Hadir' : status,
                    style: TextStyle(
                      color: status == 'present' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ✅ Format tanggal dari string "YYYY-MM-DD" atau "YYYY-MM-DD HH:mm:ss"
  String formatTanggal(dynamic rawDate) {
    try {
      if (rawDate == null || rawDate.toString().trim().isEmpty) return '-';

      final cleanDate = rawDate.toString().split(' ')[0];
      final date = DateTime.parse(cleanDate).toLocal();

      return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      print('❌ Error formatTanggal: $e | value: $rawDate');
      return 'Tanggal tidak valid';
    }
  }

  // ✅ Format jam dari string "YYYY-MM-DD HH:mm:ss"
  String formatJam(dynamic rawDate) {
    try {
      if (rawDate == null || rawDate.toString().trim().isEmpty) return '-';

      final parsed = DateTime.parse(rawDate.toString()).toLocal();
      return DateFormat('HH:mm').format(parsed);
    } catch (e) {
      print('❌ Error formatJam: $e | value: $rawDate');
      return '-';
    }
  }
}
