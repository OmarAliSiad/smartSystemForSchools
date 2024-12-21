part of 'theme_mode_cubit.dart';

@immutable
sealed class ThemeModeState {}

final class ThemeModeInitial extends ThemeModeState {
  final ThemeMode themeMode;

  ThemeModeInitial({required this.themeMode});
}

final class ThemeModeChanged extends ThemeModeState {

}

final class ThemeModeError extends ThemeModeState {
  final String errorMessage;
  ThemeModeError({required this.errorMessage});
}
