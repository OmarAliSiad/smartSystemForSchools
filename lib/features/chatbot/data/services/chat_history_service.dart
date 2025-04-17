// 3. Create a ChatHistoryService for managing chat history
// This uses SharedPreferences to persist chat histories
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:smartsystemforschools/features/chatbot/data/model/chat_history.dart';
import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';

class ChatHistoryService {
  static const String _storageKey = 'chat_histories';
  final Uuid _uuid = const Uuid();

  // Get all chat histories
  Future<List<ChatHistory>> getAllChatHistories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chatHistoriesJson = prefs.getString(_storageKey);

    if (chatHistoriesJson == null) {
      return [];
    }

    final List<dynamic> chatHistoriesData = json.decode(chatHistoriesJson);
    return chatHistoriesData.map((data) => ChatHistory.fromJson(data)).toList();
  }

  // Create a new chat history
  Future<ChatHistory> createChatHistory(
      String title, List<Message> messages) async {
    final String id = _uuid.v4();
    final DateTime now = DateTime.now();
    String? previewText;

    if (messages.isNotEmpty) {
      // Get the first message content as preview (limit to 50 chars)
      previewText = messages.first.content.length > 50
          ? '${messages.first.content.substring(0, 50)}...'
          : messages.first.content;
    }

    final ChatHistory newHistory = ChatHistory(
      id: id,
      title: title,
      lastMessageTime: now,
      messages: messages,
      previewText: previewText,
    );

    // Save to storage
    final List<ChatHistory> histories = await getAllChatHistories();
    histories.add(newHistory);
    await _saveChatHistories(histories);

    return newHistory;
  }

  // Update an existing chat history
  Future<void> updateChatHistory(ChatHistory updatedHistory) async {
    final List<ChatHistory> histories = await getAllChatHistories();
    final int index = histories.indexWhere((h) => h.id == updatedHistory.id);

    if (index != -1) {
      histories[index] = updatedHistory;
      await _saveChatHistories(histories);
    }
  }

  // Delete a chat history
  Future<void> deleteChatHistory(String id) async {
    final List<ChatHistory> histories = await getAllChatHistories();
    histories.removeWhere((history) => history.id == id);
    await _saveChatHistories(histories);
  }

  // Save all chat histories
  Future<void> _saveChatHistories(List<ChatHistory> histories) async {
    final prefs = await SharedPreferences.getInstance();
    final String chatHistoriesJson = json.encode(
      histories.map((history) => history.toJson()).toList(),
    );
    await prefs.setString(_storageKey, chatHistoriesJson);
  }
}
