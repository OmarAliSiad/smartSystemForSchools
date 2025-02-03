import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';
import 'package:smartsystemforschools/features/notification_view/presenation/views/notification_view.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/models/child_details_model.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../settings/presentation/views/settings_view.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_balance_card_details.dart';
import '../widgets/custom_card_transactions.dart';
import '../widgets/custom_details_child_view.dart';

class HomeView extends StatelessWidget {
  static const String id = 'HomeView';
  static List<ChildDetailsModel> childDetails = [
    ChildDetailsModel(
        imagePath: Assets.imagesShahdImage,
        name: LocaleKeys.homeView_nameShahd.tr(),
        price: LocaleKeys.homeView_priceShahd1.tr()),
    ChildDetailsModel(
        imagePath: Assets.imagesHodaImage,
        name: LocaleKeys.homeView_nameShahd.tr(),
        price: LocaleKeys.homeView_priceShahd2.tr()),
    ChildDetailsModel(
        imagePath: Assets.imagesAhmedImage,
        name: LocaleKeys.homeView_nameAhmed.tr(),
        price: LocaleKeys.homeView_priceAhmed.tr()),
  ];
  const HomeView({super.key});

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
            SliverList.builder(
              itemCount: childDetails.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    EdgeInsetsDirectional.only(bottom: index == 2 ? 0 : 13),
                child: index % 2 == 0
                    ? SlideInRight(
                        child: CustomDetailsChildView(
                          childDetailsModel: childDetails[index],
                        ),
                      )
                    : SlideInLeft(
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
