import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/models/attendance_model/attendance.dart';
import '../../../../core/models/attendance_model/attendance_model.dart';
import '../../../../core/models/attendance_model/result.dart';
import '../../../../core/services/attendance_service/attendance_service.dart';
import '../../../../core/widgets/build_loading_view.dart';
import '../../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/animated_app_bar.dart';
import '../../../main_screen/presentation/views/main_screen.dart';

class AttendanceDetailsView extends StatefulWidget {
  static const String id = 'AttendanceDetailsView';
  final Result childData;
  final String dateFormated;
  final AttendanceModel attendanceModel;

  const AttendanceDetailsView({
    super.key,
    required this.childData,
    required this.dateFormated,
    required this.attendanceModel,
  });

  @override
  State<AttendanceDetailsView> createState() => _AttendanceDetailsViewState();
}

class _AttendanceDetailsViewState extends State<AttendanceDetailsView> {
  bool isLoading = false;
  late bool isAbsent;
  late Attendance? todayAttendance;
  List<AttendanceData> attendanceHistoryData = [];
  List<AttendanceModel> historicalAttendance = [];

  @override
  void initState() {
    super.initState();
    _prepareAttendanceData();
    _loadHistoricalData();
  }

  Future<void> refreshData() async {
    await _loadHistoricalData();
  }

  Future<void> _loadHistoricalData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final attendanceService = AttendanceService();
      final attendanceModel = await attendanceService.getAttendanceByParent(
          date: widget.dateFormated);
      historicalAttendance.clear();
      historicalAttendance.add(attendanceModel);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _prepareAttendanceData() {
    // Check if child has attendances
    isAbsent = widget.childData.attendances == null ||
        widget.childData.attendances!.isEmpty;

    // Get today's attendance
    todayAttendance = isAbsent ? null : widget.childData.attendances!.first;

    // Prepare attendance history data
    _generateAttendanceHistoryData();
  }

  void _generateAttendanceHistoryData() {
    // If no attendance data is available, create empty history
    if (widget.attendanceModel.result == null ||
        widget.attendanceModel.result!.isEmpty) {
      return;
    }

    // Iterate through all results to create attendance history
    attendanceHistoryData = widget.attendanceModel.result!.map((result) {
      // Check if the result has any attendance records
      bool isPresent =
          result.attendances != null && result.attendances!.isNotEmpty;

      // Use the date of the first attendance record or current date
      String month =
          result.attendances != null && result.attendances!.isNotEmpty
              ? _extractMonthFromDate(result.attendances!.first.attendanceDate)
              : _extractMonthFromDate(DateTime.now().toString());

      return AttendanceData(month: month, isPresent: isPresent);
    }).toList();
  }

