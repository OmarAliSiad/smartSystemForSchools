import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NoProductsWidget extends StatelessWidget {
  final bool isDarkMode;
  final String? categoryName;
  final VoidCallback? onRefresh;

  const NoProductsWidget({
    super.key,
    required this.isDarkMode,
    this.categoryName,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon with Gradient Background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.blue.withOpacity(0.3),
                      ]
                    : [
                        Colors.blue.withOpacity(0.1),
                        Colors.blue.shade900.withOpacity(0.1),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.blue.shade700 : Colors.blue)
                      .withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: isDarkMode ? Colors.white70 : Colors.blue.shade600,
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shimmer(duration: 2000.ms),

          const SizedBox(height: 32),

          // Main Title
          Text(
            'No Products Available',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 300.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 16),

          // Subtitle with category name if provided
          Text(
            categoryName != null
                ? 'No products found in "$categoryName" category'
                : 'This category is currently empty',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white60 : Colors.black54,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 500.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 32),

          // Helpful suggestions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey.shade800.withOpacity(0.5)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 110),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: isDarkMode
                        ? Colors.amber.shade300
                        : Colors.amber.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Try these suggestions:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSuggestionItem(
                  '• Check other categories',
                  isDarkMode,
                ),
                _buildSuggestionItem(
                  '• Come back later for new products',
                  isDarkMode,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 700.ms)
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 24),

          // Refresh Button (if callback provided)
          if (onRefresh != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.purple.shade600, Colors.blue.shade600]
                      : [Colors.blue.shade600, Colors.purple.shade600],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode ? Colors.purple : Colors.blue)
                        .withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Refresh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms, delay: 900.ms)
                .slideY(begin: 0.3, end: 0),

          // Floating particles animation
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white70 : Colors.black54,
          height: 1.3,
        ),
      ),
    );
  }
}
