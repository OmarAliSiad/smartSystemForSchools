import 'package:flutter/material.dart';

import '../../../core/utils/assets.dart';
import '../widgets/custom_page_screen.dart';

class PagesScreen extends StatefulWidget {
  static String id = 'PagesScreen';
  const PagesScreen({super.key});
  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (page) {
          setState(
            () {
              currentIndex = page.round();
            },
          );
        },
        controller: pageController,
        children: [
          CustomPageScreen(
            pageController: pageController,
            activeIndex: currentIndex == 0 ? currentIndex : currentIndex,
            image: Assets.imagesOnBoardingImageOne,
            widthImage: 344.03,
            title: 'Welcom to the Parent Portal ',
            subtitle:
                'Easily monitor your child’s needs and manage all their details from one place, providing a seamless and integrated experience .',
          ),
          CustomPageScreen(
            pageController: pageController,
            activeIndex: currentIndex == 1 ? currentIndex : currentIndex,
            image: Assets.imagesOnBoardingImageTwo,
            widthImage: 255.68,
            title: 'Easy to Control',
            subtitle:
                'Set daily budget for your child and track their activities to ensure smooth and effective management.',
          ),
          CustomPageScreen(
            pageController: pageController,
            activeIndex: currentIndex == 2 ? currentIndex : currentIndex,
            image: Assets.imagesOnBoardingImageThree,
            widthImage: 258.71,
            title: 'Stay Connected',
            subtitle:
                'Receive instant reports and regular updates about your child’s spending to stay informed and in control at all time.',
          ),
        ],
      ),
    );
  }
}
