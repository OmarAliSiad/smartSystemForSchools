import 'package:flutter/material.dart';
import '../../../core/utils/animated_app_bar.dart';
import '../../../core/utils/app_styles.dart';
import '../data/models/meal_recommendation.dart';

class RecommendationsScreen extends StatelessWidget {
  final List<MealRecommendation> recommendations;
  final String mealType;
  final bool isDarkMode;
  const RecommendationsScreen({
    super.key,
    required this.recommendations,
    required this.isDarkMode,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: Colors.blue,
        thereIsIcon: false,
        backgroundColor: Colors.blue.shade900,
        title: 'Not Recommended Meals',
        textStyle: AppStyles.styleSemiBold20(),
      ),
      body: recommendations.isEmpty
          ? _buildEmptyState(context)
          : _buildRecommendationsList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Recommendations Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 42),
            child: Text(
              'Try adjusting your search criteria or check your internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsList(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDarkMode == true ? Colors.black : Colors.white,
              boxShadow: [
                isDarkMode == true
                    ? BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
              ]),
          child: ExpansionTile(
            iconColor: isDarkMode ? Colors.white : Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            collapsedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.restaurant_menu,
                color: Colors.white,
              ),
            ),
            title: Text(
              recommendation.name,
              style: AppStyles.styleBold16(),
            ),
            subtitle: const Text('Tap to see details'),
            childrenPadding: EdgeInsets.zero,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, 'Ingredients:', Icons.egg_alt),
                    const SizedBox(height: 8),
                    ...recommendation.ingredients.map((ingredient) => Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.fiber_manual_record,
                                  size: 12, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 20),
                    _buildSectionHeader(
                        context, 'Disadvantages:', Icons.warning_amber_rounded),
                    const SizedBox(height: 8),
                    Text(
                      recommendation.disadvantageDescription,
                      style: AppStyles.styleMedium16(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppStyles.styleBold16().copyWith(
            fontSize: 18,
            color: Colors.blue.shade800,
          ),
        ),
      ],
    );
  }
}
