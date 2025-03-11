import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/views/notification_view.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/models/get_child_details/result.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/school_service.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_balance_card_details.dart';
import '../widgets/custom_card_transactions.dart';
import '../widgets/custom_details_child_view.dart';
import 'dart:developer';

class HomeView extends StatefulWidget {
  static const String id = 'HomeView';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<ResultForChildDetails> childDetails = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadChildDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when the screen is shown
    loadChildDetails();
  }

  Future<void> loadChildDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use the new method that returns a list of children
      final results = await SchoolService().getAllChildDetails();

      setState(() {
        // Clear the list and add all new children
        childDetails.clear();
        childDetails.addAll(results);
        _isLoading = false;
      });

      log("Loaded ${results.length} children in HomeView");
    } catch (e) {
      log("Error loading children in HomeView: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarHomeView(
        onTapPrefix: () {
          Navigator.of(context).pushNamed(SettingsHomeView.id);
        },
        onTapSuffix: () {
          Navigator.of(context).pushNamed(NotificationView.id);
        },
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 18, end: 19),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: BounceInDown(
                child: const CustomBalanceCardDetails(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                LocaleKeys.homeView_family.tr(),
                style: AppStyles.styleMedium20(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            _isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.blue.shade900,
                        size: 50,
                      ),
                    ),
                  )
                : childDetails.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.family_restroom,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No children added yet',
                                  style: AppStyles.styleRegular16(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverList.builder(
                        itemCount: childDetails.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsetsDirectional.only(
                              bottom:
                                  index == childDetails.length - 1 ? 0 : 13),
                          child: index % 2 == 0
                              ? SlideInRight(
                                  child: CustomDetailsChildView(
                                    index: index,
                                    childDetailsModel: childDetails[index],
                                  ),
                                )
                              : SlideInLeft(
                                  child: CustomDetailsChildView(
                                    index: index,
                                    childDetailsModel: childDetails[index],
                                  ),
                                ),
                        ),
                      ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                LocaleKeys.transactions_transactions.tr(),
                style: AppStyles.styleMedium20(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 13),
                child: ZoomIn(child: const CustomCardTransactions()),
              ),
              itemCount: 10,
            ),
          ],
        ),
      ),
    );
  }
}
