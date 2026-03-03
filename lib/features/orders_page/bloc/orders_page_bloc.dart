import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/models/order_response.dart';
import 'package:credito_solitario_mobile/core/services/orders_service.dart';
import 'package:equatable/equatable.dart';

part 'orders_page_event.dart';
part 'orders_page_state.dart';

class OrdersPageBloc extends Bloc<OrdersPageEvent, OrdersPageState> {
  OrdersPageBloc(OrdersService ordersService) : super(OrdersPageInitial()) {
    on<OrdersPageEvent>((event, emit) async {
      emit(OrdersPageLoading());
      try {
        final orders = await ordersService.getMyOrders();
        emit(OrdersPageSuccess(orders: orders));
      } catch (e) {
        emit(OrdersPageError(message: e.toString()));
      }
    });
  }
}
