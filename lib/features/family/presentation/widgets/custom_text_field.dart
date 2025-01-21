import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../login/presenation/widgets/custom_text_field.dart';

class SectionTextFiledForAddChild extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Color imageColor;
  final String image;
  final TextInputType? keyboardType;
  const SectionTextFiledForAddChild({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.imageColor,
    required this.image,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppStyles.styleMedium16(),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextField(
          controller: controller,
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.all(15),
            child: Image.asset(
              image,
              color: imageColor,
              width: 10,
              height: 10,
            ),
          ),
          borderRaduis: 5,
          obsure: false,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
