part of 'get_user_data_cubit.dart';

@immutable
sealed class GetUserDataState {}

final class GetUserDataInitial extends GetUserDataState {}

final class GetUserDataLoading extends GetUserDataState {}

final class GetUserDataSuccess extends GetUserDataState {
  UserInfoModel userInfo;
  GetUserDataSuccess({required this.userInfo});
}

final class UserDataFailure extends GetUserDataState {
  final String errorMessage;
  UserDataFailure({required this.errorMessage});
}
