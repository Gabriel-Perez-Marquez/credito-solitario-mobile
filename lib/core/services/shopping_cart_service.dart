import 'dart:convert';

import 'package:http/http.dart' as http;

class ShoppingCartService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  

  Future<Map<String, dynamic>> checkoutVenta({
    required int clienteId,
    required List<Map<String, dynamic>> lineasCarrito,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/carrito/checkout-movil');

    final Map<String, dynamic> bodyData = {
      "cliente_id": clienteId,
      "lineas": lineasCarrito,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } 
      else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Error de validación o stock');
      } 
      else {
        throw Exception('Error en el servidor. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  } 



}