import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/models/attendance_model/attendance_model.dart';
import 'package:smartsystemforschools/core/models/attendance_model/result.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/attendance_service.dart';

class AttendanceDetailsView extends StatefulWidget {
  static const String id = 'AttendanceDetailsView';
  final Result childData;
  final String date;
  final AttendanceModel attendanceModel;

  const AttendanceDetailsView({
    super.key,
    required this.childData,
    required this.date,
    required this.attendanceModel,
  });

  @override
  State<AttendanceDetailsView> createState() => _AttendanceDetailsViewState();
}

class _AttendanceDetailsViewState extends State<AttendanceDetailsView> {
  bool isLoading = false;
  List<AttendanceModel> historicalAttendance = [];
  Map<String, int> weeklyStats = {
    'present': 0,
    'absent': 0,
  };
  Map<String, int> monthlyStats = {
    'present': 0,
    'absent': 0,
    'late': 0,
  };
  Map<String, int> arrivalTimeDistribution = {};

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  // Load one week worth of data
  Future<void> _loadHistoricalData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final attendanceService = AttendanceService();

      // Load data for the past 7 days
      final now = DateTime.now();

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final formattedDate = DateFormat('yyyy/MM/dd').format(date);

        final attendanceModel =
            await attendanceService.getAttendanceByParent(date: formattedDate);

