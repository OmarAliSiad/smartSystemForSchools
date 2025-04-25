import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';

class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String currentTypingResponse;

  ChatState({
    required this.messages,
    required this.isLoading,
    required this.currentTypingResponse,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? currentTypingResponse,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      currentTypingResponse:
          currentTypingResponse ?? this.currentTypingResponse,
    );
  }
}
