part of 'shopping_cart_bloc.dart';

sealed class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}


final class AddItemEvent extends ShoppingCartEvent {
  final CartItem item;
  const AddItemEvent(this.item);
  @override
  List<Object> get props => [item];
}


final class RemoveItemEvent extends ShoppingCartEvent {
  final int productId;
  const RemoveItemEvent(this.productId);
  @override
  List<Object> get props => [productId];
}

final class CheckoutEvent extends ShoppingCartEvent {
  final int clienteId;
  final String token;
  const CheckoutEvent({required this.clienteId, required this.token});
  @override
  List<Object> get props => [clienteId, token];
}

final class UpdateQuantityEvent extends ShoppingCartEvent {
  final int productId;
  final int nuevaCantidad;
  const UpdateQuantityEvent(this.productId, this.nuevaCantidad);
  @override
  List<Object> get props => [productId, nuevaCantidad];
}