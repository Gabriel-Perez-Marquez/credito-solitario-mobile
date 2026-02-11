import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  // Cambia esta URL por la URL de tu API
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Usuario o contraseña incorrectos'};
      } else {
        return {
          'success': false,
          'error': 'Error en el servidor. Código: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Error de conexión
      return {'success': false, 'error': 'Error de conexión: ${e.toString()}'};
    }
  }
}
