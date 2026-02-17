import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/models/cart_item_response.dart';
import 'package:credito_solitario_mobile/core/services/shopping_cart_service.dart';
import 'package:credito_solitario_mobile/features/shopping_cart/bloc/shopping_cart_bloc.dart';





class SoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {

  SoppingCartBloc(ShoppingCartService shoppingCartService) : super(ShoppingCartInitial()) {
    on<AddItemEvent>((event, emit) async{
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((i) => i.productId == event.item.productId);
      
      if (index >= 0) {
        updatedItems[index] = updatedItems[index].copyWith(
          cantidad: updatedItems[index].cantidad + event.item.cantidad,
        );
      } else {
        updatedItems.add(event.item);
      }
      emit(ShoppingCartInitial(items: updatedItems));
    });

    on<RemoveItemEvent>((event, emit) {
      final updatedItems = state.items.where((i) => i.productId != event.productId).toList();
      emit(ShoppingCartInitial(items: updatedItems));
    });

    on<CheckoutEvent>((event, emit) async {
      if (state.items.isEmpty) return;
      
      final currentItems = state.items;
      emit(ShoppingCartLoading(items: currentItems));
      
      try {
        final lineas = currentItems.map((item) => {
          "producto_id": item.productId,
          "cantidad": item.cantidad,
        }).toList();

        final response = await shoppingCartService.checkoutVenta(
          clienteId: event.clienteId,
          lineasCarrito: lineas,
          token: event.token,
        );
        
        emit(ShoppingCartSuccess(
          items: const [], 
          message: response['message'] ?? 'Compra realizada correctamente'
        ));
        
      } catch (e) {
        emit(ShoppingCartError(
          items: currentItems, 
          message: e.toString()
        ));
        
        emit(ShoppingCartInitial(items: currentItems));
      }
    });

    on<UpdateQuantityEvent>((event, emit) {
      final updatedItems = List<CartItem>.from(state.items);
      final index = updatedItems.indexWhere((i) => i.productId == event.productId);
      
      if (index >= 0) {
        if (event.nuevaCantidad > 0) {
          updatedItems[index] = updatedItems[index].copyWith(cantidad: event.nuevaCantidad);
        } else {
          updatedItems.removeAt(index); 
        }
        emit(ShoppingCartInitial(items: updatedItems));
      }
    });
  }
}
