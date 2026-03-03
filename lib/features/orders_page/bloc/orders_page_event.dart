part of 'orders_page_bloc.dart';

sealed class OrdersPageEvent extends Equatable {
  const OrdersPageEvent();

  @override
  List<Object> get props => [];
}


class FetchOrdersEvent extends OrdersPageEvent {}