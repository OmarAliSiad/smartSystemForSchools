import 'dart:io';

class ProfileDataModel {
  final String phone;
  final File? image;
  final String gender;
  final String address;

  ProfileDataModel({
    required this.phone,
    this.image, // Made optional by removing "required"
    required this.gender,
    required this.address,
  });

  // Add copyWith method for easier updates
  ProfileDataModel copyWith({
    String? phone,
    File? image,
    String? gender, 
    String? address,
  }) {
    return ProfileDataModel(
      phone: phone ?? this.phone,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      address: address ?? this.address,
    );
  }
}