import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/custom_button_transfer.dart';

class CustomCardFaimlyWidget extends StatelessWidget {
  final String imagePath;
  final String name;
  const CustomCardFaimlyWidget({super.key, required this.imagePath, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;

        return ZoomIn(
          child: Container(
            decoration: ShapeDecoration(
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadows: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 20, bottom: 25, right: 19),
                  child: Column(
                    children: [
                      Image.asset(
                      imagePath,
                        fit: BoxFit.cover,
                        width: 52,
                        height: 52,
                      ),
                      Text(
                        name,
                        style: AppStyles.styleMedium16(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 21, bottom: 15, right: 37),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: AppStyles.styleRegular16(),
                      ),
                      Text(
                        '100 EGP',
                        style: AppStyles.styleMedium16().copyWith(
                          color: const Color(0xFF5CC2F2),
                        ),
                      ),
                      Text(
                        'Daily spending limit',
                        style: AppStyles.styleMedium16(),
                      ),
                      Text(
                        '40 EGP',
                        style: AppStyles.styleMedium16().copyWith(
                          color: const Color(0xFF5CC2F2),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomButtonTransfer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
