import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/cubit/get_all_catogries_cubit.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/cubit/cubit/meal_recommendation_cubit.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/cubit/cubit/meal_recommendation_state.dart';
import 'package:smartsystemforschools/features/food_ai_view/data/models/child_model.dart';
import 'package:smartsystemforschools/features/food_ai_view/screens/recommdation_screen.dart';
import 'package:smartsystemforschools/features/main_screen/presentation/views/main_screen.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/core/services/school_service/school_service.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/widgets/custom_text_field_edit_profile_widget.dart';

class FoodAiScreen extends StatefulWidget {
  const FoodAiScreen({super.key});

  @override
  _FoodAiScreenState createState() => _FoodAiScreenState();
}

class _FoodAiScreenState extends State<FoodAiScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  // For child selection
  List<ResultForChildDetails> _children = [];
  ResultForChildDetails? _selectedChild;
  bool _isLoadingChildren = true;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  // Blood type selection
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  String? _selectedBloodType;
  // final List<String> _dietaryOptions = [
  //   'Vegetarian',
  //   'Vegan',
  //   'Pescatarian',
  //   'Organic only'
  // ];
  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
  ];
  final List<String> _timeOfDay = ['Morning', 'Afternoon', 'Evening'];
  String _selectedMealType = 'Breakfast';
  String? _selectedTimeOfDay;
  final List<String> _selectedAllergies = [];
  final List<String> _selectedDietaryOptions = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
    _loadAllergies();
  }

  Future<void> _loadChildren() async {
    try {
      final children = await SchoolService().getAllChildDetails();
      setState(() {
        _children = children;
        _isLoadingChildren = false;
        if (_children.isNotEmpty) {
          _selectedChild = _children.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingChildren = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load children: $e')),
      );
    }
  }

  void _loadAllergies() {
    context.read<GetAllCatogriesCubit>().getAllCatogries();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode
    final themeMode = context.watch<ThemeModeCubit>().currentTheme;
    final isDarkMode = themeMode == ThemeMode.dark;
    // Determine colors based on theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.blue.shade500;
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: Colors.blue,
        backgroundColor: Colors.blue.shade900,
        title: 'Meal Planner AI',
        onTapBack: () {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        },
        thereIsIcon: false,
        textStyle: AppStyles.styleSemiBold20(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<MealRecommendationCubit, MealRecommendationState>(
          listener: (context, state) {
            if (state is MealRecommendationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is MealRecommendationLoaded) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecommendationsScreen(
                    recommendations: state.recommendations,
                    mealType: _selectedMealType,
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<MealRecommendationCubit, MealRecommendationState>(
            builder: (context, state) {
              if (state is MealRecommendationLoading) {
                return buildLoadingView(
                  'meals',
                  context,
                );
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Child name',
                        style: AppStyles.styleMedium16(),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      // Child selection
                      _isLoadingChildren
                          ? buildLoadingView('Childs', context)
                          : _buildChildSelector(isDarkMode),
                      const SizedBox(height: 8),
                      // Child's age
                      Text(
                        'Age',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          labelText: 'Age',
                          labelStyle: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: AppStyles.styleMedium16(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your child\'s age';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),
                      // NEW: Weight field
                      Text(
                        'Weight (kg)',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          labelText: 'Weight in kg',
                          labelStyle: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: AppStyles.styleMedium16(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter child\'s weight';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid weight';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),

                      // NEW: Height field
                      Text(
                        'Height (cm)',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 175.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          labelText: 'Height in cm',
                          labelStyle: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: AppStyles.styleMedium16(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter child\'s height';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid height';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 175.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),

                      // NEW: Blood Type field
                      Text(
                        'Blood Type',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 190.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          labelText: 'Select Blood Type',
                          labelStyle: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode == true
                                ? Colors.white
                                : Colors.black,
                          ),
                          filled: false,
                        ),
                        dropdownColor:
                            isDarkMode == true ? Colors.black : Colors.white,
                        value: _selectedBloodType,
                        style: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode ? Colors.white : Colors.black),
                        items: _bloodTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a blood type';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedBloodType = value;
                          });
                        },
                      )
                          .animate()
                          .fadeIn(delay: 190.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),

                      // Allergies section with BLoC
                      Text(
                        'Allergies',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      _buildAllergiesSection(isDarkMode),
                      const SizedBox(height: 16),
                      // // Dietary preferences
                      // Text(
                      //   'Dietary Preferences',
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .titleLarge
                      //       ?.copyWith(color: textColor),
                      // )
                      //     .animate()
                      //     .fadeIn(delay: 300.ms, duration: 500.ms)
                      //     .slideY(begin: 0.2, end: 0),
                      // const SizedBox(height: 8),
                      // Wrap(
                      //   spacing: 8,
                      //   children: _dietaryOptions.map((option) {
                      //     final isSelected =
                      //         _selectedDietaryOptions.contains(option);
                      //     return FilterChip(
                      //       label: Text(option),
                      //       selected: isSelected,
                      //       selectedColor: Colors.blue.shade300,
                      //       onSelected: (selected) {
                      //         setState(() {
                      //           if (selected) {
                      //             _selectedDietaryOptions.add(option);
                      //           } else {
                      //             _selectedDietaryOptions.remove(option);
                      //           }
                      //         });
                      //       },
                      //     );
                      //   }).toList(),
                      // )
                      //     .animate()
                      //     .fadeIn(delay: 350.ms, duration: 500.ms)
                      //     .slideY(begin: 0.2, end: 0),
                      // const SizedBox(height: 24),

                      // Meal type
                      Text(
                        'Meal Type',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          filled: false,
                        ),
                        dropdownColor:
                            isDarkMode == true ? Colors.black : Colors.white,
                        value: _selectedMealType,
                        style: AppStyles.styleMedium16().copyWith(
                            color: isDarkMode ? Colors.white : Colors.black),
                        items: _mealTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedMealType = value;
                            });
                          }
                        },
                      )
                          .animate()
                          .fadeIn(delay: 450.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 16),
                      // Time of day (optional)
                      Text(
                        'Time of Day',
                        style: AppStyles.styleMedium20(),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          focusedBorder: buildOutlineBorder(borderRadius: 10),
                          enabledBorder: buildOutlineBorder(borderRadius: 10),
                          border: buildOutlineBorder(borderRadius: 10),
                          filled: false,
                        ),
                        dropdownColor:
                            isDarkMode == true ? Colors.black : Colors.white,
                        value: _selectedTimeOfDay,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Any time',
                              style: AppStyles.styleMedium16(),
                            ),
                          ),
                          ..._timeOfDay.map((time) {
                            return DropdownMenuItem(
                              value: time,
                              child: Text(
                                time,
                                style: AppStyles.styleMedium16(),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeOfDay = value;
                          });
                        },
                      )
                          .animate()
                          .fadeIn(delay: 550.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 24),
                      const SizedBox(
                        height: 90,
                      ),
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff191BA9),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              log('_selectedAllergies $_selectedAllergies');
                              if (_selectedAllergies.isEmpty) {
                                dispalySnackBar(
                                  context,
                                  title: 'Please select at least one allergy',
                                  color: Colors.red,
                                );
                              } else {
                                final profile = ChildProfile(
                                  name: _selectedChild?.fullName ?? "Unknown",
                                  age: int.parse(_ageController.text),
                                  allergies: _selectedAllergies,
                                  dietaryPreferences: _selectedDietaryOptions,
                                  time: _selectedMealType,
                                  bloodType: _selectedBloodType ?? "Unknown",
                                  weight: double.parse(_weightController.text),
                                  height: double.parse(_heightController.text),
                                );
                                log(profile.toJson().toString());
                                context
                                    .read<MealRecommendationCubit>()
                                    .getRecommendations(
                                      profile: profile,
                                      mealType: _selectedMealType,
                                      timeOfDay: _selectedTimeOfDay,
                                    );
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Get Recommendations',
                              style: AppStyles.styleMedium16().copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChildSelector(bool isDarkMode) {
    if (_children.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No children found. Please add children first.',
            style: AppStyles.styleMedium20(),
          ),
        ),
      );
    }
    return DropdownButtonFormField<ResultForChildDetails>(
      dropdownColor: isDarkMode == true ? Colors.black : Colors.white,
      decoration: InputDecoration(
        focusedBorder: buildOutlineBorder(borderRadius: 10),
        enabledBorder: buildOutlineBorder(borderRadius: 10),
        border: buildOutlineBorder(borderRadius: 10),
        label: Text(
          'Select Child',
          style: AppStyles.styleMedium16().copyWith(
              color: isDarkMode == true ? Colors.white : Colors.black),
        ),
        filled: false,
        labelStyle: AppStyles.styleMedium20(),
      ),
      value: _selectedChild,
      style: AppStyles.styleMedium20(),
      items: _children.map((child) {
        return DropdownMenuItem<ResultForChildDetails>(
          value: child,
          child: Text(
            child.fullName ?? 'Unknown',
            style: AppStyles.styleMedium16()
                .copyWith(color: isDarkMode ? Colors.white : Colors.black),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedChild = value;
        });
      },
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildAllergiesSection(bool isDarkMode) {
    return BlocBuilder<GetAllCatogriesCubit, GetAllCatogriesState>(
      builder: (context, state) {
        if (state is GetAllCatogriesLoading) {
          return buildLoadingView(
            'allergies',
            context,
          );
        } else if (state is GetAllCatogriesLoaded) {
          final allergies = state.catgoryDetails.result ?? [];

          if (allergies.isEmpty) {
            return Text(
              'No allergies found',
              style: AppStyles.styleMedium20(),
            );
          }
          return Wrap(
            spacing: 8,
            children: allergies.map((allergy) {
              final allergyName = allergy.name ?? 'Unknown';
              final isSelected = _selectedAllergies.contains(allergyName);
              return FilterChip(
                color: isDarkMode == true
                    ? WidgetStatePropertyAll(Colors.grey.shade900)
                    : const WidgetStatePropertyAll(Colors.white),
                label: Text(
                  allergyName,
                  style: AppStyles.styleMedium15(),
                ),
                selected: isSelected,
                selectedColor: Colors.blue.shade900,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedAllergies.add(allergyName);
                    } else {
                      _selectedAllergies.remove(allergyName);
                    }
                  });
                },
              );
            }).toList(),
          )
              .animate()
              .fadeIn(delay: 250.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0);
        } else if (state is GetAllCatogriesFailure) {
          return Column(
            children: [
              Text(
                'Failed to load allergies: ${state.errMessage}',
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton(
                onPressed: () => _loadAllergies(),
                child: const Text('Retry'),
              ),
            ],
          );
        }
        // Initial state
        return Text(
          'Loading allergies...',
          style: AppStyles.styleMedium20(),
        );
      },
    );
  }
}
