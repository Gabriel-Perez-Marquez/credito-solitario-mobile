import 'dart:convert';

import 'package:credito_solitario_mobile/core/interfaces/products_list_interface.dart';
import 'package:credito_solitario_mobile/core/models/product_list_response.dart';
import 'package:http/http.dart' as http;

class ProductsService implements ProductsListInterface {
  
  final String _apiBaseUrl = "http://127.0.0.1:8000/api";
  
  
  
  @override
  Future<List<Product>> getAll() async {
    final url = "$_apiBaseUrl/productos";


    var response = await http.get(Uri.parse(url));

    try{
      if(response.statusCode >= 200  && response.statusCode <300){
        var productListResponse = ProductListResponse.fromJson(
          jsonDecode(response.body),
        ).products;

        return productListResponse;
      } else {
        return [];
      }
    } catch (e){
      throw Exception("Error al obtener la información");
    }

  }

}