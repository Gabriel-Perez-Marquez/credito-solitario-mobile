import 'dart:convert';
import 'package:credito_solitario_mobile/core/models/order_response.dart';
import 'package:http/http.dart' as http;
import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';

class OrdersService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; 
  final AuthStorageService _authStorage = AuthStorageService();

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final token = await _authStorage.getToken();
      if (token == null) throw Exception('No hay token de sesión');

      final response = await http.get(
        Uri.parse('$baseUrl/my-orders'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}