import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/login/presenation/widgets/custom_text_field.dart';
import '../../../../core/utils/app_styles.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obsure;
  final TextEditingController controller;
  const UserInfo(
      {super.key,
      required this.title,
      required this.hintText,
      required this.obsure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            title,
            style: AppStyles.styleRegular14().copyWith(
              color: Colors.black.withOpacity(.70),
            ),
          ),
        ),
        const SizedBox(
          height: 9,
        ),
        CustomTextField(
          borderRaduis: 10,
          hintText: hintText,
          obsure: obsure,
          controller: controller,
        ),
      ],
    );
  }
}
