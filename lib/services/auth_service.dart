import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = 'http://localhost:3000/auth';

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        'token': data['token'],
        'user': data['user'],
      };
    } else {
      return null;
    }
  }

  static Future<bool> register(String name, String email, String password, String role) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
    );

    return res.statusCode == 201;
  }
}
