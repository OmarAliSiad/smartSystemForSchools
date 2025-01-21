part of 'theme_mode_cubit.dart';

@immutable
abstract class ThemeModeState {}

class ThemeModeInitial extends ThemeModeState {
  final ThemeMode themeMode;

  ThemeModeInitial({required this.themeMode});
}

class ThemeModeChanged extends ThemeModeState {
  final ThemeMode themeMode;

  ThemeModeChanged({required this.themeMode});
}
