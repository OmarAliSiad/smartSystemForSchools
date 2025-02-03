import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_styles.dart';
import '../manager/themeMode/theme_mode_cubit.dart';

class CustomContainerSettingsView extends StatelessWidget {
  final String title;
  final String? iconImage;
  final IconData? icon;
  final void Function()? onTap;
  final Color? colorIcon;
  const CustomContainerSettingsView({
    super.key,
    required this.title,
    this.iconImage,
    this.onTap,
    this.icon,
    this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        return ZoomIn(
          duration: const Duration(milliseconds: 800),
          child: Container(
            decoration: BoxDecoration(
              color:
                  context.read<ThemeModeCubit>().currentTheme == ThemeMode.dark
                      ? null
                      : Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: .3,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                  color: Colors.black.withOpacity(0.02),
                )
              ],
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: onTap,
              minWidth: 344,
              height: 50,
              child: Row(
                children: [
                  const SizedBox(
                    width: 28,
                  ),
                  iconImage == null
                      ? Icon(icon,
                          color: context.read<ThemeModeCubit>().currentTheme ==
                                  ThemeMode.dark
                              ? Colors.white
                              : Colors.black)
                      : Image.asset(
                          color: context.read<ThemeModeCubit>().currentTheme ==
                                  ThemeMode.dark
                              ? Colors.white
                              : colorIcon ?? Colors.black,
                          iconImage!,
                          width: 24,
                          height: 24,
                        ),
                  const SizedBox(
                    width: 54,
                  ),
                  Text(
                    title,
                    style: AppStyles.styleRegular20().copyWith(
                        color: context.read<ThemeModeCubit>().currentTheme ==
                                ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
