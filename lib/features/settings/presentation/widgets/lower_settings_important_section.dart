import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'settings_view_body.dart';

class LowerSettingsImportantSection extends StatelessWidget {
  const LowerSettingsImportantSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 190,
      right: 0,
      left: 0,
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final theme = context.read<ThemeModeCubit>().currentTheme;
          return FadeInUp(
            child: Center(
              child: Container(
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                width: 379,
                height: 911,
                decoration: ShapeDecoration(
                  color: context.read<ThemeModeCubit>().currentTheme ==
                          ThemeMode.dark
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    theme == ThemeMode.dark
                        ? BoxShadow(
                            color: const Color(0xFFBDBDBD).withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          )
                        : const BoxShadow(),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 25, vertical: 19),
                  child: SettingsViewBody(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
