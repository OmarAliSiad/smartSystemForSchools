import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/chatbot/data/cubit/chatbot_state.dart';
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
    // Implementation using Dio instead of http
    try {
      const apiKey =
          'AIzaSyBLTEcKLPeOAeq89fasRpA0s6KbPzeVaJA'; // Replace with your actual API key
      const url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

      Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {'text': message}
            ]
          }
        ]
      };

      // Add image data if available
      if (imagePath != null) {
        final File imageFile = File(imagePath);
        final List<int> imageBytes = await imageFile.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        requestBody['contents'][0]['parts'].add({
          'inline_data': {
            'mime_type': 'image/jpeg', // Adjust based on image type
            'data': base64Image
          }
        });
      }

      // Add file data if available
      if (filePath != null) {
        // Handle file depending on what you need to do with it
        // For now we'll just mention it in the message
        requestBody['contents'][0]['parts'][0]['text'] +=
            "\n[File attached: ${filePath.split('/').last}]";
      }

      // Configure Dio
      _dio.options.headers['Content-Type'] = 'application/json';

      final response =
          await _dio.post(url, data: requestBody, queryParameters: {
        'key': apiKey,
      });

      if (response.statusCode == 200) {
        // You'd need to parse the actual response structure from Gemini API
        return response.data['candidates'][0]['content']['parts'][0]['text'] ??
            "I couldn't generate a proper response.";
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Dio error: ${e.toString()}');
      // For demo purposes, return a mock response
      await Future.delayed(const Duration(seconds: 2));
      return "This is a simulated response to demonstrate the character-by-character typing animation. In a real implementation, this would be the response from the Gemini API or your custom AI service.";
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
}
