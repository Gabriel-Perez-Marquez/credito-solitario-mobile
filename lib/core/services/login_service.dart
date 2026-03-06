import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';

class LoginService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  final AuthStorageService _authStorageService = AuthStorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user']['cliente'] == null) {
          throw Exception('Los administradores deben usar el panel web.');
        }
        final token = _extractToken(data);
        final user = _extractUser(data);

        if (token == null || token.isEmpty) {
          return {
            'success': false,
            'error':
                'Login correcto, pero no se encontró token en la respuesta.',
          };
        }

        await _authStorageService.saveToken(token);
        if (user != null) {
          await _authStorageService.saveUser(user);
        }
        return {'success': true, 'data': data};
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Usuario o contraseña incorrectos'};
      } else {
        return {
          'success': false,
          'error': 'Error en el servidor. Código: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: ${e.toString()}'};
    }
  }

  

  String? _extractToken(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }

    if (data['token'] is String) {
      return data['token'] as String;
    }

    if (data['access_token'] is String) {
      return data['access_token'] as String;
    }

    if (data['data'] is Map<String, dynamic>) {
      final nestedData = data['data'] as Map<String, dynamic>;
      if (nestedData['token'] is String) {
        return nestedData['token'] as String;
      }
      if (nestedData['access_token'] is String) {
        return nestedData['access_token'] as String;
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractUser(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return null;
    }

    if (_looksLikeUserMap(data)) {
      return data;
    }

    final nestedCandidates = [
      data['data'],
      data['user'],
      data['usuario'],
      data['profile'],
    ];

    for (final candidate in nestedCandidates) {
      if (candidate is Map<String, dynamic> && _looksLikeUserMap(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  bool _looksLikeUserMap(Map<String, dynamic> map) {
    return map.containsKey('name') ||
        map.containsKey('nombre') ||
        map.containsKey('email') ||
        map.containsKey('correo');
  }
}
