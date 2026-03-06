import 'dart:convert';

import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final String _apiBaseUrl;
  final AuthStorageService _authStorageService;

  ProfileService({
    String apiBaseUrl = 'http://10.0.2.2:8000/api',
    AuthStorageService? authStorageService,
    List<String>? profilePaths,
  }) : _apiBaseUrl = apiBaseUrl,
       _authStorageService = authStorageService ?? AuthStorageService();



  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final token = await _authStorageService.getToken();

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar el perfil');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
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


  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String calle,
    required String numCasa,
    required String municipio,
  }) async {
    try {
      final token = await _authStorageService.getToken();

      final response = await http.put(
        Uri.parse('$_apiBaseUrl/profile'), 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'telefono': phone,
          'calle': calle,
          'numCasa': numCasa,
          'municipio': municipio,
        }),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Error al actualizar el perfil');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getMyHistory() async {
    try {
      final token = await _authStorageService.getToken();

      final response = await http.get(
        Uri.parse('$_apiBaseUrl/my-orders'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
