import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class CustomBottomContainer extends StatelessWidget {
  final Color color;
  const CustomBottomContainer({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.watch<ThemeModeCubit>().currentTheme;
        return Center(
          child: Container(
            margin: const EdgeInsetsDirectional.only(bottom: 18),
            width: 134,
            height: 5,
            decoration: BoxDecoration(
                color: themeMode == ThemeMode.dark ? Colors.white : color,
                borderRadius: BorderRadius.circular(30)),
          ),
        );
      },
    );
  }
}
