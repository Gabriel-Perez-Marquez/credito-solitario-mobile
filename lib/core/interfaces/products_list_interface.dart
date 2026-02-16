import 'package:credito_solitario_mobile/core/models/product_list_response.dart';

abstract class ProductsListInterface {
  Future<List<Product>> getAll ();
}