import 'dart:convert';

import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final String _apiBaseUrl;
  final AuthStorageService _authStorageService;
  final List<String> _profilePaths;

  ProfileService({
    String apiBaseUrl = 'http://10.0.2.2:8000/api',
    AuthStorageService? authStorageService,
    List<String>? profilePaths,
  }) : _apiBaseUrl = apiBaseUrl,
       _authStorageService = authStorageService ?? AuthStorageService(),
       _profilePaths =
           profilePaths ?? const ['/perfil', '/profile', '/me', '/user'];

  Future<Map<String, dynamic>> getMyProfile() async {
    final token = await _authStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa. Inicia sesión nuevamente.');
    }

    final savedUser = await _authStorageService.getUser();
    if (savedUser != null) {
      return savedUser;
    }

    for (final path in _profilePaths) {
      final uri = Uri.parse('$_apiBaseUrl$path');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _parseProfileResponse(response.body);
      }

      if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado. Inicia sesión otra vez.');
      }

      if (response.statusCode != 404) {
        throw Exception('Error al cargar perfil (${response.statusCode}).');
      }
    }

    throw Exception(
      'No se encontró endpoint de perfil válido. Revisa profilePaths en ProfileService.',
    );
  }

  Map<String, dynamic> _parseProfileResponse(String body) {
    final decoded = jsonDecode(body);

    if (decoded is Map<String, dynamic>) {
      final user = _extractUserMap(decoded);
      if (user != null) {
        return user;
      }
    }

    throw Exception('Formato de respuesta inválido para perfil.');
  }

  Map<String, dynamic>? _extractUserMap(Map<String, dynamic> data) {
    if (_looksLikeUserMap(data)) {
      return data;
    }

    final nestedCandidates = [
      data['data'],
      data['user'],
      data['profile'],
      data['usuario'],
    ];

    for (final candidate in nestedCandidates) {
      if (candidate is Map<String, dynamic> && _looksLikeUserMap(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  bool _looksLikeUserMap(Map<String, dynamic> map) {
    final hasName = map.containsKey('name') || map.containsKey('nombre');
    final hasEmail = map.containsKey('email') || map.containsKey('correo');
    return hasName || hasEmail;
  }




  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await _authStorageService.getToken();

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('La contraseña actual no es correcta');
      }

      return;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
