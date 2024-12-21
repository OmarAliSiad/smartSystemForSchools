import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:smartsystemforschools/features/presenation/widgets/custom_button.dart';
import 'package:smartsystemforschools/features/presenation/widgets/dots_indicator.dart';

import '../../../core/utils/app_styles.dart';
import '../../../core/widgets/custom_bottom_container.dart';

class CustomPageScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final double widthImage;
  final int activeIndex;
  final PageController pageController;

  const CustomPageScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.widthImage,
    required this.activeIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 164,
        ),
        FadeInRight(
          duration: const Duration(seconds: 1),
          child: Container(
            width: widthImage,
            height: 256,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: AssetImage(image),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        DotsIndicator(
          activeIndex: activeIndex,
          color: const Color(0xff191BA9),
        ),
        const SizedBox(
          height: 20,
        ),
        FadeInLeft(
          duration: const Duration(seconds: 1),
          child: Text(
            title,
            style: AppStyles.styleSemiBold20(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FadeInRight(
          duration: const Duration(seconds: 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Text(
              subtitle,
              style: AppStyles.styleLight14().copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        ZoomIn(
          duration: const Duration(milliseconds: 1300),
          child: Center(
            child: CustomButtonPageView(
              pageController: pageController,
              activeIndex: activeIndex,
            ),
          ),
        ),
        const SizedBox(
          height: 22,
        ),
        const CustomBottomContainer(
          color: Colors.black,
        )
      ],
    );
  }
}

/*
import 'package:animate_do/animate_do.dart';
import 'package:canteen/core/widgets/custom_bottom_container.dart';
import 'package:canteen/features/pageView/presenation/widgets/custom_button.dart';
import 'package:canteen/features/pageView/presenation/widgets/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class CustomPageScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final double widthImage;
  final int activeIndex;
  final PageController pageController;

  const CustomPageScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.widthImage,
    required this.activeIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 164,
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInRight(
            duration: const Duration(seconds: 1),
            child: Container(
              width: widthImage,
              height: 256,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: AssetImage(image),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
          ),
        ),
        SliverToBoxAdapter(
          child: DotsIndicator(
            activeIndex: activeIndex,
            color: const Color(0xff191BA9),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInLeft(
            duration: const Duration(seconds: 1),
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: AppStyles.styleSemiBold20(context),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        SliverToBoxAdapter(
          child: FadeInRight(
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Text(
                subtitle,
                style: AppStyles.styleLight14(context).copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 12,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: ZoomIn(
            duration: const Duration(milliseconds: 1300),
            child: Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButtonPageView(
                  pageController: pageController,
                  activeIndex: activeIndex,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 12,
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomBottomContainer(
              color: Colors.black,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 22,
          ),
        )
      ],
    );
  }
}
*/