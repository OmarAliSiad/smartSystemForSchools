import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';

import 'chatbot_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final Dio _dio = Dio();
  // Cache to store image data for the conversation context
  final Map<String, String> _imageCache = {};

  ChatCubit()
      : super(ChatState(
          messages: [],
          isLoading: false,
          currentTypingResponse: '',
        ));

  Future<void> sendMessage(String message,
      {String? imagePath, String? filePath}) async {
    // Add user message to chat
    final userMessage = Message(
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      imageUrl: imagePath,
      filePath: filePath,
    );

    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    ));

    try {
      // Cache image data if provided
      if (imagePath != null) {
        final File imageFile = File(imagePath);
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);
        _imageCache[imagePath] = base64Image;
      }

      // Call the AI service with conversation history
      final response = await _callAIService(message,
          imagePath: imagePath, filePath: filePath);

      // Start typing animation
      await _animateResponse(response);

      // Add final bot response
      final botMessage = Message(
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, botMessage],
        isLoading: false,
        currentTypingResponse: '',
      ));
    } catch (e) {
      // Handle error
      emit(state.copyWith(
        isLoading: false,
        currentTypingResponse: '',
      ));

      final errorMessage = Message(
        content:
            "Sorry, I couldn't process your request. Error: ${e.toString()}",
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, errorMessage],
      ));
    }
  }

  Future<String> _callAIService(String message,
      {String? imagePath, String? filePath}) async {
    try {
      const apiKey =
          'AIzaSyBLTEcKLPeOAeq89fasRpA0s6KbPzeVaJA'; // Replace with your actual API key

      // Use the correct, current Gemini API endpoint structure
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

      // Build conversation history
      final List<Map<String, dynamic>> contents = [];
      // Add previous messages to establish context - limit to last 10 messages
      // We'll start with oldest messages first
      // const int historyLimit = 10;
      // final int startIdx = state.messages.length > historyLimit
      //     ? state.messages.length - historyLimit
      //     : 0;
      int startIdx = 0;
      for (int i = startIdx; i < state.messages.length; i++) {
        final Message msg = state.messages[i];
        final List<Map<String, dynamic>> parts = [];
        // Add text content
        parts.add({'text': msg.content});
        // Add image if this message had one
        if (msg.imageUrl != null && _imageCache.containsKey(msg.imageUrl)) {
          parts.add({
            'inline_data': {
              'mime_type': _getMimeType(msg.imageUrl!),
              'data': _imageCache[msg.imageUrl!]
            }
          });
        }
        contents.add({'role': msg.isUser ? 'user' : 'model', 'parts': parts});
      }

      // Add current message
      final List<Map<String, dynamic>> currentParts = [];

      // Add text message
      currentParts.add({'text': message});

      // Add image data if available for current message
      if (imagePath != null) {
        String base64Image;
        if (_imageCache.containsKey(imagePath)) {
          base64Image = _imageCache[imagePath]!;
        } else {
          final File imageFile = File(imagePath);
          final List<int> imageBytes = await imageFile.readAsBytes();
          base64Image = base64Encode(imageBytes);
          _imageCache[imagePath] = base64Image;
        }

        currentParts.add({
          'inline_data': {
            'mime_type': _getMimeType(imagePath),
            'data': base64Image
          }
        });
      }
      // Add current message to contents
      contents.add({'role': 'user', 'parts': currentParts});
      // Create proper request structure for Gemini API with conversation history
      Map<String, dynamic> requestBody = {
        'contents': contents,
        // 'generationConfig': {
        //   'temperature': 0.7,
        //   'maxOutputTokens': 2048,
        // }
      };
      _dio.options.headers['Content-Type'] = 'application/json';
      final response = await _dio.post(url, data: requestBody);
      if (response.statusCode == 200) {
        try {
          final responseData = response.data;
          final candidates = responseData['candidates'];

          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            if (content != null) {
              final parts = content['parts'];
              if (parts != null && parts.isNotEmpty) {
                return parts[0]['text'] ??
                    "I couldn't generate a proper response.";
              }
            }
          }
          print('Unexpected response structure: ${response.data}');
          return "I couldn't understand the API response format.";
        } catch (e) {
          print('Response parsing error: ${e.toString()}');
          return "Error parsing response: ${e.toString()}";
        }
      } else {
        print('Error response: ${response.statusCode}, ${response.data}');
        throw Exception(
            'Failed to get response: ${response.statusCode}, ${response.data}');
      }
    } catch (e) {
      print('Dio error: ${e.toString()}');
      // Return a more informative error message
      if (e.toString().contains('404')) {
        return "API connection error: The Gemini API endpoint couldn't be found. Please check your API key and model names.";
      } else {
        return "I couldn't process your request at the moment. Error: ${e.toString()}";
      }
    }
  }

  // Helper method to determine the MIME type from file extension
  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg'; // Default case
    }
  }

  Future<void> _animateResponse(String fullResponse) async {
    String currentText = '';
    // Split the response into characters and animate them typing out
    for (int i = 0; i < fullResponse.length; i++) {
      currentText += fullResponse[i];
      emit(state.copyWith(currentTypingResponse: currentText));

      // Adjust typing speed - random delay between 10-50ms for natural typing feel
      await Future.delayed(Duration(milliseconds: 10 + (5 * (i % 3))));
    }
  }

  // Add this method to ChatCubit:
  void loadMessages(List<Message> messages) {
    emit(state.copyWith(
      messages: messages,
    ));
  }

  // Clear conversation history and cache
  void clearConversation() {
    _imageCache.clear();
    emit(ChatState(
      messages: [],
      isLoading: false,
      currentTypingResponse: '',
    ));
  }
}
