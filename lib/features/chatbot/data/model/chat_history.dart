// 1. First, let's create a chat history model - chat_history.dart

import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';

class ChatHistory {
  final String id;
  final String title;
  final DateTime lastMessageTime;
  final List<Message> messages;
  final String? previewText;

  ChatHistory({
    required this.id,
    required this.title,
    required this.lastMessageTime,
    required this.messages,
    this.previewText,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'],
      title: json['title'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
      previewText: json['previewText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'previewText': previewText,
    };
  }
}