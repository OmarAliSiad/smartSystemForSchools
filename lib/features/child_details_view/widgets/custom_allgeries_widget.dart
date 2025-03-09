import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';

import '../../../core/utils/app_styles.dart';
import '../../../core/utils/assets.dart';
import '../../Allergies/presentation/views/AllergiesView.dart';

class CustomAllergiesWidget extends StatelessWidget {
  const CustomAllergiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Card(
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
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    LocaleKeys.allegries_Allergies.tr(),
                    style: AppStyles.styleMedium16(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    LocaleKeys.allegries_des.tr(),
                    style: AppStyles.styleRegular10().copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        end: 15, bottom: 15.65),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(AllergiesView.id);
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 5.50,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 12.5,
                                  vertical: 11.8,
                                ),
                                child: Image.asset(
                                  Assets.imagesAdd,
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
