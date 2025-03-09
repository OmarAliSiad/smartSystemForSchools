import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/profile_data_model.dart';
part 'change_data_profile_state.dart';

class ChangeDataProfileCubit extends Cubit<ChangeDataProfileState> {
  TextEditingController Phone = TextEditingController();

  File? image;

  ChangeDataProfileCubit() : super(ChangeDataProfileInitial());

  // Save profile data to SharedPreferences
  Future<void> saveProfileData(ProfileDataModel profileDataModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save data to SharedPreferences
      // await prefs.setString('name', profileDataModel.name);
      await prefs.setString('phone', profileDataModel.phone);
      // await prefs.setString('email', profileDataModel.email);
      await prefs.setString('image', profileDataModel.image?.path ?? '');

      // Debug: Print saved data
      log('Profile data saved:');
      // log('Name: ${profileDataModel.name}');
      log('Phone: ${profileDataModel.phone}');
      // log('Email: ${profileDataModel.email}');
      log('Image Path: ${profileDataModel.image?.path}');
    } catch (e) {
      log('Error saving profile data: $e');
    }
  }

  // Load profile data from SharedPreferences
  Future<void> loadProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve data from SharedPreferences
      // String? name = prefs.getString('name');
      String? phone = prefs.getString('phone');
      // String? email = prefs.getString('email');
      String? imagePath = prefs.getString('image');

      // Update controllers and image
      // if (name != null) Name.text = name;
      if (phone != null) Phone.text = phone;
      // if (email != null) Email.text = email;

      if (imagePath != null && imagePath.isNotEmpty) {
        // Check if the image file exists
        if (File(imagePath).existsSync()) {
          image = File(imagePath);
        } else {
          log('Image file not found at path: $imagePath');
          image = null;
        }
      } else {
        image = null;
      }

      // Emit the loaded state
      emit(
        DataProfileLoaded(
          profileDataModel: ProfileDataModel(
            // email: Email.text,
            // name: Name.text,
            phone: Phone.text,
            image: image,
          ),
        ),
      );
    } catch (e) {
      log('Error loading profile data: $e');
      emit(ChangeDataProfileError('Failed to load profile data.'));
    }
  }

  // Pick an image from the gallery
  Future<void> pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);

        // Debug: Print picked image path
        log('Image picked: ${image!.path}');

        // Emit the updated state
        emit(
          DataProfileLoaded(
            profileDataModel: ProfileDataModel(
              // email: Email.text,
              // name: Name.text,
              phone: Phone.text,
              image: image,
            ),
          ),
        );
      } else {
        log('No image selected.');
      }
    } catch (e) {
      log('Error picking image: $e');
      emit(ChangeDataProfileError('Failed to pick image.'));
    }
  }
}
