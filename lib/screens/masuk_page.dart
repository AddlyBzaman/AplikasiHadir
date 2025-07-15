import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/kehadiran_service.dart';

class MasukPage extends StatefulWidget {
  final String name;
  final String token;

  const MasukPage({super.key, required this.name, required this.token});

  @override
  _MasukPageState createState() => _MasukPageState();
}

class _MasukPageState extends State<MasukPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _handleAbsenMasuk() async {
    if (selectedDate == null || selectedTime == null) {
      _showMessage("⚠️ Silakan pilih tanggal dan jam terlebih dahulu.");
      return;
    }

    final rawHour = selectedTime!.hour;
    final rawMinute = selectedTime!.minute;

    final selectedDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      rawHour,
      rawMinute,
    );

    // Format manual tanpa UTC/offset
    final formattedCheckIn = DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDateTime);
    print("📤 check_in dikirim ke backend: $formattedCheckIn");

    // Validasi batas masuk maksimal jam 13.00
    final batasMasuk = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      13, 0, 0,
    );

    if (selectedDateTime.isAfter(batasMasuk)) {
      _showMessage("❌ Jam masuk melebihi batas pukul 13:00.");
      return;
    }

    try {
      final message = await KehadiranService.absenMasuk(
        widget.token,
        checkIn: formattedCheckIn,
      );
      _showMessage("✅ ${widget.name}, $message");

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, true);
      });
    } catch (e) {
      _showMessage("❌ Gagal absen: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = const Color(0xFF8FAFC6);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Absen Masuk"),
        backgroundColor: colorTheme,
      ),
      backgroundColor: const Color(0xFFF0F4F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat datang, ${widget.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3A5160),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Absen Masuk",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                const Text("Pilih Jam", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime == null
                              ? "Belum dipilih"
                              : selectedTime!.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.access_time, color: colorTheme),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text("Pilih Tanggal", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Belum dipilih"
                              : DateFormat.yMMMMEEEEd().format(selectedDate!),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today_outlined, color: colorTheme),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleAbsenMasuk,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Saya Telah Masuk"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorTheme,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
