import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/assets.dart';
import '../views/spending_limits_view.dart';
import 'custom_button.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

class CustomCardSpendingLimits extends StatelessWidget {
  final String studentId;
  final VoidCallback onUpdateLimits;

  const CustomCardSpendingLimits({
    super.key,
    required this.studentId,
    required this.onUpdateLimits,
  });

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
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 15.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.childDetailsView_spendingLimits.tr(),
                      style: AppStyles.styleMedium16()),
                  CustomButtonChildDetails(
                    onPressed: () async {
                      // Navigate to SpendingLimitsView and wait for result
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SpendingLimitsView(
                            studentId: studentId,
                            isDarkMode: themeMode == ThemeMode.dark,
                          ),
                        ),
                      );

                      // If result is true, refresh data in parent widget
                      if (result == true) {
                        if (context.mounted) {
                          dispalySnackBar(
                            context,
                            title: LocaleKeys
                                .childDetailsView_spendingLimitsUpdated
                                .tr(),
                            color: Colors.green,
                          );
                          // Call the callback provided by the parent to refresh data
                          onUpdateLimits();
                        }
                      }
                    },
                    title: LocaleKeys.childDetailsView_spendingLimits.tr(),
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10, vertical: 5),
                    imagePath: Assets.imagesShooping,
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
