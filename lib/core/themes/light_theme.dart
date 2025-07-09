import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) {
  TextStyle blackedStyleColor = const TextStyle(color: Colors.black);
  return ThemeData(
    fontFamily: context.locale.toString() == 'ar' ? 'Cairo' : 'Poppins',
    brightness: Brightness.light,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    datePickerTheme: DatePickerThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      todayBackgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: Colors.white,
      todayForegroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
      todayBorder: const BorderSide(width: 1),
      dayStyle: const TextStyle(color: Colors.black),
      yearStyle: const TextStyle(color: Colors.black),
      headerBackgroundColor: Colors.white,
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(
            Colors.black), // Cancel button text in black
      ),
      confirmButtonStyle: ButtonStyle(
        foregroundColor:
            WidgetStateProperty.all(Colors.black), // OK button text in black
      ),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: blackedStyleColor,
      titleMedium: blackedStyleColor,
      titleSmall: blackedStyleColor,
      bodyLarge: blackedStyleColor,
      bodyMedium: blackedStyleColor,
      bodySmall: blackedStyleColor,
      displayLarge: blackedStyleColor,
      displayMedium: blackedStyleColor,
      displaySmall: blackedStyleColor,
      headlineLarge: blackedStyleColor,
      headlineMedium: blackedStyleColor,
      headlineSmall: blackedStyleColor,
      labelLarge: blackedStyleColor,
      labelMedium: blackedStyleColor,
      labelSmall: blackedStyleColor,
    ),
  );
}
