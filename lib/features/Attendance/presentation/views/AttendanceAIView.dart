// // lib/features/ai_features/presentation/views/attendance_ai_view.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../../attendance_ai_service.dart';
// import '../../data/manager/attendance_ai_cubit/attendance_ai_cubit.dart';
// import '../../data/manager/attendance_ai_cubit/attendance_ai_state.dart';

// class AttendanceAIView extends StatefulWidget {
//   static String id = "AttendanceAIView";
//   final List<AttendanceRecord>? initialRecords;

//   const AttendanceAIView({super.key, this.initialRecords});

//   @override
//   State<AttendanceAIView> createState() => _AttendanceAIViewState();
// }

// class _AttendanceAIViewState extends State<AttendanceAIView> {
//   List<AttendanceRecord> _records = [];
//   bool _hasAnalyzed = false;

//   @override
//   void initState() {
//     super.initState();
//     _records = widget.initialRecords ?? [];

//     // If we have initial records, analyze them
//     if (_records.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.read<AttendanceAICubit>().analyzeAttendance(_records);
//         _hasAnalyzed = true;
//       });
//     }
//   }

//   void _analyzeAttendance() {
//     if (_records.isNotEmpty) {
//       context.read<AttendanceAICubit>().analyzeAttendance(_records);
//       setState(() {
//         _hasAnalyzed = true;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No attendance records to analyze')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Analysis'),
//         backgroundColor: const Color(0xff1A0F91),
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Records summary section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.grey.shade100,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${_records.length} Records',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _analyzeAttendance,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff1A0F91),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text('Analyze Attendance'),
//                 ),
//               ],
//             ),
//           ),

//           // Analysis results section
//           Expanded(
//             child: BlocBuilder<AttendanceAICubit, AttendanceAIState>(
//               builder: (context, state) {
//                 if (state is AttendanceAILoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state is AttendanceAISuccess) {
//                   return _buildAnalysisResults(state.analysis);
//                 } else if (state is AttendanceAIError) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Error: ${state.message}',
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return _hasAnalyzed
//                       ? const Center(child: Text('No analysis available'))
//                       : _buildAttendanceList();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddRecordDialog();
//         },
//         backgroundColor: const Color(0xff1A0F91),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildAnalysisResults(Map<String, dynamic> analysis) {
//     // Map status to color
//     Color statusColor;
//     switch (analysis['status']) {
//       case 'Normal':
//         statusColor = Colors.green;
//         break;
//       case 'Concerning':
//         statusColor = Colors.orange;
//         break;
//       case 'Critical':
//         statusColor = Colors.red;
//         break;
//       default:
//         statusColor = Colors.blue;
//         break;
//     }

//     // Map risk level to color
//     Color riskColor;
//     switch (analysis['risk_level']) {
//       case 'Low':
//         riskColor = Colors.green;
//         break;
//       case 'Medium':
//         riskColor = Colors.orange;
//         break;
//       case 'High':
//         riskColor = Colors.red;
//         break;
//       default:
//         riskColor = Colors.blue;
//         break;
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Status Card
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Attendance Status',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Status'),
//                           const SizedBox(height: 4),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: statusColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: statusColor),
//                             ),
//                             child: Text(
//                               analysis['status'],
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: statusColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Trend'),
//                           const SizedBox(height: 4),
//                           Text(
//                             analysis['trend'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text('Risk Level'),
//                           const SizedBox(height: 4),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: riskColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: riskColor),
//                             ),
//                             child: Text(
//                               analysis['risk_level'],
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: riskColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Recommendations Card
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.lightbulb_outline, color: Color(0xff1A0F91)),
//                       SizedBox(width: 8),
//                       Text(
//                         'Recommendations',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: (analysis['recommendations'] as List).length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('• ',
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold)),
//                             Expanded(
//                               child: Text(
//                                 analysis['recommendations'][index],
//                                 style: const TextStyle(fontSize: 15),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Return to records button
//           Center(
//             child: TextButton.icon(
//               onPressed: () {
//                 setState(() {
//                   _hasAnalyzed = false;
//                 });
//               },
//               icon: const Icon(Icons.list),
//               label: const Text('View Attendance Records'),
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xff1A0F91),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttendanceList() {
//     return _records.isEmpty
//         ? const Center(
//             child: Text(
//               'No attendance records yet.\nPress the + button to add records.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           )
//         : ListView.builder(
//             itemCount: _records.length,
//             itemBuilder: (context, index) {
//               final record = _records[index];

//               // Choose color based on status
//               Color statusColor;
//               IconData statusIcon;

//               switch (record.status) {
//                 case 'present':
//                   statusColor = Colors.green;
//                   statusIcon = Icons.check_circle;
//                   break;
//                 case 'absent':
//                   statusColor = Colors.red;
//                   statusIcon = Icons.cancel;
//                   break;
//                 case 'late':
//                   statusColor = Colors.orange;
//                   statusIcon = Icons.access_time;
//                   break;
//                 default:
//                   statusColor = Colors.blue;
//                   statusIcon = Icons.info;
//                   break;
//               }

//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 child: ListTile(
//                   leading: Icon(
//                     statusIcon,
//                     color: statusColor,
//                     size: 28,
//                   ),
//                   title: Text(
//                     DateFormat('MMM d, yyyy').format(record.date),
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     record.status.toUpperCase(),
//                     style: TextStyle(color: statusColor),
//                   ),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.grey),
//                     onPressed: () {
//                       setState(() {
//                         _records.removeAt(index);
//                       });
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//   }

//   void _showAddRecordDialog() {
//     final dateController = TextEditingController();
//     String selectedStatus = 'present';
//     DateTime selectedDate = DateTime.now();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Attendance Record'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Date picker field
//             InkWell(
//               onTap: () async {
//                 final DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime.now(),
//                 );
//                 if (picked != null) {
//                   selectedDate = picked;
//                   dateController.text =
//                       DateFormat('MMM d, yyyy').format(selectedDate);
//                 }
//               },
//               child: TextField(
//                 controller: dateController,
//                 enabled: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Date',
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Status dropdown
//             DropdownButtonFormField<String>(
//               value: selectedStatus,
//               decoration: const InputDecoration(
//                 labelText: 'Status',
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'present', child: Text('Present')),
//                 DropdownMenuItem(value: 'absent', child: Text('Absent')),
//                 DropdownMenuItem(value: 'late', child: Text('Late')),
//               ],
//               onChanged: (value) {
//                 selectedStatus = value!;
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (dateController.text.isNotEmpty) {
//                 setState(() {
//                   _records.add(
//                     AttendanceRecord(
//                       date: selectedDate,
//                       status: selectedStatus,
//                     ),
//                   );
//                   // Sort records by date
//                   _records.sort((a, b) => b.date.compareTo(a.date));
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xff1A0F91),
//             ),
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
