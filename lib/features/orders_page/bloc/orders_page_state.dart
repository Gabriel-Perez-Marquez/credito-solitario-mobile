part of 'orders_page_bloc.dart';

sealed class OrdersPageState extends Equatable {
  const OrdersPageState();
  
  @override
  List<Object> get props => [];
}

final class OrdersPageInitial extends OrdersPageState {}


final class OrdersPageLoading extends OrdersPageState {}

final class OrdersPageSuccess extends OrdersPageState {
  final List<OrderModel> orders;
  const OrdersPageSuccess({required this.orders});
}

final class OrdersPageError extends OrdersPageState {
  final String message;
  const OrdersPageError({required this.message});
}