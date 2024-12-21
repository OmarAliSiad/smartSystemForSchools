import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';

import '../../../../core/utils/app_styles.dart';
import '../../data/models/child_details_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_balance_card_details.dart';
import '../widgets/custom_card_transactions.dart';
import '../widgets/custom_details_child_view.dart';

class HomeView extends StatelessWidget {
  static const String id = 'HomeView';
  static List<ChildDetailsModel> childDetails = [
    ChildDetailsModel(
        imagePath: Assets.imagesShahdImage, name: 'Shahd', price: '100 EGP'),
    ChildDetailsModel(
        imagePath: Assets.imagesHodaImage, name: 'Shahd', price: '150 EGP'),
    ChildDetailsModel(
        imagePath: Assets.imagesAhmedImage, name: 'Ahmed', price: '100 EGP'),
  ];
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarHomeView(),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 19),
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
              child: ZoomIn(
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
                'My Family',
                style: AppStyles.styleMedium20(),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
            SliverList.builder(
              itemCount: childDetails.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: index == 2 ? 0 : 13),
                child: ZoomIn(
                  child: CustomDetailsChildView(
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
                'Transactions',
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
                padding: EdgeInsets.only(bottom: index == 2 ? 0 : 13),
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
