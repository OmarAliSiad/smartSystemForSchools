import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class CustomWiveWidget extends StatefulWidget {
  const CustomWiveWidget({
    super.key,
  });

  @override
  State<CustomWiveWidget> createState() => _CustomWiveWidgetState();
}

class _CustomWiveWidgetState extends State<CustomWiveWidget> {
  List<int>? durations = [
    4000,
    5000,
    6000,
  ];

  List<Color> colors = [
    Colors.blue.shade500,
    Colors.blue.shade700,
    Colors.blue.shade900,
  ];

  List<double> heightPercentages = [
    0.65,
    0.70,
    0.75,
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        context.watch<ThemeModeCubit>().currentTheme == ThemeMode.dark
            ? Colors.indigo.shade900
            : const Color(0xff1A0F91);

    return WaveWidget(
      config: CustomConfig(
        colors: colors,
        durations: durations,
        heightPercentages: heightPercentages,
      ),
      backgroundColor: primaryColor,
      size: const Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }
}
