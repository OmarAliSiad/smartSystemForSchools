part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductLoading extends ProductsState {}

final class ProductsSucess extends ProductsState {
  final GetAllProducts getAllProducts;
  const ProductsSucess({required this.getAllProducts});
}

final class ProductsFailure extends ProductsState {
  final String errMessage;
  const ProductsFailure({required this.errMessage});
}
