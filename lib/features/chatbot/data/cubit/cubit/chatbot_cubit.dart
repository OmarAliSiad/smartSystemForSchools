import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/chatbot/data/cubit/cubit/chatbot_state.dart';
import 'package:smartsystemforschools/features/chatbot/data/model/message.dart';

class ChatCubit extends Cubit<ChatState> {
  final Dio _dio = Dio();

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
      // Call the AI service
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
      // For multimodal (text+image) use gemini-pro-vision
      // For text-only use gemini-pro
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

      final List<Map<String, dynamic>> parts = [];

      // Add text message
      parts.add({'text': message});

      // Add image data if available
      if (imagePath != null) {
        final File imageFile = File(imagePath);
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        parts.add({
          'inline_data': {
            'mime_type': _getMimeType(imagePath),
            'data': base64Image
          }
        });
      }

      // // Add file mention if available
      // if (filePath != null) {
      //   // Just mention the file in the text
      //   final filename = filePath.split('/').last;
      //   if (parts.isNotEmpty && parts[0].containsKey('text')) {
      //     parts[0]['text'] += "\n[File attached: $filename]";
      //   }
      // }

      // Create proper request structure for Gemini API
      Map<String, dynamic> requestBody = {
        'contents': [
          {'parts': parts}
        ],
        // 'generationConfig': {
        //   'temperature': 0.7,
        //   'maxOutputTokens': 2048,
        // }
      };

      // Configure Dio
      _dio.options.headers['Content-Type'] = 'application/json';

      // Print request for debugging
      print('Making request to: $url');

      // Make the API request WITHOUT putting the key in the query parameters
      // since we've already included it in the URL
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
}
