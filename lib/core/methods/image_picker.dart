import '../utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

Future<void> pickImage(
    void Function(String imagePath) sourcePicker, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor:
        context.watch<ThemeModeCubit>().currentTheme == ThemeMode.dark
            ? Colors.grey[850]
            : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Image Source',
                style: AppStyles.styleSemiBold14().copyWith(
                  fontSize: 16,
                  color: context.watch<ThemeModeCubit>().currentTheme ==
                          ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    title: 'Camera',
                    onTap: () async {
                      Navigator.pop(context);
                      await chooseImageFromGalleryOrCamera(
                          ImageSource.camera, sourcePicker);
                    },
                  ),
                  _imageSourceOption(
                    icon: Icons.photo_library_rounded,
                    title: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      await chooseImageFromGalleryOrCamera(
                          ImageSource.gallery, sourcePicker);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _imageSourceOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 10),
        Text(title),
      ],
    ),
  );
}

Future<void> chooseImageFromGalleryOrCamera(
    ImageSource source, void Function(String imagePath) sourcePicker) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source);
  if (image != null) {
    sourcePicker(image.path);
  }
}
