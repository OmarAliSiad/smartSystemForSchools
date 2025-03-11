import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/models/attendance_model/attendance_model.dart';
import '../../../../core/utils/app_styles.dart';

class CardDetailsAttendanceWidget extends StatelessWidget {
  final AttendanceModel childAttendanceModel;
  final int childIndex;
  final void Function()? onTap;
  final bool isAbsent;

  const CardDetailsAttendanceWidget({
    super.key,
    required this.childAttendanceModel,
    required this.childIndex,
    this.onTap,
    this.isAbsent = false,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          final themeMode = context.read<ThemeModeCubit>().currentTheme;
          final isDark = themeMode == ThemeMode.dark;
          final statusColor = isAbsent ? Colors.red : Colors.green;
          final backgroundColor =
              isDark ? const Color(0xFF1E1E1E) : Colors.white;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Status indicator and avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: statusColor.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: isDark
                                    ? Colors.grey.shade800
                                    : statusColor.withOpacity(0.1),
                                radius: 26,
                                child: Icon(
                                  isAbsent ? Icons.person_off : Icons.person,
                                  color: statusColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: statusColor,
                              child: Icon(
                                isAbsent ? Icons.close : Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // Student information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                childAttendanceModel
                                    .result![childIndex].fullName
                                    .toString(),
                                style: AppStyles.styleMedium16().copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    isAbsent
                                        ? Icons.event_busy
                                        : Icons.event_available,
                                    size: 14,
                                    color: statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      isAbsent
                                          ? "Absent today"
                                          : "Present at: ${childAttendanceModel.result![childIndex].attendances![0].attendanceDate.toString()}",
                                      style: AppStyles.styleMedium16().copyWith(
                                        fontSize: 14,
                                        color: statusColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade700,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    childAttendanceModel
                                        .result![childIndex].city
                                        .toString(),
                                    style: AppStyles.styleMedium13().copyWith(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Status badge and action
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                isAbsent ? 'ABSENT' : 'PRESENT',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
