import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
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
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 6,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 15, bottom: 25, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Transfer from your wallet to Shahd',
                      style: AppStyles.styleRegular14(),
                    ),
                    const Spacer(),
                    Text(
                      '10 EGP',
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
                  'Available in wallet Shahd 100 EGP',
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