        if (attendanceModel != null) {
          historicalAttendance.add(attendanceModel);

          // Find this child in the results
          final childResult = attendanceModel.result?.firstWhere(
            (result) => result.id == widget.childData.id,
            orElse: () => Result(),
          );

          // Update weekly stats
          if (childResult != null && childResult.id != null) {
            final dayOfWeek = DateFormat('E').format(date);

            bool isPresent = childResult.attendances != null &&
                childResult.attendances!.isNotEmpty;

            if (isPresent) {
              weeklyStats['present'] = (weeklyStats['present'] ?? 0) + 1;

              // Check if late (after 8:00 AM)
              try {
                final attendance = childResult.attendances![0];
                if (attendance.attendanceDate != null) {
                  final attendanceTime =
                      DateTime.parse(attendance.attendanceDate!);
                  final hour = attendanceTime.hour;
                  final minute = attendanceTime.minute;

                  // Consider late if after 8:00 AM
                  if (hour > 8 || (hour == 8 && minute > 0)) {
                    monthlyStats['late'] = (monthlyStats['late'] ?? 0) + 1;
                  } else {
                    // Track arrival time distribution
                    String timeSlot;
                    if (hour < 7 || (hour == 7 && minute < 30)) {
                      timeSlot = 'Before 7:30';
                    } else if (hour == 7 && minute >= 30 && minute < 45) {
                      timeSlot = '7:30-7:45';
                    } else if ((hour == 7 && minute >= 45) ||
                        (hour == 8 && minute == 0)) {
                      timeSlot = '7:45-8:00';
                    } else {
                      timeSlot = 'After 8:00';
                    }
                    arrivalTimeDistribution[timeSlot] =
                        (arrivalTimeDistribution[timeSlot] ?? 0) + 1;
                  }
                }
              } catch (e) {
                // If date parsing fails, just count as present
              }
            } else {
              weeklyStats['absent'] = (weeklyStats['absent'] ?? 0) + 1;
            }
          }
        }
      }

      // For monthly stats, just multiply the weekly stats
      monthlyStats['present'] =
          (weeklyStats['present'] ?? 0) * 4; // Approximate
      monthlyStats['absent'] = (weeklyStats['absent'] ?? 0) * 4; // Approximate
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getAttendanceStatus() {
    if (widget.childData.attendances == null ||
        widget.childData.attendances!.isEmpty) {
      return 'Absent';
    } else {
      // Check if there's leaving date
      final attendance = widget.childData.attendances![0];
      if (attendance.leavingDate != null &&
          attendance.leavingDate!.isNotEmpty) {
        return 'Present (Full Day)';
      } else {
        return 'Present (Not Left Yet)';
      }
    }
  }

  String _formatTimeFromDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      // Parse the datetime string according to its format
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      // If we can't parse it, return as is
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAbsent = widget.childData.attendances == null ||
        widget.childData.attendances!.isEmpty;
    final attendanceStatus = _getAttendanceStatus();
    final arrivalTime = isAbsent
        ? null
        : _formatTimeFromDateTime(
            widget.childData.attendances![0].attendanceDate);
    final leavingTime = isAbsent ||
            widget.childData.attendances![0].leavingDate == null
        ? null
        : _formatTimeFromDateTime(widget.childData.attendances![0].leavingDate);

    return Scaffold(
      appBar: CustomAppBar(
        ThereIsicon: false,
        title: 'Attendance Details',
        textStyle: AppStyles.styleSemiBold20(),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.blue.shade900,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isAbsent
                                    ? Colors.red.shade100
                                    : Colors.green.shade100,
                                radius: 30,
                                child: Icon(
                                  isAbsent ? Icons.person_off : Icons.person,
                                  color: isAbsent ? Colors.red : Colors.green,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.childData.fullName ?? 'Unknown',
                                      style: AppStyles.styleSemiBold20(),
                                    ),
                                    Text(
                                      'Grade: ${widget.childData.grade}',
                                      style: AppStyles.styleMedium16(),
                                    ),
                                    Text(
                                      'Date: ${widget.date}',
                                      style: AppStyles.styleRegular14(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          // Status info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildStatusItem(
                                  'Status',
                                  attendanceStatus,
                                  isAbsent ? Colors.red : Colors.green,
                                ),
                              ),
                              Expanded(
                                child: _buildStatusItem(
                                  'Arrival',
                                  arrivalTime ?? 'N/A',
                                  Colors.blue,
                                ),
                              ),
                              Expanded(
                                child: _buildStatusItem(
                                  'Departure',
                                  leavingTime ?? 'Not yet',
                                  Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Weekly Attendance Chart
                  Text(
                    'Weekly Attendance',
                    style: AppStyles.styleSemiBold20(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildWeeklyAttendanceChart(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Monthly Attendance Pie Chart
                  Text(
                    'Monthly Attendance Overview',
                    style: AppStyles.styleSemiBold20(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                                sections: _buildPieChartSections(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem('Present',
                                    monthlyStats['present'] ?? 0, Colors.green),
                                _buildLegendItem('Absent',
                                    monthlyStats['absent'] ?? 0, Colors.red),
                                _buildLegendItem('Late',
                                    monthlyStats['late'] ?? 0, Colors.orange),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Arrival Times Bar Chart
                  Text(
                    'Arrival Time Distribution',
                    style: AppStyles.styleSemiBold20(),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildArrivalTimeBarChart(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: AppStyles.styleRegular14(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: AppStyles.styleRegular14().copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: AppStyles.styleMedium16().copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyAttendanceChart() {
    final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final dayIndices = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return daysOfWeek[date.weekday - 1]; // weekday is 1-7 where 1 is Monday
    });

    return historicalAttendance.isEmpty
        ? const Center(child: Text('No historical data available'))
        : BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 1,
              barTouchData: BarTouchData(
                enabled: false,
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
                bool? isPresent;

                // If we have data for this day
                if (index < historicalAttendance.length) {
                  final model = historicalAttendance[index];

                  // Find this child in the results
                  final childResult = model.result?.firstWhere(
                    (result) => result.id == widget.childData.id,
                    orElse: () => Result(),
                  );

                  if (childResult != null && childResult.id != null) {
                    isPresent = childResult.attendances != null &&
                        childResult.attendances!.isNotEmpty;
                  }
                }

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: 1,
                      color: isPresent == null
                          ? Colors.grey
                          : isPresent
                              ? Colors.green
                              : Colors.red,
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final total = (monthlyStats['present'] ?? 0) +
        (monthlyStats['absent'] ?? 0) +
        (monthlyStats['late'] ?? 0);

    if (total == 0) return [];

    return [
      PieChartSectionData(
        color: Colors.green,
        value: monthlyStats['present']?.toDouble() ?? 0,
        title: '${(((monthlyStats['present'] ?? 0) / total) * 100).round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: monthlyStats['absent']?.toDouble() ?? 0,
        title: '${(((monthlyStats['absent'] ?? 0) / total) * 100).round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: monthlyStats['late']?.toDouble() ?? 0,
        title: '${(((monthlyStats['late'] ?? 0) / total) * 100).round()}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildArrivalTimeBarChart() {
    if (arrivalTimeDistribution.isEmpty) {
      return const Center(child: Text('No arrival time data available'));
    }

    // Define the standard time slots
    final standardTimeSlots = [
      'Before 7:30',
      '7:30-7:45',
      '7:45-8:00',
      'After 8:00'
    ];

    // Create a list of entries sorted by time
    final sortedEntries = standardTimeSlots
        .map((slot) => MapEntry(slot, arrivalTimeDistribution[slot] ?? 0))
        .toList();

    final maxValue = sortedEntries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue + 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < sortedEntries.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      sortedEntries[index].key,
                      style: AppStyles.styleRegular12(),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 1 == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      value.toInt().toString(),
                      style: AppStyles.styleRegular12(),
                    ),
                  );
                }
                return const SizedBox();
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: List.generate(sortedEntries.length, (index) {
          final entry = sortedEntries[index];

          // Choose colors based on time slots
          Color barColor;
          switch (entry.key) {
            case 'Before 7:30':
              barColor = Colors.green.shade400;
              break;
            case '7:30-7:45':
              barColor = Colors.green.shade600;
              break;
            case '7:45-8:00':
              barColor = Colors.blue.shade400;
              break;
            case 'After 8:00':
              barColor = Colors.orange;
              break;
            default:
              barColor = Colors.grey;
          }

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: barColor,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}
