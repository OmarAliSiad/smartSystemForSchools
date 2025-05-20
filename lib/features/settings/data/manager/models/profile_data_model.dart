import 'dart:io';

class ProfileDataModel {
  final String? username;
  final String phone;
  final File? image;
  final String gender;
  final String email;
  final String address;

  ProfileDataModel({
    this.username,
    required this.phone,
    this.image, // Made optional by removing "required"
    required this.gender,
    required this.address,
    required this.email,
  });

  // Add copyWith method for easier updates
  ProfileDataModel copyWith({
    String? phone,
    File? image,
    String? gender,
    String? address,
  }) {
    return ProfileDataModel(
      username: username ?? username,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      email: email ?? email,
    );
  }
}
