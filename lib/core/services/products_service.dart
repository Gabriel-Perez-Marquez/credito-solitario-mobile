import 'dart:convert';

import 'package:credito_solitario_mobile/core/interfaces/products_list_interface.dart';
import 'package:credito_solitario_mobile/core/models/product_list_response.dart';
import 'package:credito_solitario_mobile/core/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;

class ProductsService implements ProductsListInterface {
  final String _apiBaseUrl = 'http://10.0.2.2:8000/api';
  final AuthStorageService _authStorageService = AuthStorageService();

  @override
  Future<List<Product>> getAll() async {
    final token = await _authStorageService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No hay sesión activa. Inicia sesión nuevamente.');
    }

    final url = '$_apiBaseUrl/productos';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var productListResponse = ProductListResponse.fromJson(
          jsonDecode(response.body),
        ).products;

        return productListResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado. Inicia sesión otra vez.');
      } else {
        throw Exception('Error al cargar productos (${response.statusCode}).');
      }
    } catch (e) {
      throw Exception('Error al obtener la información: $e');
    }
  }

  Future<List<Categoria>> getCategorias() async {
    final token = await _authStorageService.getToken();
    final url = '$_apiBaseUrl/categorias'; // Asegúrate de tener esta ruta en Laravel
    
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }
}
