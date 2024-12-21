import 'package:flutter/material.dart';
import 'package:smartsystemforschools/core/utils/app_styles.dart';
import 'package:smartsystemforschools/core/utils/assets.dart';
import 'package:smartsystemforschools/core/utils/custom_app_bar.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/features/family/presentation/views/add_child_view.dart';
import '../../../main_screen/presentation/views/main_screen.dart';
import '../widgets/custom_card_family_widget.dart';

class FamilyView extends StatelessWidget {
  static List<Map<String, dynamic>> list = [
    {'imagePath': Assets.imagesShahdImage, 'name': 'Shahd'},
    {'imagePath': Assets.imagesAhmedImage, 'name': 'Ahmed'},
    {'imagePath': Assets.imagesHodaImage, 'name': 'Hoda'},
    {'imagePath': Assets.imagesShahdImage, 'name': 'Shahd'},
    {'imagePath': Assets.imagesAhmedImage, 'name': 'Ahmed'},
    {'imagePath': Assets.imagesHodaImage, 'name': 'Hoda'},
    {'imagePath': Assets.imagesShahdImage, 'name': 'Shahd'},
    {'imagePath': Assets.imagesAhmedImage, 'name': 'Ahmed'},
    {'imagePath': Assets.imagesHodaImage, 'name': 'Hoda'},
    {'imagePath': Assets.imagesShahdImage, 'name': 'Shahd'},
    {'imagePath': Assets.imagesAhmedImage, 'name': 'Ahmed'},
  ];
  static const String id = 'FamilyView';
  const FamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(MainScreen.id);
        },
        textStyle: AppStyles.styleSemiBold20(),
        title: 'Family',
        ThereIsicon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 22),
        child:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 25,
            ),
          ),
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              {
                return Column(
                  children: [
                    CustomCardFaimlyWidget(
                      imagePath: list[index]['imagePath'],
                      name: list[index]['name'],
                    ),
                    SizedBox(
                      height: index == list.length - 1 ? 30 : 25,
                    ),
                  ],
                );
              }
            },
          ),
          SliverToBoxAdapter(
            child: CustomButton(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 18,
                right: 123,
                left: 124,
              ),
              text: 'Add Child',
              textStyle: AppStyles.styleSemiBold14(),
              borderRadius: 20,
              onPressed: () {
                Navigator.of(context).pushNamed(AddChildView.id);
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
        ]),
      ),
    );
  }
}
