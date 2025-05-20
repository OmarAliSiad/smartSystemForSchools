import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/utils/app_styles.dart';

class CustomCardTransactions extends StatelessWidget {
  const CustomCardTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: themeMode == ThemeMode.dark
                    ? const Color(0xFFFFFFFF).withOpacity(.4)
                    : const Color(0x3F000000),
                blurRadius: 6,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 15, top: 15, bottom: 25, end: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      LocaleKeys.transactions_title.tr(),
                      style: AppStyles.styleRegular14(),
                    ),
                    const Spacer(),
                    Text(
                      LocaleKeys.transactions_price.tr(),
                      style: AppStyles.styleSemiBold14()
                          .copyWith(color: const Color(0xff5CC2F2)),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  LocaleKeys.transactions_subTitle.tr(),
                  style: AppStyles.styleRegular10(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
