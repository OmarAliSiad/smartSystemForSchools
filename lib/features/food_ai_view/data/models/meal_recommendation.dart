class MealRecommendation {
  final String name;
  final List<String> ingredients;
  final String description;
  // final String kidFriendlyTip;
  final String disadvantageDescription;

  MealRecommendation({
    required this.name,
    required this.ingredients,
    required this.description,
    // required this.kidFriendlyTip,
    required this.disadvantageDescription,
  });

  factory MealRecommendation.fromJson(Map<String, dynamic> json) {
    return MealRecommendation(
      name: json['name'] ?? 'Unnamed Meal',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      description: json['description'] ?? '',
      // kidFriendlyTip: json['kidFriendlyTip'] ?? '',
      disadvantageDescription: json['disadvantageDescription'] ?? '',
    );
  }
}
