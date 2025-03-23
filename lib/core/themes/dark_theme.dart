import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme(BuildContext context) {
  TextStyle whiteStyleColor = const TextStyle(color: Colors.white);
  return ThemeData(
    fontFamily: context.locale.toString() == 'ar' ? 'Cairo' : 'Poppins',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900], //232524
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.black,
      todayForegroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
      todayBorder: const BorderSide(width: 1),
      dayStyle: const TextStyle(color: Colors.black),
      yearStyle: const TextStyle(color: Colors.white),
      todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      headerBackgroundColor: Colors.black,
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
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
