import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dispalySnackBar(
  context, {
  required String title,
  String? titleActionButton,
  required Color color,
  Duration? durationD,
  Widget? child,
  int duration = 2000,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: durationD ?? Duration(milliseconds: duration),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: child ??
          Text(
            title,
            style: AppStyles.styleRegular14().copyWith(
              color: Colors.white,
            ),
          ),
      action: titleActionButton == null
          ? null
          : SnackBarAction(
              label: titleActionButton,
              textColor: Colors.white,
              onPressed: () {},
            ),
    ),
  );
}
