import 'package:flutter/material.dart';

// Singleton class to manage navigation keys across the app
class AppNavigatorKeys {
  // Private constructor
  AppNavigatorKeys._();

  // Static singleton instance
  static final AppNavigatorKeys _instance = AppNavigatorKeys._();

  // Factory constructor to return the same instance
  factory AppNavigatorKeys() => _instance;

  // The main navigator key used throughout the app
  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'mainNavigator');
}
