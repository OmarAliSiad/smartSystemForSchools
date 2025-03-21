import 'package:flutter/material.dart';
import '../utils/app_styles.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> dispalySnackBar(
    context,
    {required String title,
    required String titleActionButton,
    required Color color,
    int duration = 2000, 
    }) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration:  Duration(milliseconds: duration),
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
