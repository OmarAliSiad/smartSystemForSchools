import 'package:smartsystemforschools/features/food_ai_view/data/models/meal_recommendation.dart';

abstract class MealRecommendationState {}

class MealRecommendationInitial extends MealRecommendationState {}

class MealRecommendationLoading extends MealRecommendationState {}

class MealRecommendationLoaded extends MealRecommendationState {
  final List<MealRecommendation> recommendations;

  MealRecommendationLoaded(this.recommendations);
}

class MealRecommendationError extends MealRecommendationState {
  final String message;

  MealRecommendationError(this.message);
}
