import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../data/models/notification_card_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationCardModel notificationCardModel;
  const NotificationCard({
    super.key,
    required this.notificationCardModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: themeMode == ThemeMode.dark ? null : Colors.white,
            border: Border.all(
              color: themeMode == ThemeMode.dark ? Colors.white : Colors.white,
            ),
            boxShadow: [
              themeMode == ThemeMode.light
                  ? const BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 6.80,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  : BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      color: Colors.black.withOpacity(0.13),
                    )
            ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 15, end: 13, top: 16, bottom: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xff1A0F91).withOpacity(.10),
                  child: const Icon(
                    size: 30,
                    Icons.notifications_none_rounded,
                    color: Color(0xff1A0F91),
                  ),
                ),
                const SizedBox(
                  width: 13,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Failed transaction : ',
                          style:
                              AppStyles.styleMedium16().copyWith(fontSize: 14),
                        ),
                        const SizedBox(
                          width: 72,
                        ),
                        Text(
                          notificationCardModel.time,
                          style: AppStyles.styleRegular14().copyWith(
                            color:
                                context.read<ThemeModeCubit>().currentTheme ==
                                        ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black.withOpacity(.70),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text(
                      'Ahmed Khalid attempted a purchase,\nbut the balance was in sufficient',
                      style: AppStyles.styleRegular14().copyWith(fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
