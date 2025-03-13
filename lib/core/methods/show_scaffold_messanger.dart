import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dispalySnackBar(
    context,
    {required String title,
    required String titleActionButton,
    required Color color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2000),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(
        title,
        style: AppStyles.styleRegular14().copyWith(
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: titleActionButton,
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}
