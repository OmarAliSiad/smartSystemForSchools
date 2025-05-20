// allergies_state.dart
import 'package:equatable/equatable.dart';
import 'package:smartsystemforschools/core/models/allegries_products/allegries_products.dart';

abstract class AllergiesProductsState extends Equatable {
  const AllergiesProductsState();

  @override
  List<Object?> get props => [];
}

class AllergiesInitial extends AllergiesProductsState {}

class AllergiesLoading extends AllergiesProductsState {}

class AllergiesLoaded extends AllergiesProductsState {
  final AllegriesProducts allergiesProducts;

  const AllergiesLoaded({required this.allergiesProducts});

  @override
  List<Object> get props => [allergiesProducts];
}

class AllergiesError extends AllergiesProductsState {
  final String message;

  const AllergiesError({required this.message});

  @override
  List<Object> get props => [message];
}
