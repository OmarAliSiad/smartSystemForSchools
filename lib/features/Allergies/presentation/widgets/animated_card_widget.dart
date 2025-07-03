import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/models/allegries_products/product.dart';

class AnimatedCard extends StatefulWidget {
  final int index;
  final Product product;
  final bool isRestricted;
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;
  final bool isSelectionMode;
  final bool isSelected;
  final void Function()? onTap;

  const AnimatedCard({
    super.key,
    required this.index,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
    required this.onTap,
    required this.product,
    required this.isRestricted,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        shadowColor: widget.isDarkMode ? Colors.black87 : Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.isSelectionMode && widget.isSelected
                ? Colors.blue.shade500
                : widget.isRestricted
                    ? Colors.red.shade700
                    : Colors.green.shade500,
            width: 2,
          ),
        ),
        color: widget.cardColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Product details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Expanded(
                    flex: 3,
                    child: Image.network(
                      'https://school-api.runasp.net/Products/${widget.product.productImg}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            child: Center(
                              child: LoadingAnimationWidget.inkDrop(
                                size: 50,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  // Product info
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: widget.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.textColor.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${widget.product.price!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.textColor,
                                ),
                              ),
                              if (!widget.isSelectionMode)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: widget.isRestricted
                                        ? Colors.red.shade100
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.isRestricted
                                        ? LocaleKeys.RestrictedProducts_Blocked
                                            .tr()
                                        : LocaleKeys.RestrictedProducts_Allowed
                                            .tr(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: widget.isRestricted
                                          ? Colors.red.shade700
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Selection overlay
              if (widget.isSelectionMode && widget.isSelected)
                Positioned.fill(
                  child: Container(
                    color: Colors.blue.withOpacity(0.2),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          LocaleKeys.RestrictedProducts_SELECTED.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Restriction overlay (only show in non-selection mode)
              if (!widget.isSelectionMode && widget.isRestricted)
                Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          LocaleKeys.RestrictedProducts_RESTRICTED.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Status indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSelectionMode
                        ? widget.isSelected
                            ? Colors.blue.shade500
                            : Colors.grey.withOpacity(0.5)
                        : widget.isRestricted
                            ? Colors.red.shade700
                            : Colors.green.shade500,
                  ),
                  child: Icon(
                    widget.isSelectionMode
                        ? widget.isSelected
                            ? Icons.check
                            : Icons.add
                        : widget.isRestricted
                            ? Icons.block
                            : Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (100 * widget.index).ms).slideY(
        begin: 0.2, end: 0, duration: 400.ms, delay: (100 * widget.index).ms);
  }
}
