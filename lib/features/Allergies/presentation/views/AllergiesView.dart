import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/custom_bottom_container.dart';
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
    {"Chocolate": false},
    {"Biscuit": false},
    {"Milk": false},
    {"Soft Drinks": false},
    {"Banana": false},
    {"Nuts": false},
  ];
  List<Map> data = [
    {"Chocolate": Assets.imagesChocolate},
    {"Biscuit": Assets.imagesBiscuit},
    {"Milk": Assets.imagesMilk},
    {"Soft Drinks": Assets.imagesSoftDrink},
    {"Banana": Assets.imagesBanana},
    {"Nuts": Assets.imagesNuts},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: CustomAppBar(
              title: "Allergies",
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
                  'Specify any allergies to help us tailor food options accordingly',
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
                      // Toggle the selection state
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
                text: 'Confirm',
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
