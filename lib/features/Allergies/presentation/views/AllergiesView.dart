import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../widgets/custom_allergies_card.dart';

class AllergiesView extends StatefulWidget {
  static const String id = "AllergiesView";
  const AllergiesView({super.key});
  @override
  State<AllergiesView> createState() => _AllergiesViewState();
}

class _AllergiesViewState extends State<AllergiesView> {
  List<Map<String, bool>> isSelected = [
    {LocaleKeys.allegries_chocolate.tr(): false},
    {LocaleKeys.allegries_biscuit.tr(): false},
    {LocaleKeys.allegries_milk.tr(): false},
    {LocaleKeys.allegries_softDrinks.tr(): false},
    {LocaleKeys.allegries_banana.tr(): false},
    {LocaleKeys.allegries_nuts.tr(): false},
  ];
  List<Map> data = [
    {LocaleKeys.allegries_chocolate.tr(): Assets.imagesChocolate},
    {LocaleKeys.allegries_biscuit.tr(): Assets.imagesBiscuit},
    {LocaleKeys.allegries_milk.tr(): Assets.imagesMilk},
    {LocaleKeys.allegries_softDrinks.tr(): Assets.imagesSoftDrink},
    {LocaleKeys.allegries_banana.tr(): Assets.imagesBanana},
    {LocaleKeys.allegries_nuts.tr(): Assets.imagesNuts},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Image.asset(
                Assets.imagesGluten,
                height: 70,
                width: 70,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15, end: 14),
              child: FittedBox(
                child: Text(
                  LocaleKeys.allegries_headline.tr(),
                  style: AppStyles.styleMedium13(),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
            sliver: SliverGrid.builder(
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 29,
                mainAxisSpacing: 25,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      isSelected[index][isSelected[index].entries.first.key] =
                          !isSelected[index]
                              [isSelected[index].entries.first.key]!;
                      log('the value after selected : ${isSelected[index]}');
                    });
                  },
                  child: CustomAllergiesCard(
                    isSelected: isSelected[index]
                        [isSelected[index].entries.first.key]!,
                    text: data[index].entries.first.key,
                    image: data[index].entries.first.value,
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: CustomButton(
                padding: const EdgeInsetsDirectional.only(
                  top: 15,
                  bottom: 18,
                  end: 123,
                  start: 124,
                ),
                text: LocaleKeys.allegries_button.tr(),
                textStyle: AppStyles.styleSemiBold14(),
                borderRadius: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 18,
            ),
          ),
          const SliverToBoxAdapter(
              child: CustomBottomContainer(
            color: Colors.black,
          )),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 8,
            ),
          ),
        ],
      ),
    );
  }
}
