import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodAIService {
  final String _baseUrl =
      'http://localhost:8000'; // Change this to your server address
  bool _isModelLoaded = true; // Assuming the Python server is running

  Future<void> loadModel() async {
    try {
      // Check if the server is running by making a GET request to the root endpoint
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        _isModelLoaded = true;
        debugPrint('Food AI service is running');
      } else {
        _isModelLoaded = false;
        debugPrint('Food AI service is not running properly');
      }
    } catch (e) {
      debugPrint('Error connecting to Food AI service: $e');
      _isModelLoaded = false;
    }
  }

  bool get isModelLoaded => _isModelLoaded;

  Future<Map<String, dynamic>> analyzeFoodImage(File imageFile) async {
    if (!_isModelLoaded) {
      throw Exception('Food AI service not available');
    }

    try {
      // Create a multipart request
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/analyze-food'));

      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> result = json.decode(response.body);
        return {
          'foodType': result['foodType'],
          'allergens': List<String>.from(result['allergens']),
          'nutritionalInfo': result['nutritionalInfo'],
          'confidenceScore': result['confidenceScore']
        };
      } else {
        throw Exception('Failed to analyze food image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error analyzing food image: $e');
      // Return a default response with error information
      return {
        'foodType': 'Unknown',
        'allergens': <String>[],
        'nutritionalInfo': {'calories': 0, 'protein': 0, 'carbs': 0, 'fat': 0},
        'confidenceScore': 0.0,
        'error': e.toString()
      };
    }
  }
}
