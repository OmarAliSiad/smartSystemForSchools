import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/child_details_view/widgets/custom_button.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../core/utils/app_styles.dart';

class CustomCardForSpendingAndRecharge extends StatelessWidget {
  final String title;
  final String price;
  final String titleButton;
  final String imagePath;
  final void Function()? onPressed;

  const CustomCardForSpendingAndRecharge(
      {super.key,
      required this.title,
      required this.price,
      required this.titleButton,
      required this.imagePath,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                      : const Color(0xFF000000).withOpacity(.2),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: AppStyles.styleMedium16()),
                      Text(
                        price,
                        style: AppStyles.styleSemiBold14().copyWith(
                            fontSize: 15, color: const Color(0xFF5CC2F2)),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                CustomButtonChildDetails(
                  onPressed: onPressed,
                  title: titleButton,
                  imagePath: imagePath,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
