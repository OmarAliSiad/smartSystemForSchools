// // 5. Create a ChatHistoryScreen to display the list of chat histories
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
// import 'package:smartsystemforschools/core/utils/app_styles.dart';
// import 'package:smartsystemforschools/features/chatbot/data/cubit/cubit/chat_history_cubit.dart';
// import 'package:smartsystemforschools/features/chatbot/data/cubit/cubit/chat_history_state.dart';
// import 'package:smartsystemforschools/features/chatbot/data/model/chat_history.dart';
// import 'package:smartsystemforschools/features/chatbot/presentation/chat_bot_screen.dart';
// import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';

// class ChatHistoryScreen extends StatefulWidget {
//   static const String id = 'chat_history_screen';

//   const ChatHistoryScreen({super.key});

//   @override
//   State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
// }

// class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ChatHistoryCubit>().loadChatHistories();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeMode = context.watch<ThemeModeCubit>().currentTheme;

//     return Scaffold(
//       appBar: AnimatedCustomAppBar(
//         waveColor: Colors.blue.shade700,
//         backgroundColor: Colors.blue.shade900,
//         onTapBack: () {
//           Navigator.of(context).pushReplacementNamed(MainScreen.id);
//         },
//         textStyle: AppStyles.styleSemiBold20(),
//         title: 'Chat History',
//         onTapSuffix: () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => const ChatbotScreen(),
//             ),
//           );
//         },
//       ),
//       backgroundColor: themeMode == ThemeMode.dark
//           ? const Color(0xFF121212)
//           : const Color(0xFFF5F5F5),
//       body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
//         builder: (context, state) {
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.histories.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.chat_bubble_outline,
//                     size: 80,
//                     color: themeMode == ThemeMode.dark
//                         ? Colors.white.withOpacity(0.5)
//                         : Colors.grey,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No chat history yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: themeMode == ThemeMode.dark
//                           ? Colors.white
//                           : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(
//                           builder: (context) => const ChatbotScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: themeMode == ThemeMode.dark
//                           ? Colors.blue
//                           : const Color(0xFF3D5AFE),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Start a new chat',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: state.histories.length,
//             itemBuilder: (context, index) {
//               final history = state.histories[index];
//               return _buildChatHistoryItem(context, history, themeMode);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildChatHistoryItem(
//     BuildContext context,
//     ChatHistory history,
//     ThemeMode themeMode,
//   ) {
//     final dateFormat = DateFormat('MMM d, yyyy · h:mm a');

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: themeMode == ThemeMode.dark
//             ? const Color(0xFF1E1E1E)
//             : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: themeMode == ThemeMode.dark
//                 ? const Color(0xFFFFFFFF).withOpacity(.1)
//                 : const Color(0x3F000000),
//             blurRadius: 6,
//             offset: const Offset(0, 0),
//             spreadRadius: 0,
//           )
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(
//                 builder: (context) => const ChatbotScreen(),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: themeMode == ThemeMode.dark
//                         ? Colors.blue.shade900
//                         : Colors.blue.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.chat_rounded,
//                     color: themeMode == ThemeMode.dark
//                         ? Colors.blue.shade300
//                         : Colors.blue.shade700,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         history.title,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: themeMode == ThemeMode.dark
//                               ? Colors.white
//                               : Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         history.previewText ?? 'No messages',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: themeMode == ThemeMode.dark
//                               ? Colors.grey[400]
//                               : Colors.grey[600],
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         dateFormat.format(history.lastMessageTime),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: themeMode == ThemeMode.dark
//                               ? Colors.grey[500]
//                               : Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.delete_outline,
//                     color: themeMode == ThemeMode.dark
//                         ? Colors.grey[400]
//                         : Colors.grey[600],
//                   ),
//                   onPressed: () {
//                     _showDeleteConfirmationDialog(
//                         context, history.id, themeMode);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _showDeleteConfirmationDialog(
//     BuildContext context,
//     String historyId,
//     ThemeMode themeMode,
//   ) async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: themeMode == ThemeMode.dark
//               ? const Color(0xFF1E1E1E)
//               : Colors.white,
//           title: Text(
//             'Delete Chat',
//             style: TextStyle(
//               color:
//                   themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to delete this chat? This action cannot be undone.',
//             style: TextStyle(
//               color: themeMode == ThemeMode.dark
//                   ? Colors.grey[300]
//                   : Colors.grey[700],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: themeMode == ThemeMode.dark
//                       ? Colors.grey[300]
//                       : Colors.grey[700],
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text(
//                 'Delete',
//                 style: TextStyle(
//                   color: Colors.red[400],
//                 ),
//               ),
//               onPressed: () {
//                 context.read<ChatHistoryCubit>().deleteChatHistory(historyId);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
