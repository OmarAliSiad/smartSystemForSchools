import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../utils/app_styles.dart';

Widget buildLoadingView(String message, BuildContext context) {
  Color primaryColor =
      context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
          ? Colors.white
          : Colors.black;
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.hexagonDots(
          color: primaryColor,
          size: 50,
        ),
        const SizedBox(height: 20),
        Text(
          'Loading $message details...',
          style: AppStyles.styleRegular14(),
        ),
      ],
    ),
  );
}
