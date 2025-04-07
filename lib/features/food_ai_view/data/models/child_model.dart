// MODELS
class ChildProfile {
  final String name;
  final int age;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final String time;

  ChildProfile( {
    required this.name,
    required this.age,
    required this.allergies,
    required this.dietaryPreferences,
    required this.time,
  });

  Map<String,dynamic> toJson() => {
    'name': name,
    'age': age,
    'allergies': allergies,
    'dietaryPreferences': dietaryPreferences,
    'time': time,
  };
}
