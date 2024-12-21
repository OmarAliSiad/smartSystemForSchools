import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class CustomTextFieldEditProfile extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? length;
  const CustomTextFieldEditProfile(
      {super.key,
      required this.title,
      required this.hintText,
      this.controller,
      this.keyboardType,
      this.length});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.styleRegular20(),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 57,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: .3,
                spreadRadius: 1,
                offset: const Offset(0, 0),
                color: Colors.black.withOpacity(0.02),
              )
            ],
          ),
          child: TextFormField(
            maxLength: length,
            style: const TextStyle(color: Colors.black),
            keyboardType: keyboardType,
            controller: controller,
            maxLines: 1,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintFadeDuration: const Duration(milliseconds: 400),
              hintText: hintText,
              hintStyle: AppStyles.styleRegular14().copyWith(
                color: const Color(0xFF000000).withOpacity(0.5),
              ),
              border: buildOutlineBorder(),
              enabledBorder: buildOutlineBorder(),
              focusedBorder: buildOutlineBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder buildOutlineBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
    borderSide: BorderSide.none,
  );
}
