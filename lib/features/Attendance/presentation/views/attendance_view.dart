import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/models/attendance_model/attendance_model.dart';
import '../../../../core/utils/animated_app_bar.dart';
import '../../../../core/widgets/build_loading_view.dart';
import '../../data/manager/cubit/attendance_cubit.dart';
import 'attendance_details_view.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../widgets/card_details_attendce.dart';
import 'package:easy_localization/easy_localization.dart';

class AttendanceView extends StatefulWidget {
  static const String id = '/AttendanceView';
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  List<AttendanceModel> attendances = [];
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
    loadAttendances(formattedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade900,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
        attendances.clear();
      });
      loadAttendances(formattedDate);
    }
  }

  Future<void> refreshData() async {
    await loadAttendances(formattedDate);
  }

  loadAttendances(String date) async {
    setState(() {
      isLoading = true;
    });
    AttendanceModel? attendanceModel =
        await context.read<AttendanceCubit>().getChildsAttendance(date: date);
    if (attendanceModel != null) {
      setState(() {
        attendances = [attendanceModel];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        appBar: AnimatedCustomAppBar(
          waveColor: Colors.blue.shade700,
          backgroundColor: Colors.blue.shade900,
          thereIsIcon: false,
          title: LocaleKeys.attendanceDetails_attendance.tr(),
          textStyle: AppStyles.styleSemiBold20(),
          onTapBack: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              MainScreen.id,
              (Route<dynamic> route) => false,
            );
          },
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.blue.shade900,
          onRefresh: refreshData,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // Date selector
              BlocBuilder<ThemeModeCubit, ThemeModeState>(
                builder: (context, state) {
                  final state = context.read<ThemeModeCubit>().currentTheme;
                  return Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16,
                    ),
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: state == ThemeMode.dark
                              ? Colors.black
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: state == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.blue.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${LocaleKeys.attendanceDetails_attendanceDetailsView_studentInformationCard_date.tr()}: $formattedDate',
                              style: AppStyles.styleMedium16(),
                            ),
                            Icon(Icons.calendar_today,
                                color: state == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),

              // Attendance data
              Expanded(
                child: BlocBuilder<AttendanceCubit, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoading || isLoading) {
                      return Center(
                        child: buildLoadingView(
                            LocaleKeys.attendanceDetails_attendance.tr(),
                            context),
                      );
                    }
                    if (state is AttendanceLoaded) {
                      if (attendances.isEmpty ||
                          attendances[0].result == null ||
                          attendances[0].result!.isEmpty) {
                        if (attendances[0].resultForVaction != null &&
                            attendances[0].resultForVaction!.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    size: 60, color: Colors.amber),
                                const SizedBox(height: 16),
                                Text(
                                  attendances[0].resultForVaction.toString(),
                                  style: AppStyles.styleMedium16(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    LocaleKeys
                                        .attendanceDetails_SelectAnotherDate
                                        .tr(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    size: 60, color: Colors.amber),
                                const SizedBox(height: 16),
                                Text(
                                  LocaleKeys
                                      .attendanceDetails_noAttendanceRecordsFoundForThisDate
                                      .tr(),
                                  style: AppStyles.styleMedium16(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    LocaleKeys
                                        .attendanceDetails_SelectAnotherDate
                                        .tr(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return isLoading
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Center(
                                    child: LoadingAnimationWidget
                                        .threeArchedCircle(
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: attendances[0].result?.length ?? 0,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 20,
                              ),
                              itemBuilder: (context, index) {
                                final childData = attendances[0].result![index];
                                // Check if child is absent (no attendance records for the day)
                                final bool isAbsent =
                                    childData.attendances == null ||
                                        childData.attendances!.isEmpty;
                                return InkWell(
                                  child: CardDetailsAttendanceWidget(
                                    childAttendanceModel: attendances[0],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceDetailsView(
                                            childData: childData,
                                            dateFormated: formattedDate,
                                            attendanceModel: attendances[0],
                                          ),
                                        ),
                                      );
                                    },
                                    childIndex: index,
                                    isAbsent: isAbsent,
                                  )
                                      .animate()
                                      .fade(
                                          duration: 600.ms,
                                          delay: 200.ms * index)
                                      .slideY(begin: 0.2, end: 0),
                                );
                              },
                            );
                    }
                    if (state is AttendanceFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              LocaleKeys
                                  .attendanceDetails_failedToLoadAttendanceData
                                  .tr(),
                              style: AppStyles.styleMedium16(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.errMessage,
                              style: AppStyles.styleRegular14(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                              ),
                              onPressed: () => loadAttendances(formattedDate),
                              child: Text(
                                LocaleKeys.attendanceDetails_TryAgain.tr(),
                                style: AppStyles.styleMedium13()
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
