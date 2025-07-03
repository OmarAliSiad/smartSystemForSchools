import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../widgets/splash_view_body.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashView extends StatelessWidget {
  static String id = '/SplashView';
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return KeyedSubtree(
          key: ValueKey(context.locale.toString()),
          child: Scaffold(
            backgroundColor: themeMode == ThemeMode.dark
                ? Colors.black
                : const Color(0xFF191BA9),
            body: const SplashViewBody(),
          ),
        );
      },
    );
  }
}
