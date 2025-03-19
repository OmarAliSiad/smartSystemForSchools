import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/build_loading_view.dart';
import 'package:smartsystemforschools/features/family/data/manager/add_child_cubit/add_child_cubit.dart';
import 'package:smartsystemforschools/features/family/presentation/views/add_child_view.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_card_family_widget.dart';

class FamilyView extends StatefulWidget {
  static const String id = 'FamilyView';
  const FamilyView({super.key});

  @override
  State<FamilyView> createState() => _FamilyViewState();
}

class _FamilyViewState extends State<FamilyView> with WidgetsBindingObserver {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadChildDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when the screen is shown
    loadChildDetails();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes to foreground
      loadChildDetails();
    }
  }

  Future<void> loadChildDetails() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<AddChildCubit>().refreshChildData();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedCustomAppBar(
        waveColor: Colors.blue.shade700,
        backgroundColor: Colors.blue.shade900,
        onTapBack: () {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        },
        textStyle: AppStyles.styleSemiBold20(),
        title: LocaleKeys.family_family.tr(),
        thereIsIcon: false,
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue.shade900,
        onRefresh: loadChildDetails,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 18, end: 22),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 25,
                ),
              ),
              _isLoading
                  ? SliverToBoxAdapter(
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child: buildLoadingView('family', context),
                      ),
                    )
                  : BlocBuilder<AddChildCubit, AddChildCubitState>(
                      builder: (context, state) {
                        if (state is AddChildCubitInitial ||
                            state is AddChildCubitLAddedSuccess) {
                          final childDetailsModel =
                              context.read<AddChildCubit>().listchildDetails;

                          if (childDetailsModel.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.family_restroom,
                                      size: 80,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'No children added yet',
                                      style: AppStyles.styleSemiBold20(),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          }

                          return SliverList.builder(
                            itemCount: childDetailsModel.length,
                            itemBuilder: (context, index) {
                              {
                                return Column(
                                  children: [
                                    index % 2 == 0
                                        ? SlideInRight(
                                            child: CustomCardFaimlyWidget(
                                              childDetailsModel:
                                                  childDetailsModel[index],
                                            ),
                                          )
                                        : SlideInLeft(
                                            child: CustomCardFaimlyWidget(
                                              childDetailsModel:
                                                  childDetailsModel[index],
                                            ),
                                          ),
                                    SizedBox(
                                      height:
                                          index == childDetailsModel.length - 1
                                              ? 30
                                              : 25,
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        } else if (state is AddChildCubitAddedFailure) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50),
                                  Icon(
                                    Icons.error_outline,
                                    size: 80,
                                    color: Colors.red[300],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Failed to loading children',
                                    style: AppStyles.styleSemiBold20(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    state.errorMessage,
                                    style: AppStyles.styleRegular14(),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: loadChildDetails,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A0F91),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Try Again',
                                      style: AppStyles.styleRegular14()
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Text(
                                'No children added yet',
                                style: AppStyles.styleMedium20(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
              _isLoading
                  ? const SliverToBoxAdapter(
                      child: SizedBox(),
                    )
                  : SliverToBoxAdapter(
                      child: BounceInDown(
                        child: CustomButton(
                          padding: const EdgeInsetsDirectional.only(
                            top: 15,
                            bottom: 18,
                            end: 123,
                            start: 124,
                          ),
                          text: LocaleKeys.family_AddChild.tr(),
                          textStyle: AppStyles.styleSemiBold14(),
                          borderRadius: 20,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AddChildView.id)
                                .then((dynamic result) {
                              log('the result returned from childView : $result');
                              // Refresh data when returning from AddChildView
                              if (result != null) {
                                loadChildDetails();
                              }
                            });
                          },
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
