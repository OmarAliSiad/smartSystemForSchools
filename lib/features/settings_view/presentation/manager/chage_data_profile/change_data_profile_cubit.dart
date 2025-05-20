import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/utils/Constants.dart';
import '../../../../settings/data/manager/models/profile_data_model.dart';
import 'change_data_profile_state.dart';

class ChangeDataProfileCubit extends Cubit<ChangeDataProfileState> {
  TextEditingController Phone = TextEditingController();
  TextEditingController Gender = TextEditingController();
  TextEditingController Address = TextEditingController();

  File? image;

  ChangeDataProfileCubit() : super(ChangeDataProfileInitial());

  // Save profile data to SharedPreferences
  Future<void> saveProfileData(ProfileDataModel profileDataModel) async {
    try {
      emit(ChangeDataProfileLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Save all data using Constants
      await prefs.setString(Constants.phone, profileDataModel.phone);
      await prefs.setString(Constants.gender, profileDataModel.gender);
      await prefs.setString(Constants.address, profileDataModel.address);
      await prefs.setString(Constants.email, profileDataModel.email);

      // Update local controllers
      Phone.text = profileDataModel.phone;
      Gender.text = profileDataModel.gender;
      Address.text = profileDataModel.address;

      // Only save image path if image exists
      if (profileDataModel.image != null) {
        await prefs.setString(Constants.image, profileDataModel.image!.path);
      }

      // Emit success state with updated profile data
      emit(DataProfileLoaded(
          profileDataModel: ProfileDataModel(
              username: profileDataModel.username,
              phone: profileDataModel.phone,
              gender: profileDataModel.gender,
              address: profileDataModel.address,
              email: profileDataModel.email,
              image: profileDataModel.image)));
    } catch (e) {
      log('Error saving profile data: $e');
      emit(ChangeDataProfileError('Failed to save profile data: $e'));
    }
  }

  // Load profile data from SharedPreferences
  Future<void> loadProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Retrieve data from SharedPreferences
      String? phone = prefs.getString(Constants.phone);
      String? gender = prefs.getString(Constants.gender);
      String? address = prefs.getString(Constants.address);
      String? email = prefs.getString(Constants.email);
      String? imagePath = prefs.getString(Constants.image);
      // Update controllers
      if (phone != null) Phone.text = phone;
      if (gender != null) Gender.text = gender;
      if (address != null) Address.text = address;
      // Update image if path exists and file exists
      if (imagePath != null && imagePath.isNotEmpty) {
        File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          image = imageFile;
          emit(ImagePicked(image: image!));
          return;
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
            phone: Phone.text,
            email: email.toString(),
            image: image,
            gender: Gender.text,
            address: Address.text,
          ),
        ),
      );
    } catch (e) {
      log('Error loading profile data: $e');
      emit(ChangeDataProfileError('Failed to load profile data: $e'));
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
        log('Image picked: ${image!.path}');
        emit(ImagePicked(image: image!));
      } else {
        log('No image selected.');
      }
    } catch (e) {
      log('Error picking image: $e');
      emit(ChangeDataProfileError('Failed to pick image: $e'));
    }
  }
}
