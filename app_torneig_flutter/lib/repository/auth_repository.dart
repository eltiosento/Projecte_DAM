import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static Future<void> login(
    String username,
    String password,
    String ip,
  ) async {
    String url = 'http://$ip/api/auth/login';

    http.Response response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token']; // Extrae el token
      final role = responseData['roles'][0]; // Extrae el primer rol

      // Almacenar el token JWT y el rol
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_role', role);
    } else {
      throw Exception('Error al iniciar sessio.');
    }
  }
}
