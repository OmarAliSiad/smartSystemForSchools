import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(ThemeModeInitial(themeMode: ThemeMode.light)) {
    _loadThemeMode();
  }
  ThemeMode currentTheme = ThemeMode.light;
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0; // 0 for light, 1 for dark
    currentTheme = (themeIndex == 1) ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeModeChanged(themeMode: currentTheme));
  }

  Future<void> changeThemeMode() async {
    currentTheme =
        (currentTheme == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', (currentTheme == ThemeMode.dark) ? 1 : 0);
    emit(ThemeModeChanged(themeMode: currentTheme));
  }
}