import 'package:flutter/material.dart';
import '../services/cuti_service.dart';

class CutiPage extends StatefulWidget {
  final String token;
  CutiPage({required this.token});

  @override
  _CutiPageState createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  final _formKey = GlobalKey<FormState>();
  final _alasanController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  bool _isLoading = false;

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _submitCuti() async {
    if (_formKey.currentState!.validate() &&
        _tanggalMulai != null &&
        _tanggalSelesai != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await CutiService.ajukanCuti(
          token: widget.token,
          alasan: _alasanController.text,
          tanggalMulai: formatDate(_tanggalMulai!),
          tanggalSelesai: formatDate(_tanggalSelesai!),
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Pengajuan cuti berhasil!')),
          );
          Navigator.pop(context);
        } else {
          throw Exception();
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal mengajukan cuti')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        if (isStart) {
          _tanggalMulai = selected;
        } else {
          _tanggalSelesai = selected;
        }
      });
    }
  }

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajukan Cuti'),
        backgroundColor: Color(0xFF8FAFC6),
      ),
      backgroundColor: Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Pengajuan Cuti',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A5160),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _alasanController,
                      decoration: InputDecoration(
                        labelText: 'Alasan Cuti',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.edit_note),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alasan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Tanggal Mulai',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tanggalMulai == null
                                ? 'Belum dipilih'
                                : formatDate(_tanggalMulai!),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context, true),
                          icon: Icon(Icons.calendar_today),
                          label: Text('Pilih'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8FAFC6),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tanggal Selesai',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tanggalSelesai == null
                                ? 'Belum dipilih'
                                : formatDate(_tanggalSelesai!),
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context, false),
                          icon: Icon(Icons.calendar_today_outlined),
                          label: Text('Pilih'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8FAFC6),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitCuti,
                          icon: Icon(Icons.send),
                          label: Text('Kirim Pengajuan'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Color(0xFF3A5160),
                            foregroundColor: Colors.white,
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
        ),
      ),
    );
  }
}
