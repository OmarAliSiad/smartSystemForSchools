import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import '../../../../core/utils/custom_app_bar.dart';
import '../../../../core/utils/custom_button.dart';
import '../../../../core/widgets/custom_bottom_container.dart';
import '../../data/manager/get_all_catogries_cubit/get_all_catogries_cubit.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../core/models/allegry_details/allegry_details.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../data/manager/allegris_catogries/allegris_cubit.dart';
import '../../data/manager/allegris_catogries/allegris_state.dart';
import '../widgets/custom_allergies_card.dart';

class AllergiesView extends StatefulWidget {
  static const String id = "/AllergiesView";
  final String studentId;
  const AllergiesView({super.key, required this.studentId});

  @override
  State<AllergiesView> createState() => _AllergiesViewState();
}

class _AllergiesViewState extends State<AllergiesView>
    with SingleTickerProviderStateMixin {
  // Map to store selected categories by their actual ID from the model
  Map<int, bool> selectedCategories = {};
  bool isAssigning = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    loadCategories();
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadCategories() async {
    await context.read<GetAllCatogriesCubit>().getAllCatogries();
  }

  void _handleCardTap(int categoryId, String categoryName) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      // Toggle selection
      selectedCategories[categoryId] =
          !(selectedCategories[categoryId] ?? false);
      log('Category ID $categoryId ($categoryName) selected: ${selectedCategories[categoryId]}');
    });
  }

  Future<void> _assignAllergies() async {
    // Get the list of selected category IDs
    final selectedCategoryIds = selectedCategories.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedCategoryIds.isEmpty) {
      dispalySnackBar(
        context,
        title: LocaleKeys.allegries_allegries_no_selection.tr(),
        color: Colors.red,
      );
      return;
    }

    setState(() {
      isAssigning = true;
    });

    try {
      AllegryCatogryDetails allegryDetails = await context
          .read<AllergiesCubitCatogry>()
          .assignAllergies(widget.studentId, selectedCategoryIds);
      if (mounted &&
          allegryDetails.result != null &&
          allegryDetails.result!.isNotEmpty) {
        dispalySnackBar(context,
            title: LocaleKeys.allegries_allegries_success.tr(),
            color: Colors.green);

        Navigator.pop(context, true); // Return true to indicate success
      } else {
        if (mounted) {
          dispalySnackBar(context,
              title: allegryDetails.message.toString(), color: Colors.red);
          Navigator.pop(context, true);
        }
      }
      // Return true to indicate success
    } catch (e) {
      if (mounted) {
        dispalySnackBar(context, title: e.toString(), color: Colors.red);

        setState(() {
          isAssigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: CustomAppBar(
                    title: LocaleKeys.allegries_Allergies.tr(),
                    textStyle: AppStyles.styleSemiBold20(),
                    ThereIsicon: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      // Animated allergies icon
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Image.asset(
                              Assets.imagesGluten,
                              height: 80,
                              width: 80,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 15, end: 14),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          LocaleKeys.allegries_headline.tr(),
                          style: AppStyles.styleMedium13(),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                BlocBuilder<GetAllCatogriesCubit, GetAllCatogriesState>(
                  builder: (context, state) {
                    if (state is GetAllCatogriesLoading) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            children: [
                              LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.blue.shade900,
                                size: 60,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                LocaleKeys.allegries_loading_categories.tr(),
                                style: AppStyles.styleMedium16()
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is GetAllCatogriesFailure) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 60, color: Colors.amber),
                              const SizedBox(height: 16),
                              Text(
                                state.errMessage.toString(),
                                style: AppStyles.styleMedium16(),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: loadCategories,
                                child: Text(LocaleKeys.allegries_retry.tr()),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is GetAllCatogriesLoaded) {
                      if (state.catgoryDetails.result == null ||
                          state.catgoryDetails.result!.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              LocaleKeys.allegries_no_allergies_found.tr(),
                              style: AppStyles.styleMedium16(),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 25),
                        sliver: SliverGrid.builder(
                          itemCount: state.catgoryDetails.result!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 29,
                            mainAxisSpacing: 25,
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            final category =
                                state.catgoryDetails.result![index];
                            final categoryId = category.id ?? -1;
                            final isSelected =
                                selectedCategories[categoryId] ?? false;

                            return AnimatedBuilder(
                              animation: _scaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      isSelected ? _scaleAnimation.value : 1.0,
                                  child: GestureDetector(
                                    onTap: () => _handleCardTap(
                                        categoryId, category.name ?? ""),
                                    child: CustomAllergiesCard(
                                      isSelected: isSelected,
                                      text: category.name ?? "",
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }
                  },
                ),
                // Add extra space at the bottom for the button
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
            // Fixed button at bottom with loading state
            Positioned(
              bottom: -10,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<AllergiesCubitCatogry, AllergiesState>(
                    builder: (context, state) {
                      final isLoading = state is AssignAllergiesLoading;

                      return CustomButton(
                          padding: const EdgeInsetsDirectional.only(
                            top: 15,
                            bottom: 18,
                            end: 124,
                            start: 124,
                          ),
                          text: isLoading
                              ? LocaleKeys.allegries_allegries_saving.tr()
                              : LocaleKeys.allegries_button.tr(),
                          textStyle: AppStyles.styleSemiBold14(),
                          borderRadius: 20,
                          onPressed: isLoading ? null : _assignAllergies,
                          isLoading: isLoading);
                    },
                  ),
                  const SizedBox(height: 18),
                  const CustomBottomContainer(color: Colors.black)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
