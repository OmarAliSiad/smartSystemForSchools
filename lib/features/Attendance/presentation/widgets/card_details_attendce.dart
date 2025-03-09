import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../data/models/child_attendance_model.dart';

class CardDetailsAttendenceWidget extends StatelessWidget {
  final ChildAttendceModel childAttendceModel;

  const CardDetailsAttendenceWidget({
    super.key,
    required this.childAttendceModel,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final themeMode = context.read<ThemeModeCubit>().currentTheme;
          return Card(
            color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            child: Container(
              padding: const EdgeInsetsDirectional.all(15),
              decoration: BoxDecoration(
                color:
                    themeMode == ThemeMode.dark ? Colors.black : Colors.white,
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
              child: Row(
                children: [
                  Image.asset(
                    childAttendceModel.imagePath1,
                    fit: BoxFit.cover,
                    width: 52,
                    height: 52,
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(childAttendceModel.text1,
                          style: AppStyles.styleMedium16()),
                      Text(childAttendceModel.text2,
                          style:
                              AppStyles.styleMedium16().copyWith(fontSize: 15)),
                      Text(childAttendceModel.text3,
                          style:
                              AppStyles.styleMedium13().copyWith(fontSize: 14)),
                    ],
                  ),
                  const Spacer(),
                  Image.asset(
                    childAttendceModel.imagePath2,
                    fit: BoxFit.cover,
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
