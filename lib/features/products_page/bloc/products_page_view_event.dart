part of 'products_page_view_bloc.dart';

sealed class ProductsPageViewEvent extends Equatable {
  const ProductsPageViewEvent();

  @override
  List<Object> get props => [];
}


final class ProductsPageViewFetchAllEvent extends ProductsPageViewEvent {}