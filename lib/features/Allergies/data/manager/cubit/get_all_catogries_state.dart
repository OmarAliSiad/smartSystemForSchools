part of 'get_all_catogries_cubit.dart';

@immutable
sealed class GetAllCatogriesState {}

final class GetAllCatogriesInitial extends GetAllCatogriesState {}

final class GetAllCatogriesLoading extends GetAllCatogriesState {}

final class GetAllCatogriesLoaded extends GetAllCatogriesState {
  final CatgoryDetails catgoryDetails;
  GetAllCatogriesLoaded({required this.catgoryDetails});
}

final class GetAllCatogriesFailure extends GetAllCatogriesState {
  final String errMessage;
  GetAllCatogriesFailure(this.errMessage);
}
