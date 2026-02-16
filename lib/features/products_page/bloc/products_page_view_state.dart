part of 'products_page_view_bloc.dart';

sealed class ProductsPageViewState extends Equatable {
  const ProductsPageViewState();
  
  @override
  List<Object> get props => [];
}

final class ProductsPageViewInitial extends ProductsPageViewState {}

final class ProductsPageViewLoading extends ProductsPageViewState {}

final class ProductsPageViewSuccess extends ProductsPageViewState {
  final List<Product> productsList;
  const ProductsPageViewSuccess({required this.productsList});
}

final class ProductsPageViewError extends ProductsPageViewState {
  final String message;
  const ProductsPageViewError({required this.message});
}
