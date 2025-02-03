import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme(BuildContext context) {
  TextStyle whiteStyleColor = const TextStyle(color: Colors.white);
  return ThemeData(
    fontFamily: context.locale.toString() == 'ar' ? 'Cairo' : 'Poppins',
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
    ),
    dialogBackgroundColor: Colors.black,
    textTheme: TextTheme(
      titleLarge: whiteStyleColor,
      titleMedium: whiteStyleColor,
      titleSmall: whiteStyleColor,
      bodyLarge: whiteStyleColor,
      bodyMedium: whiteStyleColor,
      bodySmall: whiteStyleColor,
      displayLarge: whiteStyleColor,
      displayMedium: whiteStyleColor,
      displaySmall: whiteStyleColor,
      headlineLarge: whiteStyleColor,
      headlineMedium: whiteStyleColor,
      headlineSmall: whiteStyleColor,
      labelLarge: whiteStyleColor,
      labelMedium: whiteStyleColor,
      labelSmall: whiteStyleColor,
    ),
  );
}
