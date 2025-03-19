import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/food_cubit/food_ai_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../widgets/custom_allergies_card.dart';

class FoodAIView extends StatefulWidget {
  static const String id = "FoodAIView";
  const FoodAIView({super.key});

  @override
  State<FoodAIView> createState() => _FoodAIViewState();
}

class _FoodAIViewState extends State<FoodAIView> {
  // Common allergens that can be detected
  final List<String> commonAllergens = [
    'Nuts',
    'Milk',
    'Gluten',
    'Eggs',
    'Fish',
    'Shellfish',
    'Soy',
  ];

  // Selected allergen for analysis
  String? selectedAllergen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, themeState) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Scaffold(
          backgroundColor: themeMode == ThemeMode.dark
              ? const Color(0xFF121212)
              : Colors.white,
          appBar: const CustomAppBar(
            title:
                'food_allergen_detection', //LocaleKeys.allegries_food_allergen_detection.tr(),
            ThereIsicon: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'allegries_select_allergen', //LocaleKeys.allegries_select_allergen.tr(),
                  style: AppStyles.styleBold20().copyWith(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: commonAllergens.length,
                    itemBuilder: (context, index) {
                      final allergen = commonAllergens[index];
                      final isSelected = selectedAllergen == allergen;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAllergen = allergen;
                          });
                        },
                        child: CustomAllergiesCard(
                          text: allergen,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<FoodAICubit, FoodAIState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state is FoodAISuccess)
                          ..._buildResultsWidget(state, themeMode),
                        if (state is FoodAILoading) _buildLoadingWidget(),
                        if (state is FoodAIError)
                          _buildErrorWidget(state.message, themeMode),
                        const SizedBox(height: 20),
                        CustomButton(
                          borderRadius: 10,
                          padding: const EdgeInsetsDirectional.all(16),
                          textStyle: AppStyles.styleMedium13(),
                          text:
                              'allegries_analyze_food', // LocaleKeys.allegries_analyze_food.tr(),
                          onPressed: selectedAllergen == null
                              ? null
                              : () => _analyzeSelectedAllergen(),
                          // color: selectedAllergen == null
                          //     ? Colors.grey
                          //     : const Color(0xff1A0F91),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildResultsWidget(FoodAISuccess state, ThemeMode themeMode) {
    return [
      Text(
        '${/*LocaleKeys.allegries_food_type.tr()*/ 'allegries_food_type'}: ${state.foodType}',
        style: AppStyles.styleBold14().copyWith(
          fontSize: 16,
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '${/*LocaleKeys.allegries_detected_allergens.tr()*/ 'allegries_detected_allergens'}:',
        style: AppStyles.styleBold14().copyWith(
          fontSize: 16,
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      const SizedBox(height: 4),
      ...state.allergens.map((allergen) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Text(
              '• $allergen',
              style: AppStyles.styleRegular14().copyWith(
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
          )),
      const SizedBox(height: 8),
      Text(
        '${/*LocaleKeys.allegries_nutritional_info.tr()*/ 'allegries_nutritional_info'}:',
        style: AppStyles.styleBold14().copyWith(
          fontSize: 16,
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      const SizedBox(height: 4),
      ...state.nutritionalInfo.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
            child: Text(
              '• ${entry.key}: ${entry.value}',
              style: AppStyles.styleRegular14().copyWith(
                color:
                    themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              ),
            ),
          )),
    ];
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String message, ThemeMode themeMode) {
    return Text(
      message,
      style: AppStyles.styleRegular14().copyWith(
        color: Colors.red,
      ),
    );
  }

  void _analyzeSelectedAllergen() {
    // Instead of using an image, we'll simulate the analysis based on the selected allergen
    // This is a text-based approach as requested by the user
    final Map<String, dynamic> mockResult = {
      'foodType': selectedAllergen,
      'allergens': _getMockAllergens(selectedAllergen!),
      'nutritionalInfo': _getMockNutritionalInfo(selectedAllergen!),
      'confidenceScore': 0.95,
    };

    // Update the state with the mock result
    context.read<FoodAICubit>().emit(FoodAISuccess(
          foodType: mockResult['foodType'],
          allergens: List<String>.from(mockResult['allergens']),
          nutritionalInfo: mockResult['nutritionalInfo'],
          confidenceScore: mockResult['confidenceScore'],
        ));
  }

  List<String> _getMockAllergens(String allergen) {
    switch (allergen.toLowerCase()) {
      case 'nuts':
        return ['Peanuts', 'Tree nuts', 'May contain traces of other nuts'];
      case 'milk':
        return ['Lactose', 'Casein', 'Whey'];
      case 'gluten':
        return ['Wheat', 'Barley', 'Rye'];
      case 'eggs':
        return ['Egg whites', 'Egg yolks', 'Albumin'];
      case 'fish':
        return ['Fish protein', 'Fish oil', 'Omega-3 fatty acids'];
      case 'shellfish':
        return ['Crustaceans', 'Mollusks', 'Seafood'];
      case 'soy':
        return ['Soy protein', 'Soy lecithin', 'Tofu'];
      default:
        return ['Unknown allergen'];
    }
  }

  Map<String, dynamic> _getMockNutritionalInfo(String allergen) {
    switch (allergen.toLowerCase()) {
      case 'nuts':
        return {
          'calories': '600 kcal',
          'protein': '20g',
          'fat': '50g',
          'carbs': '20g',
        };
      case 'milk':
        return {
          'calories': '150 kcal',
          'protein': '8g',
          'fat': '8g',
          'carbs': '12g',
        };
      case 'gluten':
        return {
          'calories': '350 kcal',
          'protein': '10g',
          'fat': '2g',
          'carbs': '70g',
        };
      default:
        return {
          'calories': '200 kcal',
          'protein': '5g',
          'fat': '10g',
          'carbs': '25g',
        };
    }
  }
}
