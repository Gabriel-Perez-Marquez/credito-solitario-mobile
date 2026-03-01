part of 'shopping_cart_bloc.dart';

@immutable
sealed class ShoppingCartState extends Equatable {
  final List<CartItem> items;
  
  const ShoppingCartState({this.items = const []});

  double get totalPrice => items.fold(0, (total, item) => total + (item.precio * item.cantidad));

  @override
  List<Object> get props => [items];
}

final class ShoppingCartInitial extends ShoppingCartState {
  const ShoppingCartInitial({super.items = const []});
}

final class ShoppingCartLoading extends ShoppingCartState {
  const ShoppingCartLoading({required super.items}); 
}

final class ShoppingCartSuccess extends ShoppingCartState {
  final String message;
  const ShoppingCartSuccess({required super.items, required this.message});

  @override
  List<Object> get props => [items, message];
}

final class ShoppingCartError extends ShoppingCartState {
  final String message;
  const ShoppingCartError({required super.items, required this.message});

  @override
  List<Object> get props => [items, message];
}