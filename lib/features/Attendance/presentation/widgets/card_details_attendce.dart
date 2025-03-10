import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/models/attendance_model/attendance_model.dart';
import '../../../../core/utils/app_styles.dart';

class CardDetailsAttendenceWidget extends StatelessWidget {
  final AttendanceModel childAttendceModel;
  final int childIndex;
  final bool isAbsent;

  const CardDetailsAttendenceWidget({
    super.key,
    required this.childAttendceModel,
    required this.childIndex,
    this.isAbsent = false,
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
                  CircleAvatar(
                    backgroundColor:
                        isAbsent ? Colors.red.shade100 : Colors.green.shade100,
                    radius: 26,
                    child: Icon(
                      isAbsent ? Icons.person_off : Icons.person,
                      color: isAbsent ? Colors.red : Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          childAttendceModel.result![childIndex].fullName
                              .toString(),
                          style: AppStyles.styleMedium16(),
                        ),
                        Text(
                          isAbsent
                              ? "Absent today"
                              : "Present at: ${childAttendceModel.result![childIndex].attendances![0].attendanceDate.toString()}",
                          style: AppStyles.styleMedium16().copyWith(
                            fontSize: 15,
                            color: isAbsent ? Colors.red : Colors.green,
                          ),
                        ),
                        Text(
                          childAttendceModel.result![childIndex].city
                              .toString(),
                          style:
                              AppStyles.styleMedium13().copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAbsent
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAbsent ? 'ABSENT' : 'PRESENT',
                      style: TextStyle(
                        color: isAbsent ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade600,
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
