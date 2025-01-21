import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/widgets/custom_text_field.dart';
import '../../../../core/utils/app_styles.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obsure;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  const UserInfo({
    super.key,
    required this.title,
    required this.hintText,
    required this.obsure,
    required this.controller,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2),
          child: Text(
            title,
            style: AppStyles.styleRegular14().copyWith(),
          ),
        ),
        const SizedBox(
          height: 9,
        ),
        CustomTextField(
          suffixIcon: suffixIcon,
          validator: validator,
          borderRaduis: 10,
          hintText: hintText,
          obsure: obsure,
          controller: controller,
        ),
      ],
    );
  }
}
