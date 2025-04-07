import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/api_handler.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/cubit/cubit/meal_recommendation_state.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/models/child_model.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/models/meal_recommendation.dart';

class MealRecommendationCubit extends Cubit<MealRecommendationState> {
  MealRecommendationCubit() : super(MealRecommendationInitial());

  Future<void> getRecommendations({
    required ChildProfile profile,
    required String mealType,
    String? timeOfDay,
  }) async {
    try {
      emit(MealRecommendationLoading());

      // Prepare the prompt for Gemini
      final prompt = _buildPrompt(profile, mealType, timeOfDay);

      // Call Gemini API
      final recommendations = await _callGeminiApi(prompt);

      emit(MealRecommendationLoaded(recommendations));
    } catch (e) {
      emit(MealRecommendationError(
          'Failed to get recommendations: ${e.toString()}'));
    }
  }

  String _buildPrompt(
      ChildProfile profile, String mealType, String? timeOfDay) {
    final allergiesText = profile.allergies.join(', ');
    final preferencesText = profile.dietaryPreferences.isEmpty
        ? 'no specific preferences'
        : profile.dietaryPreferences.join(', ');

    return """
    My child is ${profile.age} years old and has allergies to $allergiesText. 
    They have dietary preferences: $preferencesText.
    Please provide a comprehensive list of food products that are forbidden or not recommended for ${mealType.toLowerCase()} options${timeOfDay != null ? ' for $timeOfDay' : ''}.
    For each option, include:
    - Name
    - Ingredients
    - Why it's harmful
    """;
  }

  Future<List<MealRecommendation>> _callGeminiApi(String prompt) async {
    log(prompt);
    // Replace with your actual API key and endpoint
    const apiKey = 'AIzaSyBLTEcKLPeOAeq89fasRpA0s6KbPzeVaJA';
    final response = await DioHelper().post(
      url:
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final responseText = data['candidates'][0]['content']['parts'][0]['text'];
      log('responseText\n$responseText');
      return _parseRecommendations(responseText);
    } else {
      throw Exception('Failed to get recommendations from Gemini API');
    }
  }

