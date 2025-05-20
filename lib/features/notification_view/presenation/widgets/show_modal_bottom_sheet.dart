import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../data/cubit/notification_cubit.dart';

void showFilterBottomSheet({
  required BuildContext context,
  required List<ResultForChildDetails> childDetails,
  required String selectedStudentId,
  required Function(String) onStudentSelected,
  required bool isDark,
}) {
  TextEditingController dateController = TextEditingController();
  int? selectedStatus;
  int? selectedTitle;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              start: 20,
              end: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Student dropdown
                DropdownButtonFormField<String>(
                  dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                  style: AppStyles.styleMedium16().copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Select Student',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                  value: selectedStudentId,
                  items: childDetails.map((student) {
                    return DropdownMenuItem<String>(
                      value: student.id,
                      child: Text(student.fullName ?? 'Unknown Student'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    // Update selected student ID
                    setState(() {
                      selectedStudentId = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                // Date picker
                TextFormField(
                  controller: dateController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.blue,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blue.shade900,
                              onPrimary: Colors.white,
                              onSurface: Theme.of(context).brightness ==
                                      Brightness.dark
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
                        dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                const SizedBox(height: 15),
                // Status dropdown - 0 failed, 1 success
                DropdownButtonFormField<int>(
                  dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Notification Status',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text('All'),
                    ),
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Failed'),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Success'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                // Title dropdown - 0 payment, 1 attendance
                DropdownButtonFormField<int>(
                  dropdownColor: isDark ? Colors.grey[800] : Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Notification Type',
                    labelStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.blue,
                      ),
                    ),
                  ),
                  value: selectedTitle,
                  items: const [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text('All'),
                    ),
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Payment'),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text('Attendance'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTitle = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // Reset filters
                        setState(() {
                          selectedStudentId = childDetails.first.id!;
                          dateController.clear();
                          selectedStatus = null;
                          selectedTitle = null;
                        });
                      },
                      child: Text(
                        'Reset',
                        style: AppStyles.styleMedium16(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<NotificationCubit>().applyFilter(
                              studentId: selectedStudentId,
                              date: dateController.text.isEmpty
                                  ? null
                                  : dateController.text,
                              status: selectedStatus,
                              title: selectedTitle,
                            );
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Apply',
                        style: AppStyles.styleMedium16(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}
