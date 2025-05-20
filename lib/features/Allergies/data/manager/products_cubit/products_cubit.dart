import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/models/get_all_products/get_all_products.dart';
import '../../../../../core/services/product_catogry_service/product_catogry_service.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  Future<void> getProducts({int? catogryIdFilter}) async {
    try {
      emit(ProductLoading());
      await ProductAndCatogryService()
          .getAllProducts(catogrydIdFilter: catogryIdFilter)
          .then((GetAllProducts value) {
        if (value.statusCode == 200 || value.isSuccess == true) {
          emit(ProductsSucess(getAllProducts: value));
        } else {
          log('===================${value.message!}');
          emit(ProductsFailure(errMessage: value.message!));
        }
      });
    } catch (e) {
      emit(ProductsFailure(errMessage: e.toString()));
    }
  }
}
