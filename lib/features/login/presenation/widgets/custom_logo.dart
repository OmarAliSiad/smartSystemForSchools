import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/assets.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        ThemeMode themeMode = ThemeMode.light; // Default theme
        if (state is ThemeModeChanged) {
          themeMode = state.themeMode;
        }
        return Image.asset(
          Assets.imagesLogoColorWhite,
          width: 121,
          height: 107,
          color: themeMode == ThemeMode.dark
              ? Colors.white
              : const Color(0xff191BA9),
        );
      },
    );
  }
}
