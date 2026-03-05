import 'dart:convert';
import 'package:credito_solitario_mobile/core/models/notificacion_response.dart';
import 'package:http/http.dart' as http;
import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';

class NotificationsService {
  // Ajusta esta URL a tu configuración
  final String _apiBaseUrl = 'http://10.0.2.2:8000/api'; 
  final AuthStorageService _authStorageService = AuthStorageService();

  Future<List<NotificationModel>> getMyNotifications() async {
    try {
      final token = await _authStorageService.getToken();
      
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/notificaciones'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        return []; 
      }
    } catch (e) {
      return [];
    }
  }
}