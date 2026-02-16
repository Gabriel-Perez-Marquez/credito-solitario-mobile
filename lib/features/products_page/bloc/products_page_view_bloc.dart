import 'package:bloc/bloc.dart';
import 'package:credito_solitario_mobile/core/models/product_list_response.dart';
import 'package:credito_solitario_mobile/core/services/products_service.dart';
import 'package:equatable/equatable.dart';

part 'products_page_view_event.dart';
part 'products_page_view_state.dart';

class ProductsPageViewBloc extends Bloc<ProductsPageViewEvent, ProductsPageViewState> {
  ProductsPageViewBloc(ProductsService productsService) : super(ProductsPageViewInitial()) {
    on<ProductsPageViewEvent>((event, emit) async {
      emit(ProductsPageViewLoading());
      try{
        var apiProductsList = await productsService.getAll();

        emit(ProductsPageViewSuccess(productsList: apiProductsList));
      } catch (e){
        emit(ProductsPageViewError(message: e.toString()));
      }
    });
  }
}