  String _extractMonthFromDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return 'N/A';
    try {
      DateTime parsedTime = DateTime.parse(timeString);
      return DateFormat('hh:mm a').format(parsedTime);
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: Colors.blue.shade700,
        backgroundColor: Colors.blue.shade900,
        thereIsIcon: false,
        title: 'Attendance Details',
        textStyle: AppStyles.styleSemiBold20().copyWith(color: Colors.white),
        onTapBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? buildLoadingView('attendance', context)
          : BlocBuilder<ThemeModeCubit, ThemeModeState>(
              builder: (context, state) {
                final themeMode = context.read<ThemeModeCubit>().currentTheme;
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue.shade900,
                  onRefresh: refreshData,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Attendance Status
                          _buildAttendanceStatusCard()
                              .animate()
                              .fade(duration: 600.ms, delay: 200.ms)
                              .slideX(begin: 0.1, end: 0),

                          const SizedBox(height: 20),

                          // Student Information Card
                          _buildStudentInfoCard(themeMode)
                              .animate()
                              .fade(duration: 600.ms)
                              .slideX(begin: -0.1, end: 0),
                          const SizedBox(height: 20),
                          Text(
                            'Weekly Attendance',
                            style: AppStyles.styleSemiBold20(),
                          )
                              .animate()
                              .fade(duration: 600.ms, delay: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
                            child: Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: context
                                            .read<ThemeModeCubit>()
                                            .currentTheme ==
                                        ThemeMode.light
                                    ? Colors.white
                                    : const Color(0xFF1E1E1E),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: _buildWeeklyAttendanceChart(),
                              ),
                            ),
                          )
                              .animate()
                              .fade(duration: 600.ms, delay: 200.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 20),

                          // Attendance Charts
                          AttendanceCharts(
                                  themeMode: themeMode,
                                  attendanceData: attendanceHistoryData)
                              .animate()
                              .fade(duration: 600.ms, delay: 400.ms)
                              .slideX(begin: 0.1, end: 0),

                          const SizedBox(height: 20),

                          // Detailed Attendance Information
                          _buildDetailedAttendanceInfo(themeMode)
                              .animate()
                              .fade(duration: 600.ms, delay: 600.ms)
                              .slideY(begin: 0.1, end: 0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStudentInfoCard(ThemeMode themeMode) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Information',
              style: AppStyles.styleSemiBold14().copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Name', widget.childData.fullName ?? 'N/A'),
            _buildInfoRow('Grade', widget.childData.grade?.toString() ?? 'N/A'),
            _buildInfoRow('Gender', widget.childData.gender ?? 'N/A'),
            _buildInfoRow('Date', widget.dateFormated),
            _buildInfoRow('Birth Date', widget.childData.birthDate ?? 'N/A'),
            _buildInfoRow('City', widget.childData.city ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusCard() {
    return Card(
      color: isAbsent ? Colors.red.shade100 : Colors.green,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              isAbsent ? Icons.cancel_outlined : Icons.check_circle_outline,
              color: isAbsent ? Colors.red : Colors.white,
              size: 40,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAbsent ? 'Absent' : 'Present',
                    style: AppStyles.styleSemiBold14().copyWith(
                      color: isAbsent ? Colors.red : Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  if (!isAbsent)
                    Text(
                      'Attendance recorded for the day',
                      style: AppStyles.styleRegular12().copyWith(
                        color: isAbsent ? Colors.red : Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedAttendanceInfo(ThemeMode themeMode) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Details',
              style: AppStyles.styleSemiBold14().copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            if (isAbsent)
              _buildInfoRow('Status', 'Absent for the day')
            else ...[
              _buildInfoRow('Status', 'Present'),
              _buildInfoRow(
                  'Arrival Time', _formatTime(todayAttendance?.attendanceDate)),
              _buildInfoRow(
                  'Leaving Time', _formatTime(todayAttendance?.leavingDate)),
              if (todayAttendance?.leavingDate != null)
                _buildDurationCalculation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurationCalculation() {
    if (todayAttendance?.attendanceDate == null ||
        todayAttendance?.leavingDate == null) {
      return const SizedBox.shrink();
    }

    try {
      DateTime arrivalTime = DateTime.parse(todayAttendance!.attendanceDate!);
      DateTime leavingTime = DateTime.parse(todayAttendance!.leavingDate!);
      Duration duration = leavingTime.difference(arrivalTime);

      return _buildInfoRow('Time Spent',
          '${duration.inHours} hours ${duration.inMinutes % 60} minutes');
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.styleMedium16(),
          ),
          Text(
            value,
            style: AppStyles.styleRegular14(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyAttendanceChart() {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final dayIndices = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return daysOfWeek[date.weekday - 1];
    });

    // Debug output to verify data
    if (historicalAttendance.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'No attendance data available for this week',
              style: AppStyles.styleRegular14().copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Create a map to track attendance for each day
    final Map<int, bool?> attendanceByDay = {};

    // Process the attendance data
    for (int i = 0; i < historicalAttendance.length; i++) {
      final model = historicalAttendance[i];
      final childResult = model.result?.firstWhere(
        (result) => result.id == widget.childData.id,
        orElse: () => Result(),
      );

      if (childResult != null && childResult.id != null) {
        attendanceByDay[i] = childResult.attendances != null &&
            childResult.attendances!.isNotEmpty;
      }
    }
    log("Attendance by day: $attendanceByDay");
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueAccent.withOpacity(0.9),
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String status = 'No Data';
              if (attendanceByDay.containsKey(groupIndex)) {
                status =
                    attendanceByDay[groupIndex] == true ? 'Present' : 'Absent';
              }
              return BarTooltipItem(
                '${dayIndices[groupIndex]}\n$status',
                AppStyles.styleMedium16().copyWith(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dayIndices.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      dayIndices[index],
                      style: AppStyles.styleRegular14(),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: List.generate(7, (index) {
          // Fixed: Simply use the attendance status directly for this day
          bool? isPresent = attendanceByDay[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: 1, // Fixed height for all bars
                color: isPresent == null
                    ? Colors.grey.withOpacity(0.5) // No data
                    : isPresent
                        ? Colors.green.withOpacity(0.8) // Present
                        : Colors.red.withOpacity(0.8), // Absent
                width: 25,
                borderRadius: BorderRadius.circular(8),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class AttendanceCharts extends StatelessWidget {
  final ThemeMode themeMode;
  final List<AttendanceData> attendanceData;

  const AttendanceCharts(
      {super.key, required this.attendanceData, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildLineChart(themeMode),
      ],
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return attendanceData.map((data) {
      return BarChartGroupData(
        x: attendanceData.indexOf(data),
        barRods: [
          BarChartRodData(
            toY: data.isPresent ? 1 : 0,
            color: data.isPresent ? Colors.green : Colors.red,
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLineChart(ThemeMode themeMode) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Trend Line Chart',
              style: AppStyles.styleSemiBold14().copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getLineSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            attendanceData[value.toInt()].month,
                            style: AppStyles.styleRegular12(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getLineSpots() {
    return attendanceData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.isPresent ? 1 : 0);
    }).toList();
  }
}

class AttendanceData {
  final String month;
  final bool isPresent;

  AttendanceData({required this.month, required this.isPresent});
}
