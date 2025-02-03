part of 'get_user_data_cubit.dart';

@immutable
sealed class GetUserDataState {}

final class GetUserDataInitial extends GetUserDataState {}

final class Loading extends GetUserDataState {}

final class UserDataLoaded extends GetUserDataState {
  // final List<QueryDocumentSnapshot> data;
  // UserDataLoaded({required this.data});
}

final class UserDataFailure extends GetUserDataState {
  final String errorMessage;
  UserDataFailure({required this.errorMessage});
}
