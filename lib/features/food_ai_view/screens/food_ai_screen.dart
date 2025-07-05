import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smartsystemforschools/core/models/get_all_products/get_all_products.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/methods/show_scaffold_messanger.dart';
import '../../../core/services/product_catogry_service/product_catogry_service.dart';
import '../../../core/utils/animated_app_bar.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/widgets/build_loading_view.dart';
import '../../Allergies/data/manager/get_all_catogries_cubit/get_all_catogries_cubit.dart';
import '../data/cubit/cubit/meal_recommendation_cubit.dart';
import '../data/cubit/cubit/meal_recommendation_state.dart';
import '../data/models/child_model.dart';
import 'recommdation_screen.dart';
import '../../main_screen/presentation/views/main_screen.dart';
import '../../../core/models/get_child_details/result.dart';
import '../../../core/services/school_service/school_service.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../../settings_view/presentation/widgets/custom_text_field_edit_profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class FoodAiScreen extends StatefulWidget {
  const FoodAiScreen({super.key});

  @override
  _FoodAiScreenState createState() => _FoodAiScreenState();
}

class _FoodAiScreenState extends State<FoodAiScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // For child selection
  List<ResultForChildDetails> _children = [];
  ResultForChildDetails? _selectedChild;
  GetAllProducts? catogryProducts;

  bool _isLoadingChildren = true;

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

  final List<String> _selectedAllergies = [];
  final List<String> _selectedDietaryOptions = [];

  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _loadChildren();
    _loadAllergies();

    // Initialize background animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
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
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${LocaleKeys.foodAiScreen_failedToLoadChildren.tr()} $e',
            style: AppStyles.styleMedium13(),
          ),
        ),
      );
    }
  }

  void _loadAllergies() {
    context.read<GetAllCatogriesCubit>().getAllCatogries();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeCubit>().currentTheme;
    final isDarkMode = themeMode == ThemeMode.dark;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        Color.lerp(
                            const Color(0xFF0F0F23),
                            const Color(0xFF1A1A2E),
                            _backgroundAnimation.value)!,
                        Color.lerp(
                            const Color(0xFF1A1A2E),
                            const Color(0xFF16213E),
                            _backgroundAnimation.value)!,
                        Color.lerp(
                            const Color(0xFF16213E),
                            const Color(0xFF0F0F23),
                            _backgroundAnimation.value)!,
                      ]
                    : [
                        Color.lerp(
                            const Color.fromARGB(255, 1, 42, 124),
                            const Color.fromARGB(255, 3, 8, 87),
                            _backgroundAnimation.value)!,
                        Color.lerp(
                            const Color.fromARGB(255, 1, 2, 35),
                            const Color.fromARGB(255, 1, 6, 30),
                            _backgroundAnimation.value)!,
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildCustomHeader(isDarkMode),
                  Expanded(
                    child: _buildMainContent(isDarkMode),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.play,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      LocaleKeys.foodAiScreen_nutritionist.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            LocaleKeys.foodAiScreen_smartMealPlanning.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.5, end: 0),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.foodAiScreen_personalizedNutrition.tr(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 800.ms)
              .slideY(begin: -0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isDarkMode) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BlocListener<MealRecommendationCubit, MealRecommendationState>(
        listener: (context, state) {
          if (state is MealRecommendationError) {
            dispalySnackBar(context, title: state.message, color: Colors.red);
          } else if (state is MealRecommendationLoaded) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RecommendationsScreen(
                  recommendations: state.recommendations,
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
                  LocaleKeys.foodAiScreen_meals.tr(), context);
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Child Selection Card
                    _buildStyledCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                              LocaleKeys.foodAiScreen_childInformation.tr(),
                              Icons.child_care),
                          const SizedBox(height: 16),
                          _isLoadingChildren
                              ? buildLoadingView(
                                  LocaleKeys.foodAiScreen_Children.tr(),
                                  context)
                              : _buildChildSelector(isDarkMode),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 20),

                    // Physical Information Card
                    _buildStyledCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                              LocaleKeys.foodAiScreen_physicalDetails.tr(),
                              Icons.accessibility_new),
                          const SizedBox(height: 16),

                          // Age Field
                          _buildStyledTextField(
                            controller: _ageController,
                            label: LocaleKeys.foodAiScreen_age.tr(),
                            hint: LocaleKeys.foodAiScreen_enterChildAge.tr(),
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            isDarkMode: isDarkMode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys.foodAiScreen_enterChildAge
                                    .tr();
                              } else if (double.tryParse(value) == null ||
                                  double.parse(value) > 18 ||
                                  double.parse(value) <= 0) {
                                return LocaleKeys.foodAiScreen_enterValidAge
                                    .tr();
                              } else if (value.length > 2) {
                                return LocaleKeys
                                    .foodAiScreen_enterValidAgeLength
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Weight and Height Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildStyledTextField(
                                  controller: _weightController,
                                  label: LocaleKeys.foodAiScreen_weight.tr(),
                                  hint: LocaleKeys.foodAiScreen_weightHint.tr(),
                                  icon: Icons.monitor_weight,
                                  keyboardType: TextInputType.number,
                                  isDarkMode: isDarkMode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LocaleKeys.foodAiScreen_enterWeight
                                          .tr();
                                    } else if (double.tryParse(value) == null ||
                                        double.parse(value) <= 0 ||
                                        value.length > 2) {
                                      return LocaleKeys
                                          .foodAiScreen_enterValidWeight
                                          .tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStyledTextField(
                                  controller: _heightController,
                                  label: LocaleKeys.foodAiScreen_height.tr(),
                                  hint: LocaleKeys.foodAiScreen_heightHint.tr(),
                                  icon: Icons.height,
                                  keyboardType: TextInputType.number,
                                  isDarkMode: isDarkMode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LocaleKeys.foodAiScreen_enterHeight
                                          .tr();
                                    }
                                    if (double.tryParse(value) == null ||
                                        double.parse(value) <= 0 ||
                                        value.length > 3) {
                                      return LocaleKeys
                                          .foodAiScreen_enterValidHeight
                                          .tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildStyledDropdown(
                            label: LocaleKeys.foodAiScreen_bloodType.tr(),
                            value: _selectedBloodType,
                            items: _bloodTypes,
                            onChanged: (value) {
                              setState(() {
                                _selectedBloodType = value;
                              });
                            },
                            icon: Icons.bloodtype,
                            isDarkMode: isDarkMode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LocaleKeys.foodAiScreen_selectBloodType
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 20),

                    // Allergies Card
                    _buildStyledCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                              LocaleKeys.foodAiScreen_allergiesAndDietary.tr(),
                              Icons.warning_amber),
                          const SizedBox(height: 16),
                          _buildAllergiesSection(isDarkMode),
                        ],
                      ),
                      isDarkMode: isDarkMode,
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 40),

                    // Generate Button
                    _buildGenerateButton(isDarkMode, catogryProducts)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0)
                        .then()
                        .shimmer(
                            duration: 2000.ms,
                            color: Colors.white.withOpacity(0.5)),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStyledCard({required Widget child, required bool isDarkMode}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.blue.shade600,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.blue.shade600,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blue.shade600,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
    required bool isDarkMode,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Colors.blue.shade600,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blue.shade600,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
      ),
      dropdownColor: isDarkMode ? Colors.grey.shade700 : Colors.white,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildChildSelector(bool isDarkMode) {
    if (_children.isEmpty) {
      return Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.orange.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                LocaleKeys.foodAiScreen_noChildrenFound.tr(),
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<ResultForChildDetails>(
      value: _selectedChild,
      decoration: InputDecoration(
        labelText: LocaleKeys.foodAiScreen_selectChild.tr(),
        prefixIcon: Icon(
          Icons.child_care,
          color: Colors.blue.shade600,
        ),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.blue.shade600,
            width: 2,
          ),
        ),
      ),
      dropdownColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      items: _children.map((child) {
        return DropdownMenuItem<ResultForChildDetails>(
          value: child,
          child:
              Text(child.fullName ?? LocaleKeys.foodAiScreen_unknownChild.tr()),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedChild = value;
        });
      },
    );
  }

  Widget _buildAllergiesSection(bool isDarkMode) {
    return BlocBuilder<GetAllCatogriesCubit, GetAllCatogriesState>(
      builder: (context, state) {
        if (state is GetAllCatogriesLoading) {
          return buildLoadingView(
              LocaleKeys.foodAiScreen_allergies.tr(), context);
        } else if (state is GetAllCatogriesLoaded) {
          final products = state.catgoryDetails.result ?? [];

          if (products.isEmpty) {
            return Container(
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    LocaleKeys.foodAiScreen_noAllergiesData.tr(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: products.map((allergy) {
              final allergyName =
                  allergy.name ?? LocaleKeys.foodAiScreen_unknown.tr();
              final isSelected = _selectedAllergies.contains(allergyName);
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    if (isSelected) {
                      _selectedAllergies.remove(allergyName);
                    } else {
                      _selectedAllergies.add(allergyName);
                    }
                  });
                  catogryProducts = await ProductAndCatogryService()
                      .getAllProducts(catogrydIdFilter: allergy.id!);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.shade600
                        : isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue.shade600
                          : isDarkMode
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected
                            ? Colors.white
                            : isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        allergyName,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade800,
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else if (state is GetAllCatogriesFailure) {
          return Container(
            padding: const EdgeInsetsDirectional.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${LocaleKeys.foodAiScreen_failedToLoadAllergies.tr()} ${state.errMessage}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _loadAllergies(),
                  icon: const Icon(Icons.refresh),
                  label: Text(LocaleKeys.foodAiScreen_retry.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsetsDirectional.all(16),
          child: Row(
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.foodAiScreen_loadingAllergies.tr(),
                style: TextStyle(
                  color:
                      isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenerateButton(bool isDarkMode, GetAllProducts? products) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          final profile = ChildProfile(
            name: _selectedChild?.fullName ??
                LocaleKeys.foodAiScreen_unknownChild.tr(),
            age: int.parse(_ageController.text),
            allergies: _selectedAllergies,
            time: LocaleKeys.foodAiScreen_mealType.tr(),
            bloodType:
                _selectedBloodType ?? LocaleKeys.foodAiScreen_unknown.tr(),
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text),
          );
          context.read<MealRecommendationCubit>().getRecommendations(
                profile: profile,
                products: products,
                mealType: LocaleKeys.foodAiScreen_mealType
                    .tr(), // Default value since we removed meal type selection
              );
        }
      },
      child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade900,
                Colors.blue,
              ],
            ),
          ),
          child: Text(
            LocaleKeys.foodAiScreen_recommendations.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
