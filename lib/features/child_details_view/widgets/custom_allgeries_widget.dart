import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/models/allegry_details/allegry_details.dart';
import 'package:smartsystemforschools/core/models/get_child_details/result.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/assing_allegris/allegris.dart';
import 'package:smartsystemforschools/features/Allergies/data/manager/assing_allegris/allegris_state.dart';
import 'package:smartsystemforschools/features/child_details_view/widgets/buildAllegryChip.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/assets.dart';
import '../../Allergies/presentation/views/AllergiesView.dart';

class CustomAllergiesWidget extends StatefulWidget {
  final ResultForChildDetails childDetails;
  const CustomAllergiesWidget({super.key, required this.childDetails});

  @override
  State<CustomAllergiesWidget> createState() => _CustomAllergiesWidgetState();
}

class _CustomAllergiesWidgetState extends State<CustomAllergiesWidget>
    with SingleTickerProviderStateMixin {
  // Tracks items being removed for animation
  final Set<String> _removingItems = {};
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    loadAllegrisForStudent();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadAllegrisForStudent() async {
    log(widget.childDetails.id.toString());
    await context
        .read<AllergiesCubit>()
        .getAllegrisForStudent(widget.childDetails.id.toString());
  }

  // Remove allergy with animation
  void _removeAllergy(int allergyId, String allergyName) {
    setState(() {
      _removingItems.add(allergyName);
    });
    // Start the animation
    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<AllergiesCubit>().deleteAllegris(
        widget.childDetails.id.toString(),
        [allergyId],
      ).then((_) {
        // After deletion completed, reload the list
        loadAllegrisForStudent();
        setState(() {
          _removingItems.remove(allergyName);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeCubit, ThemeModeState>(
      builder: (context, state) {
        final themeMode = context.read<ThemeModeCubit>().currentTheme;
        return Card(
          color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeMode == ThemeMode.dark
                      ? const Color(0xFFFFFFFF).withOpacity(.4)
                      : const Color(0xFF000000).withOpacity(.2),
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    LocaleKeys.allegries_Allergies.tr(),
                    style: AppStyles.styleMedium16(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    LocaleKeys.allegries_des.tr(),
                    style: AppStyles.styleRegular10().copyWith(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        end: 15, bottom: 15.65),
                    child: Row(
                      children: [
                        BlocBuilder<AllergiesCubit, AllergiesState>(
                          builder: (context, state) {
                            if (state is GetAllergiesLoading) {
                              return Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.blue.shade900,
                                  size: 50,
                                ),
                              );
                            } else if (state is GetAllergiesLoaded) {
                              AllegryDetails allegryDetails =
                                  state.allergyItems;
                              return (allegryDetails.result == null ||
                                      allegryDetails.result!.isEmpty)
                                  ? const Expanded(
                                      child: SizedBox(),
                                    )
                                  : SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                          width: 10,
                                        ),
                                        itemCount:
                                            allegryDetails.result!.length,
                                        itemBuilder: (context, index) {
                                          final allergy =
                                              allegryDetails.result![index];
                                          final allergyName = allergy
                                                  .category?.name
                                                  ?.toString() ??
                                              '';
                                          final allergyId =
                                              allergy.category?.id ?? 0;

                                          // Check if this item is being removed
                                          final isRemoving = _removingItems
                                              .contains(allergyName);

                                          return AnimatedOpacity(
                                            opacity: isRemoving ? 0.0 : 1.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              child: isRemoving
                                                  ? const SizedBox(
                                                      width:
                                                          0) // Shrink to nothing when removing
                                                  : GestureDetector(
                                                      onLongPress: () {
                                                        // Show confirmation dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: Text(LocaleKeys
                                                                .allegries_allegries_Remove
                                                                .tr()),
                                                            content: Text(
                                                              "${LocaleKeys.allegries_allegries_RemoveConfirm.tr()} '$allergyName'?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                    LocaleKeys
                                                                        .allegries_cancel
                                                                        .tr()),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  _removeAllergy(
                                                                      allergyId,
                                                                      allergyName);
                                                                },
                                                                child: Text(
                                                                  LocaleKeys
                                                                      .allegries_remove
                                                                      .tr(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          BuildAllergyChip(
                                                            childDetails: widget
                                                                .childDetails,
                                                            name: allergyName,
                                                          ),
                                                          // Add a small remove button overlay
                                                          Positioned(
                                                            right: 0,
                                                            top: 0,
                                                            child: InkWell(
                                                              onTap: () =>
                                                                  _removeAllergy(
                                                                      allergyId,
                                                                      allergyName),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 2,
                                                                  right: 2,
                                                                  left: 2,
                                                                  bottom: 10,
                                                                ),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .red,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .minimize,
                                                                  size: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                            } else if (state is GetAllergiesFailure) {
                              return Center(
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
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AllergiesView(
                                studentId: widget.childDetails.id.toString(),
                              );
                            })).then((result) {
                              if (result == true) {
                                // Reload allergies data
                                loadAllegrisForStudent();
                              }
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 5.50,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 12.5,
                                  vertical: 11.8,
                                ),
                                child: Image.asset(
                                  Assets.imagesAdd,
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
