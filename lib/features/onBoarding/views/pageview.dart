import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/utils/assets.dart';
import '../../settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import '../widgets/custom_page_screen.dart';

class PagesScreen extends StatefulWidget {
  static String id = '/PagesScreen';
  const PagesScreen({super.key});
  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(context.locale.toString()),
      child: Scaffold(
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
              title: LocaleKeys.PageView1_title.tr(),
              subtitle: LocaleKeys.PageView1_subtitle.tr(),
            ),
            CustomPageScreen(
              pageController: pageController,
              activeIndex: currentIndex == 1 ? currentIndex : currentIndex,
              image: Assets.imagesOnBoardingImageTwo,
              widthImage: 255.68,
              title: LocaleKeys.PageView2_title.tr(),
              subtitle: LocaleKeys.PageView2_subtitle.tr(),
            ),
            CustomPageScreen(
              pageController: pageController,
              activeIndex: currentIndex == 2 ? currentIndex : currentIndex,
              image: Assets.imagesOnBoardingImageThree,
              widthImage: 258.71,
              title: LocaleKeys.PageView3_title.tr(),
              subtitle: LocaleKeys.PageView3_subtitle.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
