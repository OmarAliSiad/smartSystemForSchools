// MODELS
class ChildProfile {
  final String name;
  final int age;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final String time;
  final double weight;
  final double height;
  final String bloodType;
  final List<Map<String, dynamic>> selectedProducts;
  ChildProfile({
    required this.name,
    required this.age,
    required this.allergies,
    required this.dietaryPreferences,
    required this.time,
    required this.weight,
    required this.height,
    required this.bloodType,
    required this.selectedProducts,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'allergies': allergies,
        'dietaryPreferences': dietaryPreferences,
        'time': time,
      };
}
