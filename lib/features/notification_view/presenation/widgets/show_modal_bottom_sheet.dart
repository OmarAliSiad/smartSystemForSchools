import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/features/notification_view/data/cubit/notification_cubit.dart';

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
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Student dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Student',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
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
                  decoration: const InputDecoration(
                    labelText: 'Notification Status',
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
                    labelText: 'Notification Type',
                    border: OutlineInputBorder(),
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
                    TextButton(
                      onPressed: () {
                        // Reset filters
                        setState(() {
                          selectedStudentId = childDetails.first.id!;
                          dateController.clear();
                          selectedStatus = null;
                          selectedTitle = null;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
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
                      child: const Text('Apply'),
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
