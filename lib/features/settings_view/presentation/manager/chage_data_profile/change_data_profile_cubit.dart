import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/profile_data_model.dart';
part 'change_data_profile_state.dart';

class ChangeDataProfileCubit extends Cubit<ChangeDataProfileState> {
  TextEditingController Name = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Email = TextEditingController();
  File? image;
  ChangeDataProfileCubit() : super(ChangeDataProfileInitial());

  Future<void> saveProfileData(ProfileDataModel profileDataModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', profileDataModel.name);
    await prefs.setString('phone', profileDataModel.phone);
    await prefs.setString('email', profileDataModel.email);
    await prefs.setString('image', profileDataModel.image?.path ?? '');
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');
    String? email = prefs.getString('email');
    String? imagePath = prefs.getString('image');
    if (name != null) Name.text = name;
    if (phone != null) Phone.text = phone;
    if (email != null) Email.text = email;
    if (imagePath != null && imagePath.isNotEmpty) {
      image = File(imagePath);
    } else {
      image = null;
    }
    emit(DataProfileLoaded(
      profileDataModel: ProfileDataModel(
        email: Email.text,
        name: Name.text,
        phone: Phone.text,
        image: image!,
      ),
    ));
  }

  pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    image = await imagePicker.pickImage(source: ImageSource.gallery).then(
          (value) => File(
            value!.path,
          ),
        );
    emit(
      DataProfileLoaded(
        profileDataModel: ProfileDataModel(
          email: Email.text,
          name: Name.text,
          phone: Phone.text,
          image: image!,
        ),
      ),
    );
  }
}
