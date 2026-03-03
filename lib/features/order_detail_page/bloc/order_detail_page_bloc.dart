import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_detail_page_event.dart';
part 'order_detail_page_state.dart';

class OrderDetailPageBloc extends Bloc<OrderDetailPageEvent, OrderDetailPageState> {
  OrderDetailPageBloc() : super(OrderDetailPageInitial()) {
    on<OrderDetailPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