  List<MealRecommendation> _parseRecommendations(String responseText) {
    final recommendations = <MealRecommendation>[];

    // Split the text by numbered items, looking for patterns like "1. " or "1. **"
    final regex = RegExp(r'\*\*\d+\.\s+([^*]+)\*\*', dotAll: true);
    final matches = regex.allMatches(responseText);

    if (matches.isEmpty) {
      // Try alternative pattern that looks for meal names
      final nameRegex = RegExp(r'\*\*Name:\*\*\s+([^\n]+)', dotAll: true);
      final nameMatches = nameRegex.allMatches(responseText);

      // If we find meal names, extract each meal section
      if (nameMatches.isNotEmpty) {
        int startPos = 0;
        for (int i = 0; i < nameMatches.length; i++) {
          final nameMatch = nameMatches.elementAt(i);
          final mealName = nameMatch.group(1)?.trim() ?? 'Unnamed Meal';

          // Find the end of this section (either the next name or the end of text)
          int endPos = i < nameMatches.length - 1
              ? nameMatches.elementAt(i + 1).start
              : responseText.length;
          // Extract the meal section text
          final sectionText = responseText.substring(startPos, endPos);
          startPos = endPos;
          // Extract ingredients
          final ingredientsRegex =
              RegExp(r'\*\*Ingredients:\*\*(.*?)(?=\*\*Why|$)', dotAll: true);
          final ingredientsMatch = ingredientsRegex.firstMatch(sectionText);
          final ingredientsText = ingredientsMatch?.group(1)?.trim() ?? '';

          // Extract ingredients as list items
          final ingredientsList = <String>[];
          final ingredientItemRegex = RegExp(r'\*\s+([^\n]+)');
          final ingredientItems =
              ingredientItemRegex.allMatches(ingredientsText);
          for (var item in ingredientItems) {
            final ingredient = item.group(1)?.trim();
            if (ingredient != null && ingredient.isNotEmpty) {
              ingredientsList.add(ingredient);
            }
          }

          // Extract disadvantages
          final harmful = RegExp(
              r"\*\*Why it\'s harmful:\*\*(.*?)(?=\*\*Kid-Friendly|$)",
              dotAll: true);
          final disadvantagMatch = harmful.firstMatch(sectionText);
          final disadvantageText = disadvantagMatch?.group(1)?.trim() ?? '';

          // Extract tips
          // final tipsRegex = RegExp(
          //     r'\*\*Kid-Friendly Tips:\*\*(.*?)(?=\*\*\d|$)',
          //     dotAll: true);
          // final tipsMatch = tipsRegex.firstMatch(sectionText);
          // final tipsText = tipsMatch?.group(1)?.trim() ?? '';

          recommendations.add(MealRecommendation(
            name: mealName,
            ingredients: ingredientsList,
            description: sectionText,
            // kidFriendlyTip: tipsText,
            disadvantageDescription: disadvantageText,
          ));
        }
      }
    } else {
      // Process original regex matches if found
      for (var match in matches) {
        final title = match.group(1)?.trim() ?? 'Unnamed Meal';
        final fullText = responseText.substring(match.start);

        // Find the end of this section (either the next meal or the end)
        int endPos = responseText.length;
        for (var nextMatch in matches) {
          if (nextMatch.start > match.start) {
            endPos = nextMatch.start;
            break;
          }
        }
        final sectionText = responseText.substring(match.start, endPos);
        // Extract the name from the meal section
        final nameRegex = RegExp(r'\*\*Name:\*\*\s+([^\n]+)');
        final nameMatch = nameRegex.firstMatch(sectionText);
        final name = nameMatch?.group(1)?.trim() ?? title.replaceAll('*', '');

        // Extract ingredients
        final ingredientsRegex =
            RegExp(r'\*\*Ingredients:\*\*(.*?)(?=\*\*Why|$)', dotAll: true);
        final ingredientsMatch = ingredientsRegex.firstMatch(sectionText);
        final ingredientsText = ingredientsMatch?.group(1)?.trim() ?? '';

        // Extract ingredients as list items
        final ingredientsList = <String>[];
        final ingredientItemRegex = RegExp(r'\*\s+([^\n]+)');
        final ingredientItems = ingredientItemRegex.allMatches(ingredientsText);
        for (var item in ingredientItems) {
          final ingredient = item.group(1)?.trim();
          if (ingredient != null && ingredient.isNotEmpty) {
            ingredientsList.add(ingredient);
          }
        }
        // Extract benefits
        final harmful = RegExp(
            r"\*\*Why it\'s harmful:\*\*(.*?)(?=\*\*Kid-Friendly|$)",
            dotAll: true);
        final disadvantagMatch = harmful.firstMatch(sectionText);
        final disadvantageText = disadvantagMatch?.group(1)?.trim() ?? '';
        // Extract tips
        // final tipsRegex = RegExp(r'\*\*Kid-Friendly Tips:\*\*(.*?)(?=\*\*\d|$)',
        //     dotAll: true);
        // final tipsMatch = tipsRegex.firstMatch(sectionText);
        // final tipsText = tipsMatch?.group(1)?.trim() ?? '';
        recommendations.add(MealRecommendation(
          name: name,
          ingredients: ingredientsList.isEmpty
              ? ['No ingredients listed']
              : ingredientsList,
          description: sectionText,
          // kidFriendlyTip: tipsText,
          disadvantageDescription: disadvantageText,
        ));
      }
    }
    return recommendations;
  }

  String _extractSection(String text, String sectionName) {
    final sectionRegex =
        RegExp('\\*\\*$sectionName\\*\\*(.+?)(?=\\*\\*|\$)', dotAll: true);
    final match = sectionRegex.firstMatch(text);
    return match?.group(1)?.trim() ?? '';
  }
}
