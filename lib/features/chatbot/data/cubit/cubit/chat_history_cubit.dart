// // Chat history cubit
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smartsystemforschools/features/chatbot/data/cubit/cubit/chat_history_state.dart';
// import 'package:smartsystemforschools/features/chatbot/data/model/chat_history.dart';
// import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';
// import 'package:smartsystemforschools/features/chatbot/data/services/chat_history_service.dart';

// class ChatHistoryCubit extends Cubit<ChatHistoryState> {
//   final ChatHistoryService _historyService = ChatHistoryService();

//   ChatHistoryCubit()
//       : super(ChatHistoryState(
//           histories: [],
//           isLoading: false,
//         ));

//   // Load all chat histories
//   Future<void> loadChatHistories() async {
//     emit(state.copyWith(isLoading: true));
//     try {
//       final histories = await _historyService.getAllChatHistories();
//       // Sort by last message time (newest first)
//       histories.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
//       emit(state.copyWith(histories: histories, isLoading: false));
//     } catch (e) {
//       emit(state.copyWith(
//         isLoading: false,
//         error: 'Failed to load chat histories: ${e.toString()}',
//       ));
//     }
//   }

//   // Create a new chat history
//   Future<ChatHistory?> createChatHistory(String title, List<Message> messages) async {
//     try {
//       final newHistory = await _historyService.createChatHistory(title, messages);
//       await loadChatHistories(); // Reload the list
//       return newHistory;
//     } catch (e) {
//       emit(state.copyWith(error: 'Failed to create chat history: ${e.toString()}'));
//       return null;
//     }
//   }

//   // Delete a chat history
//   Future<void> deleteChatHistory(String id) async {
//     try {
//       await _historyService.deleteChatHistory(id);
//       await loadChatHistories(); // Reload the list
//     } catch (e) {
//       emit(state.copyWith(error: 'Failed to delete chat history: ${e.toString()}'));
//     }
//   }
// }
