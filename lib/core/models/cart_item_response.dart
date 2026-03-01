import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String nombre;
  final double precio;
  final int cantidad;
  final String? imageUrl;

  const CartItem({
    required this.productId,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.imageUrl
  });

  CartItem copyWith({
    int? productId,
    String? nombre,
    double? precio,
    int? cantidad,
    String? imageUrl
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      imageUrl: imageUrl ?? this.imageUrl
    );
  }

  @override
  List<Object> get props => [productId, nombre, precio, cantidad];
}