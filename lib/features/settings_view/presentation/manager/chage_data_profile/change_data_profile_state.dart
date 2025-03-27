import 'dart:io';

import 'package:smartsystemforschools/features/settings/data/manager/models/profile_data_model.dart';

sealed class ChangeDataProfileState {}

final class ChangeDataProfileInitial extends ChangeDataProfileState {}

final class ChangeDataProfileLoading extends ChangeDataProfileState {}

final class ChangeDataProfileSuccess extends ChangeDataProfileState {}

final class DataProfileLoaded extends ChangeDataProfileState {
  final ProfileDataModel profileDataModel;
  DataProfileLoaded({required this.profileDataModel});
}

final class ImagePicked extends ChangeDataProfileState {
  final File image;
  ImagePicked({required this.image});
}

class ChangeDataProfileError extends ChangeDataProfileState {
  final String message;
  ChangeDataProfileError(this.message);
}
