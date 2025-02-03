part of 'add_child_cubit.dart';

@immutable
sealed class AddChildCubitState {}

final class AddChildCubitInitial extends AddChildCubitState {}

final class AddChildCubitLAddedSuccess extends AddChildCubitState {}

final class AddChildCubitAddedFailure extends AddChildCubitState {
  final String errorMessage;
  AddChildCubitAddedFailure({required this.errorMessage});
}
