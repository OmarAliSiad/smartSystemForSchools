import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/message.dart';

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
        )) {
    // Configure Dio with longer timeout and better error handling
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.validateStatus = (status) {
      return status != null &&
          status <
              500; // Accept all non-500 status codes for better error handling
    };
  }

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
            "Sorry, I couldn't process your request. ${_formatErrorMessage(e)}",
        isUser: false,
        timestamp: DateTime.now(),
      );

      emit(state.copyWith(
        messages: [...state.messages, errorMessage],
      ));
    }
  }

  String _formatErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout) {
        return "Connection timeout. Please check your internet connection.";
      } else if (error.type == DioExceptionType.receiveTimeout) {
        return "Server is taking too long to respond. Please try again later.";
      } else if (error.response != null) {
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        if (statusCode == 400) {
          return "Invalid request format. Please try again with different input.";
        } else if (statusCode == 401 || statusCode == 403) {
          return "API key authentication error. Please check your API key.";
        } else if (statusCode == 404) {
          return "API endpoint not found. Please check your configuration.";
        } else if (statusCode == 429) {
          return "API quota exceeded. Please try again later.";
        } else if (statusCode == 500 || statusCode == 503) {
          return "Server error. The AI service is currently unavailable.";
        }

        // Try to extract error message from response data
        if (responseData is Map) {
          final errorMessage = responseData['error']?['message'] ??
              responseData['message'] ??
              responseData['error'] ??
              "Unknown server error";
          return "Server error: $errorMessage";
        }
      }
    }
    return "Error: ${error.toString()}";
  }

  Future<String> _callAIService(String message,
      {String? imagePath, String? filePath}) async {
    try {
      // Use environment variables or secure storage in production!
      const apiKey = 'AIzaSyB5cs0Z_G1dnwe9DqHnH_Alfd2cybOsurk';
      // Updated API endpoint for Gemini 2.0 Flash
      const String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

      // Build conversation history
      final List<Map<String, dynamic>> contents = [];

      // Limit conversation context to avoid token limits
      // Only include last 5 messages to stay within context window
      int startIdx = state.messages.length > 5 ? state.messages.length - 5 : 0;

      for (int i = startIdx; i < state.messages.length; i++) {
        final Message msg = state.messages[i];
        final List<Map<String, dynamic>> parts = [];

        // Add text content if not empty
        if (msg.content.isNotEmpty) {
          parts.add({'text': msg.content});
        }

        // Add image if this message had one and it's in the cache
        if (msg.imageUrl != null && _imageCache.containsKey(msg.imageUrl)) {
          parts.add({
            'inline_data': {
              'mime_type': _getMimeType(msg.imageUrl!),
              'data': _imageCache[msg.imageUrl!]
            }
          });
        }

        // Only add message if it has content
        if (parts.isNotEmpty) {
          contents.add({'role': msg.isUser ? 'user' : 'model', 'parts': parts});
        }
      }

      // Add current message
      final List<Map<String, dynamic>> currentParts = [];

      // Add text message if not empty
      if (message.isNotEmpty) {
        currentParts.add({'text': message});
      }

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

      // Only add current message if it has content
      if (currentParts.isNotEmpty) {
        contents.add({'role': 'user', 'parts': currentParts});
      }

      // Create proper request structure for Gemini API
      Map<String, dynamic> requestBody = {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
          'topP': 0.95,
          'topK': 40,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      _dio.options.headers['Content-Type'] = 'application/json';

      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        try {
          final responseData = response.data;

          // First check for errors in the response
          if (responseData.containsKey('error')) {
            final error = responseData['error'];
            final errorMessage = error['message'] ?? 'Unknown API error';
            throw Exception(errorMessage);
          }

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
          return "I received an unexpected response format. Please try again.";
        } catch (e) {
          if (e is Exception) rethrow;
          return "Error processing response: ${e.toString()}";
        }
      } else {
        final errorData = response.data;
        String errorMessage = "API error";

        if (errorData is Map && errorData.containsKey('error')) {
          errorMessage = errorData['error']['message'] ?? errorMessage;
        }

        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: errorMessage,
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      }
      throw Exception("Failed to communicate with AI service: ${e.toString()}");
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
    final int animationSteps = fullResponse.length;
    const int maxAnimationDuration = 2000; // max 2 seconds for animation

    // Calculate delay to ensure animation completes in reasonable time
    final int stepDelay = (animationSteps > 100)
        ? (maxAnimationDuration ~/ animationSteps)
        : 20; // 20ms default for short responses

    for (int i = 0; i < fullResponse.length; i++) {
      currentText += fullResponse[i];
      emit(state.copyWith(currentTypingResponse: currentText));

      // Adjust typing speed - random delay between 5-15ms for natural typing feel
      await Future.delayed(Duration(milliseconds: stepDelay + (5 * (i % 3))));
    }
  }

  // Load saved messages
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
