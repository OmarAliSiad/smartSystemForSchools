import 'package:flutter/material.dart';

ThemeData lightTheme() {
  TextStyle blackedStyleColor = const TextStyle(color: Colors.black);
  return ThemeData(

    dialogTheme: const DialogTheme(
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    dialogBackgroundColor: Colors.white,
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
