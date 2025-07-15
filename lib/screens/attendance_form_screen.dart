import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceFormScreen extends StatefulWidget {
  final String name;
  final String token;

  const AttendanceFormScreen({required this.name, required this.token});

  @override
  _AttendanceFormScreenState createState() => _AttendanceFormScreenState();
}

class _AttendanceFormScreenState extends State<AttendanceFormScreen> {
  bool submitted = false;
  String message = '';

  Future<void> submitAttendance() async {
    final res = await http.post(
      Uri.parse('http://localhost:3000/attendance/mark'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (res.statusCode == 201) {
      setState(() {
        submitted = true;
        message = 'Absensi berhasil!';
      });
    } else {
      final body = jsonDecode(res.body);
      setState(() {
        submitted = true;
        message = 'Gagal: ${body['message']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Absensi')),
      body: Center(
        child: submitted
            ? Text(message, style: TextStyle(fontSize: 18))
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat datang, ${widget.name}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitAttendance,
              child: Text('Check In'),
            ),
          ],
        ),
      ),
    );
  }
}
