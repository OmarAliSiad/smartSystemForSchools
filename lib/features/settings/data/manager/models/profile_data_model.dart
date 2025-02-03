import 'dart:io';

class ProfileDataModel {
  final String name;
  final String email;
  final String phone;
  final File? image;

  ProfileDataModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });
}
