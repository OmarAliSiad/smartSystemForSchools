part of 'change_data_profile_cubit.dart';

@immutable
sealed class ChangeDataProfileState {}

final class ChangeDataProfileInitial extends ChangeDataProfileState {}

final class DataProfileLoaded extends ChangeDataProfileState {
  final ProfileDataModel profileDataModel;
  DataProfileLoaded({required this.profileDataModel});
}

class ChangeDataProfileError extends ChangeDataProfileState {
  final String message;
  ChangeDataProfileError(this.message);
}
