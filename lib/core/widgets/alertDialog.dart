import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class CustomButtonAlertDailog extends StatelessWidget {
  final Color colorFont;
  final Color containerColor;
  final String title;
  final void Function()? onPressed;
  const CustomButtonAlertDailog(
      {super.key,
      required this.colorFont,
      required this.title,
      required this.containerColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 32),
          child: Text(
            title,
            style: AppStyles.styleRegular14().copyWith(color: colorFont),
          ),
        ),
      ),
    );
  }
}
