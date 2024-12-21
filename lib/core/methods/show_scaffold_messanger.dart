import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dispalySnackBar(
    context,
    {required String title,
    required String titleActionButton,
    required Color color}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1000),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
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
