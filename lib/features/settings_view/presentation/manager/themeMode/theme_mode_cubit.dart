import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(ThemeModeInitial(themeMode: ThemeMode.light));
  ThemeMode currentTheme = ThemeMode.light;

  void changeThemeMode() {
    emit(ThemeModeChanged());
    currentTheme =
        (currentTheme == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeModeChanged());
  }
}
